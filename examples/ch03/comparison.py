# Python 条件语句对比示例
# 用于与CMD的if语句进行对比

import os
import sys

def main():
    print("Python 条件语句示例")
    print("=" * 50)
    
    # 1. 基本if/elif/else
    print("\n1. 基本if/elif/else:")
    score = 85
    
    if score >= 90:
        print("   成绩优秀")
    elif score >= 80:
        print("   成绩良好")
    elif score >= 60:
        print("   成绩及格")
    else:
        print("   成绩不及格")
    
    # 2. 字符串比较
    print("\n2. 字符串比较:")
    name = "test"
    
    if name == "test":
        print("   字符串相等")
    else:
        print("   字符串不相等")
    
    # 3. 数值比较运算符
    print("\n3. 数值比较运算符:")
    a = 10
    b = 20
    
    print(f"   比较 {a} 和 {b}:")
    print(f"   {a} == {b}: {a == b}")
    print(f"   {a} != {b}: {a != b}")
    print(f"   {a} < {b}: {a < b}")
    print(f"   {a} <= {b}: {a <= b}")
    print(f"   {a} > {b}: {a > b}")
    print(f"   {a} >= {b}: {a >= b}")
    
    # 4. 字符串比较与数值比较的区别
    print("\n4. 字符串比较与数值比较的区别:")
    str1 = "10"
    str2 = "010"
    
    # 字符串比较
    if str1 == str2:
        print(f'   字符串比较: "{str1}" == "{str2}" = 相等')
    else:
        print(f'   字符串比较: "{str1}" == "{str2}" = 不相等')
    
    # 数值比较
    if int(str1) == int(str2):
        print(f'   数值比较: {int(str1)} == {int(str2)} = 相等')
    else:
        print(f'   数值比较: {int(str1)} == {int(str2)} = 不相等')
    
    # 5. 文件存在性检查
    print("\n5. 文件存在性检查:")
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # 检查文件
    if os.path.exists(os.path.join(current_dir, "if_basics.bat")):
        print("   if_basics.bat 存在")
    else:
        print("   if_basics.bat 不存在")
    
    # 检查目录
    if os.path.isdir(os.path.join(current_dir, "..", "ch02")):
        print("   ch02目录存在")
    else:
        print("   ch02目录不存在")
    
    # 6. 逻辑运算符
    print("\n6. 逻辑运算符:")
    x = 15
    
    # and (逻辑与)
    if x > 10 and x < 20:
        print(f"   {x} 在10到20之间 (and)")
    
    # or (逻辑或)
    if x < 10 or x > 20:
        print(f"   {x} 小于10或大于20 (or)")
    else:
        print(f"   {x} 不在范围外 (or)")
    
    # not (逻辑非)
    if not (x > 100):
        print(f"   {x} 不大于100 (not)")
    
    # 7. 条件表达式（三元运算符）
    print("\n7. 条件表达式（三元运算符）:")
    age = 20
    status = "成年" if age >= 18 else "未成年"
    print(f"   年龄: {age}, 状态: {status}")
    
    # 8. 多条件检查
    print("\n8. 多条件检查:")
    username = "admin"
    password = "123456"
    
    if username == "admin" and password == "123456":
        print("   登录成功")
    else:
        print("   登录失败")
    
    # 9. 类型检查
    print("\n9. 类型检查:")
    value = "123"
    
    if isinstance(value, str):
        print(f"   '{value}' 是字符串")
    elif isinstance(value, int):
        print(f"   {value} 是整数")
    
    # 10. 空值检查
    print("\n10. 空值检查:")
    empty_list = []
    none_value = None
    
    if not empty_list:
        print("   空列表为假")
    
    if none_value is None:
        print("   None值检查")

if __name__ == "__main__":
    main()