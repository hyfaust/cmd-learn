#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
data_exchange.py - Python 数据交换示例

功能: 演示与 CMD 之间的数据交换方式
用法: python data_exchange.py
安全提示: 仅在项目目录内操作
"""

import os
import sys
import json
from datetime import datetime


def read_env_variables():
    """从环境变量读取数据"""
    print("=" * 40)
    print("  环境变量数据交换")
    print("=" * 40)
    print()
    
    # 读取常见的环境变量
    env_vars = [
        'INPUT_DATA', 'MAX_VALUE', 'USER_NAME',
        'COMPUTERNAME', 'USERNAME', 'TEMP', 'PATH'
    ]
    
    print("[Python] 读取环境变量:")
    for var in env_vars:
        value = os.environ.get(var, '<未设置>')
        # PATH 太长，只显示前 50 个字符
        if var == 'PATH' and len(value) > 50:
            value = value[:50] + '...'
        print(f"  {var} = {value}")
    print()


def generate_output():
    """生成输出数据"""
    print("=" * 40)
    print("  生成输出数据")
    print("=" * 40)
    print()
    
    # 生成结构化数据
    data = {
        'timestamp': datetime.now().isoformat(),
        'status': 'success',
        'data': {
            'numbers': [1, 2, 3, 4, 5],
            'text': 'Hello from Python',
            'nested': {
                'key1': 'value1',
                'key2': 'value2'
            }
        }
    }
    
    # 输出 JSON 格式（供 CMD 捕获）
    print("[Python] 输出 JSON 数据:")
    json_output = json.dumps(data, ensure_ascii=False, indent=2)
    print(json_output)
    print()
    
    # 输出键值对格式（供 CMD for /f 解析）
    print("[Python] 输出键值对:")
    print(f"TIMESTAMP={data['timestamp']}")
    print(f"STATUS={data['status']}")
    print(f"NUMBERS_COUNT={len(data['data']['numbers'])}")
    print(f"TEXT={data['data']['text']}")
    print()


def process_stdin():
    """处理标准输入数据"""
    print("=" * 40)
    print("  处理标准输入")
    print("=" * 40)
    print()
    
    if sys.stdin.isatty():
        print("[Python] 没有标准输入数据（交互模式）")
        print("[Python] 提示: 使用管道传递数据，例如:")
        print("  echo data | python data_exchange.py")
    else:
        print("[Python] 从标准输入读取数据:")
        lines = sys.stdin.readlines()
        for i, line in enumerate(lines, 1):
            print(f"  行 {i}: {line.strip()}")
        print(f"\n[Python] 共读取 {len(lines)} 行")
    print()


def main():
    """主函数"""
    print()
    print("========================================")
    print("  Python 数据交换演示")
    print("========================================")
    print()
    
    # 1. 读取环境变量
    read_env_variables()
    
    # 2. 生成输出数据
    generate_output()
    
    # 3. 处理标准输入
    process_stdin()
    
    print("=" * 40)
    print("  演示完成")
    print("=" * 40)
    
    sys.exit(0)


if __name__ == "__main__":
    main()
