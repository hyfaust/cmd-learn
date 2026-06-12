@echo off
REM ============================================================
REM call_c.bat - 调用 C 程序示例
REM
REM 功能: 演示如何编译和调用 C 程序
REM 安全提示: 仅在项目目录内操作
REM ============================================================

setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

echo ========================================
echo   CMD 调用 C 程序示例
echo ========================================
echo.

set "SCRIPT_DIR=%~dp0scripts"
set "C_SOURCE=%SCRIPT_DIR%\hello.c"
set "C_EXE=%SCRIPT_DIR%\hello.exe"

REM 检查 GCC 是否可用
echo [1/4] 检查编译环境...
set "COMPILER="
where gcc >nul 2>nul
if !errorlevel! equ 0 (
    set "COMPILER=GCC"
    goto :compiler_found
)

echo [警告] GCC 未找到，尝试使用 MSVC...
where cl >nul 2>nul
if !errorlevel! equ 0 (
    set "COMPILER=MSVC"
    goto :compiler_found
)

echo [错误] 未找到 C 编译器
echo 请安装 GCC (MinGW-w64) 或 MSVC
exit /b 1

:compiler_found
echo [信息] 使用编译器: !COMPILER!

REM 检查源文件
echo.
echo [2/4] 检查源文件...
if not exist "%C_SOURCE%" (
    echo [错误] 源文件不存在: %C_SOURCE%
    exit /b 1
)
echo [信息] 源文件: %C_SOURCE%

REM 编译 C 程序
echo.
echo [3/4] 编译 C 程序...
echo ----------------------------------------

if "%COMPILER%"=="GCC" (
    gcc "%C_SOURCE%" -o "%C_EXE%" -Wall
) else (
    cl /Fe:"%C_EXE%" "%C_SOURCE%"
)

if errorlevel 1 (
    echo [错误] 编译失败
    exit /b 1
)
echo [成功] 编译完成: %C_EXE%
echo ----------------------------------------

REM 调用 C 程序
echo.
echo [4/4] 调用 C 程序...
echo ----------------------------------------
echo [信息] 传递参数: arg1 arg2 arg3
"%C_EXE%" arg1 arg2 arg3
set "C_EXIT_CODE=%errorlevel%"
echo ----------------------------------------

REM 检查结果
echo.
echo [结果] C 程序退出码: %C_EXIT_CODE%

if %C_EXIT_CODE% equ 0 (
    echo [成功] C 程序执行完成
) else (
    echo [失败] C 程序执行失败
)

REM 清理编译产物
echo.
echo [清理] 删除编译产物...
del "%C_EXE%" 2>nul
if exist "%C_EXE%.obj" del "%C_EXE%.obj" 2>nul

echo.
echo ========================================
echo   示例完成
echo ========================================

endlocal
exit /b %C_EXIT_CODE%
