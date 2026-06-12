@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: network_info.bat - 网络信息收集
:: 功能：收集系统网络配置和状态信息
:: 安全提示：仅收集本地网络信息，不进行任何恶意操作
:: ============================================================

echo ========================================
echo       网络信息收集工具
echo ========================================
echo.

:: 创建报告文件
set "report_file=network_info_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt"
echo 网络信息报告 > %report_file%
echo 生成时间：%date% %time% >> %report_file%
echo 主机名：%computername% >> %report_file%
echo ======================================== >> %report_file%
echo. >> %report_file%

:: 1. 基本网络配置
echo [1] 基本网络配置
echo ----------------------------------------
echo 收集基本网络配置...
echo.

echo 基本网络配置： >> %report_file%
ipconfig | findstr /v "DNS\|DHCP\|Lease" >> %report_file%
echo. >> %report_file%

echo 显示内容：
ipconfig
echo.

:: 2. 详细网络配置
echo [2] 详细网络配置
echo ----------------------------------------
echo 收集详细网络配置...
echo.

echo 详细网络配置： >> %report_file%
ipconfig /all >> %report_file%
echo. >> %report_file%

echo 详细配置已保存到报告文件
echo.

:: 3. DNS信息
echo [3] DNS信息
echo ----------------------------------------
echo 收集DNS配置...
echo.

echo DNS配置： >> %report_file%
ipconfig /all | findstr "DNS" >> %report_file%
echo. >> %report_file%

echo DNS缓存： >> %report_file%
ipconfig /displaydns | findstr /C:"Record Name" /C:"Record Type" /C:"IP Address" >> %report_file%
echo. >> %report_file%

echo DNS配置：
ipconfig /all | findstr "DNS"
echo.

:: 4. 网络接口信息
echo [4] 网络接口信息
echo ----------------------------------------
echo 收集网络接口信息...
echo.

echo 网络接口信息： >> %report_file%
netsh interface show interface >> %report_file%
echo. >> %report_file%

echo 网络接口状态：
netsh interface show interface
echo.

:: 5. 路由表信息
echo [5] 路由表信息
echo ----------------------------------------
echo 收集路由表信息...
echo.

echo 路由表： >> %report_file%
route print >> %report_file%
echo. >> %report_file%

echo 默认路由：
route print | findstr "0.0.0.0"
echo.

:: 6. ARP表信息
echo [6] ARP表信息
echo ----------------------------------------
echo 收集ARP表信息...
echo.

echo ARP表： >> %report_file%
arp -a >> %report_file%
echo. >> %report_file%

echo ARP表内容：
arp -a
echo.

:: 7. 网络连接信息
echo [7] 网络连接信息
echo ----------------------------------------
echo 收集网络连接信息...
echo.

echo 活动连接： >> %report_file%
netstat -an | findstr "ESTABLISHED" >> %report_file%
echo. >> %report_file%

echo 活动连接数：
netstat -an | findstr "ESTABLISHED" | find /c /v ""
echo.

:: 8. DHCP信息
echo [8] DHCP信息
echo ----------------------------------------
echo 收集DHCP配置...
echo.

echo DHCP信息： >> %report_file%
ipconfig /all | findstr "DHCP" >> %report_file%
echo. >> %report_file%

echo DHCP状态：
ipconfig /all | findstr "DHCP"
echo.

:: 9. 网络统计信息
echo [9] 网络统计信息
echo ----------------------------------------
echo 收集网络统计信息...
echo.

echo 网络统计： >> %report_file%
netstat -e >> %report_file%
echo. >> %report_file%

echo 以太网统计：
netstat -e
echo.

:: 10. 测试网络连通性
echo [10] 网络连通性测试
echo ----------------------------------------
echo 测试基本网络连通性...
echo.

echo 连通性测试： >> %report_file%

echo 测试本地回环... >> %report_file%
ping -n 1 127.0.0.1 | findstr "Reply" >> %report_file%
echo.

echo 测试网关...
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr "Default Gateway"') do (
    set "gateway=%%i"
    set "gateway=!gateway: =!"
    if defined gateway (
        echo 网关：!gateway! >> %report_file%
        ping -n 1 !gateway! | findstr "Reply" >> %report_file%
    )
)
echo.

echo 测试DNS...
echo DNS测试： >> %report_file%
ping -n 1 8.8.8.8 | findstr "Reply" >> %report_file%
echo.

:: 11. 无线网络信息（如果有）
echo [11] 无线网络信息
echo ----------------------------------------
echo 收集无线网络信息...
echo.

echo 无线网络配置： >> %report_file%
netsh wlan show interfaces >> %report_file%
echo. >> %report_file%

echo 无线网络配置：
netsh wlan show interfaces 2>nul || echo 未检测到无线网络适配器
echo.

:: 12. 防火墙状态
echo [12] 防火墙状态
echo ----------------------------------------
echo 收集防火墙状态...
echo.

echo 防火墙状态： >> %report_file%
netsh advfirewall show currentprofile >> %report_file%
echo. >> %report_file%

echo 防火墙状态：
netsh advfirewall show currentprofile | findstr "State"
echo.

:: 13. 生成摘要
echo [13] 生成摘要
echo ----------------------------------------
echo 生成网络信息摘要...
echo.

echo 网络信息摘要： >> %report_file%
echo ======================================== >> %report_file%
echo.

:: 获取IP地址
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr "IPv4"') do (
    set "ip=%%i"
    set "ip=!ip: =!"
    echo IP地址：!ip! >> %report_file%
)

:: 获取子网掩码
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr "Subnet"') do (
    set "mask=%%i"
    set "mask=!mask: =!"
    echo 子网掩码：!mask! >> %report_file%
)

:: 获取默认网关
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr "Default Gateway"') do (
    set "gw=%%i"
    set "gw=!gw: =!"
    if defined gw (
        echo 默认网关：!gw! >> %report_file%
    )
)

:: 获取MAC地址
for /f "tokens=2 delims=:" %%i in ('ipconfig /all ^| findstr "Physical"') do (
    set "mac=%%i"
    set "mac=!mac: =!"
    echo MAC地址：!mac! >> %report_file%
)

echo. >> %report_file%
echo 报告生成完成 >> %report_file%

echo.
echo ========================================
echo 网络信息收集完成
echo ========================================
echo.
echo 报告已保存到：%report_file%
echo.
echo 摘要信息：
echo.

:: 显示摘要
echo IP地址：
ipconfig | findstr "IPv4"
echo.

echo 默认网关：
ipconfig | findstr "Default Gateway"
echo.

echo DNS服务器：
ipconfig /all | findstr "DNS"
echo.

echo 网络接口：
netsh interface show interface | findstr "Connected"
echo.

echo ========================================

pause