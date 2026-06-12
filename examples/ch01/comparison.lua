-- comparison.lua - Lua/LuaJIT与CMD对比示例
-- 说明：展示Lua/LuaJIT中与CMD等价的功能实现

-- 1. 输出对比
-- CMD: echo Hello, World!
-- Lua: print("Hello, World!")
print("==================================================")
print("       Lua/LuaJIT与CMD对比示例")
print("==================================================")
print()

print("1. 输出对比:")
print("   CMD: echo Hello, World!")
print("   Lua: print('Hello, World!')")
print("   结果: Hello, World!")
print()

-- 2. 变量定义对比
-- CMD: set "name=CMD学习者"
-- Lua: local name = "Lua学习者"
print("2. 变量定义对比:")
local name = "Lua学习者"
print(string.format("   CMD: set \"name=CMD学习者\""))
print(string.format("   Lua: local name = \"%s\"", name))
print(string.format("   结果: %s", name))
print()

-- 3. 算术运算对比
-- CMD: set /a "result=5+3"
-- Lua: local result = 5 + 3
print("3. 算术运算对比:")
local result = 5 + 3
print("   CMD: set /a \"result=5+3\"")
print("   Lua: local result = 5 + 3")
print(string.format("   结果: %d", result))
print()

-- 4. 用户输入对比
-- CMD: set /p "user_input=请输入: "
-- Lua: local user_input = io.read()
print("4. 用户输入对比:")
print("   CMD: set /p \"user_input=请输入: \"")
print("   Lua: local user_input = io.read()")
print("   说明: Lua使用io.read()读取标准输入")
print()

-- 5. 条件判断对比
-- CMD: if "%var%"=="value" (echo 真) else (echo 假)
-- Lua: if var == "value" then print("真") else print("假") end
print("5. 条件判断对比:")
local choice = "Y"
print("   CMD: if \"%var%\"==\"value\" (echo 真) else (echo 假)")
print("   Lua: if var == \"value\" then print(\"真\") else print(\"假\") end")
if choice == "Y" then
    print("   结果: 真")
else
    print("   结果: 假")
end
print()

-- 6. 循环对比
-- CMD: for /l %%i in (1,1,5) do echo %%i
-- Lua: for i = 1, 5 do print(i) end
print("6. 循环对比:")
print("   CMD: for /l %%%%i in (1,1,5) do echo %%%%i")
print("   Lua: for i = 1, 5 do print(i) end")
print("   结果:")
for i = 1, 5 do
    print(string.format("     %d", i))
end
print()

-- 7. 字符串处理对比
-- CMD: set "str=Hello %name%"
-- Lua: local str = "Hello " .. name
print("7. 字符串处理对比:")
local str = "Hello " .. name
print("   CMD: set \"str=Hello %name%\"")
print("   Lua: local str = \"Hello \" .. name")
print(string.format("   结果: %s", str))
print()

-- 8. 表/数组对比
-- CMD: 无原生数组支持
-- Lua: local arr = {1, 2, 3, 4, 5}
print("8. 表/数组对比:")
print("   CMD: 无原生数组支持，需要特殊处理")
print("   Lua: local arr = {1, 2, 3, 4, 5}")
local arr = {1, 2, 3, 4, 5}
print("   结果: " .. table.concat(arr, ", "))
print()

-- 9. 函数定义对比
-- CMD: 无原生函数支持，使用标签和goto
-- Lua: function myFunc() ... end
print("9. 函数定义对比:")
print("   CMD: 使用标签和goto模拟函数")
print("   Lua: function myFunc() ... end")
print("   说明: Lua支持真正的函数和闭包")
print()

-- 10. 错误处理对比
-- CMD: command || echo 错误
-- Lua: pcall(function() ... end) 或 xpcall
print("10. 错误处理对比:")
print("    CMD: command || echo 错误")
print("    Lua: pcall(function() ... end) 或 xpcall")
print("    说明: Lua的pcall可以捕获运行时错误")
print()

-- 11. 注释对比
-- CMD: :: 注释 或 REM 注释
-- Lua: -- 注释 或 --[[ 多行注释 ]]
print("11. 注释对比:")
print("    CMD: :: 注释 或 REM 注释")
print("    Lua: -- 注释 或 --[[ 多行注释 ]]")
print()

-- 12. 模块系统对比
-- CMD: call other.bat
-- Lua: require("module")
print("12. 模块系统对比:")
print("    CMD: call other.bat")
print("    Lua: require(\"module\")")
print("    说明: Lua有完整的模块系统，支持包管理")
print()

-- 13. 元表/面向对象对比
-- CMD: 无面向对象支持
-- Lua: 使用元表实现面向对象
print("13. 元表/面向对象对比:")
print("    CMD: 无面向对象支持")
print("    Lua: 使用元表实现面向对象")
print("    说明: Lua通过元表实现原型继承")
print()

-- 14. 垃圾回收对比
-- CMD: 无内存管理
-- Lua: 自动垃圾回收
print("14. 垃圾回收对比:")
print("    CMD: 无内存管理，变量自动管理")
print("    Lua: 自动垃圾回收，无需手动管理")
print("    说明: Lua有自动垃圾回收机制")
print()

-- 15. 协程对比
-- CMD: 无协程支持
-- Lua: coroutine.create/resume
print("15. 协程对比:")
print("    CMD: 无协程支持")
print("    Lua: coroutine.create/resume")
print("    说明: Lua原生支持协程，适合异步编程")
print()

print("==================================================")
print("       Lua/LuaJIT与CMD对比完成")
print("==================================================")
print()
print("主要差异总结:")
print("1. Lua是动态类型语言，CMD所有变量都是字符串")
print("2. Lua支持表（table）作为通用数据结构")
print("3. Lua有自动垃圾回收，CMD无内存管理")
print("4. Lua支持闭包和协程，CMD功能有限")
print("5. Lua是嵌入式脚本语言，CMD是系统脚本")
print("6. Lua跨平台，CMD仅限Windows")
print("7. LuaJIT有JIT编译，性能更高")
print("8. Lua适合嵌入其他程序，CMD用于系统管理")