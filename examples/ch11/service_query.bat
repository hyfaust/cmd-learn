@echo off
chcp 65001 >nul
REM ============================================================
REM 文件名: service_query.bat
REM 功能: 演示服务状态查询的各种方法
REM 作者: CMD教程系列
REM 日期: 2026-06-11
REM
REM 安全提示：
REM   本脚本仅执行查询操作，不会启停任何服务
REM ============================================================

setlocal enabledelayedexpansion

echo ========================================
echo    服务状态查询演示
echo ========================================
echo.

REM 第一部分：查询所有服务
echo [1] 查询所有服务（仅显示前20个）
echo ----------------------------------------
set count=0
for /f "tokens=2 delims==" %%a in ('sc query state^= all ^| findstr "SERVICE_NAME"') do (
    if !count! lss 20 (
        echo %%a
        set /a count+=1
    )
)
echo ... 省略其他服务
echo.

pause

REM 第二部分：查询特定服务详细信息
echo [2] 查询特定服务 - Windows Update (wuauserv)
echo ----------------------------------------
sc query wuauserv
echo.

pause

REM 第三部分：查询运行中的服务
echo [3] 查询所有运行中的服务
echo ----------------------------------------
sc query state= active type= service | findstr "SERVICE_NAME"
echo.

pause

REM 第四部分：查询已停止的服务
echo [4] 查询已停止的服务（显示前10个）
echo ----------------------------------------
set count=0
for /f "tokens=2 delims==" %%a in ('sc query state^= inactive type^= service ^| findstr "SERVICE_NAME"') do (
    if !count! lss 10 (
        echo %%a
        set /a count+=1
    )
)
echo.
echo ... 省略其他服务
echo.

pause

REM 第五部分：提取服务状态
echo [5] 提取服务状态信息
echo ----------------------------------------
echo 服务: wuauserv (Windows Update)
for /f "tokens=3 delims=:" %%a in ('sc query wuauserv ^| findstr "STATE"') do (
    set state=%%a
    REM 移除前导空格
    set state=!state: =!
    echo 状态: !state!
)
echo.

pause

REM 第六部分：批量检查关键服务状态
echo [6] 关键服务状态检查
echo ----------------------------------------
echo.

set "services=wuauserv Spooler Dhcp Dnscache WinDefend wscsvc"

for %%s in (%services%) do (
    REM 获取服务显示名称
    set "display_name="
    for /f "tokens=2 delims==" %%d in ('sc qc %%s 2^>nul ^| findstr "DISPLAY_NAME"') do (
        set "display_name=%%d"
    )
    
    REM 获取服务状态
    set "status=未知"
    for /f "tokens=3 delims=:" %%a in ('sc query %%s 2^>nul ^| findstr "STATE"') do (
        set "status=%%a"
    )
    
    REM 格式化输出
    if defined display_name (
        echo 服务: %%s
        echo   显示名称: !display_name!
        echo   状态: !status: =!
        echo.
    )
)

pause

REM 第七部分：检查服务启动类型
echo [7] 服务启动类型检查
echo ----------------------------------------
echo.

REM 检查关键服务的启动类型
set "services=wuauserv Spooler Dhcp Dnscache"

for %%s in (%services%) do (
    echo 服务: %%s
    for /f "tokens=3 delims=:" %%a in ('sc qc %%s 2^>nul ^| findstr "START_TYPE"') do (
        set start_type=%%a
        echo   启动类型: !start_type: =!
    )
    echo.
)

pause

REM 第八部分：使用 net 命令查询
echo [8] 使用 net start 查看运行的服务
echo ----------------------------------------
net start
echo.

pause

REM 第九部分：服务依赖关系查询
echo [9] 服务依赖关系查询
echo ----------------------------------------
echo 查询 wuauserv 的依赖服务:
sc enumdepend wuauserv
echo.

pause

REM 第十部分：生成服务状态报告
echo [10] 生成服务状态报告
echo ----------------------------------------

set "report_file=%~dp0service_report.txt"

echo 服务状态报告 > %report_file%
echo 生成时间: %date% %time% >> %report_file%
echo ======================================== >> %report_file%
echo. >> %report_file%

REM 写入关键服务状态
set "services=wuauserv Spooler Dhcp Dnscache WinDefend"

for %%s in (%services%) do (
    for /f "tokens=3 delims=:" %%a in ('sc query %%s 2^>nul ^| findstr "STATE"') do (
        set status=%%a
        echo %%s: !status: =! >> %report_file%
    )
)

echo. >> %report_file%
echo 报告已保存到: %report_file%

REM 显示报告内容
echo.
echo 报告内容:
type %report_file%

echo.
echo ========================================
echo    演示完成
echo ========================================
echo.
echo 关键要点:
echo   1. sc query 查询服务状态
echo   2. sc qc 查询服务配置
echo   3. 注意 state= 后面的空格
echo   4. 可以结合 for 循环批量处理
echo.
pause
