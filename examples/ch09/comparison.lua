-- Lua 环境变量操作对比
-- 文件: comparison.lua
-- 作者: 教程工程师
-- 日期: 2026-06-11
-- 说明: 展示Lua中环境变量操作与CMD的对比
-- 注意: Lua标准库没有直接操作注册表的功能，需要通过系统命令

-- 颜色定义
local colors = {
    reset = "\27[0m",
    bright = "\27[1m",
    red = "\27[31m",
    green = "\27[32m",
    yellow = "\27[33m",
    blue = "\27[34m",
    magenta = "\27[35m",
    cyan = "\27[36m"
}

-- 格式化输出函数
local function print_header(title)
    print("\n" .. colors.bright .. colors.cyan .. "============================================================" .. colors.reset)
    print(colors.bright .. colors.cyan .. title .. colors.reset)
    print(colors.bright .. colors.cyan .. "============================================================" .. colors.reset)
end

local function print_subheader(title)
    print("\n" .. colors.yellow .. "[" .. title .. "]" .. colors.reset)
    print(colors.yellow .. "----------------------------------------" .. colors.reset)
end

local function print_success(message)
    print(colors.green .. "✓ " .. message .. colors.reset)
end

local function print_error(message)
    print(colors.red .. "✗ " .. message .. colors.reset)
end

local function print_warning(message)
    print(colors.yellow .. "⚠ " .. message .. colors.reset)
end

local function print_info(message)
    print(colors.blue .. "ℹ " .. message .. colors.reset)
end

-- 环境变量操作对比
local function compare_environment_variables()
    print_header("环境变量操作对比")

    -- 1. 获取环境变量
    print_subheader("获取环境变量")
    
    -- Lua方式
    local lua_path = os.getenv("PATH") or "默认值"
    local lua_temp = os.getenv("TEMP") or "默认值"
    local lua_userprofile = os.getenv("USERPROFILE") or "默认值"
    
    -- 截断PATH显示
    if #lua_path > 100 then
        print_info("Lua获取PATH: " .. lua_path:sub(1, 100) .. "...")
    else
        print_info("Lua获取PATH: " .. lua_path)
    end
    
    print_info("Lua获取TEMP: " .. lua_temp)
    print_info("Lua获取USERPROFILE: " .. lua_userprofile)
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print("  echo %PATH%")
    print("  echo %TEMP%")
    print("  echo %USERPROFILE%")

    -- 2. 设置环境变量
    print_subheader("设置环境变量")
    
    -- Lua方式 - 注意：Lua标准库没有os.setenv函数
    print_warning("Lua标准库没有os.setenv函数，需要通过系统命令:")
    print_info("Lua设置环境变量: os.execute('set LUA_TEST_VAR=Lua Test Value')")
    
    -- 实际执行（仅在当前CMD会话中有效）
    os.execute('set LUA_TEST_VAR=Lua Test Value')
    
    -- 验证设置
    local lua_test_var = os.getenv("LUA_TEST_VAR")
    if lua_test_var then
        print_success("Lua设置LUA_TEST_VAR: " .. lua_test_var)
    else
        print_error("Lua设置LUA_TEST_VAR: 失败（可能因为os.execute在子进程中执行）")
    end
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print("  set LUA_TEST_VAR=Lua Test Value")

    -- 3. 删除环境变量
    print_subheader("删除环境变量")
    
    -- Lua方式
    print_warning("Lua标准库没有os.unsetenv函数，需要通过系统命令:")
    print_info("Lua删除环境变量: os.execute('set LUA_TEST_VAR=')")
    
    -- 实际执行
    os.execute('set LUA_TEST_VAR=')
    
    -- 验证删除
    lua_test_var = os.getenv("LUA_TEST_VAR")
    if not lua_test_var then
        print_success("Lua删除LUA_TEST_VAR: 成功")
    else
        print_error("Lua删除LUA_TEST_VAR: 失败")
    end
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print("  set LUA_TEST_VAR=")

    -- 4. 遍历环境变量
    print_subheader("遍历环境变量")
    
    -- Lua方式 - 通过pairs遍历环境表
    print_info("Lua遍历环境变量（前10个）:")
    
    local count = 0
    for key, value in pairs(os.getenv) do
        if count >= 10 then break end
        if type(key) == "string" and type(value) == "string" then
            print("  " .. key .. ": " .. value:sub(1, 50) .. "...")
            count = count + 1
        end
    end
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print("  set")
end

