@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: ping_test.bat - Ping连通性测试示例
:: 功能：演示ping命令的各种用法
:: 安全提示：仅测试本地或公开测试服务
:: ============================================================

echo ========================================
echo       Ping连通性测试工具
echo ========================================
echo.

:: 1. 基本ping测试
echo [1] 基本ping测试 - 本地回环地址
echo ----------------------------------------
ping -n 3 127.0.0.1
echo.

:: 2. 测试默认网关
echo [2] 测试默认网关
echo ----------------------------------------
:: 获取默认网关地址
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr "Default Gateway"') do (
    set "gateway=%%i"
    set "gateway=!gateway: =!"
)

if defined gateway (
    echo 默认网关：!gateway!
    ping -n 2 !gateway!
) else (
    echo 未找到默认网关配置
)
echo.

:: 3. 测试DNS服务器
echo [3] 测试DNS服务器连通性
echo ----------------------------------------
echo 测试Google DNS (8.8.8.8)...
ping -n 2 8.8.8.8

echo.
echo 测试Cloudflare DNS (1.1.1.1)...
ping -n 2 1.1.1.1
echo.

:: 4. 测试域名解析
echo [4] 测试域名解析
echo ----------------------------------------
echo 测试百度 (baidu.com)...
ping -n 2 baidu.com

echo.
echo 测试微软 (microsoft.com)...
ping -n 2 microsoft.com
echo.

:: 5. 高级ping参数演示
echo [5] 高级ping参数演示
echo ----------------------------------------
echo 测试指定数据包大小 (1000字节)...
ping -n 1 -l 1000 8.8.8.8

echo.
echo 测试指定超时时间 (3000毫秒)...
ping -n 1 -w 3000 8.8.8.8
echo.

:: 6. 连续ping测试（带计数）
echo [6] 连续ping测试（5次）
echo ----------------------------------------
set "success=0"
set "fail=0"

for /l %%i in (1,1,5) do (
    echo 测试 %%i/5...
    ping -n 1 -w 1000 8.8.8.8 >nul
    if !errorlevel! equ 0 (
        set /a success+=1
        echo   结果：成功
    ) else (
        set /a fail+=1
        echo   结果：失败
    )
)

echo.
echo 统计结果：
echo   成功次数：!success!
echo   失败次数：!fail!
echo   成功率：!success!0%%
echo.

:: 7. 保存ping结果到文件
echo [7] 保存ping结果到文件
echo ----------------------------------------
set "outputfile=ping_results.txt"
echo Ping测试结果 - %date% %time% > %outputfile%
echo ======================================== >> %outputfile%
echo. >> %outputfile%

echo 测试本地回环地址： >> %outputfile%
ping -n 2 127.0.0.1 >> %outputfile%
echo. >> %outputfile%

echo 测试Google DNS： >> %outputfile%
ping -n 2 8.8.8.8 >> %outputfile%
echo. >> %outputfile%

echo 结果已保存到：%outputfile%
echo.

:: 8. 网络延迟测试
echo [8] 网络延迟测试
echo ----------------------------------------
echo 测试到不同服务器的延迟...
echo.

set "servers=8.8.8.8 1.1.1.1 114.114.114.114"

for %%s in (%servers%) do (
    echo 测试 %%s...
    for /f "tokens=6 delims== " %%t in ('ping -n 1 %%s ^| findstr "Average"') do (
        echo   平均延迟：%%t
    )
)

echo.
echo ========================================
echo 测试完成
echo ========================================

pause