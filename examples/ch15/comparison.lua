--[[
    Lua安全编程对比示例
    
    本文件展示Lua中的安全编程实践，包括：
    1. 输入验证和消毒
    2. 路径遍历防护
    3. 安全文件操作
    4. 敏感信息处理
    5. 日志记录
    6. 哈希计算
]]

-- 危险字符列表
local DANGEROUS_CHARS = "[\\/:*?\"<>|&;`$]"

-- 危险模式列表
local DANGEROUS_PATTERNS = {
    "%.%.",  -- 路径遍历
    "[&|<>^]",  -- 命令注入
    "[;]",  -- 命令分隔符
}

-- 非法文件名字符
local ILLEGAL_FILENAME_CHARS = "[\\/:*?\"<>|]"

-- ============================================================
-- 安全验证器
-- ============================================================

local SecurityValidator = {}

function SecurityValidator.validate_input(user_input)
    -- 验证用户输入是否安全
    
    -- 检查空输入
    if user_input == nil or user_input == "" then
        return false
    end
    
    -- 检查危险字符
    if string.find(user_input, DANGEROUS_CHARS) then
        return false
    end
    
    -- 检查危险模式
    for _, pattern in ipairs(DANGEROUS_PATTERNS) do
        if string.find(user_input, pattern) then
            return false
        end
    end
    
    return true
end

function SecurityValidator.validate_filename(filename)
    -- 验证文件名是否安全
    
    -- 检查空文件名
    if filename == nil or filename == "" then
        return false
    end
    
    -- 检查非法字符
    if string.find(filename, ILLEGAL_FILENAME_CHARS) then
        return false
    end
    
    -- 检查长度
    if #filename > 255 then
        return false
    end
    
    return true
end

function SecurityValidator.validate_path(path_input)
    -- 验证路径是否安全
    
    -- 检查空路径
    if path_input == nil or path_input == "" then
        return false
    end
    
    -- 检查路径遍历
    if string.find(path_input, "%.%.") then
        return false
    end
    
    -- 检查危险字符
    if string.find(path_input, "[&|<>^]") then
        return false
    end
    
    return true
end

-- ============================================================
-- 安全路径处理器
-- ============================================================

local SafePathHandler = {}
SafePathHandler.__index = SafePathHandler

function SafePathHandler.new(base_dir)
    -- 创建安全路径处理器
    
    local self = setmetatable({}, SafePathHandler)
    self.base_dir = base_dir
    
    -- 确保基础目录存在
    os.execute(string.format('mkdir "%s" 2>nul', base_dir))
    
    return self
end

function SafePathHandler:safe_join(user_path)
    -- 安全地连接路径
    
    -- 验证用户路径
    if not SecurityValidator.validate_path(user_path) then
        return nil
    end
    
    -- 检查是否为绝对路径
    if string.match(user_path, "^[A-Za-z]:") then
        return nil
    end
    
    -- 构建完整路径
    local full_path = self.base_dir .. "\\" .. user_path
    
    -- 规范化路径
    full_path = string.gsub(full_path, "\\", "/")
    full_path = string.gsub(full_path, "/+", "/")
    
    -- 验证路径是否在基础目录内
    local normalized_base = string.gsub(self.base_dir, "\\", "/")
    if not string.find(full_path, normalized_base, 1, true) then
        return nil
    end
    
    return full_path
end

function SafePathHandler:safe_read(filename)
    -- 安全地读取文件
    
    -- 验证路径
    local file_path = self:safe_join(filename)
    if file_path == nil then
        return nil
    end
    
    -- 检查文件是否存在
    local file = io.open(file_path, "r")
    if file == nil then
        return nil
    end
    
    -- 读取文件内容
    local content = file:read("*a")
    file:close()
    
    return content
end

function SafePathHandler:safe_write(filename, content)
    -- 安全地写入文件
    
    -- 验证路径
    local file_path = self:safe_join(filename)
    if file_path == nil then
        return false
    end
    
    -- 写入文件
    local file = io.open(file_path, "w")
    if file == nil then
        return false
    end
    
    file:write(content)
    file:close()
    
    return true
end

-- ============================================================
-- 安全哈希计算器
-- ============================================================

local SecureHasher = {}

function SecureHasher.calculate_simple_hash(input)
    -- 计算简单的哈希值（仅用于演示）
    
    local hash = 5381
    for i = 1, #input do
        hash = ((hash * 33) + string.byte(input, i)) % 1000000007
    end
    
    return hash
end

function SecureHasher.hash_password(password, salt)
    -- 安全地哈希密码（简化版本）
    
    if salt == nil then
        -- 生成随机盐
        math.randomseed(os.time())
        salt = ""
        for i = 1, 32 do
            salt = salt .. string.char(math.random(65, 122))
        end
    end
    
    -- 简单哈希（实际应用应使用更强的哈希函数）
    local combined = password .. salt
    local hash = SecureHasher.calculate_simple_hash(combined)
    
    return {
        salt = salt,
        hash = tostring(hash)
    }
