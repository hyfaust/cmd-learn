@echo off
REM ============================================================
REM call_python_inline.bat - 内联 Python 代码示例
REM
REM 功能: 演示如何在 CMD 中直接执行内联 Python 代码
REM 安全提示: 仅在项目目录内操作
REM ============================================================

chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ========================================
echo   内联 Python 代码示例
echo ========================================
echo.

REM 检查 Python
where python >nul 2>nul
if errorlevel 1 (
    echo [错误] Python 未安装
    exit /b 1
)

REM 示例 1: 简单计算
echo [示例 1] 简单计算
echo ----------------------------------------
python -c "print(f'1 + 1 = {1 + 1}')"
python -c "print(f'2 * 3 = {2 * 3}')"
python -c "import math; print(f'圆周率 = {math.pi:.6f}')"
echo.

REM 示例 2: 读取环境变量
echo [示例 2] 读取环境变量
echo ----------------------------------------
set "MY_VAR=Hello from CMD"
python -c "import os; print(f'环境变量 MY_VAR = {os.environ.get(\"MY_VAR\", \"未设置\")}')"
echo.

REM 示例 3: 管道数据处理
echo [示例 3] 管道数据处理
echo ----------------------------------------
echo apple,banana,cherry,date | python -c "
import sys
fruits = sys.stdin.read().strip().split(',')
print(f'水果数量: {len(fruits)}')
for i, fruit in enumerate(fruits, 1):
    print(f'  {i}. {fruit}')
"
echo.

REM 示例 4: 生成并处理 JSON
echo [示例 4] JSON 数据处理
echo ----------------------------------------
python -c "
import json
import sys

# 生成数据
data = {
    'name': '测试用户',
    'scores': [85, 92, 78, 95],
    'passed': True
}

# 输出 JSON
json_str = json.dumps(data, ensure_ascii=False, indent=2)
print('生成的 JSON:')
print(json_str)

# 计算平均分
avg = sum(data['scores']) / len(data['scores'])
print(f'平均分: {avg:.1f}')
"
echo.

REM 示例 5: 捕获 Python 输出
echo [示例 5] 捕获 Python 输出
echo ----------------------------------------
for /f "delims=" %%i in ('python -c "import datetime; print(datetime.datetime.now().strftime('%%Y-%%m-%%d %%H:%%M:%%S'))"') do (
    set "CURRENT_TIME=%%i"
)
echo 当前时间: %CURRENT_TIME%
echo.

REM 示例 6: 多行 Python 代码
echo [示例 6] 多行 Python 代码
echo ----------------------------------------
(
echo import random
echo import sys
echo.
echo # 生成 5 个随机数
echo numbers = [random.randint(1, 100) for _ in range(5)]
echo print(f'随机数: {numbers}')
echo print(f'最大值: {max(numbers)}')
echo print(f'最小值: {min(numbers)}')
echo print(f'平均值: {sum(numbers) / len(numbers):.1f}')
) | python -
echo.

echo ========================================
echo   示例完成
echo ========================================

endlocal
