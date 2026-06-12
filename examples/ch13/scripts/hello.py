#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
hello.py - Python 示例脚本

功能: 接收命令行参数并输出问候语
用法: python hello.py [name] [count]
安全提示: 仅在项目目录内操作
"""

import sys


def main():
    """主函数"""
    # 获取脚本名称
    script_name = sys.argv[0] if sys.argv else "hello.py"
    print(f"[Python] 脚本: {script_name}")
    
    # 解析参数
    # sys.argv[0] 是脚本名，用户参数从 [1] 开始
    name = sys.argv[1] if len(sys.argv) > 1 else "World"
    
    try:
        count = int(sys.argv[2]) if len(sys.argv) > 2 else 1
    except ValueError:
        print(f"[错误] 无效的计数参数: {sys.argv[2]}")
        sys.exit(1)
    
    # 限制最大次数，防止无限循环
    count = min(count, 100)
    
    # 输出问候语
    print(f"[Python] 参数: name={name}, count={count}")
    print()
    
    for i in range(count):
        print(f"Hello, {name}! (第 {i + 1} 次)")
    
    print()
    print(f"[Python] 执行完成，共输出 {count} 次")
    
    # 通过退出码返回状态 (0 = 成功)
    sys.exit(0)


if __name__ == "__main__":
    main()
