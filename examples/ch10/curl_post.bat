@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: curl_post.bat - curl POST请求示例
:: 功能：演示curl的POST请求功能
:: 安全提示：仅测试公开测试服务httpbin.org
:: ============================================================

echo ========================================
echo       curl POST请求演示
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

:: 1. 基本POST请求（表单数据）
echo [1] 基本POST请求（表单数据）
echo ----------------------------------------
echo 提交表单数据到httpbin.org/post
echo.
curl -s -X POST https://httpbin.org/post ^
     -d "username=admin&password=secret123&email=admin@example.com"
echo.
echo.

:: 2. JSON数据POST请求
echo [2] JSON数据POST请求
echo ----------------------------------------
echo 提交JSON数据
echo.
curl -s -X POST https://httpbin.org/post ^
     -H "Content-Type: application/json" ^
     -d "{\"username\":\"admin\",\"password\":\"secret123\",\"email\":\"admin@example.com\"}"
echo.
echo.

:: 3. 从文件读取JSON数据
echo [3] 从文件读取JSON数据
echo ----------------------------------------
:: 创建临时JSON文件
set "jsonfile=temp_data.json"
echo {> %jsonfile%
echo   "name": "test_user",>> %jsonfile%
echo   "age": 25,>> %jsonfile%
echo   "city": "Beijing">> %jsonfile%
echo }>> %jsonfile%

echo 提交的JSON数据：
type %jsonfile%
echo.
echo.
echo 发送请求...
curl -s -X POST https://httpbin.org/post ^
     -H "Content-Type: application/json" ^
     -d @%jsonfile%
echo.
echo.

:: 4. 文件上传
echo [4] 文件上传
echo ----------------------------------------
:: 创建测试文件
set "uploadfile=test_upload.txt"
echo This is a test file for upload. > %uploadfile%
echo Created at: %date% %time% >> %uploadfile%

echo 上传文件内容：
type %uploadfile%
echo.
echo.
echo 上传文件...
curl -s -X POST https://httpbin.org/post ^
     -F "file=@%uploadfile%" ^
     -F "description=Test file upload"
echo.
echo.

:: 5. 设置请求头
echo [5] 设置自定义请求头
echo ----------------------------------------
echo 设置Authorization和自定义头
echo.
curl -s -X POST https://httpbin.org/post ^
     -H "Content-Type: application/json" ^
     -H "Authorization: Bearer test_token_12345" ^
     -H "X-Custom-Header: custom_value" ^
     -H "User-Agent: CMD-Tutorial/1.0" ^
     -d "{\"action\":\"test\",\"data\":\"sample\"}"
echo.
echo.

:: 6. 处理POST响应
echo [6] 处理POST响应
echo ----------------------------------------
echo 保存响应到文件并提取状态码
echo.

set "responsefile=post_response.json"
curl -s -X POST https://httpbin.org/post ^
     -H "Content-Type: application/json" ^
     -d "{\"test\":\"response_handling\"}" ^
     -o %responsefile%

echo 响应已保存到：%responsefile%
echo.
echo 响应内容：
type %responsefile%
echo.
echo.

:: 7. 获取响应头信息
echo [7] 获取响应头信息
echo ----------------------------------------
echo 使用-v参数显示完整请求/响应信息
echo.
curl -s -v -X POST https://httpbin.org/post ^
     -d "test=verbose" 2>&1 | findstr /C:"> " /C:"< " /C:"HTTP/"
echo.
echo.

:: 8. 错误处理示例
echo [8] 错误处理示例
echo ----------------------------------------
echo 测试POST到不存在的端点
echo.
curl -s -X POST https://httpbin.org/status/404 ^
     -d "test=error"
if errorlevel 1 (
    echo 请求失败，错误代码：%errorlevel%
) else (
    echo 请求完成（可能返回错误状态码）
)
echo.

:: 9. 带认证的POST请求
echo [9] 带认证的POST请求
echo ----------------------------------------
echo 使用基本认证
echo.
curl -s -X POST https://httpbin.org/post ^
     -u "testuser:testpassword" ^
     -d "authenticated_request=true"
echo.
echo.

:: 10. 批量POST请求
echo [10] 批量POST请求
echo ----------------------------------------
echo 连续发送多个POST请求
echo.

for /l %%i in (1,1,3) do (
    echo 发送请求 %%i/3...
    curl -s -X POST https://httpbin.org/post ^
         -d "request_number=%%i&timestamp=%time%"
    echo.
)
echo.

:: 11. 处理JSON响应中的特定字段
echo [11] 处理JSON响应
echo ----------------------------------------
echo 发送请求并解析响应
echo.

set "tempfile=temp_response.json"
curl -s -X POST https://httpbin.org/post ^
     -H "Content-Type: application/json" ^
     -d "{\"parse_test\":true}" ^
     -o %tempfile%

echo 响应内容：
type %tempfile%
echo.
echo 注意：在批处理中解析JSON需要使用jq或其他工具
echo.

echo ========================================
echo 演示完成
echo ========================================

:: 清理临时文件
if exist %jsonfile% del %jsonfile%
if exist %uploadfile% del %uploadfile%
if exist %responsefile% del %responsefile%
if exist %tempfile% del %tempfile%

pause