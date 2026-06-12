@echo off
chcp 65001 >nul
rem ============================================================
rem schtasks_demo.bat - schtasks命令基本操作演示
rem 本脚本演示schtasks命令的常用操作，使用echo模拟实际命令
rem 注意：不会实际创建系统级计划任务
rem ============================================================

rem 安全提示
echo ============================================================
echo 安全提示：本脚本使用echo模拟schtasks命令，不会实际执行
echo 在生产环境中使用schtasks需要管理员权限
echo ============================================================
echo.

rem 显示菜单
:menu
echo.
echo schtasks命令演示菜单
echo ====================
echo 1. 创建计划任务演示
echo 2. 查询计划任务演示
echo 3. 立即运行任务演示
echo 4. 修改任务演示
echo 5. 删除任务演示
echo 6. 查看触发器类型
echo 7. 退出
echo.
set /p choice="请选择操作 (1-7): "

if "%choice%"=="1" goto create_demo
if "%choice%"=="2" goto query_demo
if "%choice%"=="3" goto run_demo
if "%choice%"=="4" goto change_demo
if "%choice%"=="5" goto delete_demo
if "%choice%"=="6" goto trigger_types
if "%choice%"=="7" goto end
echo 无效选择，请重试
goto menu

:create_demo
echo.
echo === 创建计划任务演示 ===
echo.
echo 1. 创建每日任务：
echo schtasks /create /tn "DailyBackup" /tr "C:\scripts\backup.bat" /sc daily /st 02:00
echo.
echo 2. 创建每周任务：
echo schtasks /create /tn "WeeklyReport" /tr "C:\scripts\report.bat" /sc weekly /d MON /st 09:00
echo.
echo 3. 创建启动时任务：
echo schtasks /create /tn "StartupCheck" /tr "C:\scripts\check.bat" /sc onstart
echo.
echo 4. 创建登录时任务：
echo schtasks /create /tn "LoginScript" /tr "C:\scripts\login.bat" /sc onlogon
echo.
pause
goto menu

:query_demo
echo.
echo === 查询计划任务演示 ===
echo.
echo 1. 查询所有任务（表格格式）：
echo schtasks /query /fo TABLE
echo.
echo 2. 查询特定任务详细信息：
echo schtasks /query /tn "DailyBackup" /fo LIST /v
echo.
echo 3. 查询任务（CSV格式）：
echo schtasks /query /fo CSV /nh
echo.
pause
goto menu

:run_demo
echo.
echo === 立即运行任务演示 ===
echo.
echo 1. 立即运行备份任务：
echo schtasks /run /tn "DailyBackup"
echo.
echo 2. 立即运行报告任务：
echo schtasks /run /tn "WeeklyReport"
echo.
pause
goto menu

:change_demo
echo.
echo === 修改任务演示 ===
echo.
echo 1. 修改任务执行时间：
echo schtasks /change /tn "DailyBackup" /st 03:00
echo.
echo 2. 修改任务执行命令：
echo schtasks /change /tn "DailyBackup" /tr "C:\scripts\new_backup.bat"
echo.
pause
goto menu

:delete_demo
echo.
echo === 删除任务演示 ===
echo.
echo 1. 删除任务（带确认）：
echo schtasks /delete /tn "DailyBackup"
echo.
echo 2. 强制删除任务（无确认）：
echo schtasks /delete /tn "DailyBackup" /f
echo.
pause
goto menu

:trigger_types
echo.
echo === 触发器类型详解 ===
echo.
echo 1. 一次执行 (once)：
echo    schtasks /create /tn "OneTimeTask" /tr "script.bat" /sc once /st 14:00
echo.
echo 2. 每日执行 (daily)：
echo    schtasks /create /tn "DailyTask" /tr "script.bat" /sc daily /st 02:00
echo.
echo 3. 每周执行 (weekly)：
echo    schtasks /create /tn "WeeklyTask" /tr "script.bat" /sc weekly /d MON,FRI /st 09:00
echo.
echo 4. 每月执行 (monthly)：
echo    schtasks /create /tn "MonthlyTask" /tr "script.bat" /sc monthly /d 1,15 /st 10:00
echo.
echo 5. 启动时执行 (onstart)：
echo    schtasks /create /tn "StartupTask" /tr "script.bat" /sc onstart
echo.
echo 6. 登录时执行 (onlogon)：
echo    schtasks /create /tn "LogonTask" /tr "script.bat" /sc onlogon
echo.
echo 7. 空闲时执行 (onidle)：
echo    schtasks /create /tn "IdleTask" /tr "script.bat" /sc onidle /i 10
echo.
pause
goto menu

:end
echo.
echo 演示结束。
echo 实际使用schtasks时，请确保：
echo 1. 以管理员身份运行
echo 2. 使用正确的路径和参数
echo 3. 仔细测试任务
echo.
pause