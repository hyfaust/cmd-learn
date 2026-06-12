# comparison.py - Python与CMD对比示例
# 说明：展示Python中与CMD等价的功能实现

import os
import sys
from datetime import datetime

def main():
    print("=" * 50)
    print("       Python与CMD对比示例")
    print("=" * 50)
    print()
    
    # 1. 输出对比
    # CMD: echo Hello, World!
    # Python: print("Hello, World!")
    print("1. 输出对比:")
    print("   CMD: echo Hello, World!")
    print("   Python: print('Hello, World!')")
    print("   结果: Hello, World!")
    print()
    
    # 2. 变量定义对比
    # CMD: set "name=CMD学习者"
    # Python: name = "CMD学习者"
    print("2. 变量定义对比:")
    name = "Python学习者"
    print(f"   CMD: set \"name=CMD学习者\"")
    print(f"   Python: name = \"{name}\"")
    print(f"   结果: {name}")
    print()
    
    # 3. 算术运算对比
    # CMD: set /a "result=5+3"
    # Python: result = 5 + 3
    print("3. 算术运算对比:")
    result = 5 + 3
    print(f"   CMD: set /a \"result=5+3\"")
    print(f"   Python: result = 5 + 3")
    print(f"   结果: {result}")
    print()
    
    # 4. 用户输入对比
    # CMD: set /p "user_input=请输入: "
    # Python: user_input = input("请输入: ")
    print("4. 用户输入对比:")
    print("   CMD: set /p \"user_input=请输入: \"")
    print("   Python: user_input = input('请输入: ')")
    print("   说明: Python的input()函数更安全，不会执行命令")
    print()
    
    # 5. 条件判断对比
    # CMD: if "%var%"=="value" (echo 真) else (echo 假)
    # Python: if var == "value": print("真") else: print("假")
    print("5. 条件判断对比:")
    choice = "Y"
    print(f"   CMD: if \"%choice%\"==\"Y\" (echo 真) else (echo 假)")
    print(f"   Python: if choice == 'Y': print('真') else: print('假')")
    if choice == "Y":
        print("   结果: 真")
    else:
        print("   结果: 假")
    print()
    
    # 6. 循环对比
    # CMD: for /l %%i in (1,1,5) do echo %%i
    # Python: for i in range(1, 6): print(i)
    print("6. 循环对比:")
    print("   CMD: for /l %%i in (1,1,5) do echo %%i")
    print("   Python: for i in range(1, 6): print(i)")
    print("   结果:")
    for i in range(1, 6):
        print(f"     {i}")
    print()
    
    # 7. 文件操作对比
    # CMD: dir C:\Windows
    # Python: os.listdir("C:\\Windows")
    print("7. 文件操作对比:")
    print("   CMD: dir C:\\Windows")
    print("   Python: os.listdir('C:\\Windows')")
    print("   说明: Python的文件操作更强大，支持异常处理")
    print()
    
    # 8. 环境变量对比
    # CMD: %PATH%
    # Python: os.environ["PATH"]
    print("8. 环境变量对比:")
    path_var = os.environ.get("PATH", "未找到")
    print(f"   CMD: %PATH%")
    print(f"   Python: os.environ['PATH']")
    print(f"   结果: {path_var[:100]}...")  # 只显示前100个字符
    print()
    
    # 9. 错误处理对比
    # CMD: command || echo 错误
    # Python: try/except
    print("9. 错误处理对比:")
    print("   CMD: command || echo 错误")
    print("   Python: try: command() except: print('错误')")
    print("   说明: Python的异常处理更精细，可以捕获特定异常")
    print()
    
    # 10. 注释对比
    # CMD: :: 注释 或 REM 注释
    # Python: # 注释
    print("10. 注释对比:")
    print("    CMD: :: 注释 或 REM 注释")
    print("    Python: # 注释")
    print("    说明: Python还有多行注释: ''' 多行注释 '''")
    print()
    
    print("=" * 50)
    print("       Python与CMD对比完成")
    print("=" * 50)
    print()
    print("主要差异总结:")
    print("1. Python有类型系统，CMD所有变量都是字符串")
    print("2. Python有异常处理，CMD使用错误码")
    print("3. Python的语法更清晰，CMD更接近自然语言")
    print("4. Python支持面向对象，CMD是过程式脚本")
    print("5. Python跨平台，CMD仅限Windows")

if __name__ == "__main__":
    main()