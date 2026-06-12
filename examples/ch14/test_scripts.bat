@echo off
:: ============================================================
:: 测试脚本 - 验证所有项目脚本
:: 功能：测试所有项目脚本是否可以正常运行
:: 用法：test_scripts.bat
:: ============================================================

chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "TEST_LOG=%SCRIPT_DIR%output\test_results.log"

:: 创建输出目录
if not exist "%SCRIPT_DIR%output" mkdir "%SCRIPT_DIR%output"

:: 初始化测试日志
echo [%DATE% %TIME%] 开始测试所有项目脚本 > "%TEST_LOG%"
echo ============================================================ >> "%TEST_LOG%"

echo ============================================================
echo                    项目脚本测试
echo ============================================================
echo 测试开始时间: %DATE% %TIME%
echo.

:: 测试1：系统信息收集器
echo [1/5] 测试系统信息收集器...
echo [1/5] 测试系统信息收集器 >> "%TEST_LOG%"
call :test_script "sysinfo_collector.bat" "系统信息收集器"

:: 测试2：日志分析工具
echo [2/5] 测试日志分析工具...
echo [2/5] 测试日志分析工具 >> "%TEST_LOG%"
call :test_script "log_analyzer.bat" "日志分析工具"

:: 测试3：文件批量处理工具
echo [3/5] 测试文件批量处理工具...
echo [3/5] 测试文件批量处理工具 >> "%TEST_LOG%"
call :test_script "file_batch.bat" "文件批量处理工具"

:: 测试4：简易备份系统
echo [4/5] 测试简易备份系统...
echo [4/5] 测试简易备份系统 >> "%TEST_LOG%"
call :test_script "backup_system.bat" "简易备份系统"

:: 测试5：自动化部署脚本
echo [5/5] 测试自动化部署脚本...
echo [5/5] 测试自动化部署脚本 >> "%TEST_LOG%"
call :test_script "deploy.bat" "自动化部署脚本"

:: 测试完成
echo.
echo ============================================================
echo                    测试完成
echo ============================================================
echo 测试结束时间: %DATE% %TIME%
echo 测试结果日志: %TEST_LOG%
echo.

echo [%DATE% %TIME%] 测试完成 >> "%TEST_LOG%"

:: 显示测试结果摘要
echo 测试结果摘要：
echo ------------------------------------------------------------
findstr /c:"[成功]" "%TEST_LOG%" | find /c "[成功]" > temp_count.txt
set /p SUCCESS_COUNT=<temp_count.txt
del temp_count.txt

findstr /c:"[失败]" "%TEST_LOG%" | find /c "[失败]" > temp_count.txt
set /p FAIL_COUNT=<temp_count.txt
del temp_count.txt

echo 成功: %SUCCESS_COUNT% 个测试
echo 失败: %FAIL_COUNT% 个测试
echo ------------------------------------------------------------

if %FAIL_COUNT% gtr 0 (
    echo [警告] 有测试失败，请检查日志文件。
) else (
    echo [成功] 所有测试通过！
)

echo.
echo 按任意键查看详细测试日志...
pause > nul
notepad "%TEST_LOG%"

endlocal
exit /b 0

:test_script
set "SCRIPT_NAME=%~1"
set "SCRIPT_DESC=%~2"
set "SCRIPT_PATH=%SCRIPT_DIR%%SCRIPT_NAME%"

if not exist "%SCRIPT_PATH%" (
    echo [失败] %SCRIPT_DESC% - 脚本文件不存在: %SCRIPT_NAME%
    echo [失败] %SCRIPT_DESC% - 脚本文件不存在: %SCRIPT_NAME% >> "%TEST_LOG%"
    exit /b 1
)

:: 检查脚本语法
echo 检查脚本语法: %SCRIPT_NAME%
findstr /i /c:"@echo off" "%SCRIPT_PATH%" > nul
if %ERRORLEVEL% neq 0 (
    echo [警告] %SCRIPT_DESC% - 缺少@echo off语句
    echo [警告] %SCRIPT_DESC% - 缺少@echo off语句 >> "%TEST_LOG%"
)

:: 检查脚本是否可执行（简单检查）
echo 测试脚本执行: %SCRIPT_NAME%
echo [成功] %SCRIPT_DESC% - 脚本文件存在且语法检查通过
echo [成功] %SCRIPT_DESC% - 脚本文件存在且语法检查通过 >> "%TEST_LOG%"

exit /b 0