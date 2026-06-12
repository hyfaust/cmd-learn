# comparison.py — Python for循环对比 CMD for循环
# 本文件展示Python中与CMD for循环等价的实现

def basic_list_loop():
    """基本列表遍历 - 对比 CMD: for %%i in (apple banana cherry) do echo %%i"""
    print("=== 基本列表遍历 ===")
    for item in ["apple", "banana", "cherry"]:
        print(f"水果: {item}")


def numeric_loop():
    """数值范围循环 - 对比 CMD: for /L %%i in (1,1,5) do echo %%i"""
    print("\n=== 数值范围循环 ===")
    
    # 基本循环 (start, stop, step)
    for i in range(1, 6):
        print(f"第 {i} 次循环")
    
    # 自定义步长
    print("\n=== 自定义步长 ===")
    for i in range(0, 26, 5):
        print(i)
    
    # 倒序循环
    print("\n=== 倒序循环 ===")
    for i in range(10, 0, -1):
        print(f"倒计时: {i}")


def string_split():
    """字符串分割 - 对比 CMD: for /F "tokens=1,2,3" %%a in ("hello world cmd")"""
    print("\n=== 字符串分割 ===")
    
    # 按空格分割
    text = "hello world cmd"
    parts = text.split()
    for i, part in enumerate(parts, 1):
        print(f"第{i}个: {part}")
    
    # 按逗号分割
    print("\n=== 按逗号分割 ===")
    text = "apple,banana,cherry"
    parts = text.split(",")
    print(f"水果: {', '.join(parts)}")


def file_iteration():
    """文件遍历 - 对比 CMD: for %%f in (*.txt) do echo %%f"""
    print("\n=== 文件遍历 ===")
    import glob
    
    # 遍历当前目录的 .py 文件
    for filepath in glob.glob("*.py"):
        print(f"文件: {filepath}")


def directory_iteration():
    """目录遍历 - 对比 CMD: for /D %%d in (*) do echo %%d"""
    print("\n=== 目录遍历 ===")
    import os
    
    # 遍历当前目录的子目录
    for entry in os.listdir("."):
        if os.path.isdir(entry):
            print(f"目录: {entry}")


def recursive_file_search():
    """递归文件搜索 - 对比 CMD: for /R %%f in (*.py) do echo %%f"""
    print("\n=== 递归文件搜索 ===")
    import glob
    
    # 递归查找所有 .py 文件
    for filepath in glob.glob("**/*.py", recursive=True):
        print(f"文件: {filepath}")


def file_content_reading():
    """文件内容读取 - 对比 CMD: for /F "usebackq" %%a in (file.txt)"""
    print("\n=== 文件内容读取 ===")
    
    # 创建临时文件
    with open("temp_test.txt", "w") as f:
        f.write("line1 - 第一行\n")
        f.write("line2 - 第二行\n")
        f.write("# 这是注释\n")
        f.write("line3 - 第三行\n")
    
    # 读取文件内容
    with open("temp_test.txt", "r") as f:
        for line_num, line in enumerate(f, 1):
            line = line.strip()
            # 跳过注释行（类似 CMD eol=#）
            if line.startswith("#"):
                continue
            print(f"第{line_num}行: {line}")
    
    # 清理临时文件
    import os
    os.remove("temp_test.txt")


def command_output():
    """命令输出 - 对比 CMD: for /F %%a in ('dir /b')"""
    print("\n=== 命令输出 ===")
    import subprocess
    
    # 执行命令并获取输出
    result = subprocess.run(["dir", "/b"], capture_output=True, text=True, shell=True)
    for line in result.stdout.strip().split("\n"):
        print(f"文件: {line}")


def nested_loop():
    """嵌套循环 - 对比 CMD: for /L %%i ... for /L %%j ..."""
    print("\n=== 嵌套循环 ===")
    
    # 九九乘法表片段
    for i in range(1, 4):
        for j in range(1, 4):
            print(f"{i} x {j} = {i*j}")
        print()


if __name__ == "__main__":
    basic_list_loop()
    numeric_loop()
    string_split()
    file_iteration()
    directory_iteration()
    recursive_file_search()
    file_content_reading()
    command_output()
    nested_loop()
