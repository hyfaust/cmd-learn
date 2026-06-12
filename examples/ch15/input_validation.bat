@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: input_validation.bat - 输入验证演示
::
:: 安全提示：本脚本演示各种输入验证技术
:: 用于防止命令注入、路径遍历等安全攻击
:: ============================================================

chcp 65001 >nul 2>&1

echo ============================================================
echo 输入验证演示
echo ============================================================
echo.

:: 设置日志文件
set "log_file=%~dp0input_validation.log"

:: 记录开始时间
echo [%date% %time%] 输入验证演示开始 >> "%log_file%"

:: 演示1：基本输入验证
echo [演示1] 基本输入验证
echo ----------------------------------------
echo 测试各种输入验证场景：
echo.

:: 测试用例1：空输入
echo [测试1] 空输入验证
set "test_input="
call :validate_input "%test_input%"
if %errorLevel% == 0 (
    echo [PASS] 空输入被正确拒绝
) else (
    echo [FAIL] 空输入验证失败
)
echo.

:: 测试用例2：正常输入
echo [测试2] 正常输入验证
set "test_input=hello_world"
call :validate_input "%test_input%"
if %errorLevel% == 0 (
    echo [PASS] 正常输入通过验证
) else (
    echo [FAIL] 正常输入验证失败
)
echo.

:: 测试用例3：包含危险字符的输入
echo [测试3] 危险字符验证
set "test_input=file.txt & del /f /q C:\*.*"
call :validate_input "%test_input%"
if %errorLevel% neq 0 (
    echo [PASS] 危险字符被正确拒绝
) else (
    echo [FAIL] 危险字符验证失败
)
echo.

:: 测试用例4：路径遍历攻击
echo [测试4] 路径遍历攻击验证
set "test_input=..\..\..\Windows\System32\config\SAM"
call :validate_input "%test_input%"
if %errorLevel% neq 0 (
    echo [PASS] 路径遍历攻击被正确拒绝
) else (
    echo [FAIL] 路径遍历攻击验证失败
)
echo.

:: 测试用例5：命令注入攻击
echo [测试5] 命令注入攻击验证
set "test_input=file.txt | net user hacker P@ssw0rd /add"
call :validate_input "%test_input%"
if %errorLevel% neq 0 (
    echo [PASS] 命令注入攻击被正确拒绝
) else (
    echo [FAIL] 命令注入攻击验证失败
)
echo.

:: 演示2：文件名验证
echo [演示2] 文件名验证
echo ----------------------------------------
echo 测试文件名验证：
echo.

:: 测试有效文件名
echo [测试1] 有效文件名
set "filename=document.txt"
call :validate_filename "%filename%"
if %errorLevel% == 0 (
    echo [PASS] 文件名有效: %filename%
) else (
    echo [FAIL] 文件名验证失败: %filename%
)
echo.

:: 测试包含非法字符的文件名
echo [测试2] 包含非法字符的文件名
set "filename=file:name.txt"
call :validate_filename "%filename%"
if %errorLevel% neq 0 (
    echo [PASS] 非法字符被正确拒绝: %filename%
) else (
    echo [FAIL] 非法字符验证失败: %filename%
)
echo.

:: 测试包含空格的文件名
echo [测试3] 包含空格的文件名
set "filename=my document.txt"
call :validate_filename "%filename%"
if %errorLevel% == 0 (
    echo [PASS] 包含空格的文件名有效: %filename%
) else (
    echo [FAIL] 包含空格的文件名验证失败: %filename%
)
echo.

:: 演示3：路径验证
echo [演示3] 路径验证
echo ----------------------------------------
echo 测试路径验证：
echo.

:: 测试相对路径
echo [测试1] 相对路径验证
set "test_path=documents\file.txt"
call :validate_path "%test_path%"
if %errorLevel% == 0 (
    echo [PASS] 相对路径有效: %test_path%
) else (
    echo [FAIL] 相对路径验证失败: %test_path%
)
echo.

