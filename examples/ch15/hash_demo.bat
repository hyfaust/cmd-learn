@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: hash_demo.bat - 文件哈希计算演示
::
:: 安全提示：本脚本演示文件哈希计算和验证
:: 用于文件完整性检查和安全验证
:: ============================================================

chcp 65001 >nul 2>&1

echo ============================================================
echo 文件哈希计算演示
echo ============================================================
echo.

:: 设置日志文件
set "log_file=%~dp0hash_demo.log"

:: 设置测试目录
set "test_dir=%~dp0hash_test"

:: 记录开始时间
echo [%date% %time%] 哈希计算演示开始 >> "%log_file%"

:: 创建测试目录
if not exist "%test_dir%" (
    echo [INFO] 创建测试目录: %test_dir%
    mkdir "%test_dir%"
    echo [%date% %time%] 创建测试目录: %test_dir% >> "%log_file%"
)

:: 创建测试文件
echo [INFO] 创建测试文件...
echo This is a test file for hash calculation. > "%test_dir%\test_file1.txt"
echo Another test file with different content. > "%test_dir%\test_file2.txt"
echo Same content as file1. > "%test_dir%\test_file3.txt"
echo [%date% %time%] 创建测试文件 >> "%log_file%"

:: 演示1：基本哈希计算
echo [演示1] 基本哈希计算
echo ----------------------------------------
echo 计算文件的MD5和SHA256哈希值：
echo.

:: 计算MD5哈希
echo [测试1] 计算MD5哈希
echo 文件: test_file1.txt
certutil -hashfile "%test_dir%\test_file1.txt" MD5
echo.

:: 计算SHA256哈希
echo [测试2] 计算SHA256哈希
echo 文件: test_file1.txt
certutil -hashfile "%test_dir%\test_file1.txt" SHA256
echo.

:: 演示2：不同文件的哈希比较
echo [演示2] 不同文件的哈希比较
echo ----------------------------------------
echo 比较不同文件的哈希值：
echo.

echo [测试1] 文件1的MD5哈希
for /f "tokens=*" %%h in ('certutil -hashfile "%test_dir%\test_file1.txt" MD5 ^| findstr /v "CertUtil"') do (
    set "hash1=%%h"
    echo 文件1 MD5: !hash1!
)
echo.

echo [测试2] 文件2的MD5哈希
for /f "tokens=*" %%h in ('certutil -hashfile "%test_dir%\test_file2.txt" MD5 ^| findstr /v "CertUtil"') do (
    set "hash2=%%h"
    echo 文件2 MD5: !hash2!
)
echo.

echo [测试3] 文件3的MD5哈希
for /f "tokens=*" %%h in ('certutil -hashfile "%test_dir%\test_file3.txt" MD5 ^| findstr /v "CertUtil"') do (
    set "hash3=%%h"
    echo 文件3 MD5: !hash3!
)
echo.

:: 演示3：文件完整性检查
echo [演示3] 文件完整性检查
echo ----------------------------------------
echo 检查文件完整性：
echo.

:: 计算并保存哈希值
echo [INFO] 计算并保存哈希值...
set "hash_db=%test_dir%\hash_database.txt"

:: 清空哈希数据库
echo # 哈希数据库 - %date% %time% > "%hash_db%"
echo # 格式: 文件名 | MD5哈希 | SHA256哈希 >> "%hash_db%"

:: 计算每个文件的哈希并保存
for %%f in ("%test_dir%\*.txt") do (
    if "%%~nxf" neq "hash_database.txt" (
        echo 处理文件: %%~nxf
        
        :: 计算MD5
        for /f "tokens=*" %%m in ('certutil -hashfile "%%f" MD5 ^| findstr /v "CertUtil"') do (
            set "md5_hash=%%m"
        )
        
        :: 计算SHA256
        for /f "tokens=*" %%s in ('certutil -hashfile "%%f" SHA256 ^| findstr /v "CertUtil"') do (
            set "sha256_hash=%%s"
        )
        
        :: 保存到数据库
        echo %%~nxf ^| !md5_hash! ^| !sha256_hash! >> "%hash_db%"
    )
)

echo [INFO] 哈希数据库已保存到: %hash_db%
echo.

:: 显示哈希数据库内容
echo [INFO] 哈希数据库内容:
type "%hash_db%"
echo.

:: 演示4：哈希验证
echo [演示4] 哈希验证
echo ----------------------------------------
echo 验证文件哈希：
echo.

:: 模拟验证过程
echo [测试1] 验证文件完整性
set "verify_file=test_file1.txt"
set "expected_hash=expected_hash_value"

:: 计算当前哈希
for /f "tokens=*" %%h in ('certutil -hashfile "%test_dir%\%verify_file%" MD5 ^| findstr /v "CertUtil"') do (
    set "current_hash=%%h"
)

