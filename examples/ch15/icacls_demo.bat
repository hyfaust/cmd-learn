@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: icacls_demo.bat - 文件权限操作演示
::
:: 安全提示：本脚本仅用于演示目的，不会实际修改系统权限
:: 所有权限操作仅在项目目录内进行
:: ============================================================

chcp 65001 >nul 2>&1

echo ============================================================
echo 文件权限操作演示 (icacls)
echo ============================================================
echo.

:: 设置工作目录
set "work_dir=%~dp0test_permissions"
set "log_file=%~dp0icacls_demo.log"

:: 记录开始时间
echo [%date% %time%] icacls演示开始 >> "%log_file%"

:: 创建测试目录
if not exist "%work_dir%" (
    echo [INFO] 创建测试目录: %work_dir%
    mkdir "%work_dir%"
    echo [%date% %time%] 创建测试目录: %work_dir% >> "%log_file%"
)

:: 创建测试文件
echo [INFO] 创建测试文件...
echo This is a test file for permission demo. > "%work_dir%\test_file.txt"
echo Another test file. > "%work_dir%\test_file2.txt"
echo [%date% %time%] 创建测试文件 >> "%log_file%"

:: 演示1：查看当前权限
echo.
echo [演示1] 查看当前文件权限
echo ----------------------------------------
echo 文件: test_file.txt
icacls "%work_dir%\test_file.txt"
echo.
echo 文件: test_file2.txt
icacls "%work_dir%\test_file2.txt"
echo.

:: 记录当前权限
echo [%date% %time%] 查看当前权限 >> "%log_file%"
icacls "%work_dir%\test_file.txt" >> "%log_file%" 2>&1

:: 演示2：查看目录权限
echo [演示2] 查看目录权限
echo ----------------------------------------
echo 目录: %work_dir%
icacls "%work_dir%"
echo.

:: 演示3：模拟权限修改（仅显示命令，不实际执行）
echo [演示3] 权限修改命令示例（模拟）
echo ----------------------------------------
echo 以下命令将授予当前用户读取权限：
echo icacls "%work_dir%\test_file.txt" /grant "%USERNAME%:(R)"
echo.
echo 以下命令将授予管理员完全控制权限：
echo icacls "%work_dir%\test_file.txt" /grant "Administrators:(F)"
echo.
echo 以下命令将移除所有继承的权限：
echo icacls "%work_dir%\test_file.txt" /inheritance:r
echo.
echo 以下命令将禁用继承并复制权限：
echo icacls "%work_dir%\test_file.txt" /inheritance:d
echo.

:: 演示4：实际执行安全的权限查看操作
echo [演示4] 实际执行权限查看操作
echo ----------------------------------------
echo 当前用户: %USERNAME%
echo 当前计算机: %COMPUTERNAME%
echo.

:: 显示当前用户的权限信息
echo [INFO] 当前用户权限信息:
whoami /groups | findstr /i "BUILTIN"
echo.

:: 演示5：模拟权限备份和恢复
echo [演示5] 权限备份和恢复示例（模拟）
echo ----------------------------------------
echo 备份权限到文件：
echo icacls "%work_dir%" /save "%work_dir%\permissions_backup.txt" /T
echo.
echo 从备份恢复权限：
echo icacls "%work_dir%" /restore "%work_dir%\permissions_backup.txt"
echo.

:: 演示6：安全警告和最佳实践
echo [演示6] 安全警告和最佳实践
echo ----------------------------------------
echo [WARNING] 以下操作需要管理员权限，请谨慎使用：
echo 1. takeown - 获取文件所有权
echo 2. icacls /grant - 修改权限
echo 3. icacls /inheritance - 修改继承设置
echo.
echo [BEST PRACTICE] 最佳实践：
echo 1. 使用最小权限原则
echo 2. 定期审查权限设置
echo 3. 记录所有权限变更
echo 4. 使用权限备份和恢复
echo 5. 避免使用完全控制权限
echo.

:: 演示7：错误处理示例
echo [演示7] 错误处理示例
echo ----------------------------------------
echo 检查文件是否存在：
if exist "%work_dir%\test_file.txt" (
    echo [SUCCESS] 文件存在
) else (
    echo [ERROR] 文件不存在
)
echo.

echo 检查目录是否存在：
if exist "%work_dir%" (
    echo [SUCCESS] 目录存在
) else (
    echo [ERROR] 目录不存在
)
echo.

:: 记录结束时间
echo [%date% %time%] icacls演示结束 >> "%log_file%"

:: 清理测试文件（可选）
echo [INFO] 清理测试文件...
if exist "%work_dir%\test_file.txt" del "%work_dir%\test_file.txt"
if exist "%work_dir%\test_file2.txt" del "%work_dir%\test_file2.txt"
if exist "%work_dir%" rmdir "%work_dir%" 2>nul

echo.
echo ============================================================
echo icacls演示完成
echo ============================================================
echo.
echo 日志文件: %log_file%
echo.
echo 按任意键退出...
pause >nul