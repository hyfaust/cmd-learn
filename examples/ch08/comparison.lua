-- Lua数据结构对比示例
-- 展示Lua中table的使用，与CMD的模拟方式对比

print("=== Lua数据结构对比示例 ===")
print()

-- 1. 数组（使用table）
print("=== 1. 数组（table）===")
local fruits = {"Apple", "Banana", "Cherry", "Date"}
print("数组:")
for i, fruit in ipairs(fruits) do
    print(string.format("  [%d] = %s", i, fruit))
end

-- 添加元素
table.insert(fruits, "Elderberry")
print("添加后:")
for i, fruit in ipairs(fruits) do
    print(string.format("  [%d] = %s", i, fruit))
end

-- 修改元素
fruits[2] = "Blueberry"
print("修改后:")
for i, fruit in ipairs(fruits) do
    print(string.format("  [%d] = %s", i, fruit))
end

-- 删除元素
table.remove(fruits, 3)  -- 删除第3个元素
print("删除后:")
for i, fruit in ipairs(fruits) do
    print(string.format("  [%d] = %s", i, fruit))
end

print()

-- 2. 字典（使用table）
print("=== 2. 字典（table）===")
local person = {
    name = "Alice",
    age = 25,
    city = "Beijing",
    role = "Developer"
}

print("字典:")
for key, value in pairs(person) do
    print(string.format("  %s = %s", key, tostring(value)))
end

-- 访问字典
print(string.format("姓名: %s", person.name))
print(string.format("年龄: %d", person.age))

-- 修改字典
person.age = 26
print(string.format("修改后年龄: %d", person.age))

-- 添加新键值对
person.email = "alice@example.com"
print(string.format("邮箱: %s", person.email))

print()

-- 3. 集合模拟（使用table作为集合）
print("=== 3. 集合模拟 ===")
local fruits_set = {}

-- 添加元素到集合
local function set_add(set, item)
    set[item] = true
end

-- 检查元素是否在集合中
local function set_contains(set, item)
    return set[item] ~= nil
end

-- 删除元素
local function set_remove(set, item)
    set[item] = nil
end

-- 添加元素
set_add(fruits_set, "Apple")
set_add(fruits_set, "Banana")
set_add(fruits_set, "Cherry")
set_add(fruits_set, "Apple")  -- 重复添加，不会增加

print("集合内容:")
for item, _ in pairs(fruits_set) do
    print(string.format("  %s", item))
end

print(string.format("Apple 在集合中: %s", tostring(set_contains(fruits_set, "Apple"))))
print(string.format("Date 在集合中: %s", tostring(set_contains(fruits_set, "Date"))))

-- 删除元素
set_remove(fruits_set, "Banana")
print("删除 Banana 后:")
for item, _ in pairs(fruits_set) do
    print(string.format("  %s", item))
end

print()

-- 4. 栈（使用table）
print("=== 4. 栈（后进先出）===")
local stack = {}

-- 入栈
table.insert(stack, "First")
table.insert(stack, "Second")
table.insert(stack, "Third")
print("栈内容:")
for i, item in ipairs(stack) do
    print(string.format("  [%d] = %s", i, item))
end

-- 出栈
local top = table.remove(stack)
print(string.format("弹出: %s", top))
top = table.remove(stack)
print(string.format("弹出: %s", top))
print("剩余栈:")
for i, item in ipairs(stack) do
    print(string.format("  [%d] = %s", i, item))
end

print()

-- 5. 队列（使用table）
print("=== 5. 队列（先进先出）===")
local queue = {}

-- 入队
table.insert(queue, "Task A")
table.insert(queue, "Task B")
table.insert(queue, "Task C")
print("队列内容:")
for i, item in ipairs(queue) do
    print(string.format("  [%d] = %s", i, item))
end

-- 出队
local front = table.remove(queue, 1)  -- 从头部移除
print(string.format("出队: %s", front))
front = table.remove(queue, 1)
print(string.format("出队: %s", front))
print("剩余队列:")
for i, item in ipairs(queue) do
    print(string.format("  [%d] = %s", i, item))
end

print()

-- 6. 多维数组（嵌套table）
print("=== 6. 多维数组（矩阵）===")
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}

print("矩阵:")
for i, row in ipairs(matrix) do
    local line = "  "
    for j, val in ipairs(row) do
        line = line .. val .. " "
    end
    print(line)
end

-- 访问元素
print(string.format("matrix[2][3] = %d", matrix[2][3]))

-- 矩阵转置
local transposed = {}
for i = 1, #matrix[1] do
    transposed[i] = {}
    for j = 1, #matrix do
        transposed[i][j] = matrix[j][i]
    end
end

print("转置矩阵:")
for i, row in ipairs(transposed) do
    local line = "  "
    for j, val in ipairs(row) do
        line = line .. val .. " "
    end
    print(line)
end

print()

-- 7. 链表实现
print("=== 7. 链表 ===")
local LinkedList = {}
LinkedList.__index = LinkedList

function LinkedList.new()
    local self = setmetatable({}, LinkedList)
    self.head = nil
    self.size = 0
    return self
end

function LinkedList:append(data)
    local new_node = {data = data, next = nil}
    
    if not self.head then
        self.head = new_node
    else
        local current = self.head
        while current.next do
            current = current.next
        end
        current.next = new_node
    end
    
    self.size = self.size + 1
end

function LinkedList:print()
    local current = self.head
    local result = "链表: "
    while current do
        result = result .. current.data .. " -> "
        current = current.next
    end
    result = result .. "NULL"
    print(result)
end

-- 使用链表
local list = LinkedList.new()
list:append(10)
list:append(20)
list:append(30)
list:append(40)
list:print()

