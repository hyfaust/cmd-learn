-- Lua字符串操作对比 - 与CMD字符串处理对比
-- 运行: lua comparison.lua

print("=== Lua字符串操作对比 ===\n")

-- 原始字符串
local original = "Hello, World!"
print("原始字符串: " .. original)
print()

-- 1. 字符串长度
print("--- 1. 字符串长度 ---")
print("字符串长度: " .. string.len(original))                    -- CMD: 需要循环计算
print("使用#操作符: " .. #original)                              -- 另一种方法
print()

-- 2. 子串截取
print("--- 2. 子串截取 ---")
print("前5个字符: " .. string.sub(original, 1, 5))               -- CMD: %str:~0,5%
print("从索引7开始: " .. string.sub(original, 7))                -- CMD: %str:~7%
print("最后6个字符: " .. string.sub(original, -6))               -- CMD: %str:~-6%
print("从索引2到5: " .. string.sub(original, 2, 5))             -- CMD: %str:~2,3%
print()

-- 3. 字符串查找
print("--- 3. 字符串查找 ---")
local start_pos, end_pos = string.find(original, "World")
if start_pos then
    print("查找World: 在索引" .. start_pos .. "处找到")          -- CMD: findstr
else
    print("查找World: 未找到")
end

start_pos, end_pos = string.find(original, "xyz")
if start_pos then
    print("查找xyz: 在索引" .. start_pos .. "处找到")
else
    print("查找xyz: 未找到")                                     -- CMD: findstr
end

-- 检查是否包含
if string.find(original, "World") then
    print("包含World: 是")                                       -- CMD: findstr + errorlevel
else
    print("包含World: 否")
end
print()

-- 4. 字符串替换
print("--- 4. 字符串替换 ---")
local str_replace = "Hello World Hello CMD"
print("原始字符串: " .. str_replace)

local replaced, count = string.gsub(str_replace, "Hello", "Hi")
print("替换Hello为Hi: " .. replaced)                             -- CMD: %str:Hello=Hi%
print("替换次数: " .. count)

-- 替换第一个匹配
local first_replaced = string.gsub(str_replace, "Hello", "Hi", 1)
print("替换第一个匹配: " .. first_replaced)                       -- CMD: 无直接等价
print()

-- 5. 大小写转换
print("--- 5. 大小写转换 ---")
local str_upper = "Hello World"
print("原始: " .. str_upper)
print("大写: " .. string.upper(str_upper))                        -- CMD: 需要循环替换
print("小写: " .. string.lower("HELLO WORLD"))                   -- CMD: 需要循环替换
print()

-- 6. 字符串修剪
print("--- 6. 字符串修剪 ---")
local str_trim = "   Hello World   "
print("原始: [" .. str_trim .. "]")

-- Lua没有内置的trim函数，需要自定义
local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function ltrim(s)
    return s:match("^%s*(.*)")
end

local function rtrim(s)
    return s:match("(.-)%s*$")
end

print("去除首尾空格: [" .. trim(str_trim) .. "]")                -- CMD: for /F技巧
print("去除左侧空格: [" .. ltrim(str_trim) .. "]")               -- CMD: 循环去除
print("去除右侧空格: [" .. rtrim(str_trim) .. "]")               -- CMD: 循环去除
print()

-- 7. 字符串分割
print("--- 7. 字符串分割 ---")
local csv_data = "apple,banana,cherry"
print("原始CSV: " .. csv_data)

-- Lua没有内置的split函数，需要自定义
local function split(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

local fruits = split(csv_data, ",")
print("分割结果: ")
for i, fruit in ipairs(fruits) do                                -- CMD: for /F "tokens="
    print("  " .. i .. ": " .. fruit)
end
print()

-- 8. 字符串连接
print("--- 8. 字符串连接 ---")
local words = {"Hello", "World", "CMD"}
print("单词列表: " .. table.concat(words, ", "))

-- 使用..操作符连接
local result = words[1] .. " " .. words[2] .. " " .. words[3]
print("连接结果: " .. result)                                    -- CMD: 直接拼接
print()

-- 9. 字符串格式化
print("--- 9. 字符串格式化 ---")
local name = "张三"
local age = 25
print(string.format("%s今年%d岁", name, age))                    -- CMD: %var%拼接
print("使用..连接: " .. name .. "今年" .. age .. "岁")
print()

-- 10. 模式匹配
print("--- 10. 模式匹配 ---")
local text = "abc123def456"
print("原始文本: " .. text)

-- 提取数字
local numbers = {}
for match in text:gmatch("%d+") do
    table.insert(numbers, match)                                 -- CMD: findstr /R 有限支持
end
print("提取数字: " .. table.concat(numbers, ", "))

-- 替换数字
local replaced_numbers = text:gsub("%d+", "*")
print("替换数字: " .. replaced_numbers)
print()

-- 11. 中文字符处理
print("--- 11. 中文字符处理 ---")
local chinese = "你好世界"
print("中文字符串: " .. chinese)
print("长度: " .. #chinese)                                      -- CMD: 需要特殊处理
print("前2个字符: " .. string.sub(chinese, 1, 6))               -- CMD: %str:~0,4% (GBK)
print("注意: Lua中中文字符占3个字节(UTF-8)")
print()

-- 12. 字符串检查
print("--- 12. 字符串检查 ---")
local test_str = "Hello123"
print("测试字符串: " .. test_str)
print("是否全字母: " .. tostring(string.match(test_str, "^%a+$") ~= nil))  -- CMD: 无直接等价
print("是否全数字: " .. tostring(string.match(test_str, "^%d+$") ~= nil))  -- CMD: 无直接等价
print("是否字母数字: " .. tostring(string.match(test_str, "^%w+$") ~= nil)) -- CMD: 无直接等价
print()

-- 13. 字符串重复
print("--- 13. 字符串重复 ---")
print("重复5次: " .. string.rep("Hello", 5))                     -- CMD: 无直接等价
print()

-- 14. 字符反转
print("--- 14. 字符反转 ---")
local function reverse(s)
    return s:reverse()
end
print("反转Hello: " .. reverse("Hello"))                         -- CMD: 无直接等价
print()

-- 15. 字符串转义
print("--- 15. 字符串转义 ---")
print("转义引号: He said, \"Hello!\"")
print("转义反斜杠: C:\\Users\\Admin")
print("转义换行: Line1\\nLine2")
print()

print("=== 演示完成 ===")