:: 测试绝对路径
echo [测试2] 绝对路径验证
set "test_path=C:\Users\test\file.txt"
call :validate_path "%test_path%"
if %errorLevel% == 0 (
    echo [PASS] 绝对路径有效: %test_path%
) else (
    echo [FAIL] 绝对路径验证失败: %test_path%
)
echo.

:: 测试路径遍历
echo [测试3] 路径遍历验证
set "test_path=..\..\secret.txt"
call :validate_path "%test_path%"
if %errorLevel% neq 0 (
    echo [PASS] 路径遍历被正确拒绝: %test_path%
) else (
    echo [FAIL] 路径遍历验证失败: %test_path%
)
echo.

:: 演示4：数字输入验证
echo [演示4] 数字输入验证
echo ----------------------------------------
echo 测试数字输入验证：
echo.

:: 测试有效数字
echo [测试1] 有效数字验证
set "test_number=12345"
call :validate_number "%test_number%"
if %errorLevel% == 0 (
    echo [PASS] 有效数字: %test_number%
) else (
    echo [FAIL] 数字验证失败: %test_number%
)
echo.

:: 测试无效数字
echo [测试2] 无效数字验证
set "test_number=abc123"
call :validate_number "%test_number%"
if %errorLevel% neq 0 (
    echo [PASS] 无效数字被正确拒绝: %test_number%
) else (
    echo [FAIL] 无效数字验证失败: %test_number%
)
echo.

:: 测试负数
echo [测试3] 负数验证
set "test_number=-123"
call :validate_number "%test_number%"
if %errorLevel% == 0 (
    echo [PASS] 负数有效: %test_number%
) else (
    echo [FAIL] 负数验证失败: %test_number%
)
echo.

:: 演示5：邮箱格式验证
echo [演示5] 邮箱格式验证
echo ----------------------------------------
echo 测试邮箱格式验证：
echo.

:: 测试有效邮箱
echo [测试1] 有效邮箱验证
set "test_email=user@example.com"
call :validate_email "%test_email%"
if %errorLevel% == 0 (
    echo [PASS] 有效邮箱: %test_email%
) else (
    echo [FAIL] 邮箱验证失败: %test_email%
)
echo.

:: 测试无效邮箱
echo [测试2] 无效邮箱验证
set "test_email=invalid-email"
call :validate_email "%test_email%"
if %errorLevel% neq 0 (
    echo [PASS] 无效邮箱被正确拒绝: %test_email%
) else (
    echo [FAIL] 无效邮箱验证失败: %test_email%
)
echo.

:: 演示6：命令行参数验证
echo [演示6] 命令行参数验证
echo ----------------------------------------
echo 测试命令行参数验证：
echo.

:: 模拟命令行参数
set "arg1=test.txt"
set "arg2=another file.txt"
set "arg3=dangerous & command"

echo 参数1: %arg1%
call :validate_argument "%arg1%"
if %errorLevel% == 0 (
    echo [PASS] 参数1有效
) else (
    echo [FAIL] 参数1无效
)
echo.

echo 参数2: %arg2%
call :validate_argument "%arg2%"
if %errorLevel% == 0 (
    echo [PASS] 参数2有效
) else (
    echo [FAIL] 参数2无效
)
echo.

echo 参数3: %arg3%
call :validate_argument "%arg3%"
if %errorLevel% neq 0 (
    echo [PASS] 参数3被正确拒绝
) else (
    echo [FAIL] 参数3验证失败
)
echo.

:: 演示7：安全最佳实践
echo [演示7] 输入验证最佳实践
echo ----------------------------------------
echo [BEST PRACTICE] 输入验证最佳实践：
echo 1. 始终验证用户输入
echo 2. 使用白名单而不是黑名单
echo 3. 限制输入长度
echo 4. 验证数据类型
echo 5. 消毒特殊字符
echo 6. 使用参数化查询
echo 7. 记录验证失败
echo 8. 提供清晰的错误消息
echo.

