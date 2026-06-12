#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
comparison.py - Python文件I/O对比示例

本文件展示Python中文件I/O操作，用于与CMD的文件I/O进行对比。
Python提供了更强大、更灵活的文件操作功能。
"""

import os
import tempfile
import shutil
from pathlib import Path


def demonstrate_basic_io():
    """演示基本的文件I/O操作"""
    print("=== Python基本文件I/O ===\n")
    
    # 创建测试目录
    test_dir = Path("test_output")
    test_dir.mkdir(exist_ok=True)
    
    # 1. 写入文件（覆盖模式）
    print("1. 写入文件（覆盖模式）")
    with open(test_dir / "output.txt", "w", encoding="utf-8") as f:
        f.write("Hello World\n")
        f.write("Python文件写入\n")
        f.write("第三行内容\n")
    
    # 读取并显示
    with open(test_dir / "output.txt", "r", encoding="utf-8") as f:
        content = f.read()
        print(f"文件内容:\n{content}")
    
    # 2. 追加写入
    print("2. 追加写入")
    with open(test_dir / "output.txt", "a", encoding="utf-8") as f:
        f.write("追加的第一行\n")
        f.write("追加的第二行\n")
    
    # 读取并显示
    with open(test_dir / "output.txt", "r", encoding="utf-8") as f:
        content = f.read()
        print(f"追加后内容:\n{content}")
    
    return test_dir


def demonstrate_line_by_line(test_dir):
    """演示逐行读取"""
    print("\n=== 逐行读取 ===\n")
    
    # 创建测试文件
    with open(test_dir / "lines.txt", "w", encoding="utf-8") as f:
        for i in range(1, 6):
            f.write(f"Line {i}: This is line number {i}\n")
    
    # 方法1: 直接迭代文件对象
    print("方法1: 直接迭代文件对象")
    with open(test_dir / "lines.txt", "r", encoding="utf-8") as f:
        for line_num, line in enumerate(f, 1):
            print(f"  {line_num}: {line.rstrip()}")
    
    # 方法2: 使用readlines()
    print("\n方法2: 使用readlines()")
    with open(test_dir / "lines.txt", "r", encoding="utf-8") as f:
        lines = f.readlines()
        for i, line in enumerate(lines, 1):
            print(f"  {i}: {line.rstrip()}")
    
    # 方法3: 使用read().splitlines()
    print("\n方法3: 使用read().splitlines()")
    with open(test_dir / "lines.txt", "r", encoding="utf-8") as f:
        lines = f.read().splitlines()
        for i, line in enumerate(lines, 1):
            print(f"  {i}: {line}")


def demonstrate_context_manager(test_dir):
    """演示上下文管理器（with语句）"""
    print("\n=== 上下文管理器 ===\n")
    
    # with语句自动处理文件关闭
    print("使用with语句（推荐方式）:")
    with open(test_dir / "context.txt", "w", encoding="utf-8") as f:
        f.write("使用上下文管理器\n")
        f.write("自动处理文件关闭\n")
        f.write("即使发生异常也能正确关闭\n")
    
    # 等价于（但更安全）:
    print("\n等价于（但with更安全）:")
    f = open(test_dir / "context2.txt", "w", encoding="utf-8")
    try:
        f.write("手动打开文件\n")
        f.write("需要手动关闭\n")
    finally:
        f.close()


def demonstrate_binary_io(test_dir):
    """演示二进制文件I/O"""
    print("\n=== 二进制文件I/O ===\n")
    
    # 写入二进制数据
    print("写入二进制数据:")
    data = bytes([0x48, 0x65, 0x6C, 0x6C, 0x6F])  # "Hello"
    with open(test_dir / "binary.bin", "wb") as f:
        f.write(data)
        f.write(b"\x00\x01\x02\x03")  # 添加一些字节
    
    # 读取二进制数据
    print("读取二进制数据:")
    with open(test_dir / "binary.bin", "rb") as f:
        data = f.read()
        print(f"  原始字节: {data}")
        print(f"  十六进制: {data.hex()}")
        print(f"  解码为字符串: {data[:5].decode('ascii')}")


def demonstrate_file_operations(test_dir):
    """演示文件操作"""
    print("\n=== 文件操作 ===\n")
    
    # 创建测试文件
    test_file = test_dir / "operations.txt"
    with open(test_file, "w", encoding="utf-8") as f:
        f.write("测试文件操作\n")
    
    # 1. 检查文件是否存在
    print(f"1. 文件存在: {test_file.exists()}")
    
    # 2. 获取文件大小
    print(f"2. 文件大小: {test_file.stat().st_size} 字节")
    
    # 3. 获取文件信息
    stat = test_file.stat()
    print(f"3. 文件信息:")
    print(f"   修改时间: {stat.st_mtime}")
    print(f"   创建时间: {stat.st_ctime}")
    
    # 4. 重命名文件
    new_name = test_dir / "renamed.txt"
    test_file.rename(new_name)
    print(f"4. 重命名: {test_file.name} -> {new_name.name}")
    
    # 5. 复制文件
    copy_name = test_dir / "copy.txt"
    shutil.copy2(new_name, copy_name)
    print(f"5. 复制: {new_name.name} -> {copy_name.name}")
    
    # 6. 删除文件
    copy_name.unlink()
    print(f"6. 删除: {copy_name.name}")
    print(f"   文件存在: {copy_name.exists()}")


def demonstrate_temp_files():
    """演示临时文件操作"""
    print("\n=== 临时文件操作 ===\n")
    
    # 方法1: 使用tempfile模块
    print("方法1: 使用tempfile模块")
    with tempfile.NamedTemporaryFile(mode='w', suffix='.txt', delete=False, encoding='utf-8') as f:
        temp_name = f.name
        f.write("临时文件内容\n")
        print(f"  临时文件: {temp_name}")
    
    # 读取临时文件
    with open(temp_name, 'r', encoding='utf-8') as f:
        print(f"  内容: {f.read().rstrip()}")
    
    # 删除临时文件
    os.unlink(temp_name)
    print(f"  临时文件已删除")
    
    # 方法2: 使用临时目录
    print("\n方法2: 使用临时目录")
    with tempfile.TemporaryDirectory() as temp_dir:
        print(f"  临时目录: {temp_dir}")
        
        # 在临时目录中创建文件
        temp_file = Path(temp_dir) / "test.txt"
        with open(temp_file, 'w', encoding='utf-8') as f:
            f.write("在临时目录中的文件\n")
        
        print(f"  文件内容: {temp_file.read_text(encoding='utf-8').rstrip()}")
    
    print("  临时目录已自动清理")


def demonstrate_csv_operations(test_dir):
    """演示CSV文件操作"""
    print("\n=== CSV文件操作 ===\n")
    
    import csv
    
    # 写入CSV
    csv_file = test_dir / "data.csv"
    with open(csv_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['Name', 'Age', 'City'])
        writer.writerow(['Alice', 25, 'Beijing'])
        writer.writerow(['Bob', 30, 'Shanghai'])
        writer.writerow(['Charlie', 35, 'Guangzhou'])
    
    print("CSV文件内容:")
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        for row in reader:
            print(f"  {row}")
    
    # 使用DictReader
    print("\n使用DictReader:")
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            print(f"  {row['Name']}, {row['Age']}岁, 住在{row['City']}")


def demonstrate_json_operations(test_dir):
    """演示JSON文件操作"""
    print("\n=== JSON文件操作 ===\n")
    
    import json
    
    # 创建数据
    data = {
        "name": "CMD Tutorial",
        "version": "1.0.0",
        "chapters": [
            {"id": 1, "title": "Hello CMD"},
            {"id": 2, "title": "File Management"},
            {"id": 6, "title": "File I/O"}
        ],
        "metadata": {
            "author": "Tutorial Engineer",
            "created": "2026-06-11"
        }
    }
    
    # 写入JSON
    json_file = test_dir / "data.json"
    with open(json_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print("JSON文件内容:")
    with open(json_file, 'r', encoding='utf-8') as f:
        loaded = json.load(f)
        print(json.dumps(loaded, indent=2, ensure_ascii=False))


def demonstrate_error_handling(test_dir):
    """演示错误处理"""
    print("\n=== 错误处理 ===\n")
    
    # 1. 文件不存在
    print("1. 文件不存在错误:")
    try:
        with open("nonexistent.txt", 'r') as f:
            content = f.read()
    except FileNotFoundError as e:
        print(f"   捕获错误: {e}")
    
    # 2. 权限错误
    print("\n2. 权限错误:")
    try:
        # 尝试写入只读文件（模拟）
        with open(test_dir / "readonly.txt", 'w') as f:
            f.write("test")
        # 在Windows上设置只读属性
        import stat
        os.chmod(test_dir / "readonly.txt", stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH)
        with open(test_dir / "readonly.txt", 'w') as f:
            f.write("should fail")
    except PermissionError as e:
        print(f"   捕获错误: {e}")
    except OSError as e:
        print(f"   捕获错误: {e}")
    
    # 3. 使用with语句确保资源释放
    print("\n3. 使用with语句确保资源释放:")
    try:
        with open(test_dir / "safe.txt", 'w', encoding='utf-8') as f:
            f.write("安全写入\n")
            # 即使这里发生异常，文件也会被正确关闭
            raise ValueError("模拟异常")
    except ValueError as e:
        print(f"   捕获异常: {e}")
        # 文件仍然被正确关闭
        if (test_dir / "safe.txt").exists():
            print("   文件已正确创建和关闭")


def cleanup(test_dir):
    """清理测试目录"""
    print(f"\n清理测试目录: {test_dir}")
    if test_dir.exists():
        shutil.rmtree(test_dir)
        print("清理完成")


def main():
    """主函数"""
    print("Python文件I/O对比示例")
    print("=" * 50)
    
    # 创建测试目录
    test_dir = Path("test_output")
    
    try:
        # 演示各种文件操作
        test_dir = demonstrate_basic_io()
        demonstrate_line_by_line(test_dir)
        demonstrate_context_manager(test_dir)
        demonstrate_binary_io(test_dir)
        demonstrate_file_operations(test_dir)
        demonstrate_temp_files()
        demonstrate_csv_operations(test_dir)
        demonstrate_json_operations(test_dir)
        demonstrate_error_handling(test_dir)
        
    finally:
        # 清理
        cleanup(test_dir)
    
    print("\n" + "=" * 50)
    print("Python文件I/O演示完成")
    print("=" * 50)


if __name__ == "__main__":
    main()