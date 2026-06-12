#!/usr/bin/env luajit
--[[
hello.lua - LuaJIT 示例脚本

功能: 接收命令行参数并输出信息
用法: luajit hello.lua [arg1] [arg2] ...
安全提示: 仅在项目目录内操作
--]]

-- 输出脚本信息
print("========================================")
print("  LuaJIT 脚本示例")
print("========================================")
print()

-- 获取 Lua 版本
print("[Lua] 版本: " .. (_VERSION or "unknown"))

-- 处理参数
print("[Lua] 参数数量: " .. #arg)
print()

if #arg > 0 then
    print("[Lua] 命令行参数:")
    for i, v in ipairs(arg) do
        print(string.format("  arg[%d] = \"%s\"", i, v))
    end
else
    print("[Lua] 没有命令行参数")
end
print()

-- 字符串操作演示
print("[Lua] 字符串演示:")
local test_str = "Hello, World!"
print("  原始字符串: " .. test_str)
print("  长度: " .. #test_str)
print("  大写: " .. string.upper(test_str))
print("  小写: " .. string.lower(test_str))
print("  子串(1,5): " .. string.sub(test_str, 1, 5))
print()

-- 数学计算演示
print("[Lua] 数学计算:")
print("  圆周率: " .. math.pi)
print("  2^10 = " .. 2^10)
print("  sqrt(144) = " .. math.sqrt(144))
print("  floor(3.7) = " .. math.floor(3.7))
print("  ceil(3.2) = " .. math.ceil(3.2))
print()

-- 表操作演示
print("[Lua] 表操作:")
local fruits = {"apple", "banana", "cherry", "date", "elderberry"}
print("  水果列表:")
for i, fruit in ipairs(fruits) do
    print(string.format("    %d. %s", i, fruit))
end
print("  数量: " .. #fruits)
print()

-- os.date 获取当前时间
print("[Lua] 当前时间: " .. os.date("%Y-%m-%d %H:%M:%S"))
print()

print("========================================")
print("  脚本执行完成")
print("========================================")

-- 通过 os.exit 返回退出码 (0 = 成功)
os.exit(0)
