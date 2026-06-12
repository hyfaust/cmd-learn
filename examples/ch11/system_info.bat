@echo off
chcp 65001 >nul
REM ============================================================
REM 文件名: system_info.bat
REM 功能: 收集系统详细信息
REM 作者: CMD教程系列
REM 日期: 2026-06-11
REM ============================================================

setlocal enabledelayedexpansion

echo ========================================
echo    系统信息收集工具
echo ========================================
echo.

REM 创建报告目录
set "report_dir=%~dp0reports"
if not exist "%report_dir%" mkdir "%report_dir%"

REM 设置报告文件
set "report_file=%report_dir%\system_report_%date:~0,4%%date:~5,2%%date:~8,2%.txt"

echo 正在收集系统信息，请稍候...
echo.

REM 开始生成报告
echo ============================================================ > "%report_file%"
echo                    系统信息报告 >> "%report_file%"
echo ============================================================ >> "%report_file%"
echo 生成时间: %date% %time% >> "%report_file%"
echo. >> "%report_file%"

REM 第一部分：基本系统信息
echo [1] 收集基本系统信息...
echo ----------------------------------------------------------- >> "%report_file%"
echo 基本系统信息 >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value 2^>nul') do echo 操作系统: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic os get Version /value 2^>nul') do echo 版本: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic os get OSArchitecture /value 2^>nul') do echo 架构: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic computersystem get Name /value 2^>nul') do echo 计算机名: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic computersystem get UserName /value 2^>nul') do echo 当前用户: %%a >> "%report_file%"
echo. >> "%report_file%"

REM 第二部分：CPU信息
echo [2] 收集CPU信息...
echo ----------------------------------------------------------- >> "%report_file%"
echo CPU信息 >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

for /f "tokens=2 delims==" %%a in ('wmic cpu get Name /value 2^>nul') do echo CPU型号: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value 2^>nul') do echo 核心数: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfLogicalProcessors /value 2^>nul') do echo 逻辑处理器: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic cpu get MaxClockSpeed /value 2^>nul') do echo 最大时钟速度: %%a MHz >> "%report_file%"
echo. >> "%report_file%"

REM 第三部分：内存信息
echo [3] 收集内存信息...
echo ----------------------------------------------------------- >> "%report_file%"
echo 内存信息 >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

for /f "tokens=2 delims==" %%a in ('wmic os get TotalVisibleMemorySize /value 2^>nul') do (
    set /a total_mem=%%a/1024
    echo 总物理内存: !total_mem! MB >> "%report_file%"
)

for /f "tokens=2 delims==" %%a in ('wmic os get FreePhysicalMemory /value 2^>nul') do (
    set /a free_mem=%%a/1024
    echo 可用物理内存: !free_mem! MB >> "%report_file%"
)

REM 计算内存使用率
set /a used_mem=total_mem-free_mem
set /a mem_percent=used_mem*100/total_mem
echo 内存使用率: !mem_percent!%% >> "%report_file%"
echo. >> "%report_file%"

REM 内存条信息
echo 内存条详情: >> "%report_file%"
for /f "skip=1 tokens=*" %%a in ('wmic memorychip get Capacity^,Speed^,Manufacturer /format:list 2^>nul') do (
    echo   %%a >> "%report_file%"
)
echo. >> "%report_file%"

REM 第四部分：磁盘信息
echo [4] 收集磁盘信息...
echo ----------------------------------------------------------- >> "%report_file%"
echo 磁盘信息 >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

echo 盘符   总大小      可用空间    使用率 >> "%report_file%"
echo -----  ---------   ---------   ------ >> "%report_file%"

for /f "skip=1 tokens=*" %%a in ('wmic logicaldisk where "DriveType=3" get DeviceID^,Size^,FreeSpace /format:csv 2^>nul') do (
    for /f "tokens=2,3,4 delims=," %%b in ("%%a") do (
        if defined %%b (
            set /a total=%%d/1073741824 2>nul
            set /a free=%%c/1073741824 2>nul
            set /a used=total-free
            if !total! gtr 0 (
                set /a percent=used*100/total
            ) else (
                set percent=0
            )
            echo %%b      !total! GB      !free! GB      !percent!%% >> "%report_file%"
        )
    )
)
echo. >> "%report_file%"

