@echo off
:: ============================================================
:: 系统信息收集器 - 项目1
:: 功能：收集系统信息并生成HTML报告
:: 用法：sysinfo_collector.bat [输出目录]
:: 安全约束：仅收集信息，不修改系统
:: ============================================================

chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 初始化变量
set "SCRIPT_DIR=%~dp0"
set "OUTPUT_DIR=%~1"
if "%OUTPUT_DIR%"=="" set "OUTPUT_DIR=%SCRIPT_DIR%output"
set "REPORT_FILE=%OUTPUT_DIR%\sysinfo_report.html"
set "LOG_FILE=%OUTPUT_DIR%\collector.log"

:: 创建输出目录
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
    echo [INFO] 创建输出目录: %OUTPUT_DIR%
)

:: 初始化日志
echo [%DATE% %TIME%] 开始收集系统信息 > "%LOG_FILE%"

:: 显示欢迎信息
echo ============================================================
echo                    系统信息收集器
echo ============================================================
echo 正在收集系统信息，请稍候...
echo.

:: 1. 收集操作系统信息
echo [1/6] 收集操作系统信息...
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value 2^>nul') do set "OS_NAME=%%a"
for /f "tokens=2 delims==" %%a in ('wmic os get Version /value 2^>nul') do set "OS_VERSION=%%a"
for /f "tokens=2 delims==" %%a in ('wmic os get BuildNumber /value 2^>nul') do set "OS_BUILD=%%a"
for /f "tokens=2 delims==" %%a in ('wmic os get OSArchitecture /value 2^>nul') do set "OS_ARCH=%%a"
for /f "tokens=2 delims==" %%a in ('wmic os get InstallDate /value 2^>nul') do set "OS_INSTALL_DATE=%%a"
for /f "tokens=2 delims==" %%a in ('wmic os get LastBootUpTime /value 2^>nul') do set "OS_LAST_BOOT=%%a"

:: 2. 收集CPU信息
echo [2/6] 收集CPU信息...
for /f "tokens=2 delims==" %%a in ('wmic cpu get Name /value 2^>nul') do set "CPU_NAME=%%a"
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value 2^>nul') do set "CPU_CORES=%%a"
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfLogicalProcessors /value 2^>nul') do set "CPU_THREADS=%%a"
for /f "tokens=2 delims==" %%a in ('wmic cpu get MaxClockSpeed /value 2^>nul') do set "CPU_SPEED=%%a"

:: 3. 收集内存信息
echo [3/6] 收集内存信息...
for /f "tokens=2 delims==" %%a in ('wmic memorychip get Capacity /value 2^>nul') do (
    set "MEM_CAPACITY=%%a"
    set /a "MEM_TOTAL_MB+=!MEM_CAPACITY! / 1048576"
)
for /f "tokens=2 delims==" %%a in ('wmic memorychip get Speed /value 2^>nul') do set "MEM_SPEED=%%a"
for /f "tokens=2 delims==" %%a in ('wmic memorychip get Manufacturer /value 2^>nul') do set "MEM_MANUFACTURER=%%a"

:: 4. 收集磁盘信息
echo [4/6] 收集磁盘信息...
set "DISK_INFO="
for /f "tokens=*" %%a in ('wmic diskdrive get Model^,Size^,MediaType /value 2^>nul') do (
    set "DISK_INFO=!DISK_INFO!%%a\n"
)

:: 5. 收集网络信息
echo [5/6] 收集网络信息...
for /f "tokens=2 delims==" %%a in ('wmic nicconfig where "IPEnabled=true" get IPAddress /value 2^>nul') do set "IP_ADDRESS=%%a"
for /f "tokens=2 delims==" %%a in ('wmic nicconfig where "IPEnabled=true" get MACAddress /value 2^>nul') do set "MAC_ADDRESS=%%a"
for /f "tokens=2 delims==" %%a in ('wmic nicconfig where "IPEnabled=true" get DHCPEnabled /value 2^>nul') do set "DHCP_ENABLED=%%a"

:: 6. 收集系统运行时间
echo [6/6] 收集系统运行时间...
for /f "tokens=1" %%a in ('wmic os get LastBootUpTime /value 2^>nul') do (
    set "BOOT_TIME_RAW=%%a"
)
set "BOOT_TIME_RAW=%BOOT_TIME_RAW:~14,8%"
set "CURRENT_TIME=%TIME:~0,8%"
set /a "BOOT_HOUR=!BOOT_TIME_RAW:~0,2!"
set /a "BOOT_MIN=!BOOT_TIME_RAW:~3,2!"
set /a "CURRENT_HOUR=!CURRENT_TIME:~0,2!"
set /a "CURRENT_MIN=!CURRENT_TIME:~3,2!"
set /a "UPTIME_HOURS=!CURRENT_HOUR! - !BOOT_HOUR!"
set /a "UPTIME_MINS=!CURRENT_MIN! - !BOOT_MIN!"
if !UPTIME_MINS! lss 0 (
    set /a "UPTIME_HOURS-=1"
    set /a "UPTIME_MINS+=60"
)

