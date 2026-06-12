@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: safe_path.bat - 安全路径处理
::
:: 安全提示：本脚本演示安全的路径处理技术
:: 用于防止路径遍历攻击和确保路径在安全范围内
:: ============================================================

chcp 65001 >nul 2>&1

echo ============================================================
echo 安全路径处理演示
echo ============================================================
echo.

:: 设置日志文件
set "log_file=%~dp0safe_path.log"

:: 设置基础目录（安全范围）
set "base_dir=%~dp0safe_test_dir"

:: 记录开始时间
echo [%date% %time%] 安全路径处理演示开始 >> "%log_file%"

:: 创建安全测试目录
if not exist "%base_dir%" (
    echo [INFO] 创建安全测试目录: %base_dir%
    mkdir "%base_dir%"
    echo [%date% %time%] 创建安全测试目录: %base_dir% >> "%log_file%"
)

:: 创建测试文件结构
echo [INFO] 创建测试文件结构...
echo Test file 1 > "%base_dir%\file1.txt"
echo Test file 2 > "%base_dir%\file2.txt"
mkdir "%base_dir%\subdir" 2>nul
echo Test file in subdir > "%base_dir%\subdir\file3.txt"
echo [%date% %time%] 创建测试文件结构 >> "%log_file%"

:: 演示1：基本路径验证
echo [演示1] 基本路径验证
echo ----------------------------------------
echo 测试路径验证：
echo.

:: 测试有效路径
echo [测试1] 有效相对路径
set "test_path=file1.txt"
call :safe_path_join "%base_dir%" "%test_path%"
if %errorLevel% == 0 (
    echo [PASS] 有效路径: %test_path%
    echo 完整路径: %full_path%
) else (
    echo [FAIL] 路径验证失败: %test_path%
)
echo.

:: 测试路径遍历攻击
echo [测试2] 路径遍历攻击
set "test_path=..\..\..\Windows\System32\config\SAM"
call :safe_path_join "%base_dir%" "%test_path%"
if %errorLevel% neq 0 (
    echo [PASS] 路径遍历攻击被拒绝: %test_path%
) else (
    echo [FAIL] 路径遍历攻击未被拒绝: %test_path%
)
echo.

:: 测试绝对路径
echo [测试3] 绝对路径验证
set "test_path=C:\Windows\System32\cmd.exe"
call :safe_path_join "%base_dir%" "%test_path%"
if %errorLevel% neq 0 (
    echo [PASS] 绝对路径被拒绝: %test_path%
) else (
    echo [FAIL] 绝对路径未被拒绝: %test_path%
)
echo.

:: 演示2：安全文件读取
echo [演示2] 安全文件读取
echo ----------------------------------------
echo 测试安全文件读取：
echo.

:: 测试读取有效文件
echo [测试1] 读取有效文件
set "test_file=file1.txt"
call :safe_read_file "%base_dir%" "%test_file%"
if %errorLevel% == 0 (
    echo [PASS] 成功读取文件: %test_file%
) else (
    echo [FAIL] 读取文件失败: %test_file%
)
echo.

:: 测试读取不存在的文件
echo [测试2] 读取不存在的文件
set "test_file=nonexistent.txt"
call :safe_read_file "%base_dir%" "%test_file%"
if %errorLevel% neq 0 (
    echo [PASS] 不存在的文件被正确拒绝
) else (
    echo [FAIL] 不存在的文件未被拒绝
)
echo.

:: 测试读取目录外的文件
echo [测试3] 读取目录外的文件
set "test_file=..\..\..\Windows\System32\drivers\etc\hosts"
call :safe_read_file "%base_dir%" "%test_file%"
if %errorLevel% neq 0 (
    echo [PASS] 目录外文件被拒绝
) else (
    echo [FAIL] 目录外文件未被拒绝
)
echo.

:: 演示3：安全文件写入
echo [演示3] 安全文件写入
echo ----------------------------------------
echo 测试安全文件写入：
echo.