REM 第五部分：网络信息
echo [5] 收集网络信息...
echo ----------------------------------------------------------- >> "%report_file%"
echo 网络适配器信息 >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

ipconfig | findstr /i "IPv4 Subnet Gateway DNS" >> "%report_file%"
echo. >> "%report_file%"

REM 第六部分：BIOS信息
echo [6] 收集BIOS信息...
echo ----------------------------------------------------------- >> "%report_file%"
echo BIOS信息 >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

for /f "tokens=2 delims==" %%a in ('wmic bios get Manufacturer /value 2^>nul') do echo 制造商: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic bios get Version /value 2^>nul') do echo 版本: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic bios get ReleaseDate /value 2^>nul') do echo 发布日期: %%a >> "%report_file%"
echo. >> "%report_file%"

REM 第七部分：启动时间
echo [7] 收集系统运行时间...
echo ----------------------------------------------------------- >> "%report_file%"
echo 系统运行时间 >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

for /f "tokens=2 delims==" %%a in ('wmic os get LastBootUpTime /value 2^>nul') do echo 上次启动时间: %%a >> "%report_file%"
for /f "tokens=2 delims==" %%a in ('wmic os get LocalDateTime /value 2^>nul') do echo 当前系统时间: %%a >> "%report_file%"
echo. >> "%report_file%"

REM 第八部分：已安装的热修补
echo [8] 收集已安装更新信息...
echo ----------------------------------------------------------- >> "%report_file%"
echo 最近安装的更新（前10个） >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

set count=0
for /f "skip=1 tokens=2" %%a in ('wmic qfe get HotFixID /format:table 2^>nul') do (
    if !count! lss 10 (
        if defined %%a (
            echo   %%a >> "%report_file%"
            set /a count+=1
        )
    )
)
echo. >> "%report_file%"

REM 第九部分：进程统计
echo [9] 收集进程统计信息...
echo ----------------------------------------------------------- >> "%report_file%"
echo 进程统计 >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

set proc_count=0
for /f "skip=3" %%a in ('tasklist /fo TABLE') do (
    set /a proc_count+=1
)
echo 当前运行进程数: !proc_count! >> "%report_file%"
echo. >> "%report_file%"

REM 第十部分：服务统计
echo [10] 收集服务统计信息...
echo ----------------------------------------------------------- >> "%report_file%"
echo 服务统计 >> "%report_file%"
echo ----------------------------------------------------------- >> "%report_file%"

set running_services=0
set stopped_services=0

for /f "tokens=2 delims==" %%a in ('sc query state^= active type^= service 2^>nul ^| findstr "SERVICE_NAME"') do (
    set /a running_services+=1
)

for /f "tokens=2 delims==" %%a in ('sc query state^= inactive type^= service 2^>nul ^| findstr "SERVICE_NAME"') do (
    set /a stopped_services+=1
)

echo 运行中的服务: !running_services! >> "%report_file%"
echo 已停止的服务: !stopped_services! >> "%report_file%"
echo. >> "%report_file%"

REM 完成报告
echo ============================================================ >> "%report_file%"
echo                        报告结束 >> "%report_file%"
echo ============================================================ >> "%report_file%"

echo.
echo ========================================
echo    系统信息收集完成
echo ========================================
echo.
echo 报告已保存到: %report_file%
echo.

REM 显示报告摘要
echo 报告摘要:
echo -----------------------------------------------------------
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value 2^>nul') do echo   操作系统: %%a
for /f "tokens=2 delims==" %%a in ('wmic cpu get Name /value 2^>nul') do echo   CPU: %%a
echo   总内存: %total_mem% MB
echo   可用内存: %free_mem% MB
echo   内存使用率: %mem_percent%%%
echo   运行进程数: %proc_count%
echo -----------------------------------------------------------
echo.

pause
