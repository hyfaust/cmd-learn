@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: download.bat - 文件下载演示
:: 功能：演示多种文件下载方法
:: 安全提示：仅下载公开测试文件，不下载恶意内容
:: ============================================================

echo ========================================
echo       文件下载演示
echo ========================================
echo.

:: 创建下载目录
set "download_dir=downloads"
if not exist %download_dir% mkdir %download_dir%

:: 1. 使用curl下载文件
echo [1] 使用curl下载文件
echo ----------------------------------------
echo 下载httpbin.org的测试文件...
echo.

set "curl_output=%download_dir%\curl_test.txt"
curl -s -o %curl_output% https://httpbin.org/bytes/1024

if exist %curl_output% (
    echo 下载成功！
    echo 文件大小： 
    for %%f in (%curl_output%) do echo   %%~zf 字节
    echo 文件路径： %curl_output%
) else (
    echo 下载失败
)
echo.

:: 2. 使用curl下载并显示进度
echo [2] 使用curl下载并显示进度
echo ----------------------------------------
echo 下载带进度显示的文件...
echo.

set "curl_progress=%download_dir%\curl_progress.bin"
curl -# -o %curl_progress% https://httpbin.org/bytes/10240

if exist %curl_progress% (
    echo 下载成功！
    for %%f in (%curl_progress%) do echo 文件大小： %%~zf 字节
) else (
    echo 下载失败
)
echo.

:: 3. 使用bitsadmin下载
echo [3] 使用bitsadmin下载
echo ----------------------------------------
echo 使用后台智能传输服务下载...
echo.

set "bitsadmin_output=%download_dir%\bitsadmin_test.txt"
set "bitsadmin_job=download_job_%random%"

:: 创建下载任务
bitsadmin /create %bitsadmin_job% >nul
bitsadmin /addfile %bitsadmin_job% https://httpbin.org/bytes/2048 %bitsadmin_output% >nul
bitsadmin /resume %bitsadmin_job% >nul

echo 等待下载完成...
:bitsadmin_wait
bitsadmin /info %bitsadmin_job% | findstr "STATE" | findstr "TRANSFERRED" >nul
if errorlevel 1 (
    timeout /t 1 /nobreak >nul
    goto bitsadmin_wait
)

bitsadmin /complete %bitsadmin_job% >nul

if exist %bitsadmin_output% (
    echo 下载成功！
    for %%f in (%bitsadmin_output%) do echo 文件大小： %%~zf 字节
) else (
    echo 下载失败
)
echo.

:: 4. 使用certutil下载
echo [4] 使用certutil下载
echo ----------------------------------------
echo 使用证书工具下载文件...
echo.

set "certutil_output=%download_dir%\certutil_test.txt"
certutil -urlcache -split -f "https://httpbin.org/bytes/512" "%certutil_output%" >nul 2>&1

if exist %certutil_output% (
    echo 下载成功！
    for %%f in (%certutil_output%) do echo 文件大小： %%~zf 字节
) else (
    echo 下载失败
    echo 注意：certutil可能被系统策略限制
)
echo.

:: 5. 下载JSON文件
echo [5] 下载JSON文件
echo ----------------------------------------
echo 下载JSON格式的测试数据...
echo.

set "json_output=%download_dir%\test_data.json"
curl -s -o %json_output% https://httpbin.org/json

if exist %json_output% (
    echo 下载成功！
    echo 文件内容：
    type %json_output%
) else (
    echo 下载失败
)
echo.

:: 6. 下载HTML页面
echo [6] 下载HTML页面
echo ----------------------------------------
echo 下载示例HTML页面...
echo.

set "html_output=%download_dir%\example.html"
curl -s -o %html_output% https://example.com

if exist %html_output% (
    echo 下载成功！
    echo 文件大小：
    for %%f in (%html_output%) do echo   %%~zf 字节
    echo.
    echo 页面标题（前5行）：
    more /c +1 %html_output% | findstr /n "." | findstr /b "^[1-5]:"
) else (
    echo 下载失败
)
echo.

:: 7. 带重试的下载
echo [7] 带重试的下载
echo ----------------------------------------
echo 带重试机制的下载脚本...
echo.

set "retry_output=%download_dir%\retry_test.txt"
set "max_retries=3"
set "retry_count=0"

:retry_download
set /a retry_count+=1
echo 尝试下载（第 %retry_count% 次）...
curl -s --connect-timeout 5 --max-time 10 -o %retry_output% https://httpbin.org/bytes/256

if exist %retry_output% (
    echo 下载成功！
    for %%f in (%retry_output%) do echo 文件大小： %%~zf 字节
) else (
    if %retry_count% lss %max_retries% (
        echo 下载失败，等待重试...
        timeout /t 2 /nobreak >nul
        goto retry_download
    ) else (
        echo 下载失败，已达最大重试次数
    )
)
echo.

:: 8. 验证下载文件完整性
echo [8] 验证下载文件完整性
echo ----------------------------------------
echo 计算文件哈希值...
echo.

set "verify_file=%download_dir%\curl_test.txt"
if exist %verify_file% (
    echo 文件： %verify_file%
    echo MD5哈希：
    certutil -hashfile %verify_file% MD5 | findstr /v "CertUtil"
    echo.
    echo SHA256哈希：
    certutil -hashfile %verify_file% SHA256 | findstr /v "CertUtil"
) else (
    echo 文件不存在，跳过验证
)
echo.

:: 9. 批量下载
echo [9] 批量下载
echo ----------------------------------------
echo 批量下载多个文件...
echo.

set "batch_dir=%download_dir%\batch"
if not exist %batch_dir% mkdir %batch_dir%

for /l %%i in (1,1,3) do (
    echo 下载文件 %%i/3...
    curl -s -o %batch_dir%\file_%%i.txt https://httpbin.org/bytes/128
    if exist %batch_dir%\file_%%i.txt (
        echo   成功
    ) else (
        echo   失败
    )
)

echo.
echo 批量下载完成，文件列表：
dir /b %batch_dir%
echo.

:: 10. 显示下载统计
echo [10] 下载统计
echo ----------------------------------------
echo 下载目录内容：
echo.

if exist %download_dir% (
    echo 目录： %download_dir%
    echo.
    echo 文件列表：
    dir /b %download_dir%
    echo.
    echo 总文件数：
    set /a file_count=0
    for %%f in (%download_dir%\*) do set /a file_count+=1
    echo   !file_count! 个文件
    echo.
    echo 总大小：
    set /a total_size=0
    for %%f in (%download_dir%\*) do set /a total_size+=%%~zf
    echo   !total_size! 字节
) else (
    echo 下载目录不存在
)

echo.
echo ========================================
echo 演示完成
echo ========================================
echo.
echo 注意：下载的文件保存在 %download_dir% 目录中
echo 您可以查看这些文件了解下载内容

pause