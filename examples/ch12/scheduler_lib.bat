@echo off
chcp 65001 >nul
rem ============================================================
rem scheduler_lib.bat - 任务调度函数库
rem 本脚本提供任务调度相关的实用函数
rem 可以在其他脚本中调用这些函数
rem ============================================================

rem 安全提示
echo ============================================================
echo 任务调度函数库 - 提供可重用的调度功能
echo 注意：所有schtasks操作使用echo模拟
echo ============================================================
echo.

rem 设置库变量
set SCHEDULER_LIB_VERSION=1.0.0
set SCHEDULER_LOG_DIR=%~dp0logs
set SCHEDULER_LOCK_DIR=%~dp0locks

rem 创建必要的目录
if not exist "%SCHEDULER_LOG_DIR%" mkdir "%SCHEDULER_LOG_DIR%"
if not exist "%SCHEDULER_LOCK_DIR%" mkdir "%SCHEDULER_LOCK_DIR%"

rem 显示库信息
echo 任务调度函数库版本: %SCHEDULER_LIB_VERSION%
echo 日志目录: %SCHEDULER_LOG_DIR%
echo 锁文件目录: %SCHEDULER_LOCK_DIR%
echo.

rem 显示菜单
:menu
echo.
echo 任务调度函数库菜单
echo ==================
echo 1. 查看所有函数
echo 2. 测试创建任务函数
echo 3. 测试查询任务函数
echo 4. 测试锁机制函数
echo 5. 测试日志函数
echo 6. 测试后台执行函数
echo 7. 查看函数库代码
echo 8. 退出
echo.
set /p choice="请选择操作 (1-8): "

if "%choice%"=="1" goto show_functions
if "%choice%"=="2" goto test_create
if "%choice%"=="3" goto test_query
if "%choice%"=="4" goto test_lock
if "%choice%"=="5" goto test_log
if "%choice%"=="6" goto test_background
if "%choice%"=="7" goto show_code
if "%choice%"=="8" goto end
echo 无效选择，请重试
goto menu

:show_functions
echo.
echo === 可用函数列表 ===
echo.
echo 1. create_daily_task - 创建每日任务
echo    参数: %1=任务名称 %2=脚本路径 %3=执行时间
echo.
echo 2. create_weekly_task - 创建每周任务
echo    参数: %1=任务名称 %2=脚本路径 %3=星期几 %4=执行时间
echo.
echo 3. create_monthly_task - 创建每月任务
echo    参数: %1=任务名称 %2=脚本路径 %3=日期 %4=执行时间
echo.
echo 4. query_task - 查询任务状态
echo    参数: %1=任务名称
echo.
echo 5. task_exists - 检查任务是否存在
echo    参数: %1=任务名称
echo    返回: 0=存在 1=不存在
echo.
echo 6. acquire_lock - 获取锁文件
echo    参数: %1=锁名称
echo    返回: 0=成功 1=失败
echo.
echo 7. release_lock - 释放锁文件
echo    参数: %1=锁名称
echo.
echo 8. log_message - 记录日志消息
echo    参数: %1=消息内容
echo.
echo 9. run_background - 后台运行命令
echo    参数: %1=命令
echo.
echo 10. wait_seconds - 等待指定秒数
echo     参数: %1=秒数
echo.
pause
goto menu

:test_create
echo.
echo === 测试创建任务函数 ===
echo.

echo 测试创建每日任务...
call :create_daily_task "TestDailyTask" "C:\scripts\test.bat" "02:00"
echo.

echo 测试创建每周任务...
call :create_weekly_task "TestWeeklyTask" "C:\scripts\test.bat" "MON" "09:00"
echo.

echo 测试创建每月任务...
call :create_monthly_task "TestMonthlyTask" "C:\scripts\test.bat" "1" "10:00"
echo.

pause
goto menu

:test_query
echo.
echo === 测试查询任务函数 ===
echo.

echo 测试查询任务状态...
call :query_task "TestDailyTask"
echo.

echo 测试检查任务是否存在...
call :task_exists "TestDailyTask"
if errorlevel 1 (
    echo 任务不存在
) else (
    echo 任务存在
)
echo.

pause
goto menu

:test_lock
echo.
echo === 测试锁机制函数 ===
echo.

echo 测试获取锁文件...
call :acquire_lock "test_lock"
if errorlevel 1 (
    echo 获取锁失败
) else (
    echo 获取锁成功
    echo.
    echo 测试释放锁文件...
    call :release_lock "test_lock"
    echo 锁已释放
)
echo.

pause
goto menu

:test_log
echo.
echo === 测试日志函数 ===
echo.

echo 测试记录日志消息...
call :log_message "这是一条测试日志消息"
call :log_message "日志函数测试完成"
echo.

pause
goto menu

:test_background
echo.
echo === 测试后台执行函数 ===
echo.

echo 测试后台运行命令...
call :run_background "ping 127.0.0.1 -n 3"
echo 后台命令已启动
echo.

