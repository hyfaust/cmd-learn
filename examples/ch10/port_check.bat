@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: port_check.bat - 端口检测演示
:: 功能：演示多种端口检测方法
:: 安全提示：仅检测本地或公开测试服务的端口
:: ============================================================

echo ========================================
echo       端口检测演示
echo ========================================
echo.

:: 1. 使用netstat查看本地端口
echo [1] 使用netstat查看本地端口状态
echo ----------------------------------------
echo 显示所有监听端口...
echo.

netstat -an | findstr "LISTENING"
echo.

:: 2. 检测特定端口（使用PowerShell）
echo [2] 使用PowerShell检测特定端口
echo ----------------------------------------
echo 检测常见端口状态...
echo.

echo 检测本地80端口（HTTP）...
powershell -Command "Test-NetConnection -ComputerName localhost -Port 80 -WarningAction SilentlyContinue" | findstr "TcpTestSucceeded"
echo.

echo 检测本地443端口（HTTPS）...
powershell -Command "Test-NetConnection -ComputerName localhost -Port 443 -WarningAction SilentlyContinue" | findstr "TcpTestSucceeded"
echo.

echo 检测本地3389端口（RDP）...
powershell -Command "Test-NetConnection -ComputerName localhost -Port 3389 -WarningAction SilentlyContinue" | findstr "TcpTestSucceeded"
echo.

:: 3. 使用curl检测HTTP端口
echo [3] 使用curl检测HTTP端口
echo ----------------------------------------
echo 检测远程HTTP端口...
echo.

echo 检测example.com的80端口...
curl -s --connect-timeout 3 -I http://example.com:80 >nul 2>&1
if errorlevel 1 (
    echo   端口80：关闭或不可达
) else (
    echo   端口80：开放
)
echo.

echo 检测example.com的443端口...
curl -s --connect-timeout 3 -I https://example.com:443 >nul 2>&1
if errorlevel 1 (
    echo   端口443：关闭或不可达
) else (
    echo   端口443：开放
)
echo.

:: 4. 批量检测端口
echo [4] 批量检测端口
echo ----------------------------------------
echo 批量检测本地常见端口...
echo.

set "ports=80 443 3306 8080 3389"
set "open_count=0"
set "closed_count=0"

for %%p in (%ports%) do (
    echo 检测端口 %%p...
    netstat -an | findstr ":%%p " | findstr "LISTENING" >nul
    if errorlevel 1 (
        echo   端口 %%p：关闭
        set /a closed_count+=1
    ) else (
        echo   端口 %%p：开放
        set /a open_count+=1
    )
)

echo.
echo 统计结果：
echo   开放端口：!open_count!
echo   关闭端口：!closed_count!
echo.

:: 5. 检测远程服务器端口
echo [5] 检测远程服务器端口
echo ----------------------------------------
echo 检测公开测试服务器端口...
echo.

echo 检测Google DNS (8.8.8.8) 的53端口...
powershell -Command "Test-NetConnection -ComputerName 8.8.8.8 -Port 53 -WarningAction SilentlyContinue" | findstr "TcpTestSucceeded"
echo.

echo 检测Cloudflare DNS (1.1.1.1) 的53端口...
powershell -Command "Test-NetConnection -ComputerName 1.1.1.1 -Port 53 -WarningAction SilentlyContinue" | findstr "TcpTestSucceeded"
echo.

:: 6. 使用telnet检测端口（如果可用）
echo [6] 使用telnet检测端口
echo ----------------------------------------
echo 注意：telnet客户端可能未安装
echo.

:: 检查telnet是否可用
telnet /? >nul 2>&1
if errorlevel 1 (
    echo telnet客户端未安装
    echo 安装命令：dism /online /Enable-Feature /FeatureName:TelnetClient
) else (
    echo 检测example.com的80端口...
    echo 注意：telnet连接后需要手动退出
    echo 建议使用PowerShell Test-NetConnection替代
)
echo.

:: 7. 端口扫描脚本
echo [7] 端口扫描脚本
echo ----------------------------------------
echo 扫描本地端口范围（80-85）...
echo.

set "start_port=80"
set "end_port=85"
set "open_ports="

for /l %%p in (%start_port%,1,%end_port%) do (
    netstat -an | findstr ":%%p " | findstr "LISTENING" >nul
    if not errorlevel 1 (
        echo   端口 %%p：开放
        set "open_ports=!open_ports! %%p"
    )
)

if defined open_ports (
    echo.
    echo 开放的端口：!open_ports!
) else (
    echo.
    echo 在指定范围内未发现开放端口
)
echo.

:: 8. 显示端口详细信息
echo [8] 显示端口详细信息
echo ----------------------------------------
echo 显示所有连接的详细信息...
echo.

echo TCP连接统计：
netstat -s | findstr /A "TCP"
echo.

echo UDP连接统计：
netstat -s | findstr /A "UDP"
echo.

:: 9. 持续监控端口
echo [9] 持续监控端口（示例）
echo ----------------------------------------
echo 监控本地80端口（按Ctrl+C停止）...
echo.

echo 监控命令：netstat -ano 5 ^| findstr ":80 "
echo 注意：此命令会持续运行，显示80端口的所有活动
echo.

:: 10. 端口检测报告
echo [10] 端口检测报告
echo ----------------------------------------
echo 生成端口检测报告...
echo.

set "report_file=port_report.txt"
echo 端口检测报告 > %report_file%
echo 生成时间：%date% %time% >> %report_file%
echo ======================================== >> %report_file%
echo. >> %report_file%

echo 本地监听端口： >> %report_file%
netstat -an | findstr "LISTENING" >> %report_file%
echo. >> %report_file%

echo 常见端口状态： >> %report_file%
for %%p in (80 443 3306 8080 3389) do (
    netstat -an | findstr ":%%p " | findstr "LISTENING" >nul
    if errorlevel 1 (
        echo   端口 %%p：关闭 >> %report_file%
    ) else (
        echo   端口 %%p：开放 >> %report_file%
    )
)

echo.
echo 报告已保存到：%report_file%
echo.

echo ========================================
echo 演示完成
echo ========================================

pause