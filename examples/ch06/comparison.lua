#!/usr/bin/env lua
--[[
comparison.lua - Lua文件I/O对比示例

本文件展示Lua中文件I/O操作，用于与CMD的文件I/O进行对比。
Lua提供了简洁的文件操作API。
]]

-- 创建测试目录（跨平台）
local function ensure_test_dir()
    local test_dir = "test_output"
    local success, err
    
    -- 尝试创建目录
    if package.config:sub(1,1) == '\\' then
        -- Windows
        success = os.execute('mkdir "' .. test_dir .. '" 2>nul')
    else
        -- Unix/Linux
        success = os.execute('mkdir -p "' .. test_dir .. '"')
    end
    
    return test_dir
end

-- 演示基本文件I/O
local function demonstrate_basic_io(test_dir)
    print("=== Lua基本文件I/O ===\n")
    
    local filepath = test_dir .. "/output.txt"
    
    -- 1. 写入文件（覆盖模式）
    print("1. 写入文件（覆盖模式）")
    local file = io.open(filepath, "w")
    if not file then
        print("错误: 无法创建文件")
        return
    end
    
    file:write("Hello World\n")
    file:write("Lua文件写入\n")
    file:write("第三行内容\n")
    file:close()
    
    -- 读取并显示
    file = io.open(filepath, "r")
    if not file then
        print("错误: 无法打开文件")
        return
    end
    
    print("文件内容:")
    local content = file:read("*a")
    print(content)
    file:close()
    
    -- 2. 追加写入
    print("2. 追加写入")
    file = io.open(filepath, "a")
    if not file then
        print("错误: 无法打开文件")
        return
    end
    
    file:write("追加的第一行\n")
    file:write("追加的第二行\n")
    file:close()
    
    -- 读取并显示
    file = io.open(filepath, "r")
    if not file then
        print("错误: 无法打开文件")
        return
    end
    
    print("追加后内容:")
    content = file:read("*a")
    print(content)
    file:close()
end

-- 演示逐行读取
local function demonstrate_line_by_line(test_dir)
    print("\n=== 逐行读取 ===\n")
    
    -- 创建测试文件
    local filepath = test_dir .. "/lines.txt"
    local file = io.open(filepath, "w")
    if not file then
        print("错误: 无法创建文件")
        return
    end
    
    for i = 1, 5 do
        file:write(string.format("Line %d: This is line number %d\n", i, i))
    end
    file:close()
    
    -- 方法1: 使用io.lines迭代器
    print("方法1: 使用io.lines迭代器")
    local line_number = 0
    for line in io.lines(filepath) do
        line_number = line_number + 1
        print(string.format("  %d: %s", line_number, line))
    end
    
    -- 方法2: 使用file:read逐行读取
    print("\n方法2: 使用file:read逐行读取")
    file = io.open(filepath, "r")
    if not file then
        print("错误: 无法打开文件")
        return
    end
    
    line_number = 0
    local line = file:read("*l")
    while line do
        line_number = line_number + 1
        print(string.format("  %d: %s", line_number, line))
        line = file:read("*l")
    end
    file:close()
    
    -- 方法3: 读取所有行到表中
    print("\n方法3: 读取所有行到表中")
    local lines = {}
    for line in io.lines(filepath) do
        table.insert(lines, line)
    end
    
    for i, line in ipairs(lines) do
        print(string.format("  %d: %s", i, line))
    end
end

-- 演示文件操作
local function demonstrate_file_operations(test_dir)
    print("\n=== 文件操作 ===\n")
    
    local filepath = test_dir .. "/operations.txt"
    
    -- 创建测试文件
    local file = io.open(filepath, "w")
    if not file then
        print("错误: 无法创建文件")
        return
    end
    file:write("测试文件操作\n")
    file:close()
    
    -- 1. 检查文件是否存在
    local test_file = io.open(filepath, "r")
    if test_file then
        print("1. 文件存在: 是")
        test_file:close()
    else
        print("1. 文件存在: 否")
    end
    
    -- 2. 获取文件大小
    file = io.open(filepath, "r")
    if file then
        local size = file:seek("end")
        print(string.format("2. 文件大小: %d 字节", size))
        file:close()
    end
    
    -- 3. 重命名文件
    local newpath = test_dir .. "/renamed.txt"
    local success, err = os.rename(filepath, newpath)
    if success then
        print("3. 重命名: operations.txt -> renamed.txt")
    else
        print("3. 重命名失败: " .. (err or "未知错误"))
    end
    
    -- 4. 复制文件
    local copypath = test_dir .. "/copy.txt"
    local src = io.open(newpath, "r")
    local dst = io.open(copypath, "w")
    
    if src and dst then
        local content = src:read("*a")
        dst:write(content)
        print("4. 复制: renamed.txt -> copy.txt")
    end
    
    if src then src:close() end
    if dst then dst:close() end
    
    -- 5. 删除文件
    local success, err = os.remove(copypath)
    if success then
        print("5. 删除: copy.txt")
        
        -- 检查文件是否存在
        test_file = io.open(copypath, "r")
        if test_file then
            print("   文件存在: 是")
            test_file:close()
        else
            print("   文件存在: 否")
        end
    else
        print("5. 删除失败: " .. (err or "未知错误"))
    end
