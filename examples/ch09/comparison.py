"""
Python 环境变量和注册表操作对比
文件: comparison.py
作者: 教程工程师
日期: 2026-06-11
说明: 展示Python中环境变量和注册表操作与CMD的对比
"""

import os
import sys
import json
import winreg
from datetime import datetime


def compare_environment_variables():
    """比较Python和CMD的环境变量操作"""
    print("=" * 60)
    print("环境变量操作对比")
    print("=" * 60)
    
    # 1. 获取环境变量
    print("\n[1] 获取环境变量")
    print("-" * 40)
    
    # Python方式
    python_path = os.environ.get('PATH', '默认值')
    python_temp = os.environ.get('TEMP', '默认值')
    python_userprofile = os.environ.get('USERPROFILE', '默认值')
    
    print(f"Python获取PATH: {python_path[:100]}...")
    print(f"Python获取TEMP: {python_temp}")
    print(f"Python获取USERPROFILE: {python_userprofile}")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  echo %PATH%")
    print("  echo %TEMP%")
    print("  echo %USERPROFILE%")
    
    # 2. 设置环境变量
    print("\n[2] 设置环境变量")
    print("-" * 40)
    
    # Python方式 - 设置临时环境变量
    os.environ['PYTHON_TEST_VAR'] = 'Python Test Value'
    print(f"Python设置PYTHON_TEST_VAR: {os.environ['PYTHON_TEST_VAR']}")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  set PYTHON_TEST_VAR=Python Test Value")
    
    # 3. 删除环境变量
    print("\n[3] 删除环境变量")
    print("-" * 40)
    
    # Python方式
    if 'PYTHON_TEST_VAR' in os.environ:
        del os.environ['PYTHON_TEST_VAR']
        print("Python删除PYTHON_TEST_VAR: 成功")
    else:
        print("Python删除PYTHON_TEST_VAR: 变量不存在")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  set PYTHON_TEST_VAR=")
    
    # 4. 遍历环境变量
    print("\n[4] 遍历环境变量")
    print("-" * 40)
    
    # Python方式
    print("Python遍历环境变量（前10个）:")
    for i, (key, value) in enumerate(os.environ.items()):
        if i >= 10:
            break
        print(f"  {key}: {value[:50]}...")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  set")


def compare_registry_operations():
    """比较Python和CMD的注册表操作"""
    print("\n" + "=" * 60)
    print("注册表操作对比")
    print("=" * 60)
    
    # 1. 查询注册表
    print("\n[1] 查询注册表")
    print("-" * 40)
    
    try:
        # Python方式 - 查询用户环境变量
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, 'Environment') as key:
            # 查询所有值
            print("Python查询用户环境变量:")
            i = 0
            while True:
                try:
                    name, value, reg_type = winreg.EnumValue(key, i)
                    print(f"  {name}: {value}")
                    i += 1
                except WindowsError:
                    break
    except Exception as e:
        print(f"Python查询注册表失败: {e}")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  reg query \"HKCU\\Environment\"")
    
    # 2. 查询特定值
    print("\n[2] 查询特定注册表值")
    print("-" * 40)
    
    try:
        # Python方式
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, 'Environment') as key:
            path_value, reg_type = winreg.QueryValueEx(key, 'Path')
            print(f"Python查询Path值: {path_value[:100]}...")
    except Exception as e:
        print(f"Python查询Path值失败: {e}")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  reg query \"HKCU\\Environment\" /v Path")
    
    # 3. 添加注册表值
    print("\n[3] 添加注册表值")
    print("-" * 40)
    
    try:
        # Python方式
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, 'Environment', 0, winreg.KEY_SET_VALUE) as key:
            winreg.SetValueEx(key, 'PYTHON_TEST_REG', 0, winreg.REG_SZ, 'Python Registry Value')
            print("Python添加PYTHON_TEST_REG: 成功")
    except Exception as e:
        print(f"Python添加注册表值失败: {e}")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  reg add \"HKCU\\Environment\" /v \"PYTHON_TEST_REG\" /t REG_SZ /d \"Python Registry Value\" /f")
    
    # 4. 删除注册表值
    print("\n[4] 删除注册表值")
    print("-" * 40)
    
    try:
        # Python方式
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, 'Environment', 0, winreg.KEY_SET_VALUE) as key:
            winreg.DeleteValue(key, 'PYTHON_TEST_REG')
            print("Python删除PYTHON_TEST_REG: 成功")
    except Exception as e:
        print(f"Python删除注册表值失败: {e}")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  reg delete \"HKCU\\Environment\" /v \"PYTHON_TEST_REG\" /f")


