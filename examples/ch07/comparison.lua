-- ============================================================
-- comparison.lua - Lua函数对比
-- 第07章 函数与模块化示例
--
-- 安全提示：本脚本仅进行变量操作和控制流演示
-- ============================================================

-- Lua中的函数定义和调用示例

-- 1. 基本函数定义
local function greet(name)
    -- 对应CMD的:greet
    print(string.format("你好, %s! 欢迎学习批处理编程。", name))
end

-- 2. 带返回值的函数
local function add(a, b)
    -- 对应CMD的:add
    return a + b
end

local function multiply(a, b)
    -- 对应CMD的:multiply
    return a * b
end

-- 3. 多返回值函数
local function get_min_max(...)
    -- 对应CMD的:get_min_max
    local numbers = {...}
    if #numbers == 0 then
        return nil, nil
    end
    
    local min_val = numbers[1]
    local max_val = numbers[1]
    
    for i = 2, #numbers do
        if numbers[i] < min_val then
            min_val = numbers[i]
        end
        if numbers[i] > max_val then
            max_val = numbers[i]
        end
    end
    
    return min_val, max_val
end

-- 4. 默认参数（通过or实现）
local function greet_with_default(name, greeting)
    -- 对应CMD没有直接支持，但可以通过参数检查实现
    greeting = greeting or "Hello"
    return string.format("%s, %s!", greeting, name)
end

-- 5. 可变参数
local function sum_all(...)
    -- 对应CMD的sum_array
    local sum = 0
    local numbers = {...}
    for _, num in ipairs(numbers) do
        sum = sum + num
    end
    return sum
end

-- 6. 作用域演示
local function scope_demo()
    -- 对应CMD的setlocal/endlocal
    local local_var = "I am local"  -- 局部变量
    print("函数内 local_var: " .. local_var)
    return local_var
end

-- 7. 闭包
local function make_counter()
    -- 对应CMD没有的概念
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

-- 8. 高阶函数
local function with_logging(fn)
    return function(...)
        print(string.format("调用函数，参数: %s", table.concat({...}, ", ")))
        local result = fn(...)
        print(string.format("返回结果: %s", tostring(result)))
        return result
    end
end

-- 9. 匿名函数
local square = function(x) return x ^ 2 end

-- 10. 表方法
local Calculator = {}
Calculator.__index = Calculator

function Calculator.new()
    local self = setmetatable({}, Calculator)
    self.history = {}
    return self
end

function Calculator:add(a, b)
    local result = a + b
    table.insert(self.history, string.format("%d + %d = %d", a, b, result))
    return result
end

function Calculator:multiply(a, b)
    local result = a * b
    table.insert(self.history, string.format("%d * %d = %d", a, b, result))
    return result
end

function Calculator:show_history()
    print("计算历史:")
    for i, entry in ipairs(self.history) do
        print(string.format("  %d. %s", i, entry))
    end
end

-- 11. 协程（Lua特有）
local function producer_consumer()
    -- 对应CMD没有的概念
    local co = coroutine.create(function()
        for i = 1, 5 do
            coroutine.yield(i * 10)
        end
    end)
    
    return function()
        local status, value = coroutine.resume(co)
        if status then
            return value
        else
            return nil
        end
    end
end

-- ============================================================
-- 主程序
-- ============================================================
print(string.rep("=", 50))
print("Lua函数对比演示")
print(string.rep("=", 50))
print()

-- 调用基本函数
print("=== 基本函数调用 ===")
greet("Alice")
greet("Bob")
print()

-- 调用带返回值的函数
print("=== 返回值 ===")
print(string.format("add(3, 5) = %d", add(3, 5)))
print(string.format("multiply(4, 6) = %d", multiply(4, 6)))
print()

-- 多返回值
print("=== 多返回值 ===")
local min_val, max_val = get_min_max(5, 2, 8, 1, 9)
print(string.format("最小值: %s, 最大值: %s", tostring(min_val), tostring(max_val)))
print()

-- 默认参数
print("=== 默认参数 ===")
print(greet_with_default("Alice"))
print(greet_with_default("Bob", "Hi"))
print()

-- 可变参数
print("=== 可变参数 ===")
print(string.format("sum_all(1, 2, 3, 4, 5) = %d", sum_all(1, 2, 3, 4, 5)))
print()

-- 作用域演示
print("=== 作用域演示 ===")
local global_var = "I am global"
print("调用前 global_var: " .. global_var)
scope_demo()
print("调用后 global_var: " .. global_var)
print()

-- 闭包
print("=== 闭包演示 ===")
local counter = make_counter()
print(string.format("计数: %d", counter()))
print(string.format("计数: %d", counter()))
print(string.format("计数: %d", counter()))
print()

-- 高阶函数
print("=== 高阶函数 ===")
local logged_add = with_logging(add)
logged_add(10, 20)
print()

-- 匿名函数
print("=== 匿名函数 ===")
print(string.format("square(5) = %d", square(5)))
print()

-- 表方法（面向对象）
print("=== 表方法（面向对象）===")
local calc = Calculator.new()
calc:add(10, 20)
calc:multiply(3, 7)
calc:show_history()
print()

-- 协程
print("=== 协程（Lua特有）===")
local get_next = producer_consumer()
for i = 1, 5 do
    print(string.format("生产值: %d", get_next()))
end
print()

-- 表推导式（Lua没有，但可以用表构造）
print("=== 表构造 ===")
local squares = {}
for i = 1, 5 do
    squares[i] = i ^ 2
end
print("1-5的平方: " .. table.concat(squares, ", "))