print()

-- 8. 哈希表实现（简化版）
print("=== 8. 哈希表（字典增强版）===")
local HashTable = {}
HashTable.__index = HashTable

function HashTable.new(size)
    local self = setmetatable({}, HashTable)
    self.size = size or 100
    self.buckets = {}
    for i = 1, self.size do
        self.buckets[i] = {}
    end
    return self
end

function HashTable:_hash(key)
    local hash = 0
    for i = 1, #key do
        hash = (hash * 31 + string.byte(key, i)) % self.size
    end
    return hash + 1
end

function HashTable:set(key, value)
    local index = self:_hash(key)
    local bucket = self.buckets[index]
    
    -- 查找是否已存在
    for i, item in ipairs(bucket) do
        if item.key == key then
            item.value = value
            return
        end
    end
    
    -- 不存在则添加
    table.insert(bucket, {key = key, value = value})
end

function HashTable:get(key)
    local index = self:_hash(key)
    local bucket = self.buckets[index]
    
    for i, item in ipairs(bucket) do
        if item.key == key then
            return item.value
        end
    end
    
    return nil
end

function HashTable:remove(key)
    local index = self:_hash(key)
    local bucket = self.buckets[index]
    
    for i, item in ipairs(bucket) do
        if item.key == key then
            table.remove(bucket, i)
            return true
        end
    end
    
    return false
end

-- 使用哈希表
local hash_table = HashTable.new()
hash_table:set("name", "Alice")
hash_table:set("age", 25)
hash_table:set("score", 95)

print(string.format("name = %s", hash_table:get("name")))
print(string.format("age = %d", hash_table:get("age")))
print(string.format("score = %d", hash_table:get("score")))

-- 修改值
hash_table:set("age", 26)
print(string.format("修改后 age = %d", hash_table:get("age")))

-- 删除键
hash_table:remove("score")
print(string.format("删除 score 后: %s", tostring(hash_table:get("score"))))

print()

-- 9. 数据持久化
print("=== 9. 数据持久化 ===")

-- 序列化函数
local function serialize(data, indent)
    indent = indent or 0
    local result = ""
    local prefix = string.rep("  ", indent)
    
    if type(data) == "table" then
        result = result .. "{\n"
        for k, v in pairs(data) do
            result = result .. prefix .. "  "
            if type(k) == "string" then
                result = result .. '["' .. k .. '"] = '
            else
                result = result .. "[" .. k .. "] = "
            end
            result = result .. serialize(v, indent + 1) .. ",\n"
        end
        result = result .. prefix .. "}"
    elseif type(data) == "string" then
        result = result .. '"' .. data .. '"'
    else
        result = result .. tostring(data)
    end
    
    return result
end

-- 测试数据
local data = {
    name = "Alice",
    age = 25,
    scores = {95, 87, 92},
    address = {
        city = "Beijing",
        street = "Main St"
    }
}

print("序列化数据:")
print(serialize(data))

-- 保存到文件
local filename = "lua_data.lua"
local file = io.open(filename, "w")
if file then
    file:write("return " .. serialize(data))
    file:close()
    print(string.format("数据已保存到: %s", filename))
    
    -- 从文件加载
    local loaded_data = dofile(filename)
    print("从文件加载的数据:")
    print(serialize(loaded_data))
    
    -- 清理文件
    os.remove(filename)
    print("临时文件已清理")
else
    print("无法创建文件")
end

print()

-- 10. 性能测试
print("=== 10. 性能对比 ===")

-- 表性能测试
local start_time = os.clock()
local big_table = {}
for i = 1, 1000000 do
    big_table[i] = i
end
local create_time = os.clock() - start_time

start_time = os.clock()
local access = big_table[500000]
local access_time = os.clock() - start_time

print(string.format("创建100万元素表: %.4f秒", create_time))
print(string.format("访问表元素: %.8f秒", access_time))

-- 字典性能测试
start_time = os.clock()
local big_dict = {}
for i = 1, 1000000 do
    big_dict[tostring(i)] = i * 2
end
local dict_create_time = os.clock() - start_time

start_time = os.clock()
local dict_access = big_dict["500000"]
local dict_access_time = os.clock() - start_time

print(string.format("创建100万元素字典: %.4f秒", dict_create_time))
print(string.format("访问字典元素: %.8f秒", dict_access_time))

print()

-- 11. 元表和面向对象
print("=== 11. 元表和面向对象 ===")

local Animal = {}
Animal.__index = Animal

function Animal.new(name, sound)
    local self = setmetatable({}, Animal)
    self.name = name
    self.sound = sound
    return self
end

function Animal:speak()
    return string.format("%s says %s!", self.name, self.sound)
end

-- 继承
local Dog = setmetatable({}, {__index = Animal})
Dog.__index = Dog

function Dog.new(name)
    local self = setmetatable(Animal.new(name, "Woof"), Dog)
    return self
end

function Dog:fetch(item)
    return string.format("%s fetches the %s!", self.name, item)
end

-- 使用
local animal = Animal.new("Cat", "Meow")
print(animal:speak())

local dog = Dog.new("Buddy")
print(dog:speak())
print(dog:fetch("ball"))

print()

print("=== 对比总结 ===")
print("Lua table的优势:")
print("1. 统一的数据结构（数组和字典）")
print("2. 简洁的语法")
print("3. 元表支持面向对象")
print("4. 高效的实现")
print("5. 嵌套支持良好")
print()
print("CMD模拟数据结构的限制:")
print("1. 需要手动模拟，代码复杂")
print("2. 性能较差，特别是大数据量")
print("3. 变量数量有限制")
print("4. 缺少元编程能力")
print("5. 调试困难，没有现代工具")