def compare_path_operations():
    """比较PATH变量操作"""
    print("\n" + "=" * 60)
    print("PATH变量操作对比")
    print("=" * 60)
    
    # 1. 获取PATH
    print("\n[1] 获取PATH变量")
    print("-" * 40)
    
    # Python方式
    python_path = os.environ.get('PATH', '')
    path_list = python_path.split(';')
    
    print(f"Python获取PATH（前5个目录）:")
    for i, path in enumerate(path_list[:5]):
        print(f"  {i+1}. {path}")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  echo %PATH%")
    
    # 2. 添加目录到PATH
    print("\n[2] 添加目录到PATH")
    print("-" * 40)
    
    # Python方式
    new_path = "C:\\PythonTestDir"
    os.environ['PATH'] = f"{os.environ['PATH']};{new_path}"
    print(f"Python添加目录到PATH: {new_path}")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print(f"  set PATH=%PATH%;{new_path}")
    
    # 3. 检查目录是否存在
    print("\n[3] 检查PATH目录是否存在")
    print("-" * 40)
    
    # Python方式
    print("Python检查PATH目录:")
    missing_dirs = []
    for path_dir in path_list[:10]:
        if not os.path.exists(path_dir):
            missing_dirs.append(path_dir)
            print(f"  [缺失] {path_dir}")
        else:
            print(f"  [存在] {path_dir}")
    
    print(f"缺失目录数量: {len(missing_dirs)}")
    
    # CMD等价命令
    print("\nCMD等价命令:")
    print("  for %%i in (\"%PATH:;=\" \"%\") do if not exist \"%%~i\" echo 缺失: %%~i")


def create_comparison_report():
    """创建对比报告"""
    print("\n" + "=" * 60)
    print("创建对比报告")
    print("=" * 60)
    
    report = {
        "comparison_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "python_version": sys.version,
        "operating_system": os.name,
        "environment_variables": {
            "total_count": len(os.environ),
            "important_vars": {
                "PATH": os.environ.get('PATH', '')[:100] + "...",
                "TEMP": os.environ.get('TEMP', ''),
                "USERPROFILE": os.environ.get('USERPROFILE', ''),
                "SystemRoot": os.environ.get('SystemRoot', ''),
                "ProgramFiles": os.environ.get('ProgramFiles', '')
            }
        },
        "registry_operations": {
            "query_supported": True,
            "write_supported": True,
            "delete_supported": True
        },
        "cmd_equivalent_commands": {
            "get_env": "echo %VARIABLE_NAME%",
            "set_env": "set VARIABLE_NAME=value",
            "query_reg": "reg query \"HKCU\\Environment\"",
            "add_reg": "reg add \"HKCU\\Environment\" /v Name /t REG_SZ /d Value /f",
            "delete_reg": "reg delete \"HKCU\\Environment\" /v Name /f"
        }
    }
    
    # 保存报告
    report_file = "env_registry_comparison.json"
    with open(report_file, 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2, ensure_ascii=False)
    
    print(f"对比报告已保存到: {report_file}")
    print(f"报告内容预览:")
    print(f"  生成时间: {report['comparison_date']}")
    print(f"  Python版本: {report['python_version']}")
    print(f"  环境变量总数: {report['environment_variables']['total_count']}")


def main():
    """主函数"""
    print("Python 环境变量和注册表操作对比演示")
    print("作者: 教程工程师")
    print("日期: 2026-06-11")
    print()
    
    try:
        compare_environment_variables()
        compare_registry_operations()
        compare_path_operations()
        create_comparison_report()
        
        print("\n" + "=" * 60)
        print("对比演示完成")
        print("=" * 60)
        print("\n主要区别总结:")
        print("1. Python使用os.environ管理环境变量，CMD使用set命令")
        print("2. Python使用winreg模块操作注册表，CMD使用reg命令")
        print("3. Python提供更丰富的错误处理和类型检查")
        print("4. CMD更适合简单的脚本和系统管理任务")
        print("5. Python更适合复杂的应用程序和数据处理")
        
    except Exception as e:
        print(f"演示过程中发生错误: {e}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main()