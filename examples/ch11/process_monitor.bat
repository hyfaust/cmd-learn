@echo off
chcp 65001 >nul
REM ============================================================
REM 文件名: process_monitor.bat
REM 功能: 进程监控脚本 - 持续监控指定进程
REM 作者: CMD教程系列
REM 日期: 2026-06-11
REM
REM 用法: process_monitor.bat [进程名] [检查间隔秒数]
REM 示例: process_monitor.bat notepad.exe 10
REM ============================================================

setlocal enabledelayedexpansion

REM 默认参数
set "target_process=%~1"
set "check_interval=%~2"

REM 如果未指定参数，使用默认值
if "%target_process%"=="" set "target_process=notepad.exe"
if "%check_interval%"=="" set "check_interval=5"

echo ========================================
echo    进程监控工具
echo ========================================
echo.
echo 监控目标: %target_process%
echo 检查间隔: %check_interval% 秒
echo 按 Ctrl+C 停止监控
echo.

REM 创建日志文件
set "log_file=%~dp0process_monitor.log"
echo [%date% %time%] 开始监控进程: %target_process% >> "%log_file%"

REM 初始化计数器
set check_count=0
set not_found_count=0
set last_status=unknown

:monitor_loop
REM 递增检查次数
set /a check_count+=1

REM 获取当前时间
set "current_time=%time:~0,8%"

REM 检查进程是否存在
set "process_found=0"
for /f "tokens=2" %%p in ('tasklist /fi "imagename eq %target_process%" 2^>nul ^| findstr "%target_process%"') do (
    set "process_found=1"
    set "process_pid=%%p"
)

REM 处理检查结果
if %process_found% equ 1 (
    REM 进程存在
    if "%last_status%" neq "running" (
        echo [%current_time%] [√] %target_process% 正在运行 (PID: %process_pid%)
        echo [%date% %time%] 进程状态: 运行中 (PID: %process_pid%) >> "%log_file%"
        set "last_status=running"
    )
    
    REM 获取内存使用
    for /f "tokens=5" %%m in ('tasklist /fi "imagename eq %target_process%" ^| findstr "%target_process%"') do (
        set "mem_usage=%%m"
    )
    
    REM 静默模式下减少输出
    if %check_count% gtr 10 (
        if %check_count% lss 20 (
            echo [%current_time%] 状态: 运行中 ^| 内存: %mem_usage% KB ^| 检查次数: %check_count%
        )
    )
    
    REM 每50次检查显示一次详细信息
    set /a mod_result=check_count%%50
    if !mod_result! equ 0 (
        echo.
        echo [%current_time%] === 定期报告 ===
        echo   进程: %target_process%
        echo   PID: %process_pid%
        echo   内存使用: %mem_usage% KB
        echo   检查次数: %check_count%
        echo   连续未发现次数: %not_found_count%
        echo.
    )
    
    set "not_found_count=0"
) else (
    REM 进程不存在
    set /a not_found_count+=1
    
    if "%last_status%" neq "stopped" (
        echo [%current_time%] [×] %target_process% 未运行
        echo [%date% %time%] 进程状态: 未运行 >> "%log_file%"
        set "last_status=stopped"
    )
    
    REM 连续3次未发现，显示警告
    if %not_found_count% geq 3 (
        echo [%current_time%] [!] 警告: %target_process% 已连续 %not_found_count% 次未检测到
        echo [%date% %time%] 警告: 连续 %not_found_count% 次未检测到进程 >> "%log_file%"
    )
    
    REM 每10次未发现，记录日志
    set /a mod_result=not_found_count%%10
    if !mod_result! equ 0 (
        echo [%date% %time%] 进程已连续 %not_found_count% 次未检测到 >> "%log_file%"
    )
)

REM 等待指定间隔
timeout /t %check_interval% >nul

REM 继续监控
goto monitor_loop