pause
goto menu

:show_code
echo.
echo === 函数库代码 ===
echo.
echo 以下是函数库的主要代码：
echo.
echo :create_daily_task - 创建每日任务
echo :create_weekly_task - 创建每周任务
echo :create_monthly_task - 创建每月任务
echo :query_task - 查询任务状态
echo :task_exists - 检查任务是否存在
echo :acquire_lock - 获取锁文件
echo :release_lock - 释放锁文件
echo :log_message - 记录日志消息
echo :run_background - 后台运行命令
echo :wait_seconds - 等待指定秒数
echo.
echo 详细代码请查看本文件的函数定义部分。
echo.

pause
goto menu

:end
echo.
echo 函数库演示结束。
echo.
pause
exit /b 0

rem ============================================================
rem 函数定义部分
rem ============================================================

:create_daily_task
rem 创建每日任务
rem 参数: %1=任务名称 %2=脚本路径 %3=执行时间
setlocal enabledelayedexpansion
set task_name=%~1
set script_path=%~2
set time=%~3

echo 创建每日任务: %task_name%
echo 命令: schtasks /create /tn "%task_name%" /tr "%script_path%" /sc daily /st %time%
echo 模拟创建成功
endlocal
goto :eof

:create_weekly_task
rem 创建每周任务
rem 参数: %1=任务名称 %2=脚本路径 %3=星期几 %4=执行时间
setlocal enabledelayedexpansion
set task_name=%~1
set script_path=%~2
set day=%~3
set time=%~4

echo 创建每周任务: %task_name%
echo 命令: schtasks /create /tn "%task_name%" /tr "%script_path%" /sc weekly /d %day% /st %time%
echo 模拟创建成功
endlocal
goto :eof

:create_monthly_task
rem 创建每月任务
rem 参数: %1=任务名称 %2=脚本路径 %3=日期 %4=执行时间
setlocal enabledelayedexpansion
set task_name=%~1
set script_path=%~2
set date=%~3
set time=%~4

echo 创建每月任务: %task_name%
echo 命令: schtasks /create /tn "%task_name%" /tr "%script_path%" /sc monthly /d %date% /st %time%
echo 模拟创建成功
endlocal
goto :eof

:query_task
rem 查询任务状态
rem 参数: %1=任务名称
setlocal enabledelayedexpansion
set task_name=%~1

echo 查询任务: %task_name%
echo 命令: schtasks /query /tn "%task_name%" /fo LIST /v
echo 模拟查询结果:
echo   任务名: %task_name%
echo   状态: 就绪
echo   下次运行时间: 2024/1/2 02:00:00
endlocal
goto :eof

:task_exists
rem 检查任务是否存在
rem 参数: %1=任务名称
rem 返回: 0=存在 1=不存在
setlocal enabledelayedexpansion
set task_name=%~1

echo 检查任务是否存在: %task_name%
echo 命令: schtasks /query /tn "%task_name%" ^>nul 2^>^&1
echo 模拟检查结果: 任务存在
endlocal
exit /b 0

:acquire_lock
rem 获取锁文件
rem 参数: %1=锁名称
rem 返回: 0=成功 1=失败
setlocal enabledelayedexpansion
set lock_name=%~1
set lock_file=%SCHEDULER_LOCK_DIR%\%lock_name%.lock

echo 尝试获取锁: %lock_name%
if exist "%lock_file%" (
    echo 锁文件已存在，获取失败
    endlocal
    exit /b 1
) else (
    echo %date% %time% > "%lock_file%"
    echo 锁文件创建成功
    endlocal
    exit /b 0
)

:release_lock
rem 释放锁文件
rem 参数: %1=锁名称
setlocal enabledelayedexpansion
set lock_name=%~1
set lock_file=%SCHEDULER_LOCK_DIR%\%lock_name%.lock

echo 释放锁: %lock_name%
if exist "%lock_file%" (
    del "%lock_file%"
    echo 锁文件已删除
) else (
    echo 锁文件不存在
)
endlocal
goto :eof

:log_message
rem 记录日志消息
rem 参数: %1=消息内容
setlocal enabledelayedexpansion
set message=%~1
set log_file=%SCHEDULER_LOG_DIR%\scheduler_%date:~0,4%%date:~5,2%%date:~8,2%.log

echo [%date% %time%] %message% >> "%log_file%"
echo 日志已记录: %message%
endlocal
goto :eof

:run_background
rem 后台运行命令
rem 参数: %1=命令
setlocal enabledelayedexpansion
set command=%~1

echo 后台运行命令: %command%
start /b cmd /c "%command%"
echo 命令已在后台启动
endlocal
goto :eof

:wait_seconds
rem 等待指定秒数
rem 参数: %1=秒数
setlocal enabledelayedexpansion
set seconds=%~1

echo 等待 %seconds% 秒...
timeout /t %seconds% /nobreak >nul
echo 等待完成
endlocal
goto :eof