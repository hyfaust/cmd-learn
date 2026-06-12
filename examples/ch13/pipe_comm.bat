@echo off
REM ============================================================
REM pipe_comm.bat - 管道通信演示
REM
REM 功能: 演示 CMD 与其他语言的管道通信
REM 安全提示: 仅在项目目录内操作
REM ============================================================

chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ========================================
echo   管道通信演示
echo ========================================
echo.

REM 检查 Python
where python >nul 2>nul
if errorlevel 1 (
    echo [错误] Python 未安装，部分演示将跳过
    set "PYTHON_AVAILABLE=0"
) else (
    set "PYTHON_AVAILABLE=1"
)

REM 示例 1: 基本管道
echo [示例 1] 基本管道 - 文本处理
echo ----------------------------------------
echo Hello World | findstr "World"
echo.

REM 示例 2: 多行数据管道
echo [示例 2] 多行数据管道
echo ----------------------------------------
(
echo apple
echo banana
echo cherry
echo date
echo elderberry
) | sort
echo.

REM 示例 3: 管道传递给 Python
if "%PYTHON_AVAILABLE%"=="1" (
    echo [示例 3] 管道传递给 Python
    echo ----------------------------------------
    echo Hello from CMD | python -c "import sys; print('[Python] 收到:', sys.stdin.read().strip())"
    echo.
)

REM 示例 4: 复杂数据管道
if "%PYTHON_AVAILABLE%"=="1" (
    echo [示例 4] 复杂数据管道 - CSV 处理
    echo ----------------------------------------
    (
    echo 姓名,年龄,城市
    echo 张三,25,北京
    echo 李四,30,上海
    echo 王五,28,广州
    echo 赵六,35,深圳
    ) | python -c "
import sys, csv
from io import StringIO

data = sys.stdin.read()
reader = csv.DictReader(StringIO(data))
print('处理结果:')
print('-' * 40)
for row in reader:
    print(f\"  {row['姓名']}: {row['年龄']}岁, {row['城市']}\")
print('-' * 40)
"
    echo.
)

REM 示例 5: 捕获 Python 输出
if "%PYTHON_AVAILABLE%"=="1" (
    echo [示例 5] 捕获 Python 输出
    echo ----------------------------------------
    for /f "tokens=1,2 delims==" %%a in ('python -c "import datetime; print('TIME=' + datetime.datetime.now().strftime('%%H:%%M:%%S'))"') do (
        if "%%a"=="TIME" (
            echo 当前时间: %%b
        )
    )
    echo.
)

REM 示例 6: 管道计算
if "%PYTHON_AVAILABLE%"=="1" (
    echo [示例 6] 管道数学计算
    echo ----------------------------------------
    echo 100 200 300 400 500 | python -c "
import sys
numbers = [int(x) for x in sys.stdin.read().split()]
print(f'数字: {numbers}')
print(f'总和: {sum(numbers)}')
print(f'平均: {sum(numbers) / len(numbers):.1f}')
print(f'最大: {max(numbers)}')
print(f'最小: {min(numbers)}')
"
    echo.
)

echo ========================================
echo   演示完成
echo ========================================

endlocal
