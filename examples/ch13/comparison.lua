#!/usr/bin/env luajit
--[[
comparison.lua - Lua os.execute/io.popen 示例

功能: 演示 Lua 如何调用外部命令和程序
用法: luajit comparison.lua
安全提示: 仅在项目目录内操作
--]]

--[[
演示 os.execute() 函数
--]]
local function demo_os_execute()
    print("==================================================")
    print("  方式 1: os.execute() - 简单执行")
    print("==================================================")
    print()
    
    -- 简单命令
    print("[Lua] 执行 'echo' 命令:")
    os.execute("echo Hello from os.execute")
    print()
    
    -- 获取退出码
    print("[Lua] 执行 'dir /b' 命令:")
    local exit_code = os.execute("dir /b *.lua")
    print("[Lua] 退出码: " .. tostring(exit_code))
    print()
    
    -- 失败的命令
    print("[Lua] 执行不存在的命令:")
    exit_code = os.execute("nonexistent_command 2>nul")
    print("[Lua] 退出码: " .. tostring(exit_code))
    print()
end

--[[
演示 io.popen() 管道读取
--]]
local function demo_popen_read()
    print("==================================================")
    print("  方式 2: io.popen() - 管道读取")
    print("==================================================")
    print()
    
    -- 读取单行输出
    print("[Lua] 读取 'hostname' 输出:")
    local pipe = io.popen("hostname")
    if pipe then
        local output = pipe:read("*l")
        print("  主机名: " .. (output or "未知"))
        pipe:close()
    end
    print()
    
    -- 读取多行输出
    print("[Lua] 读取 'dir /b' 输出:")
    pipe = io.popen("dir /b *.lua")
    if pipe then
        local count = 0
        for line in pipe:lines() do
            print("  文件: " .. line)
            count = count + 1
        end
        print("  共 " .. count .. " 个文件")
        pipe:close()
    end
    print()
end

--[[
演示 io.popen() 管道写入
--]]
local function demo_popen_write()
    print("==================================================")
    print("  方式 3: io.popen() - 管道写入")
    print("==================================================")
    print()
    
    print("[Lua] 通过管道写入数据:")
    local pipe = io.popen("findstr /i \"lua\"", "w")
    if pipe then
        pipe:write("Hello World\n")
        pipe:write("Lua Script\n")
        pipe:write("Test Line\n")
        pipe:write("lua example\n")
        pipe:close()
    end
    print()
end

--[[
演示多命令管道
--]]
local function demo_pipe_chain()
    print("==================================================")
    print("  方式 4: 管道链")
    print("==================================================")
    print()
    
    print("[Lua] 执行管道链命令:")
    local pipe = io.popen("echo apple & echo banana & echo cherry | sort")
    if pipe then
        print("  排序结果:")
        for line in pipe:lines() do
            print("    " .. line)
        end
        pipe:close()
    end
    print()
end

--[[
演示捕获命令输出到表
--]]
local function demo_capture_to_table()
    print("==================================================")
    print("  方式 5: 捕获输出到表")
    print("==================================================")
    print()
    
    print("[Lua] 捕获 'dir /b' 输出到表:")
    local pipe = io.popen("dir /b *.lua")
    local files = {}
    if pipe then
        for line in pipe:lines() do
            table.insert(files, line)
        end
        pipe:close()
    end
    
    print("  文件列表:")
    for i, file in ipairs(files) do
        print(string.format("    %d. %s", i, file))
    end
    print("  共 " .. #files .. " 个文件")
    print()
end

--[[
演示执行并获取退出码
--]]
local function demo_exit_code()
    print("==================================================")
    print("  方式 6: 获取退出码")
    print("==================================================")
    print()
    
    -- 成功的命令
    print("[Lua] 执行成功的命令:")
    local success, exit_type, exit_code = os.execute("echo test >nul")
    print("  成功: " .. tostring(success))
    print("  退出类型: " .. tostring(exit_type))
    print("  退出码: " .. tostring(exit_code))
    print()
    
    -- 失败的命令
    print("[Lua] 执行失败的命令:")
    success, exit_type, exit_code = os.execute("nonexistent_command 2>nul")
    print("  成功: " .. tostring(success))
    print("  退出类型: " .. tostring(exit_type))
    print("  退出码: " .. tostring(exit_code))
    print()
end

--[[
演示执行外部程序
--]]
local function demo_external_program()
    print("==================================================")
    print("  方式 7: 执行外部程序")
    print("==================================================")
    print()
    
    -- 执行 Python 脚本（如果可用）
    print("[Lua] 尝试执行 Python:")
    local pipe = io.popen("python --version 2>&1")
    if pipe then
        local output = pipe:read("*a")
        if output and output ~= "" then
            print("  " .. output:gsub("\n", ""))
        else
            print("  Python 未安装")
        end
        pipe:close()
    end
    print()
    
    -- 执行 Node.js（如果可用）
    print("[Lua] 尝试执行 Node.js:")
    pipe = io.popen("node --version 2>&1")
    if pipe then
        local output = pipe:read("*a")
        if output and output ~= "" then
            print("  " .. output:gsub("\n", ""))
        else
            print("  Node.js 未安装")
        end
        pipe:close()
    end
    print()
end

--[[
主函数
--]]
local function main()
    print()
    print("+================================================+")
    print("|        Lua os.execute/io.popen 示例           |")
    print("+================================================+")
    print()
    
    -- 演示各种调用方式
    demo_os_execute()
    demo_popen_read()
    demo_popen_write()
    demo_pipe_chain()
    demo_capture_to_table()
    demo_exit_code()
    demo_external_program()
    
    print("==================================================")
    print("  演示完成")
    print("==================================================")
    
    os.exit(0)
end

-- 执行主函数
main()