end

-- ============================================================
-- 审计日志记录器
-- ============================================================

local AuditLogger = {}
AuditLogger.__index = AuditLogger

function AuditLogger.new(log_dir)
    -- 创建审计日志记录器
    
    local self = setmetatable({}, AuditLogger)
    self.log_dir = log_dir
    self.log_file = log_dir .. "\\audit.log"
    
    -- 确保日志目录存在
    os.execute(string.format('mkdir "%s" 2>nul', log_dir))
    
    return self
end

function AuditLogger:log_event(event_type, message, user)
    -- 记录审计事件
    
    if user == nil then
        user = os.getenv("USERNAME") or "unknown"
    end
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local computer = os.getenv("COMPUTERNAME") or "unknown"
    local log_message = string.format("[%s] [%s] User: %s Computer: %s - %s\n", 
                                      timestamp, event_type, user, computer, message)
    
    local file = io.open(self.log_file, "a")
    if file then
        file:write(log_message)
        file:close()
    end
    
    -- 同时输出到控制台
    print(string.format("[AUDIT] %s", log_message))
end

function AuditLogger:log_security_event(event_type, message)
    -- 记录安全事件
    
    self:log_event("SECURITY_" .. event_type, message)
end

function AuditLogger:log_error(error_code, message)
    -- 记录错误事件
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local log_message = string.format("[%s] [ERROR] Code: %s - %s\n", 
                                      timestamp, error_code, message)
    
    local file = io.open(self.log_file, "a")
    if file then
        file:write(log_message)
        file:close()
    end
    
    print(string.format("[ERROR] %s", log_message))
end

-- ============================================================
-- 输入消毒器
-- ============================================================

local InputSanitizer = {}

function InputSanitizer.sanitize_filename(filename)
    -- 消毒文件名
    
    -- 移除非法字符
    local sanitized = string.gsub(filename, ILLEGAL_FILENAME_CHARS, "")
    
    -- 移除首尾空格
    sanitized = string.match(sanitized, "^%s*(.-)%s*$") or ""
    
    -- 限制长度
    if #sanitized > 255 then
        sanitized = string.sub(sanitized, 1, 255)
    end
    
    return sanitized
end

function InputSanitizer.sanitize_input(user_input)
    -- 消毒用户输入
    
    -- 移除危险字符
    local sanitized = string.gsub(user_input, "[&|<>^;]", "")
    
    -- 移除路径遍历
    sanitized = string.gsub(sanitized, "%.%.", "")
    
    -- 移除首尾空格
    sanitized = string.match(sanitized, "^%s*(.-)%s*$") or ""
    
    return sanitized
end

function InputSanitizer.escape_command_arg(arg)
    -- 转义命令行参数
    
    -- 使用引号包裹
    if string.find(arg, " ") or string.find(arg, "[&|<>^]") then
        return '"' .. arg .. '"'
    end
    
    return arg
end

-- ============================================================
-- 演示函数
-- ============================================================

local function demonstrate_input_validation()
    -- 演示输入验证
    
    print("============================================================")
    print("输入验证演示")
    print("============================================================")
    
    -- 测试用例
    local test_cases = {
        {input = "", expected = false, description = "空输入"},
        {input = "hello_world", expected = true, description = "正常输入"},
        {input = "file.txt & del /f /q C:\\*.*", expected = false, description = "命令注入攻击"},
        {input = "..\\..\\..\\Windows\\System32\\config\\SAM", expected = false, description = "路径遍历攻击"},
        {input = "file:name.txt", expected = false, description = "包含非法字符"},
        {input = "normal_file.txt", expected = true, description = "正常文件名"},
    }
    
    for _, test in ipairs(test_cases) do
        local result = SecurityValidator.validate_input(test.input)
        local status = (result == test.expected) and "PASS" or "FAIL"
        print(string.format("[%s] %s: '%s' -> %s", 
              status, test.description, test.input, tostring(result)))
    end
end

local function demonstrate_path_security()
    -- 演示路径安全
    
    print("\n============================================================")
    print("路径安全演示")
    print("============================================================")
    
    -- 创建临时目录
    local temp_dir = "temp_security_test_lua"
    os.execute(string.format('mkdir "%s" 2>nul', temp_dir))
    
    local handler = SafePathHandler.new(temp_dir)
    
    -- 测试用例
    local test_cases = {
        {input = "file.txt", expected = true, description = "正常文件"},
        {input = "..\\..\\secret.txt", expected = false, description = "路径遍历攻击"},
        {input = "C:\\Windows\\System32\\cmd.exe", expected = false, description = "绝对路径"},
        {input = "subdir\\file.txt", expected = true, description = "子目录文件"},
    }
    
    for _, test in ipairs(test_cases) do
        local result = handler:safe_join(test.input)
        local is_safe = (result ~= nil)
        local status = (is_safe == test.expected) and "PASS" or "FAIL"
        print(string.format("[%s] %s: '%s' -> %s", 
              status, test.description, test.input, is_safe and "安全" or "不安全"))
    end
    
    -- 清理临时目录
    os.execute(string.format('rmdir /s /q "%s" 2>nul', temp_dir))
