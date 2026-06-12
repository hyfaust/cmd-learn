@echo off
REM ============================================================
REM call_python.bat - 调用 Python 脚本示例
REM
REM 功能: 演示如何从 CMD 调用 Python 脚本并传递参数
REM 安全提示: 仅在项目目录内操作
REM ============================================================

chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ========================================
echo   CMD 调用 Python 脚本示例
echo ========================================
echo.

REM 设置脚本路径
set "SCRIPT_DIR=%~dp0scripts"
set "PYTHON_SCRIPT=%SCRIPT_DIR%\hello.py"

REM 检查 Python 是否可用
echo [1/4] 检查 Python 环境...
where python >nul 2>nul
if errorlevel 1 (
    echo [错误] Python 未安装或不在 PATH 中
    echo 请安装 Python 并添加到系统 PATH
    exit /b 1
)

REM 显示 Python 版本
for /f "delims=" %%v in ('python --version 2^>^&1') do (
    echo [信息] %%v
)

REM 检查脚本是否存在
echo.
echo [2/4] 检查脚本文件...
if not exist "%PYTHON_SCRIPT%" (
    echo [错误] 脚本文件不存在: %PYTHON_SCRIPT%
    exit /b 1
)
echo [信息] 脚本路径: %PYTHON_SCRIPT%

REM 设置参数
set "NAME=World"
set "COUNT=3"

echo.
echo [3/4] 调用 Python 脚本...
echo [信息] 参数: NAME=%NAME%, COUNT=%COUNT%
echo ----------------------------------------

REM 调用 Python 脚本并传递参数
python "%PYTHON_SCRIPT%" %NAME% %COUNT%
set "PYTHON_EXIT_CODE=%errorlevel%"

echo ----------------------------------------

REM 检查执行结果
echo.
echo [4/4] 检查执行结果...
echo [信息] Python 退出码: %PYTHON_EXIT_CODE%

if %PYTHON_EXIT_CODE% equ 0 (
    echo [成功] Python 脚本执行完成
) else (
    echo [失败] Python 脚本执行失败
)

echo.
echo ========================================
echo   示例完成
echo ========================================

endlocal
exit /b %PYTHON_EXIT_CODE%
