#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
comparison.py - Python 调用外部程序示例

功能: 演示 Python 如何调用外部命令和程序
用法: python comparison.py
安全提示: 仅在项目目录内操作
"""

import os
import sys
import subprocess


def demo_os_system():
    """演示 os.system() 调用"""
    print("=" * 50)
    print("  方式 1: os.system() - 简单执行")
    print("=" * 50)
    print()
    
    # 执行简单命令
    print("[Python] 执行 'dir /b' 命令:")
    exit_code = os.system('dir /b *.py')
    print(f"[Python] 退出码: {exit_code}")
    print()
    
    # 执行带输出的命令
    print("[Python] 执行 'echo' 命令:")
    os.system('echo Hello from os.system')
    print()


def demo_subprocess_run():
    """演示 subprocess.run() 调用"""
    print("=" * 50)
    print("  方式 2: subprocess.run() - 推荐方式")
    print("=" * 50)
    print()
    
    # 基本用法
    print("[Python] 执行 'whoami' 命令:")
    result = subprocess.run(['whoami'], capture_output=True, text=True)
    print(f"  输出: {result.stdout.strip()}")
    print(f"  退出码: {result.returncode}")
    print()
    
    # 带参数的命令
    print("[Python] 执行 'ping' 命令:")
    result = subprocess.run(
        ['ping', '-n', '2', '127.0.0.1'],
        capture_output=True,
        text=True
    )
    print(f"  退出码: {result.returncode}")
    # 只显示最后几行
    lines = result.stdout.strip().split('\n')
    for line in lines[-3:]:
        print(f"  {line.strip()}")
    print()
    
    # 使用 shell=True
    print("[Python] 使用 shell 执行复杂命令:")
    result = subprocess.run(
        'echo %DATE% %TIME%',
        capture_output=True,
        text=True,
        shell=True
    )
    print(f"  当前时间: {result.stdout.strip()}")
    print()


def demo_subprocess_popen():
    """演示 subprocess.Popen() 管道通信"""
    print("=" * 50)
    print("  方式 3: subprocess.Popen() - 管道通信")
    print("=" * 50)
    print()
    
    # 管道读取输出
    print("[Python] 通过管道读取命令输出:")
    process = subprocess.Popen(
        ['dir', '/b'],
        stdout=subprocess.PIPE,
        text=True,
        shell=True
    )
    
    output, _ = process.communicate()
    print(f"  文件列表:")
    for line in output.strip().split('\n')[:5]:
        print(f"    {line.strip()}")
    print(f"  ... (共 {len(output.strip().split(chr(10)))} 项)")
    print()
    
    # 管道写入输入
    print("[Python] 通过管道写入数据:")
    process = subprocess.Popen(
        ['findstr', 'Python'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        text=True,
        shell=True
    )
    
    input_data = "Hello\nPython World\nTest\nPython Script"
    output, _ = process.communicate(input=input_data)
    print(f"  输入包含 'Python' 的行:")
    for line in output.strip().split('\n'):
        print(f"    {line.strip()}")
    print()


def demo_subprocess_call():
    """演示 subprocess.call() 调用"""
    print("=" * 50)
    print("  方式 4: subprocess.call() - 获取退出码")
    print("=" * 50)
    print()
    
    print("[Python] 执行命令并获取退出码:")
    
    # 成功的命令
    exit_code = subprocess.call(['echo', 'Success'], shell=True)
    print(f"  'echo' 退出码: {exit_code}")
    
    # 失败的命令
    exit_code = subprocess.call(['nonexistent_command'], shell=True, 
                                 stderr=subprocess.DEVNULL)
    print(f"  不存在的命令退出码: {exit_code}")
    print()


def demo_check_output():
    """演示 subprocess.check_output() 调用"""
    print("=" * 50)
    print("  方式 5: subprocess.check_output() - 获取输出")
    print("=" * 50)
    print()
    
    try:
        print("[Python] 获取命令输出:")
        output = subprocess.check_output(
            ['hostname'],
            text=True,
            shell=True
        )
        print(f"  主机名: {output.strip()}")
    except subprocess.CalledProcessError as e:
        print(f"  命令失败: {e}")
    print()


def main():
    """主函数"""
    print()
    print("╔" + "═" * 48 + "╗")
    print("║" + " Python 调用外部程序示例".center(44) + "    ║")
    print("╚" + "═" * 48 + "╝")
    print()
    
    # 演示各种调用方式
    demo_os_system()
    demo_subprocess_run()
    demo_subprocess_popen()
    demo_subprocess_call()
    demo_check_output()
    
    print("=" * 50)
    print("  演示完成")
    print("=" * 50)


if __name__ == "__main__":
    main()
