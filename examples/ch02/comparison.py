# -*- coding: utf-8 -*-
"""
Python 文件操作对比示例
功能：演示Python中与CMD等效的文件系统操作
使用模块：os, shutil, pathlib
"""

import os
import shutil
import pathlib
from datetime import datetime


def main():
    # 设置基准目录为脚本所在目录下的sandbox
    script_dir = pathlib.Path(__file__).parent
    base_dir = script_dir / "sandbox"
    
    # 清理可能存在的旧sandbox
    if base_dir.exists():
        shutil.rmtree(base_dir)
    
    print("=" * 50)
    print("Python 文件操作对比示例")
    print("=" * 50)
    print()
    
    # 创建目录结构
    print("[1] 创建目录结构")
    # CMD: mkdir dir
    base_dir.mkdir(exist_ok=True)
    (base_dir / "sub1").mkdir(exist_ok=True)
    (base_dir / "sub2").mkdir(exist_ok=True)
    (base_dir / "sub1" / "deep").mkdir(exist_ok=True)
    print("创建完成")
    print()
    
    # 创建测试文件
    print("[2] 创建测试文件")
    # CMD: echo content > file.txt
    (base_dir / "test1.txt").write_text("这是第一个测试文件\n", encoding="utf-8")
    (base_dir / "test2.txt").write_text("这是第二个测试文件\n", encoding="utf-8")
    (base_dir / "test3.txt").write_text("Hello World\n", encoding="utf-8")
    print("创建完成")
    print()
    
    # 复制文件
    print("[3] 复制文件")
    # CMD: copy src dst
    shutil.copy2(base_dir / "test1.txt", base_dir / "test1_backup.txt")
    print(f"复制: test1.txt -> test1_backup.txt")
    
    # 批量复制
    backup_dir = base_dir / "backup"
    backup_dir.mkdir(exist_ok=True)
    for txt_file in base_dir.glob("*.txt"):
        shutil.copy2(txt_file, backup_dir / txt_file.name)
    print("批量复制完成")
    print()
    
    # 移动文件
    print("[4] 移动文件")
    # CMD: move src dst
    shutil.move(str(base_dir / "test2.txt"), str(base_dir / "sub1" / "test2.txt"))
    print("移动: test2.txt -> sub1/test2.txt")
    print()
    
    # 重命名文件
    print("[5] 重命名文件")
    # CMD: ren old new
    (base_dir / "test3.txt").rename(base_dir / "test3_renamed.txt")
    print("重命名: test3.txt -> test3_renamed.txt")
    print()
    
    # 读取文件内容
    print("[6] 读取文件内容")
    # CMD: type file.txt
    content = (base_dir / "test1.txt").read_text(encoding="utf-8")
    print(f"test1.txt 内容: {content.strip()}")
    print()
    
    # 文件属性操作
    print("[7] 文件属性操作")
    test_file = base_dir / "test1.txt"
    stat = test_file.stat()
    print(f"文件大小: {stat.st_size} 字节")
    print(f"创建时间: {datetime.fromtimestamp(stat.st_ctime)}")
    print(f"修改时间: {datetime.fromtimestamp(stat.st_mtime)}")
    
    # 设置只读属性（Windows特有）
    # CMD: attrib +R file.txt
    import stat as stat_module
    test_file.chmod(test_file.stat().st_mode | stat_module.S_IREAD)
    print("设置只读属性完成")
    print()
    
    # 遍历目录
    print("[8] 遍历目录")
    # CMD: for /R %dir% %%f in (*.txt) do echo %%f
    print("所有.txt文件:")
    for txt_file in base_dir.rglob("*.txt"):
        print(f"  {txt_file.relative_to(base_dir)}")
    print()
    
    # 使用os.walk遍历
    print("[9] 使用os.walk遍历")
    # CMD: dir /S /B
    for root, dirs, files in os.walk(base_dir):
        level = root.replace(str(base_dir), "").count(os.sep)
        indent = " " * 2 * level
        print(f"{indent}{os.path.basename(root)}/")
        subindent = " " * 2 * (level + 1)
        for file in files:
            print(f"{subindent}{file}")
    print()
    
    # 删除文件
    print("[10] 删除文件")
    # CMD: del file.txt
    (base_dir / "test1_backup.txt").unlink()
    print("删除: test1_backup.txt")
    print()
    
    # 清理sandbox目录
    print("[11] 清理sandbox目录")
    # CMD: rmdir /s /q sandbox
    shutil.rmtree(base_dir)
    print("清理完成")
    
    print()
    print("演示结束")


if __name__ == "__main__":
    main()