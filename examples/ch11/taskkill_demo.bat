@echo off
chcp 65001 >nul
REM ============================================================
REM 文件名: taskkill_demo.bat
REM 功能: 演示 taskkill 命令的安全使用方法
REM 作者: CMD教程系列
REM 日期: 2026-06-11
REM
REM 安全提示：
REM   1. 本脚本仅演示安全的进程终止方法
REM   2. 不会终止任何系统关键进程
REM   3. 使用前请确保了解进程的作用
REM ============================================================

setlocal enabledelayedexpansion

echo ========================================
echo    taskkill 命令安全演示
echo ========================================
echo.

REM 安全检查：显示警告信息
echo [安全提示]
echo 本脚本将演示安全的进程终止方法。
echo 不会自动终止任何重要进程。
echo.
pause

REM 第一部分：检查进程是否存在
echo [1] 检查记事本进程是否存在
echo ----------------------------------------
tasklist /fi "imagename eq notepad.exe" | find "notepad.exe" >nul
if %errorlevel% equ 0 (
    echo [结果] 记事本正在运行
) else (
    echo [结果] 记事本未运行
)
echo.

pause

REM 第二部分：模拟终止操作（仅显示命令，不执行）
echo [2] 模拟终止进程命令（不实际执行）
echo ----------------------------------------
echo.
echo 将要执行的命令:
echo   taskkill /im notepad.exe
echo.
echo 这将终止所有记事本进程
echo.

pause

REM 第三部分：安全终止流程演示
echo [3] 安全终止流程演示
echo ----------------------------------------
echo.

REM 设置目标进程
set "target_process=calc.exe"

echo 目标进程: %target_process%
echo.

REM 步骤1：检查进程是否存在
echo 步骤1: 检查进程是否存在...
tasklist /fi "imagename eq %target_process%" | find "%target_process%" >nul
if %errorlevel% neq 0 (
    echo [跳过] %target_process% 未运行，无需终止
    goto demo_continue
)

REM 步骤2：获取进程PID
echo 步骤2: 获取进程PID...
for /f "tokens=2" %%p in ('tasklist /fi "imagename eq %target_process%" ^| findstr "%target_process%"') do (
    set pid=%%p
    echo [信息] 找到PID: !pid!
)

REM 步骤3：尝试正常终止（仅显示）
echo 步骤3: 尝试正常终止...
echo [模拟] 执行: taskkill /im %target_process%
echo [模拟] 等待2秒检查结果...

REM 步骤4：如果需要，强制终止（仅显示）
echo 步骤4: 如果进程未响应...
echo [模拟] 执行: taskkill /im %target_process% /f

:demo_continue
echo.

pause

REM 第四部分：使用PID终止进程的演示
echo [4] 使用PID终止进程的演示
echo ----------------------------------------
echo.
echo 使用PID终止进程更精确，避免误杀同名进程。
echo.
echo 示例命令:
echo   taskkill /pid 1234
echo   taskkill /pid 1234 /f        (强制终止)
echo   taskkill /pid 1234 /t        (终止进程树)
echo   taskkill /pid 1234 /f /t     (强制终止进程树)
echo.

pause

REM 第五部分：终止进程树的演示
echo [5] 终止进程树的演示
echo ----------------------------------------
echo.
echo 进程树示例:
echo   services.exe
echo     ├── svchost.exe (PID: 1000)
echo     │   ├── 子进程1 (PID: 1001)
echo     │   └── 子进程2 (PID: 1002)
echo     └── svchost.exe (PID: 2000)
echo.
echo 使用 /t 参数会终止指定进程及其所有子进程
echo.
echo 示例: taskkill /pid 1000 /t
echo 将终止 svchost.exe (PID:1000) 及其子进程 1001, 1002
echo.

pause

REM 第六部分：批量终止同名进程
echo [6] 批量终止同名进程的演示
echo ----------------------------------------
echo.
echo 如果有多个同名进程：
echo.
tasklist /fi "imagename eq svchost.exe" /fo TABLE | findstr "svchost"
echo.
echo 使用 taskkill /im svchost.exe 会终止所有同名进程！
echo 建议使用PID精确控制。
echo.

pause

REM 第七部分：错误处理演示
echo [7] 错误处理最佳实践
echo ----------------------------------------
echo.
echo 推荐的错误处理模式:
echo.
echo   REM 检查进程是否存在
echo   tasklist /fi "imagename eq target.exe" ^| find "target.exe" ^>nul
echo   if %%errorlevel%% neq 0 (
echo       echo 进程不存在
echo       exit /b 1
echo   ^)
echo.
echo   REM 尝试终止
echo   taskkill /im target.exe ^>nul 2^>^&1
echo   if %%errorlevel%% neq 0 (
echo       echo 终止失败，尝试强制终止
echo       taskkill /im target.exe /f
echo   ^)
echo.

pause

REM 第八部分：安全检查函数
echo [8] 封装的安全终止函数
echo ----------------------------------------
echo.
echo 可以将终止逻辑封装成函数:
echo.
echo   :safe_kill
echo   set "proc_name=%%~1"
echo   tasklist /fi "imagename eq !proc_name!" ^| find "!proc_name!" ^>nul
echo   if %%errorlevel%% neq 0 (
echo       echo 进程 !proc_name! 不存在
echo       exit /b 1
echo   ^)
echo   taskkill /im !proc_name!
echo   exit /b 0
echo.

echo ========================================
echo    演示完成
echo ========================================
echo.
echo 关键要点:
echo   1. 终止前先检查进程是否存在
echo   2. 优先使用正常终止（不带 /f）
echo   3. 使用PID精确控制，避免误杀
echo   4. 谨慎使用 /t 参数终止进程树
echo   5. 添加错误处理逻辑
echo.
pause
