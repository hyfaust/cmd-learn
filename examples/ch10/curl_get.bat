@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: curl_get.bat - curl GET请求示例
:: 功能：演示curl的GET请求功能
:: 安全提示：仅测试公开测试服务httpbin.org
:: ============================================================

echo ========================================
echo       curl GET请求演示
echo ========================================
echo.

:: 检查curl是否可用
curl --version >nul 2>&1
if errorlevel 1 (
    echo 错误：curl未安装或不在PATH中
    echo 请确保curl已安装并添加到系统PATH
    pause
    exit /b 1
)

:: 1. 基本GET请求
echo [1] 基本GET请求
echo ----------------------------------------
echo 请求：https://httpbin.org/get
echo.
curl -s https://httpbin.org/get
echo.
echo.

:: 2. 带查询参数的GET请求
echo [2] 带查询参数的GET请求
echo ----------------------------------------
echo 请求：https://httpbin.org/get?name=test&value=123
echo.
curl -s "https://httpbin.org/get?name=test&value=123"
echo.
echo.

:: 3. 设置请求头
echo [3] 设置请求头
echo ----------------------------------------
echo 设置User-Agent和Accept头
echo.
curl -s -H "User-Agent: CMD-Tutorial/1.0" ^
     -H "Accept: application/json" ^
     https://httpbin.org/get
echo.
echo.

:: 4. 获取响应头信息
echo [4] 获取响应头信息
echo ----------------------------------------
echo 使用-I参数获取响应头
echo.
curl -s -I https://httpbin.org/get
echo.
echo.

:: 5. 保存响应到文件
echo [5] 保存响应到文件
echo ----------------------------------------
set "outputfile=response.json"
curl -s -o %outputfile% https://httpbin.org/get
echo 响应已保存到：%outputfile%
echo 文件内容：
type %outputfile%
echo.
echo.

:: 6. 跟随重定向
echo [6] 跟随重定向
echo ----------------------------------------
echo 测试重定向（httpbin.org/redirect/2）
echo.
curl -s -L https://httpbin.org/redirect/2
echo.
echo.

:: 7. 显示详细请求信息
echo [7] 显示详细请求信息（-v参数）
echo ----------------------------------------
echo 使用-v参数显示详细通信过程
echo.
curl -s -v https://httpbin.org/get 2>&1 | findstr /C:"> " /C:"< "
echo.
echo.

:: 8. 设置超时
echo [8] 设置超时
echo ----------------------------------------
echo 设置连接超时5秒，最大传输时间10秒
echo.
curl -s --connect-timeout 5 --max-time 10 https://httpbin.org/delay/1
echo.
echo.

:: 9. 错误处理示例
echo [9] 错误处理示例
echo ----------------------------------------
echo 测试不存在的域名（会失败）
echo.
curl -s --connect-timeout 3 https://nonexistent.example.com
if errorlevel 1 (
    echo 请求失败，错误代码：%errorlevel%
    echo 可能的原因：
    echo   - DNS解析失败
    echo   - 连接超时
    echo   - 网络不可达
)
echo.

:: 10. 获取HTTP状态码
echo [10] 获取HTTP状态码
echo ----------------------------------------
echo 使用-w参数获取状态码
echo.

echo 测试200状态码：
for /f %%i in ('curl -s -o nul -w "%%{http_code}" https://httpbin.org/get') do (
    echo   状态码：%%i
)

echo.
echo 测试404状态码：
for /f %%i in ('curl -s -o nul -w "%%{http_code}" https://httpbin.org/status/404') do (
    echo   状态码：%%i
)

echo.
echo 测试500状态码：
for /f %%i in ('curl -s -o nul -w "%%{http_code}" https://httpbin.org/status/500') do (
    echo   状态码：%%i
)

echo.
echo ========================================
echo 演示完成
echo ========================================

:: 清理临时文件
if exist %outputfile% del %outputfile%

pause