:: 测试写入有效文件
echo [测试1] 写入有效文件
set "test_file=new_file.txt"
set "test_content=This is safe content"
call :safe_write_file "%base_dir%" "%test_file%" "%test_content%"
if %errorLevel% == 0 (
    echo [PASS] 成功写入文件: %test_file%
) else (
    echo [FAIL] 写入文件失败: %test_file%
)
echo.

:: 测试写入危险路径
echo [测试2] 写入危险路径
set "test_file=..\dangerous_file.txt"
set "test_content=Dangerous content"
call :safe_write_file "%base_dir%" "%test_file%" "%test_content%"
if %errorLevel% neq 0 (
    echo [PASS] 危险路径被拒绝
) else (
    echo [FAIL] 危险路径未被拒绝
)
echo.

:: 演示4：路径规范化
echo [演示4] 路径规范化
echo ----------------------------------------
echo 测试路径规范化：
echo.

:: 测试包含空格的路径
echo [测试1] 包含空格的路径
set "test_path=my document.txt"
call :normalize_path "%test_path%"
echo 原始路径: %test_path%
echo 规范化路径: %normalized_path%
echo.

:: 测试包含特殊字符的路径
echo [测试2] 包含特殊字符的路径
set "test_path=file (copy).txt"
call :normalize_path "%test_path%"
echo 原始路径: %test_path%
echo 规范化路径: %normalized_path%
echo.

:: 演示5：目录遍历防护
echo [演示5] 目录遍历防护
echo ----------------------------------------
echo 测试目录遍历防护：
echo.

:: 创建测试目录结构
echo [INFO] 创建测试目录结构...
mkdir "%base_dir%\test_dir" 2>nul
echo File in test_dir > "%base_dir%\test_dir\file.txt"
echo [%date% %time%] 创建测试目录结构 >> "%log_file%"

:: 测试安全目录遍历
echo [测试1] 安全目录遍历
call :safe_directory_traversal "%base_dir%\test_dir"
if %errorLevel% == 0 (
    echo [PASS] 安全目录遍历成功
) else (
    echo [FAIL] 安全目录遍历失败
)
echo.

:: 测试危险目录遍历
echo [测试2] 危险目录遍历
call :safe_directory_traversal "%base_dir%\..\..\Windows"
if %errorLevel% neq 0 (
    echo [PASS] 危险目录遍历被拒绝
) else (
    echo [FAIL] 危险目录遍历未被拒绝
)
echo.

:: 演示6：文件扩展名验证
echo [演示6] 文件扩展名验证
echo ----------------------------------------
echo 测试文件扩展名验证：
echo.

:: 测试允许的扩展名
echo [测试1] 允许的扩展名
set "test_file=document.txt"
call :validate_file_extension "%test_file%" ".txt .doc .pdf"
if %errorLevel% == 0 (
    echo [PASS] 允许的扩展名: %test_file%
) else (
    echo [FAIL] 扩展名验证失败: %test_file%
)
echo.

:: 测试禁止的扩展名
echo [测试2] 禁止的扩展名
set "test_file=malware.exe"
call :validate_file_extension "%test_file%" ".txt .doc .pdf"
if %errorLevel% neq 0 (
    echo [PASS] 禁止的扩展名被拒绝: %test_file%
) else (
    echo [FAIL] 禁止的扩展名未被拒绝: %test_file%
)
echo.

:: 演示7：安全最佳实践
echo [演示7] 路径安全最佳实践
echo ----------------------------------------
echo [BEST PRACTICE] 路径安全最佳实践：
echo 1. 始终验证路径在允许的目录范围内
echo 2. 使用绝对路径而不是相对路径
echo 3. 规范化路径以消除歧义
echo 4. 限制文件扩展名
echo 5. 验证文件存在性
echo 6. 检查文件权限
echo 7. 记录路径操作
echo 8. 使用安全的文件操作函数
echo.

:: 记录结束时间
echo [%date% %time%] 安全路径处理演示完成 >> "%log_file%"