-- PATH变量操作对比
local function compare_path_operations()
    print_header("PATH变量操作对比")

    -- 1. 获取PATH
    print_subheader("获取PATH变量")
    
    -- Lua方式
    local lua_path = os.getenv("PATH") or ""
    local path_list = {}
    
    -- 分割PATH
    for path_dir in lua_path:gmatch("[^;]+") do
        table.insert(path_list, path_dir)
    end
    
    print_info("Lua获取PATH（前5个目录）:")
    for i = 1, math.min(5, #path_list) do
        print("  " .. i .. ". " .. path_list[i])
    end
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print("  echo %PATH%")

    -- 2. 添加目录到PATH
    print_subheader("添加目录到PATH")
    
    -- Lua方式
    local new_path = "C:\\LuaTestDir"
    local current_path = os.getenv("PATH") or ""
    local updated_path = current_path .. ";" .. new_path
    
    print_warning("Lua添加目录到PATH需要通过系统命令:")
    print_info("Lua添加目录到PATH: os.execute('set PATH=" .. updated_path .. "')")
    
    -- 实际执行（仅在当前CMD会话中有效）
    os.execute('set PATH=' .. updated_path)
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print("  set PATH=%PATH%;" .. new_path)

    -- 3. 检查目录是否存在
    print_subheader("检查PATH目录是否存在")
    
    -- Lua方式
    print_info("Lua检查PATH目录:")
    local missing_count = 0
    
    for i, path_dir in ipairs(path_list) do
        -- 尝试打开目录
        local test_file = io.open(path_dir .. "\\test.txt", "r")
        if test_file then
            test_file:close()
            print_success("[存在] " .. path_dir)
        else
            -- 检查目录是否存在（通过尝试创建临时文件）
            local temp_file = os.tmpname()
            local success = os.execute('dir "' .. path_dir .. '" >nul 2>&1')
            if success then
                print_success("[存在] " .. path_dir)
            else
                print_error("[缺失] " .. path_dir)
                missing_count = missing_count + 1
            end
            os.remove(temp_file)
        end
        
        if i >= 10 then break end
    end
    
    print_info("检查目录数量: " .. math.min(10, #path_list))
    print_info("缺失目录数量: " .. missing_count)
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print('  for %%i in ("%PATH:;=" "%") do if not exist "%%~i" echo 缺失: %%~i')
end

-- 注册表操作对比
local function compare_registry_operations()
    print_header("注册表操作对比")

    -- 1. 查询注册表
    print_subheader("查询注册表")
    
    -- Lua方式 - 通过系统命令
    print_warning("Lua没有直接操作注册表的函数，需要通过系统命令:")
    print_info("Lua查询用户环境变量: os.execute('reg query \"HKCU\\Environment\"')")
    
    -- 实际执行
    local success = os.execute('reg query "HKCU\\Environment"')
    if success then
        print_success("Lua查询注册表: 成功")
    else
        print_error("Lua查询注册表: 失败")
    end
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print('  reg query "HKCU\\Environment"')

    -- 2. 查询特定值
    print_subheader("查询特定注册表值")
    
    -- Lua方式
    print_info("Lua查询Path值:")
    success = os.execute('reg query "HKCU\\Environment" /v Path')
    if success then
        print_success("Lua查询Path值: 成功")
    else
        print_error("Lua查询Path值: 失败")
    end
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print('  reg query "HKCU\\Environment" /v Path')

    -- 3. 添加注册表值（仅演示，不实际执行）
    print_subheader("添加注册表值（演示）")
    
    print_warning("Lua添加注册表值需要调用系统命令:")
    print_info('Lua添加注册表值: os.execute(\'reg add "HKCU\\Environment" /v "LUA_TEST_REG" /t REG_SZ /d "Lua Registry Value" /f\')')
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print('  reg add "HKCU\\Environment" /v "LUA_TEST_REG" /t REG_SZ /d "Lua Registry Value" /f')

    -- 4. 删除注册表值（仅演示，不实际执行）
    print_subheader("删除注册表值（演示）")
    
    print_warning("Lua删除注册表值需要调用系统命令:")
    print_info('Lua删除注册表值: os.execute(\'reg delete "HKCU\\Environment" /v "LUA_TEST_REG" /f\')')
    
    -- CMD等价命令
    print("\nCMD等价命令:")
    print('  reg delete "HKCU\\Environment" /v "LUA_TEST_REG" /f')
end

-- 创建对比报告
local function create_comparison_report()
    print_header("创建对比报告")

    -- 获取当前时间
    local current_time = os.date("%Y-%m-%d %H:%M:%S")
    
    -- 获取系统信息
    local hostname = os.getenv("COMPUTERNAME") or "未知"
    local username = os.getenv("USERNAME") or "未知"
    local os_name = os.getenv("OS") or "未知"
    
    print_info("对比报告:")
    print_info("  生成时间: " .. current_time)
    print_info("  Lua版本: " .. (jit and jit.version or _VERSION))
    print_info("  主机名: " .. hostname)
    print_info("  用户名: " .. username)
    print_info("  操作系统: " .. os_name)
    
    print_info("  环境变量操作:")
    print_info("    os.getenv() - 获取环境变量")
    print_info("    os.execute('set ...') - 设置环境变量")
    print_info("    os.execute('reg ...') - 操作注册表")
    
    -- 保存报告到文件
    local report_file = io.open("env_registry_comparison_lua.txt", "w")
    if report_file then
        report_file:write("Lua环境变量操作对比报告\n")
        report_file:write("=========================\n\n")
        report_file:write("生成时间: " .. current_time .. "\n\n")
        report_file:write("主要函数:\n")
        report_file:write("  os.getenv() - 获取环境变量\n")
        report_file:write("  os.execute('set ...') - 设置环境变量\n")
        report_file:write("  os.execute('reg query ...') - 查询注册表\n")
        report_file:write("  os.execute('reg add ...') - 添加注册表值\n")
        report_file:write("  os.execute('reg delete ...') - 删除注册表值\n")
        report_file:write("\nCMD等价命令:\n")
        report_file:write("  echo %VARIABLE_NAME% - 获取环境变量\n")
        report_file:write("  set VARIABLE_NAME=value - 设置环境变量\n")
        report_file:write('  reg query "HKCU\\Environment" - 查询注册表\n')
        report_file:write('  reg add "HKCU\\Environment" /v Name /t REG_SZ /d Value /f - 添加注册表值\n')
        report_file:write('  reg delete "HKCU\\Environment" /v Name /f - 删除注册表值\n')
        
        report_file:close()
        print_success("对比报告已保存到: env_registry_comparison_lua.txt")
    else
        print_error("无法创建报告文件")
    end
end

-- 主函数
local function main()
    print(colors.bright .. colors.magenta .. "Lua 环境变量操作对比演示" .. colors.reset)
    print("作者: 教程工程师")
    print("日期: 2026-06-11")
    print("\n")

    compare_environment_variables()
    compare_path_operations()
    compare_registry_operations()
    create_comparison_report()

    print_header("对比演示完成")
    print("\n主要区别总结:")
    print("1. Lua使用os.getenv()获取环境变量，CMD使用echo命令")
    print("2. Lua没有内置的注册表操作函数，需要通过os.execute调用系统命令")
    print("3. Lua标准库功能有限，扩展性依赖外部库")
    print("4. Lua更适合嵌入式系统和游戏脚本")
    print("5. CMD更适合Windows系统管理和简单脚本任务")
    
    print("\nLua的优势:")
    print("  - 轻量级，易于嵌入")
    print("  - 语法简洁，学习曲线平缓")
    print("  - 性能良好，适合脚本任务")
    
    print("\nLua的局限性:")
    print("  - 标准库功能有限")
    print("  - 没有内置的注册表操作")
    print("  - 需要系统命令实现复杂功能")
end

-- 运行主函数
main()