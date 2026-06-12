-- Lua 条件语句对比示例
-- 用于与CMD的if语句进行对比

print("Lua 条件语句示例")
print(string.rep("=", 50))

-- 1. 基本if/then/elseif/else
print("\n1. 基本if/then/elseif/else:")
local score = 85

if score >= 90 then
    print("   成绩优秀")
elseif score >= 80 then
    print("   成绩良好")
elseif score >= 60 then
    print("   成绩及格")
else
    print("   成绩不及格")
end

-- 2. 字符串比较
print("\n2. 字符串比较:")
local name = "test"

if name == "test" then
    print("   字符串相等")
else
    print("   字符串不相等")
end

-- 3. 数值比较运算符
print("\n3. 数值比较运算符:")
local a = 10
local b = 20

print(string.format("   比较 %d 和 %d:", a, b))
print(string.format("   %d == %d: %s", a, b, tostring(a == b)))
print(string.format("   %d ~= %d: %s", a, b, tostring(a ~= b)))
print(string.format("   %d < %d: %s", a, b, tostring(a < b)))
print(string.format("   %d <= %d: %s", a, b, tostring(a <= b)))
print(string.format("   %d > %d: %s", a, b, tostring(a > b)))
print(string.format("   %d >= %d: %s", a, b, tostring(a >= b)))

-- 4. 字符串比较与数值比较的区别
print("\n4. 字符串比较与数值比较的区别:")
local str1 = "10"
local str2 = "010"

-- 字符串比较
if str1 == str2 then
    print(string.format("   字符串比较: \"%s\" == \"%s\" = 相等", str1, str2))
else
    print(string.format("   字符串比较: \"%s\" == \"%s\" = 不相等", str1, str2))
end

-- 数值比较
local num1 = tonumber(str1)
local num2 = tonumber(str2)

if num1 == num2 then
    print(string.format("   数值比较: %d == %d = 相等", num1, num2))
else
    print(string.format("   数值比较: %d == %d = 不相等", num1, num2))
end

-- 5. 文件存在性检查
print("\n5. 文件存在性检查:")

-- 检查文件
local file = io.open("if_basics.bat", "r")
if file then
    print("   if_basics.bat 存在")
    file:close()
else
    print("   if_basics.bat 不存在")
end

-- 6. 逻辑运算符
print("\n6. 逻辑运算符:")
local x = 15

-- and (逻辑与)
if x > 10 and x < 20 then
    print(string.format("   %d 在10到20之间 (and)", x))
end

-- or (逻辑或)
if x < 10 or x > 20 then
    print(string.format("   %d 小于10或大于20 (or)", x))
else
    print(string.format("   %d 不在范围外 (or)", x))
end

-- not (逻辑非)
if not (x > 100) then
    print(string.format("   %d 不大于100 (not)", x))
end

-- 7. 条件表达式（Lua没有三元运算符，但可以用and/or模拟）
print("\n7. 条件表达式（and/or模拟）:")
local age = 20
local status = (age >= 18) and "成年" or "未成年"
print(string.format("   年龄: %d, 状态: %s", age, status))

-- 8. 多条件检查
print("\n8. 多条件检查:")
local username = "admin"
local password = "123456"

if username == "admin" and password == "123456" then
    print("   登录成功")
else
    print("   登录失败")
end

-- 9. 类型检查
print("\n9. 类型检查:")
local value = "123"

if type(value) == "string" then
    print(string.format("   '%s' 是字符串", value))
elseif type(value) == "number" then
    print(string.format("   %s 是数字", tostring(value)))
end

-- 10. 空值检查
print("\n10. 空值检查:")
local nil_value = nil
local false_value = false
local zero_value = 0
local empty_string = ""

if nil_value == nil then
    print("   nil值检查")
end

if false_value == false then
    print("   false值检查")
end

-- Lua中只有nil和false为假，其他都为真
if zero_value then
    print("   0在Lua中为真")
end

if empty_string then
    print("   空字符串在Lua中为真")
end

-- 11. 表达式作为条件
print("\n11. 表达式作为条件:")
local table1 = {1, 2, 3}
local table2 = nil

if table1 then
    print("   table1存在")
end

if not table2 then
    print("   table2不存在")
end

-- 12. 多返回值与条件
print("\n12. 多返回值与条件:")
local function check_value(val)
    if val > 0 then
        return true, "正数"
    elseif val < 0 then
        return true, "负数"
    else
        return true, "零"
    end
end

local is_valid, message = check_value(42)
if is_valid then
    print(string.format("   检查结果: %s", message))
end

-- 13. 保护调用与条件
print("\n13. 保护调用与条件:")
local function risky_function()
    error("这是一个错误")
end

local success, result = pcall(risky_function)
if not success then
    print(string.format("   捕获错误: %s", result))
end

-- 14. 字符串模式匹配
print("\n14. 字符串模式匹配:")
local filename = "document.txt"

if string.match(filename, "%.txt$") then
    print("   文件是文本文件")
end

if string.match(filename, "^document") then
    print("   文件名以document开头")
end

print("\nLua条件语句示例完成")