end

-- 演示格式化I/O
local function demonstrate_formatted_io(test_dir)
    print("\n=== 格式化I/O ===\n")
    
    local filepath = test_dir .. "/formatted.txt"
    
    -- 写入格式化数据
    local file = io.open(filepath, "w")
    if not file then
        print("错误: 无法创建文件")
        return
    end
    
    file:write(string.format("整数: %d\n", 42))
    file:write(string.format("浮点数: %.2f\n", 3.14159))
    file:write(string.format("字符串: %s\n", "Hello"))
    file:write(string.format("十六进制: %X\n", 255))
    file:write(string.format("八进制: %o\n", 255))
    file:close()
    
    -- 读取格式化数据
    file = io.open(filepath, "r")
    if not file then
        print("错误: 无法打开文件")
        return
    end
    
    print("格式化文件内容:")
    local content = file:read("*a")
    print(content)
    file:close()
    
    -- 解析格式化数据
    print("解析格式化数据:")
    for line in io.lines(filepath) do
        local key, value = line:match("^(.+): (.+)$")
        if key and value then
            print(string.format("  %s = %s", key, value))
        end
    end
end

-- 演示错误处理
local function demonstrate_error_handling(test_dir)
    print("\n=== 错误处理 ===\n")
    
    -- 1. 文件不存在
    print("1. 文件不存在错误:")
    local file, err = io.open("nonexistent.txt", "r")
    if not file then
        print("   捕获错误: " .. (err or "未知错误"))
    end
    
    -- 2. 使用pcall捕获错误
    print("\n2. 使用pcall捕获错误:")
    local success, result = pcall(function()
        local f = io.open("nonexistent.txt", "r")
        if not f then
            error("无法打开文件")
        end
        return f:read("*a")
    end)
    
    if not success then
        print("   捕获错误: " .. result)
    end
    
    -- 3. 安全的文件读取函数
    print("\n3. 安全的文件读取函数:")
    local function safe_read(filepath)
        local file, err = io.open(filepath, "r")
        if not file then
            return nil, err
        end
        local content = file:read("*a")
        file:close()
        return content
    end
    
    local content, err = safe_read("nonexistent.txt")
    if not content then
        print("   捕获错误: " .. err)
    end
end

-- 演示临时文件
local function demonstrate_temp_files(test_dir)
    print("\n=== 临时文件操作 ===\n")
    
    -- 创建临时文件名
    local temp_name = os.tmpname()
    print("临时文件名: " .. temp_name)
    
    -- 写入临时文件
    local file = io.open(temp_name, "w")
    if file then
        file:write("临时文件内容\n")
        file:write("测试数据\n")
        file:close()
        
        -- 读取临时文件
        file = io.open(temp_name, "r")
        if file then
            print("临时文件内容:")
            local content = file:read("*a")
            print(content)
            file:close()
        end
        
        -- 删除临时文件
        os.remove(temp_name)
        print("临时文件已删除")
    end
end

-- 演示字符串作为文件
local function demonstrate_string_io(test_dir)
    print("\n=== 字符串I/O ===\n")
    
    -- 使用字符串作为输入
    print("1. 从字符串读取:")
    local input = "Hello\nWorld\nLua"
    local line_number = 0
    for line in input:gmatch("[^\n]+") do
        line_number = line_number + 1
        print(string.format("  %d: %s", line_number, line))
    end
    
    -- 使用字符串作为输出
    print("\n2. 写入字符串:")
    local output = {}
    table.insert(output, "第一行")
    table.insert(output, "第二行")
    table.insert(output, "第三行")
    
    local result = table.concat(output, "\n")
    print("  结果: " .. result)
end

-- 清理测试目录
local function cleanup(test_dir)
    print("\n清理测试目录...")
    
    -- 删除所有测试文件
    local files = {
        "output.txt", "lines.txt", "operations.txt",
        "renamed.txt", "formatted.txt"
    }
    
    for _, file in ipairs(files) do
        os.remove(test_dir .. "/" .. file)
    end
    
    -- 删除目录
    os.remove(test_dir)
    print("清理完成")
end

-- 主函数
local function main()
    print("Lua文件I/O对比示例")
    print("==================================================")
    
    -- 创建测试目录
    local test_dir = ensure_test_dir()
    
    -- 演示各种文件操作
    demonstrate_basic_io(test_dir)
    demonstrate_line_by_line(test_dir)
    demonstrate_file_operations(test_dir)
    demonstrate_formatted_io(test_dir)
    demonstrate_error_handling(test_dir)
    demonstrate_temp_files(test_dir)
    demonstrate_string_io(test_dir)
    
    -- 清理
    cleanup(test_dir)
    
    print("\n==================================================")
    print("Lua文件I/O演示完成")
    print("==================================================")
end

-- 运行主函数
main()