:: 清理测试文件
echo [INFO] 清理测试文件...
if exist "%base_dir%" (
    rmdir /s /q "%base_dir%" 2>nul
    echo [%date% %time%] 清理测试目录 >> "%log_file%"
)

echo ============================================================
echo 安全路径处理演示完成
echo ============================================================
echo.
echo 日志文件: %log_file%
echo.
echo 按任意键退出...
pause >nul
exit /b 0

:: ============================================================
:: 路径处理函数
:: ============================================================

:safe_path_join
:: 安全地连接路径
set "base=%~1"
set "user_path=%~2"

:: 规范化基础路径
for %%i in ("%base%") do set "normalized_base=%%~fi"

:: 检查用户路径是否包含路径遍历
echo %user_path% | findstr /r "\.\." >nul
if %errorLevel% == 0 (
    echo [ERROR] 路径包含遍历攻击
    exit /b 1
)

:: 检查用户路径是否为绝对路径
echo %user_path% | findstr /r "^[A-Za-z]:" >nul
if %errorLevel% == 0 (
    echo [ERROR] 不允许使用绝对路径
    exit /b 1
)

:: 构建完整路径
set "full_path=%normalized_base%\%user_path%"

:: 规范化完整路径
for %%i in ("%full_path%") do set "full_path=%%~fi"

:: 验证完整路径是否在基础路径内
echo %full_path% | findstr /i "%normalized_base%" >nul
if %errorLevel% neq 0 (
    echo [ERROR] 路径超出安全范围
    exit /b 1
)

exit /b 0

:safe_read_file
:: 安全地读取文件
set "base=%~1"
set "file=%~2"

:: 验证路径
call :safe_path_join "%base%" "%file%"
if %errorLevel% neq 0 (
    exit /b 1
)

:: 检查文件是否存在
if not exist "%full_path%" (
    echo [ERROR] 文件不存在: %file%
    exit /b 1
)

:: 读取文件内容
echo [INFO] 读取文件: %full_path%
type "%full_path%"
exit /b 0

:safe_write_file
:: 安全地写入文件
set "base=%~1"
set "file=%~2"
set "content=%~3"

:: 验证路径
call :safe_path_join "%base%" "%file%"
if %errorLevel% neq 0 (
    exit /b 1
)

:: 写入文件内容
echo [INFO] 写入文件: %full_path%
echo %content% > "%full_path%"
exit /b 0

:normalize_path
:: 规范化路径
set "path_input=%~1"

:: 移除首尾空格
set "normalized_path=%path_input: =%"

:: 替换多个空格为单个空格
:normalize_spaces
set "temp=%normalized_path:  =%"
if "%temp%" neq "%normalized_path%" (
    set "normalized_path=%temp%"
    goto normalize_spaces
)

exit /b 0

:safe_directory_traversal
:: 安全的目录遍历
set "dir_path=%~1"

:: 检查目录是否存在
if not exist "%dir_path%" (
    echo [ERROR] 目录不存在: %dir_path%
    exit /b 1
)

:: 检查是否为目录
if not exist "%dir_path%\*" (
    echo [ERROR] 路径不是目录: %dir_path%
    exit /b 1
)

:: 检查路径遍历
echo %dir_path% | findstr /r "\.\." >nul
if %errorLevel% == 0 (
    echo [ERROR] 目录路径包含遍历攻击
    exit /b 1
)

:: 遍历目录
echo [INFO] 安全遍历目录: %dir_path%
for %%f in ("%dir_path%\*") do (
    echo 文件: %%~nxf
)
exit /b 0

:validate_file_extension
:: 验证文件扩展名
set "filename=%~1"
set "allowed_extensions=%~2"

:: 提取文件扩展名
for %%i in ("%filename%") do set "extension=%%~xi"

:: 检查扩展名是否在允许列表中
echo %allowed_extensions% | findstr /i "%extension%" >nul
if %errorLevel% neq 0 (
    echo [ERROR] 文件扩展名不允许: %extension%
    exit /b 1
)

exit /b 0