:: 生成HTML报告
echo [INFO] 生成HTML报告...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="zh-CN"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<title^>系统信息报告^</title^>
echo     ^<style^>
echo         body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
echo         .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
echo         h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
echo         h2 { color: #34495e; margin-top: 30px; }
echo         table { width: 100%%; border-collapse: collapse; margin: 10px 0; }
echo         th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
echo         th { background-color: #3498db; color: white; }
echo         tr:hover { background-color: #f5f5f5; }
echo         .info-box { background-color: #e8f4fc; border-left: 4px solid #3498db; padding: 15px; margin: 15px 0; }
echo         .warning { background-color: #fff3cd; border-left: 4px solid #ffc107; }
echo         .timestamp { color: #666; font-size: 0.9em; text-align: right; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<h1^>系统信息报告^</h1^>
echo         ^<p class="timestamp"^>生成时间: %DATE% %TIME%^</p^>
echo.
echo         ^<h2^>操作系统信息^</h2^>
echo         ^<table^>
echo             ^<tr^>^<th^>项目^</th^>^<th^>值^</th^>^</tr^>
echo             ^<tr^>^<td^>操作系统^</td^>^<td^>%OS_NAME%^</td^>^</tr^>
echo             ^<tr^>^<td^>版本^</td^>^<td^>%OS_VERSION%^</td^>^</tr^>
echo             ^<tr^>^<td^>构建号^</td^>^<td^>%OS_BUILD%^</td^>^</tr^>
echo             ^<tr^>^<td^>系统架构^</td^>^<td^>%OS_ARCH%^</td^>^</tr^>
echo             ^<tr^>^<td^>安装日期^</td^>^<td^>%OS_INSTALL_DATE%^</td^>^</tr^>
echo             ^<tr^>^<td^>上次启动^</td^>^<td^>%OS_LAST_BOOT%^</td^>^</tr^>
echo         ^</table^>
echo.
echo         ^<h2^>CPU信息^</h2^>
echo         ^<table^>
echo             ^<tr^>^<th^>项目^</th^>^<th^>值^</th^>^</tr^>
echo             ^<tr^>^<td^>处理器^</td^>^<td^>%CPU_NAME%^</td^>^</tr^>
echo             ^<tr^>^<td^>核心数^</td^>^<td^>%CPU_CORES%^</td^>^</tr^>
echo             ^<tr^>^<td^>线程数^</td^>^<td^>%CPU_THREADS%^</td^>^</tr^>
echo             ^<tr^>^<td^>最大频率^</td^>^<td^>%CPU_SPEED% MHz^</td^>^</tr^>
echo         ^</table^>
echo.
echo         ^<h2^>内存信息^</h2^>
echo         ^<table^>
echo             ^<tr^>^<th^>项目^</th^>^<th^>值^</th^>^</tr^>
echo             ^<tr^>^<td^>总内存^</td^>^<td^>%MEM_TOTAL_MB% MB^</td^>^</tr^>
echo             ^<tr^>^<td^>内存速度^</td^>^<td^>%MEM_SPEED% MHz^</td^>^</tr^>
echo             ^<tr^>^<td^>制造商^</td^>^<td^>%MEM_MANUFACTURER%^</td^>^</tr^>
echo         ^</table^>
echo.
echo         ^<h2^>网络信息^</h2^>
echo         ^<table^>
echo             ^<tr^>^<th^>项目^</th^>^<th^>值^</th^>^</tr^>
echo             ^<tr^>^<td^>IP地址^</td^>^<td^>%IP_ADDRESS%^</td^>^</tr^>
echo             ^<tr^>^<td^>MAC地址^</td^>^<td^>%MAC_ADDRESS%^</td^>^</tr^>
echo             ^<tr^>^<td^>DHCP启用^</td^>^<td^>%DHCP_ENABLED%^</td^>^</tr^>
echo         ^</table^>
echo.
echo         ^<div class="info-box"^>
echo             ^<strong^>系统运行时间：^</strong^>约 %UPTIME_HOURS% 小时 %UPTIME_MINS% 分钟
echo         ^</div^>
echo.
echo         ^<div class="info-box warning"^>
echo             ^<strong^>注意：^</strong^>本报告仅收集系统信息，不包含敏感数据。
echo         ^</div^>
echo     ^</div^>
echo ^</body^>
echo ^</html^>
) > "%REPORT_FILE%"

:: 记录完成信息
echo [%DATE% %TIME%] 系统信息收集完成 >> "%LOG_FILE%"

:: 显示完成信息
echo.
echo ============================================================
echo                    收集完成！
echo ============================================================
echo 报告已生成: %REPORT_FILE%
echo 日志文件: %LOG_FILE%
echo.
echo 按任意键打开报告...
pause > nul
start "" "%REPORT_FILE%"

endlocal
exit /b 0