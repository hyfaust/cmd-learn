# Python数据结构对比示例
# 展示Python中内置数据结构的使用，与CMD的模拟方式对比

print("=== Python数据结构对比示例 ===")
print()

# 1. 列表（数组）
print("=== 1. 列表（数组）===")
fruits = ["Apple", "Banana", "Cherry", "Date"]
print(f"列表: {fruits}")
print(f"长度: {len(fruits)}")
print(f"第一个元素: {fruits[0]}")
print(f"最后一个元素: {fruits[-1]}")

# 添加元素
fruits.append("Elderberry")
print(f"添加后: {fruits}")

# 修改元素
fruits[1] = "Blueberry"
print(f"修改后: {fruits}")

# 遍历
print("遍历列表:")
for i, fruit in enumerate(fruits):
    print(f"  [{i}] = {fruit}")

print()

# 2. 字典
print("=== 2. 字典 ===")
person = {
    "name": "Alice",
    "age": 25,
    "city": "Beijing",
    "role": "Developer"
}
print(f"字典: {person}")
print(f"姓名: {person['name']}")
print(f"年龄: {person['age']}")

# 修改字典
person["age"] = 26
print(f"修改后年龄: {person['age']}")

# 遍历字典
print("遍历字典:")
for key, value in person.items():
    print(f"  {key} = {value}")

print()

# 3. 集合
print("=== 3. 集合 ===")
fruits_set = {"Apple", "Banana", "Cherry", "Apple"}  # 重复的Apple会被自动去除
print(f"集合: {fruits_set}")
print(f"集合大小: {len(fruits_set)}")

# 添加元素
fruits_set.add("Date")
print(f"添加后: {fruits_set}")

# 集合操作
set1 = {1, 2, 3, 4, 5}
set2 = {4, 5, 6, 7, 8}
print(f"集合1: {set1}")
print(f"集合2: {set2}")
print(f"交集: {set1 & set2}")
print(f"并集: {set1 | set2}")
print(f"差集: {set1 - set2}")

print()

# 4. 栈（使用列表实现）
print("=== 4. 栈（后进先出）===")
stack = []

# 入栈
stack.append("First")
stack.append("Second")
stack.append("Third")
print(f"栈: {stack}")

# 出栈
item = stack.pop()
print(f"弹出: {item}")
item = stack.pop()
print(f"弹出: {item}")
print(f"剩余栈: {stack}")

print()

# 5. 队列（使用collections.deque）
print("=== 5. 队列（先进先出）===")
from collections import deque

queue = deque()

# 入队
queue.append("Task A")
queue.append("Task B")
queue.append("Task C")
print(f"队列: {queue}")

# 出队
item = queue.popleft()
print(f"出队: {item}")
item = queue.popleft()
print(f"出队: {item}")
print(f"剩余队列: {queue}")

print()

# 6. 多维数组（使用嵌套列表）
print("=== 6. 多维数组（矩阵）===")
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

print("矩阵:")
for row in matrix:
    print(f"  {row}")

# 访问元素
print(f"matrix[1][2] = {matrix[1][2]}")

# 矩阵转置
transposed = [[row[i] for row in matrix] for i in range(len(matrix[0]))]
print("转置矩阵:")
for row in transposed:
    print(f"  {row}")

print()

# 7. 数据持久化
print("=== 7. 数据持久化 ===")
import json
import pickle

# JSON持久化
data = {
    "name": "Alice",
    "age": 25,
    "scores": [95, 87, 92]
}

# 保存到JSON文件
with open("data.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# 从JSON文件读取
with open("data.json", "r", encoding="utf-8") as f:
    loaded_data = json.load(f)

print(f"原始数据: {data}")
print(f"加载数据: {loaded_data}")

# 清理文件
import os
os.remove("data.json")

print()

# 8. 性能对比
print("=== 8. 性能对比 ===")
import time

# 列表性能
start = time.time()
big_list = list(range(1000000))
list_access_time = time.time() - start

start = time.time()
_ = big_list[500000]
list_access_end = time.time() - start

print(f"创建100万元素列表: {list_access_time:.4f}秒")
print(f"访问列表元素: {list_access_end:.8f}秒")

# 字典性能
start = time.time()
big_dict = {i: i*2 for i in range(1000000)}
dict_create_time = time.time() - start

start = time.time()
_ = big_dict[500000]
dict_access_end = time.time() - start

print(f"创建100万元素字典: {dict_create_time:.4f}秒")
print(f"访问字典元素: {dict_access_end:.8f}秒")

print()

print("=== 对比总结 ===")
print("Python内置数据结构的优势:")
print("1. 直接支持，无需模拟")
print("2. 高度优化，性能优秀")
print("3. 丰富的标准库支持")
print("4. 自动内存管理")
print("5. 类型安全和错误处理")
print()
print("CMD模拟数据结构的限制:")
print("1. 需要手动模拟，代码复杂")
print("2. 性能较差，特别是大数据量")
print("3. 变量数量有限制")
print("4. 缺少类型检查和错误处理")
print("5. 调试困难")