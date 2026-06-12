-- comparison.lua — Lua for循环对比 CMD for循环
-- 本文件展示Lua中与CMD for循环等价的实现
-- 运行: lua comparison.lua

-- 基本列表遍历 - 对比 CMD: for %%i in (apple banana cherry) do echo %%i
local function basic_list_loop()
    print("=== 基本列表遍历 ===")
    local fruits = {"apple", "banana", "cherry"}
    for i, fruit in ipairs(fruits) do
        print(string.format("水果: %s", fruit))
    end
end

-- 数值范围循环 - 对比 CMD: for /L %%i in (1,1,5) do echo %%i
local function numeric_loop()
    print("\n=== 数值范围循环 ===")
    
    -- 基本循环 (start, end, step)
    for i = 1, 5 do
        print(string.format("第 %d 次循环", i))
    end
    
    -- 自定义步长
    print("\n=== 自定义步长 ===")
    for i = 0, 25, 5 do
        print(i)
    end
    
    -- 倒序循环
    print("\n=== 倒序循环 ===")
    for i = 10, 1, -1 do
        print(string.format("倒计时: %d", i))
    end
end

-- 字符串分割 - 对比 CMD: for /F "tokens=1,2,3" %%a in ("hello world cmd")
local function string_split()
    print("\n=== 字符串分割 ===")
    
    -- Lua 没有内置的 split 函数，需要自己实现
    local function split(str, delimiter)
        local result = {}
        for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
            table.insert(result, match)
        end
        return result
    end
    
    -- 按空格分割
    local text = "hello world cmd"
    local parts = split(text, " ")
    for i, part in ipairs(parts) do
        print(string.format("第%d个: %s", i, part))
    end
    
    -- 按逗号分割
    print("\n=== 按逗号分割 ===")
    local csv = "apple,banana,cherry"
    local csv_parts = split(csv, ",")
    print("水果: " .. table.concat(csv_parts, ", "))
end

-- 文件遍历 - 对比 CMD: for %%f in (*.txt) do echo %%f
local function file_iteration()
    print("\n=== 文件遍历 ===")
    
    -- 使用 io.popen 执行系统命令
    local handle = io.popen('dir /b *.lua 2>nul')
    if handle then
        for line in handle:lines() do
            print("文件: " .. line)
        end
        handle:close()
    end
end

-- 目录遍历 - 对比 CMD: for /D %%d in (*) do echo %%d
local function directory_iteration()
    print("\n=== 目录遍历 ===")
    
    -- 使用 io.popen 执行系统命令
    local handle = io.popen('dir /b /ad 2>nul')
    if handle then
        for line in handle:lines() do
            print("目录: " .. line)
        end
        handle:close()
    end
end

-- 文件内容读取 - 对比 CMD: for /F "usebackq" %%a in (file.txt)
local function file_content_reading()
    print("\n=== 文件内容读取 ===")
    
    -- 创建临时文件
    local temp_file = io.open("temp_test.txt", "w")
    if temp_file then
        temp_file:write("line1 - 第一行\n")
        temp_file:write("line2 - 第二行\n")
        temp_file:write("# 这是注释\n")
        temp_file:write("line3 - 第三行\n")
        temp_file:close()
    end
    
    -- 读取文件内容
    local file = io.open("temp_test.txt", "r")
    if file then
        local line_num = 1
        for line in file:lines() do
            -- 跳过注释行（类似 CMD eol=#）
            if not line:match("^#") then
                print(string.format("第%d行: %s", line_num, line))
            end
            line_num = line_num + 1
        end
        file:close()
    end
    
    -- 清理临时文件
    os.remove("temp_test.txt")
end

-- 命令输出 - 对比 CMD: for /F %%a in ('dir /b')
local function command_output()
    print("\n=== 命令输出 ===")
    
    local handle = io.popen('dir /b')
    if handle then
        for line in handle:lines() do
            print("文件: " .. line)
        end
        handle:close()
    end
end

-- 嵌套循环 - 对比 CMD: for /L %%i ... for /L %%j ...
local function nested_loop()
    print("\n=== 嵌套循环 ===")
    
    -- 九九乘法表片段
    for i = 1, 3 do
        for j = 1, 3 do
            print(string.format("%d x %d = %d", i, j, i * j))
        end
        print()
    end
end

-- while循环示例 - 对比 CMD: goto实现的循环
local function while_loop_example()
    print("\n=== while循环（对比CMD goto循环）===")
    
    local count = 0
    while count < 5 do
        count = count + 1
        print(string.format("循环次数: %d", count))
    end
end

-- repeat...until循环 - Lua特有
local function repeat_until_example()
    print("\n=== repeat...until循环 ===")
    
    local count = 0
    repeat
        count = count + 1
        print(string.format("循环次数: %d", count))
    until count >= 5
end

-- 泛型for循环 - pairs/ipairs
local function generic_for_example()
    print("\n=== 泛型for循环 ===")
    
    -- ipairs 遍历数组部分
    local fruits = {"apple", "banana", "cherry"}
    print("使用 ipairs:")
    for i, v in ipairs(fruits) do
        print(string.format("  [%d] = %s", i, v))
    end
    
    -- pairs 遍历所有键值对
    local person = {name = "张三", age = 25, city = "北京"}
    print("\n使用 pairs:")
    for k, v in pairs(person) do
        print(string.format("  %s = %s", k, tostring(v)))
    end
end

-- 运行所有示例
basic_list_loop()
numeric_loop()
string_split()
file_iteration()
directory_iteration()
file_content_reading()
command_output()
nested_loop()
while_loop_example()
repeat_until_example()
generic_for_example()
