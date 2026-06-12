@echo off
chcp 65001 >nul
rem ============================================================
rem background.bat - 后台执行演示
rem 本脚本演示如何在批处理中实现后台执行技术
rem 包括start /b、start /min和后台进程管理
rem ============================================================

rem 安全提示
echo ============================================================
echo 本脚本演示后台执行技术
echo 部分演示会实际启动后台进程，请注意管理
echo ============================================================
echo.

rem 设置变量
set LOG_FILE=%~dp0background.log
set DEMO_DIR=%~dp0demo_output

rem 创建演示目录
if not exist "%DEMO_DIR%" mkdir "%DEMO_DIR%"

rem 开始日志
echo [%date% %time%] 开始后台执行演示 >> "%LOG_FILE%"
echo 开始后台执行演示
echo.

rem 显示菜单
:menu
echo.
echo 后台执行演示菜单
echo ==================
echo 1. start /b 后台启动演示
echo 2. start /min 最小化启动演示
echo 3. 后台进程管理演示
echo 4. 后台执行实际任务
echo 5. 清理后台进程
echo 6. 退出
echo.
set /p choice="请选择操作 (1-6): "

if "%choice%"=="1" goto start_b_demo
if "%choice%"=="2" goto start_min_demo
if "%choice%"=="3" goto manage_demo
if "%choice%"=="4" goto background_task
if "%choice%"=="5" goto cleanup
if "%choice%"=="6" goto end
echo 无效选择，请重试
goto menu

:start_b_demo
echo.
echo === start /b 后台启动演示 ===
echo.
echo start /b 命令在后台启动程序，不打开新窗口
echo.

echo 示例1: 后台运行ping命令
echo 命令: start /b ping 127.0.0.1 -n 10 ^> "%DEMO_DIR%\ping_output.txt"
echo.
echo 实际执行...
start /b ping 127.0.0.1 -n 10 > "%DEMO_DIR%\ping_output.txt"
echo 程序已在后台启动，继续执行其他命令...
echo.

echo 示例2: 后台运行计算器
echo 命令: start /b calc.exe
echo.
echo 注意: 实际运行会启动计算器程序
echo.

echo 示例3: 后台运行脚本
echo 命令: start /b cmd /c "echo Hello from background ^> "%DEMO_DIR%\bg_script.txt""
echo.
echo 实际执行...
start /b cmd /c "echo Hello from background > "%DEMO_DIR%\bg_script.txt""
echo 后台脚本已启动
echo.

pause
goto menu

:start_min_demo
echo.
echo === start /min 最小化启动演示 ===
echo.
echo start /min 命令以最小化窗口启动程序
echo.

echo 示例1: 最小化启动记事本
echo 命令: start /min notepad.exe
echo.
echo 注意: 实际运行会启动最小化的记事本
echo.

echo 示例2: 最小化启动命令提示符
echo 命令: start /min cmd /c "echo Hello from minimized window"
echo.

echo 示例3: 最小化启动脚本
echo 命令: start /min cmd /c "%~dp0background_worker.bat"
echo.

pause
goto menu

:manage_demo
echo.
echo === 后台进程管理演示 ===
echo.
echo 查看后台进程:
echo   tasklist /fi "imagename eq cmd.exe"
echo.
echo 查看特定进程:
echo   tasklist /fi "imagename eq ping.exe"
echo.
echo 终止后台进程:
echo   taskkill /f /im ping.exe
echo.
echo 按PID终止进程:
echo   taskkill /f /pid 1234
echo.

echo 实际演示: 查看当前cmd进程
echo 命令: tasklist /fi "imagename eq cmd.exe"
echo.
tasklist /fi "imagename eq cmd.exe"
echo.

pause
goto menu

:background_task
echo.
echo === 后台执行实际任务 ===
echo.
echo 演示: 后台执行长时间任务
echo.

echo 创建后台任务脚本...
echo @echo off > "%DEMO_DIR%\background_worker.bat"
echo echo 后台任务开始... >> "%DEMO_DIR%\background_worker.bat"
echo ping 127.0.0.1 -n 5 ^>nul >> "%DEMO_DIR%\background_worker.bat"
echo echo 后台任务完成！ ^> "%DEMO_DIR%\task_result.txt" >> "%DEMO_DIR%\background_worker.bat"

echo 启动后台任务...
start /b cmd /c "%DEMO_DIR%\background_worker.bat"

echo 主线程继续执行...
echo 正在处理其他任务...
ping 127.0.0.1 -n 3 >nul
echo 其他任务完成。

echo 检查后台任务结果...
if exist "%DEMO_DIR%\task_result.txt" (
    echo 后台任务已完成！
    type "%DEMO_DIR%\task_result.txt"
) else (
    echo 后台任务仍在执行...
)

pause
goto menu

:cleanup
echo.
echo === 清理后台进程 ===
echo.
echo 清理演示中启动的后台进程...
echo.

echo 1. 终止ping进程...
taskkill /f /im ping.exe 2>nul
if errorlevel 1 (
    echo 没有找到ping进程
) else (
    echo ping进程已终止
)

echo.
echo 2. 清理演示文件...
if exist "%DEMO_DIR%" (
    rd /s /q "%DEMO_DIR%"
    echo 演示目录已删除
)

echo.
echo 清理完成。

pause
goto menu

:end
echo.
echo === 后台执行最佳实践 ===
echo.
echo 1. 使用锁文件防止重复运行
echo    - 创建临时锁文件
echo    - 任务开始时检查锁文件
echo    - 任务结束时删除锁文件
echo.
echo 2. 记录后台任务日志
echo    - 记录开始和结束时间
echo    - 记录执行结果
echo    - 记录错误信息
echo.
echo 3. 使用任务计划程序
echo    - 对于定期任务，使用schtasks
echo    - 更可靠的后台执行
echo    - 支持错误处理和重试
echo.
echo 4. 监控后台进程
echo    - 定期检查进程状态
echo    - 设置超时机制
echo    - 处理异常退出
echo.

rem 结束日志
echo [%date% %time%] 后台执行演示完成 >> "%LOG_FILE%"
echo.
echo 演示结束。
echo.
pause