echo 文件: %verify_file%
echo 当前哈希: %current_hash%
echo 预期哈希: %expected_hash%
echo.

:: 演示5：哈希数据库比较
echo [演示5] 哈希数据库比较
echo ----------------------------------------
echo 比较当前哈希与数据库中的哈希：
echo.

:: 读取哈希数据库
for /f "tokens=1,2,3 delims=|" %%a in ('type "%hash_db%" ^| findstr /v "#"') do (
    set "db_filename=%%a"
    set "db_md5=%%b"
    set "db_sha256=%%c"
    
    :: 移除空格
    set "db_filename=!db_filename: =!"
    set "db_md5=!db_md5: =!"
    set "db_sha256=!db_sha256: =!"
    
    :: 计算当前哈希
    for /f "tokens=*" %%h in ('certutil -hashfile "%test_dir%\!db_filename!" MD5 ^| findstr /v "CertUtil"') do (
        set "current_md5=%%h"
    )
    
    :: 比较哈希
    echo 文件: !db_filename!
    echo 数据库MD5: !db_md5!
    echo 当前MD5: !current_md5!
    
    if "!db_md5!"=="!current_md5!" (
        echo [PASS] 哈希匹配 - 文件未修改
    ) else (
        echo [FAIL] 哈希不匹配 - 文件可能已修改
    )
    echo.
)

:: 演示6：模拟文件修改检测
echo [演示6] 文件修改检测
echo ----------------------------------------
echo 模拟文件修改并检测变化：
echo.

:: 修改文件内容
echo [INFO] 修改test_file1.txt的内容...
echo Modified content for testing. > "%test_dir%\test_file1.txt"
echo [%date% %time%] 修改test_file1.txt >> "%log_file%"

:: 重新计算哈希
for /f "tokens=*" %%h in ('certutil -hashfile "%test_dir%\test_file1.txt" MD5 ^| findstr /v "CertUtil"') do (
    set "new_hash=%%h"
)

echo 修改后的MD5哈希: %new_hash%
echo.

:: 演示7：Base64编码/解码
echo [演示7] Base64编码/解码
echo ----------------------------------------
echo 测试Base64编码和解码：
echo.

:: 创建测试文件
echo Hello, this is a test for Base64 encoding. > "%test_dir%\base64_test.txt"

:: 编码文件
echo [INFO] 编码文件到Base64...
certutil -encode "%test_dir%\base64_test.txt" "%test_dir%\base64_encoded.txt"
if %errorLevel% == 0 (
    echo [SUCCESS] 文件已编码
    echo 编码后的内容:
    type "%test_dir%\base64_encoded.txt"
) else (
    echo [ERROR] 编码失败
)
echo.

:: 解码文件
echo [INFO] 从Base64解码文件...
certutil -decode "%test_dir%\base64_encoded.txt" "%test_dir%\base64_decoded.txt"
if %errorLevel% == 0 (
    echo [SUCCESS] 文件已解码
    echo 解码后的内容:
    type "%test_dir%\base64_decoded.txt"
) else (
    echo [ERROR] 解码失败
)
echo.

:: 演示8：哈希算法比较
echo [演示8] 哈希算法比较
echo ----------------------------------------
echo 比较不同哈希算法：
echo.

echo 文件: test_file1.txt
echo.

echo MD5哈希:
certutil -hashfile "%test_dir%\test_file1.txt" MD5
echo.

echo SHA1哈希:
certutil -hashfile "%test_dir%\test_file1.txt" SHA1
echo.

echo SHA256哈希:
certutil -hashfile "%test_dir%\test_file1.txt" SHA256
echo.

echo SHA512哈希:
certutil -hashfile "%test_dir%\test_file1.txt" SHA512
echo.

:: 演示9：安全最佳实践
echo [演示9] 哈希安全最佳实践
echo ----------------------------------------
echo [BEST PRACTICE] 哈希安全最佳实践：
echo 1. 使用强哈希算法（SHA256或更高）
echo 2. 定期验证文件完整性
echo 3. 安全存储哈希数据库
echo 4. 使用数字签名验证来源
echo 5. 监控文件变化
echo 6. 记录哈希验证结果
echo 7. 备份重要文件的哈希值
echo 8. 使用盐值增强密码哈希
echo.

:: 记录结束时间
echo [%date% %time%] 哈希计算演示完成 >> "%log_file%"

:: 清理测试文件
echo [INFO] 清理测试文件...
if exist "%test_dir%" (
    rmdir /s /q "%test_dir%" 2>nul
    echo [%date% %time%] 清理测试目录 >> "%log_file%"
)

echo ============================================================
echo 哈希计算演示完成
echo ============================================================
echo.
echo 日志文件: %log_file%
echo.
echo 按任意键退出...
pause >nul