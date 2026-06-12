@echo off
REM ============================================================
REM call_lua.bat - 调用 LuaJIT 脚本示例
REM
REM 功能: 演示如何从 CMD 调用 LuaJIT 脚本
REM 安全提示: 仅在项目目录内操作
REM ============================================================

chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ========================================
echo   CMD 调用 LuaJIT 脚本示例
echo ========================================
echo.

set "SCRIPT_DIR=%~dp0scripts"

REM 检查 LuaJIT 是否可用
echo [1/3] 检查 LuaJIT 环境...
where luajit >nul 2>nul
if errorlevel 1 (
    echo [警告] LuaJIT 未找到，尝试使用 Lua...
    where lua >nul 2>nul
    if errorlevel 1 (
        echo [错误] LuaJIT 或 Lua 未安装
        echo 请从 https://luajit.org 下载 LuaJIT
        exit /b 1
    )
    set "LUA_CMD=lua"
) else (
    set "LUA_CMD=luajit"
)
echo [信息] 使用: %LUA_CMD%

REM 调用 Lua 脚本
echo.
echo [2/3] 调用 Lua 脚本...
echo ----------------------------------------
echo [信息] 参数: "CMD参数1" "CMD参数2" "CMD参数3"
%LUA_CMD% "%SCRIPT_DIR%\hello.lua" "CMD参数1" "CMD参数2" "CMD参数3"
set "LUA_EXIT_CODE=%errorlevel%"
echo ----------------------------------------

REM 检查结果
echo.
echo [3/3] 检查执行结果...
echo [信息] Lua 退出码: %LUA_EXIT_CODE%

if %LUA_EXIT_CODE% equ 0 (
    echo [成功] Lua 脚本执行完成
) else (
    echo [失败] Lua 脚本执行失败
)

echo.
echo ========================================
echo   示例完成
echo ========================================

endlocal
exit /b %LUA_EXIT_CODE%
