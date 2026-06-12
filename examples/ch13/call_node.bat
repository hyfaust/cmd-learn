@echo off
REM ============================================================
REM call_node.bat - 调用 Node.js 脚本示例
REM
REM 功能: 演示如何从 CMD 调用 Node.js 脚本
REM 安全提示: 仅在项目目录内操作
REM ============================================================

chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ========================================
echo   CMD 调用 Node.js 脚本示例
echo ========================================
echo.

set "SCRIPT_DIR=%~dp0scripts"

REM 检查 Node.js 是否可用
echo [1/3] 检查 Node.js 环境...
where node >nul 2>nul
if errorlevel 1 (
    echo [错误] Node.js 未安装或不在 PATH 中
    echo 请从 https://nodejs.org 下载安装
    exit /b 1
)

REM 显示版本信息
for /f "delims=" %%v in ('node --version 2^>^&1') do (
    echo [信息] Node.js 版本: %%v
)

REM 调用 Node.js 脚本
echo.
echo [2/3] 调用 Node.js 脚本...
echo ----------------------------------------
echo [信息] 参数: "参数1" "参数2" "参数3"
node "%SCRIPT_DIR%\hello.js" "参数1" "参数2" "参数3"
set "NODE_EXIT_CODE=%errorlevel%"
echo ----------------------------------------

REM 检查结果
echo.
echo [3/3] 检查执行结果...
echo [信息] Node.js 退出码: %NODE_EXIT_CODE%

if %NODE_EXIT_CODE% equ 0 (
    echo [成功] Node.js 脚本执行完成
) else (
    echo [失败] Node.js 脚本执行失败
)

echo.
echo ========================================
echo   示例完成
echo ========================================

endlocal
exit /b %NODE_EXIT_CODE%