:: 记录结束时间
echo [%date% %time%] 输入验证演示完成 >> "%log_file%"

echo ============================================================
echo 输入验证演示完成
echo ============================================================
echo.
echo 日志文件: %log_file%
echo.
echo 按任意键退出...
pause >nul
exit /b 0

:: ============================================================
:: 验证函数
:: ============================================================

:validate_input
:: 验证基本输入
set "input=%~1"

:: 检查空输入
if not defined input (
    echo [ERROR] 输入不能为空
    exit /b 1
)

:: 检查危险字符
echo %input% | findstr /r "[&|<>^]" >nul
if %errorLevel% == 0 (
    echo [ERROR] 输入包含危险字符
    exit /b 1
)

:: 检查路径遍历
echo %input% | findstr /r "\.\." >nul
if %errorLevel% == 0 (
    echo [ERROR] 输入包含路径遍历
    exit /b 1
)

:: 检查命令分隔符
echo %input% | findstr /r "[;]" >nul
if %errorLevel% == 0 (
    echo [ERROR] 输入包含命令分隔符
    exit /b 1
)

exit /b 0

:validate_filename
:: 验证文件名
set "filename=%~1"

:: 检查空文件名
if not defined filename (
    echo [ERROR] 文件名不能为空
    exit /b 1
)

:: 检查非法字符
echo %filename% | findstr /r "[\\/:*?\"<>|]" >nul
if %errorLevel% == 0 (
    echo [ERROR] 文件名包含非法字符
    exit /b 1
)

:: 检查长度
if "%filename:~255,1%" neq "" (
    echo [ERROR] 文件名过长
    exit /b 1
)

exit /b 0

:validate_path
:: 验证路径
set "path_input=%~1"

:: 检查空路径
if not defined path_input (
    echo [ERROR] 路径不能为空
    exit /b 1
)

:: 检查路径遍历
echo %path_input% | findstr /r "\.\." >nul
if %errorLevel% == 0 (
    echo [ERROR] 路径包含遍历攻击
    exit /b 1
)

:: 检查危险字符
echo %path_input% | findstr /r "[&|<>^]" >nul
if %errorLevel% == 0 (
    echo [ERROR] 路径包含危险字符
    exit /b 1
)

exit /b 0

:validate_number
:: 验证数字
set "number=%~1"

:: 检查空输入
if not defined number (
    echo [ERROR] 数字不能为空
    exit /b 1
)

:: 检查是否为数字（允许负号）
echo %number% | findstr /r "^-*[0-9][0-9]*$" >nul
if %errorLevel% neq 0 (
    echo [ERROR] 输入不是有效数字
    exit /b 1
)

exit /b 0

:validate_email
:: 验证邮箱格式
set "email=%~1"

:: 检查空输入
if not defined email (
    echo [ERROR] 邮箱不能为空
    exit /b 1
)

:: 检查基本格式（包含@和.）
echo %email% | findstr /r ".*@.*\..*" >nul
if %errorLevel% neq 0 (
    echo [ERROR] 邮箱格式无效
    exit /b 1
)

:: 检查危险字符
echo %email% | findstr /r "[&|<>^;]" >nul
if %errorLevel% == 0 (
    echo [ERROR] 邮箱包含危险字符
    exit /b 1
)

exit /b 0

:validate_argument
:: 验证命令行参数
set "arg=%~1"

:: 检查空参数
if not defined arg (
    echo [ERROR] 参数不能为空
    exit /b 1
)

:: 检查危险字符
echo %arg% | findstr /r "[&|<>^;]" >nul
if %errorLevel% == 0 (
    echo [ERROR] 参数包含危险字符
    exit /b 1
)

:: 检查路径遍历
echo %arg% | findstr /r "\.\." >nul
if %errorLevel% == 0 (
    echo [ERROR] 参数包含路径遍历
    exit /b 1
)

exit /b 0