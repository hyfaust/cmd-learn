#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Python字符串操作对比 - 与CMD字符串处理对比
"""

def main():
    print("=== Python字符串操作对比 ===\n")
    
    # 原始字符串
    original = "Hello, World!"
    print(f"原始字符串: {original}")
    print()
    
    # 1. 子串截取
    print("--- 1. 子串截取 ---")
    print(f"前5个字符: {original[:5]}")          # CMD: %str:~0,5%
    print(f"从索引7开始: {original[7:]}")        # CMD: %str:~7%
    print(f"最后6个字符: {original[-6:]}")        # CMD: %str:~-6%
    print(f"从索引2到5: {original[2:5]}")        # CMD: %str:~2,3%
    print(f"步长为2: {original[::2]}")           # CMD: 无直接等价
    print()
    
    # 2. 字符串长度
    print("--- 2. 字符串长度 ---")
    print(f"字符串长度: {len(original)}")         # CMD: 需要循环计算
    print()
    
    # 3. 字符串替换
    print("--- 3. 字符串替换 ---")
    str_replace = "Hello World Hello CMD"
    print(f"原始字符串: {str_replace}")
    print(f"替换Hello为Hi: {str_replace.replace('Hello', 'Hi')}")  # CMD: %str:Hello=Hi%
    print(f"替换第一个匹配: {str_replace.replace('Hello', 'Hi', 1)}")  # CMD: 无直接等价
    print()
    
    # 4. 字符串查找
    print("--- 4. 字符串查找 ---")
    print(f"查找World: {original.find('World')}")      # CMD: findstr
    print(f"查找xyz: {original.find('xyz')}")          # CMD: findstr
    print(f"包含World: {'World' in original}")         # CMD: findstr + errorlevel
    print()
    
    # 5. 大小写转换
    print("--- 5. 大小写转换 ---")
    print(f"大写: {original.upper()}")                  # CMD: 需要循环替换
    print(f"小写: {original.lower()}")                  # CMD: 需要循环替换
    print(f"首字母大写: {'hello world'.title()}")       # CMD: 无直接等价
    print()
    
    # 6. 字符串修剪
    print("--- 6. 字符串修剪 ---")
    str_trim = "   Hello World   "
    print(f"原始: [{str_trim}]")
    print(f"去除首尾空格: [{str_trim.strip()}]")        # CMD: for /F技巧
    print(f"去除左侧空格: [{str_trim.lstrip()}]")       # CMD: 循环去除
    print(f"去除右侧空格: [{str_trim.rstrip()}]")       # CMD: 循环去除
    print()
    
    # 7. 字符串分割
    print("--- 7. 字符串分割 ---")
    csv_data = "apple,banana,cherry"
    print(f"原始CSV: {csv_data}")
    print(f"分割结果: {csv_data.split(',')}")           # CMD: for /F "tokens="
    print(f"分割次数: {csv_data.split(',', 1)}")        # CMD: 无直接等价
    print()
    
    # 8. 字符串连接
    print("--- 8. 字符串连接 ---")
    words = ["Hello", "World", "CMD"]
    print(f"单词列表: {words}")
    print(f"空格连接: {' '.join(words)}")                # CMD: 直接拼接
    print(f"逗号连接: {', '.join(words)}")               # CMD: 需要循环
    print()
    
    # 9. 字符串格式化
    print("--- 9. 字符串格式化 ---")
    name = "张三"
    age = 25
    print(f"f-string格式化: {name}今年{age}岁")         # CMD: %var%拼接
    print("format方法: {}今年{}岁".format(name, age))    # CMD: 无直接等价
    print("%格式化: %s今年%d岁" % (name, age))            # CMD: 无直接等价
    print()
    
    # 10. 正则表达式
    print("--- 10. 正则表达式 ---")
    import re
    text = "abc123def456"
    numbers = re.findall(r'\d+', text)
    print(f"原始文本: {text}")
    print(f"提取数字: {numbers}")                        # CMD: findstr /R 有限支持
    print(f"替换数字: {re.sub(r'\\d+', '*', text)}")     # CMD: 无直接等价
    print()
    
    # 11. 中文字符处理
    print("--- 11. 中文字符处理 ---")
    chinese = "你好世界"
    print(f"中文字符串: {chinese}")
    print(f"长度: {len(chinese)}")                       # CMD: 需要特殊处理
    print(f"前2个字符: {chinese[:2]}")                   # CMD: %str:~0,4% (GBK)
    print()
    
    # 12. 字符串检查
    print("--- 12. 字符串检查 ---")
    test_str = "Hello123"
    print(f"测试字符串: {test_str}")
    print(f"是否以Hello开头: {test_str.startswith('Hello')}")  # CMD: findstr /R "^Hello"
    print(f"是否以123结尾: {test_str.endswith('123')}")        # CMD: findstr /R "123$"
    print(f"是否全字母: {test_str.isalpha()}")                 # CMD: 无直接等价
    print(f"是否全数字: {test_str.isdigit()}")                 # CMD: 无直接等价
    print(f"是否字母数字: {test_str.isalnum()}")               # CMD: 无直接等价
    print()

if __name__ == "__main__":
    main()