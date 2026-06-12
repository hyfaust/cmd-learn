@echo off
chcp 65001 >nul
REM ============================================
REM 注册表写入演示
REM 文件: reg_write.bat
REM 作者: 教程工程师
REM 日期: 2026-06-11
REM 安全提示: 本脚本仅在安全位置演示注册表写入操作
REM         不会修改系统关键注册表项
REM         演示完成后会清理创建的测试项
REM ============================================

setlocal enabledelayedexpansion

echo ============================================
echo 注册表写入演示
echo ============================================
echo.
echo 警告: 本脚本将修改注册表！
echo 仅在 HKCU\Environment 位置创建测试值
echo 演示完成后会自动清理
echo.
pause

echo.
echo [1] 备份当前环境变量注册表项
echo ----------------------------------------
set "BACKUP_FILE=%USERPROFILE%\env_backup_%date:~0,4%%date:~5,2%%date:~8,2%.reg"
echo 备份文件: !BACKUP_FILE!
reg export "HKCU\Environment" "!BACKUP_FILE!" /y
if %errorLevel% equ 0 (
    echo 备份成功
) else (
    echo 备份失败，继续演示...
)
echo.

echo [2] 添加新的环境变量（测试）
echo ----------------------------------------
echo 添加测试变量 TEST_REG_VAR...
reg add "HKCU\Environment" /v "TEST_REG_VAR" /t REG_SZ /d "Test Value from CMD" /f
if %errorLevel% equ 0 (
    echo 测试变量添加成功
) else (
    echo 测试变量添加失败
)
echo.

echo [3] 查询添加的变量
echo ----------------------------------------
echo 查询 TEST_REG_VAR:
reg query "HKCU\Environment" /v "TEST_REG_VAR"
echo.

echo [4] 修改环境变量值
echo ----------------------------------------
echo 修改 TEST_REG_VAR 的值...
reg add "HKCU\Environment" /v "TEST_REG_VAR" /t REG_SZ /d "Modified Value" /f
if %errorLevel% equ 0 (
    echo 变量修改成功
) else (
    echo 变量修改失败
)
echo.

echo [5] 查询修改后的变量
echo ----------------------------------------
echo 查询修改后的 TEST_REG_VAR:
reg query "HKCU\Environment" /v "TEST_REG_VAR"
echo.

echo [6] 添加带空格的路径值
echo ----------------------------------------
echo 添加路径变量 TEST_PATH...
reg add "HKCU\Environment" /v "TEST_PATH" /t REG_EXPAND_SZ /d "C:\Program Files\Test Folder" /f
if %errorLevel% equ 0 (
    echo 路径变量添加成功
) else (
    echo 路径变量添加失败
)
echo.

echo [7] 查询路径变量
echo ----------------------------------------
echo 查询 TEST_PATH:
reg query "HKCU\Environment" /v "TEST_PATH"
echo.

echo [8] 添加DWORD类型变量
echo ----------------------------------------
echo 添加数值变量 TEST_NUMBER...
reg add "HKCU\Environment" /v "TEST_NUMBER" /t REG_DWORD /d 42 /f
if %errorLevel% equ 0 (
    echo 数值变量添加成功
) else (
    echo 数值变量添加失败
)
echo.

echo [9] 查询所有测试变量
echo ----------------------------------------
echo 查询所有测试变量:
reg query "HKCU\Environment" /v "TEST_REG_VAR"
reg query "HKCU\Environment" /v "TEST_PATH"
reg query "HKCU\Environment" /v "TEST_NUMBER"
echo.

echo [10] 清理测试变量
echo ----------------------------------------
echo 删除测试变量...
reg delete "HKCU\Environment" /v "TEST_REG_VAR" /f
reg delete "HKCU\Environment" /v "TEST_PATH" /f
reg delete "HKCU\Environment" /v "TEST_NUMBER" /f
echo 测试变量已清理
echo.

echo [11] 验证清理结果
echo ----------------------------------------
echo 验证测试变量是否已删除:
reg query "HKCU\Environment" /v "TEST_REG_VAR" 2>nul && echo 变量仍存在 || echo 变量已删除
reg query "HKCU\Environment" /v "TEST_PATH" 2>nul && echo 变量仍存在 || echo 变量已删除
reg query "HKCU\Environment" /v "TEST_NUMBER" 2>nul && echo 变量仍存在 || echo 变量已删除
echo.

echo [12] 注册表写入最佳实践
echo ----------------------------------------
echo 1. 始终备份注册表项
echo 2. 仅在安全位置进行测试
echo 3. 使用 /f 参数避免确认提示
echo 4. 测试完成后清理测试数据
echo 5. 避免修改系统关键注册表项
echo 6. 记录所有修改内容
echo 7. 测试修改的影响
echo.

echo ============================================
echo 注册表写入演示完成
echo ============================================
echo.
echo 提示: 本演示仅在 HKCU\Environment 位置创建测试值
echo 系统关键注册表项未受影响
echo.
echo 如需恢复原始环境变量，请导入备份文件:
echo reg import "!BACKUP_FILE!"
echo.

pause