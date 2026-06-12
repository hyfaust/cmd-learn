# ============================================================
# comparison.py - Python函数对比
# 第07章 函数与模块化示例
#
# 安全提示：本脚本仅进行变量操作和控制流演示
# ============================================================

# Python中的函数定义和调用示例

# 1. 基本函数定义
def greet(name):
    """问候函数 - 对应CMD的:greet"""
    print(f"你好, {name}! 欢迎学习批处理编程。")

# 2. 带返回值的函数
def add(a, b):
    """加法函数 - 对应CMD的:add"""
    return a + b

def multiply(a, b):
    """乘法函数 - 对应CMD的:multiply"""
    return a * b

# 3. 多返回值函数
def get_min_max(*numbers):
    """获取最小值和最大值 - 对应CMD的:get_min_max"""
    if not numbers:
        return None, None
    return min(numbers), max(numbers)

# 4. 带默认参数的函数
def greet_with_default(name, greeting="Hello"):
    """带默认参数的问候函数"""
    return f"{greeting}, {name}!"

# 5. 可变参数函数
def sum_all(*args):
    """求和函数 - 接受任意数量参数"""
    return sum(args)

# 6. 作用域示例
def scope_demo():
    """作用域演示 - 对应CMD的setlocal/endlocal"""
    local_var = "I am local"  # 局部变量
    global_var = "modified"   # 尝试修改全局变量（会创建新的局部变量）
    print(f"函数内 local_var: {local_var}")
    return local_var

# 7. 闭包示例
def make_counter():
    """创建计数器 - 对应CMD没有的概念"""
    count = 0
    def counter():
        nonlocal count
        count += 1
        return count
    return counter

# 8. Lambda函数（匿名函数）
square = lambda x: x ** 2

# ============================================================
# 主程序
# ============================================================
if __name__ == "__main__":
    print("=" * 50)
    print("Python函数对比演示")
    print("=" * 50)
    print()
    
    # 调用基本函数
    print("=== 基本函数调用 ===")
    greet("Alice")
    greet("Bob")
    print()
    
    # 调用带返回值的函数
    print("=== 返回值 ===")
    result = add(3, 5)
    print(f"3 + 5 = {result}")
    
    result = multiply(4, 6)
    print(f"4 * 6 = {result}")
    print()
    
    # 多返回值
    print("=== 多返回值 ===")
    min_val, max_val = get_min_max(5, 2, 8, 1, 9)
    print(f"最小值: {min_val}, 最大值: {max_val}")
    print()
    
    # 默认参数
    print("=== 默认参数 ===")
    print(greet_with_default("Alice"))
    print(greet_with_default("Bob", "Hi"))
    print()
    
    # 可变参数
    print("=== 可变参数 ===")
    print(f"sum_all(1,2,3,4,5) = {sum_all(1, 2, 3, 4, 5)}")
    print()
    
    # 作用域演示
    print("=== 作用域演示 ===")
    global_var = "I am global"
    print(f"调用前 global_var: {global_var}")
    scope_demo()
    print(f"调用后 global_var: {global_var}")  # 保持不变
    print()
    
    # 闭包
    print("=== 闭包演示 ===")
    counter = make_counter()
    print(f"计数: {counter()}")
    print(f"计数: {counter()}")
    print(f"计数: {counter()}")
    print()
    
    # Lambda
    print("=== Lambda函数 ===")
    print(f"square(5) = {square(5)}")
    print()
    
    # 列表推导式（CMD没有的概念）
    print("=== 列表推导式（CMD没有的概念）===")
    squares = [x**2 for x in range(1, 6)]
    print(f"1-5的平方: {squares}")