end

local function demonstrate_hashing()
    -- 演示哈希计算
    
    print("\n============================================================")
    print("哈希计算演示")
    print("============================================================")
    
    local hasher = SecureHasher
    
    -- 测试字符串哈希
    local test_strings = {
        "Hello, World!",
        "Lua security",
        "Test hash",
    }
    
    for _, str in ipairs(test_strings) do
        local hash = hasher.calculate_simple_hash(str)
        print(string.format("字符串: '%s' -> 哈希: %d", str, hash))
    end
    
    -- 测试密码哈希
    print("\n密码哈希测试:")
    local password = "secure_password"
    local result = hasher.hash_password(password)
    
    print(string.format("密码: '%s'", password))
    print(string.format("盐值: '%s...'", string.sub(result.salt, 1, 16)))
    print(string.format("哈希: '%s'", result.hash))
end

local function demonstrate_logging()
    -- 演示日志记录
    
    print("\n============================================================")
    print("日志记录演示")
    print("============================================================")
    
    -- 创建临时日志目录
    local log_dir = "temp_logs_lua"
    
    local logger = AuditLogger.new(log_dir)
    
    -- 记录各种事件
    logger:log_event("INFO", "用户登录系统")
    logger:log_security_event("LOGIN_SUCCESS", "登录成功")
    logger:log_error("FILE_NOT_FOUND", "找不到文件: test.txt")
    
    print("日志记录完成")
    print(string.format("日志目录: %s", log_dir))
    
    -- 显示日志内容
    local log_file = log_dir .. "\\audit.log"
    local file = io.open(log_file, "r")
    if file then
        print("\n日志内容:")
        print(file:read("*a"))
        file:close()
    end
    
    -- 清理临时日志目录
    os.execute(string.format('rmdir /s /q "%s" 2>nul', log_dir))
end

local function demonstrate_sanitization()
    -- 演示输入消毒
    
    print("\n============================================================")
    print("输入消毒演示")
    print("============================================================")
    
    -- 测试用例
    local test_cases = {
        {input = "file:name.txt", description = "文件名消毒"},
        {input = "  hello world  ", description = "空格处理"},
        {input = "file.txt & command", description = "命令注入消毒"},
        {input = "..\\..\\path", description = "路径遍历消毒"},
    }
    
    for _, test in ipairs(test_cases) do
        local sanitized = InputSanitizer.sanitize_input(test.input)
        print(string.format("%s:", test.description))
        print(string.format("  输入: '%s'", test.input))
        print(string.format("  输出: '%s'", sanitized))
        print("")
    end
end

local function demonstrate_file_operations()
    -- 演示文件操作安全
    
    print("\n============================================================")
    print("文件操作安全演示")
    print("============================================================")
    
    -- 创建临时目录
    local temp_dir = "temp_file_test_lua"
    os.execute(string.format('mkdir "%s" 2>nul', temp_dir))
    
    local handler = SafePathHandler.new(temp_dir)
    
    -- 测试文件写入
    local test_file = "test_file.txt"
    local test_content = "Hello, this is a test file for security demonstration."
    
    print(string.format("创建测试文件: %s", test_file))
    if handler:safe_write(test_file, test_content) then
        print("  文件创建成功")
        
        -- 测试文件读取
        local content = handler:safe_read(test_file)
        if content then
            print(string.format("  文件内容: '%s'", content))
            
            -- 计算哈希
            local hash = SecureHasher.calculate_simple_hash(content)
            print(string.format("  文件哈希: %d", hash))
        else
            print("  文件读取失败")
        end
    else
        print("  文件创建失败")
    end
    
    -- 测试危险路径
    print("\n测试危险路径:")
    local dangerous_paths = {
        "..\\..\\secret.txt",
        "C:\\Windows\\System32\\cmd.exe",
        "file.txt & del /f /q C:\\*.*",
    }
    
    for _, dangerous_path in ipairs(dangerous_paths) do
        local result = handler:safe_join(dangerous_path)
        local status = (result == nil) and "PASS" or "FAIL"
        print(string.format("[%s] 危险路径被拒绝: '%s'", status, dangerous_path))
    end
    
    -- 清理临时目录
    os.execute(string.format('rmdir /s /q "%s" 2>nul', temp_dir))
end

-- ============================================================
-- 主函数
-- ============================================================

local function main()
    print("Lua安全编程对比示例")
    print("============================================================")
    
    demonstrate_input_validation()
    demonstrate_path_security()
    demonstrate_hashing()
    demonstrate_logging()
    demonstrate_sanitization()
    demonstrate_file_operations()
    
    print("\n============================================================")
    print("所有演示完成")
    print("============================================================")
end

-- 运行主函数
main()