@echo off
chcp 65001 >nul
REM ============================================
REM 环境变量导出演示
REM 文件: env_export.bat
REM 作者: 教程工程师
REM 日期: 2026-06-11
REM 安全提示: 本脚本仅导出环境变量，不会修改系统配置
REM ============================================

setlocal enabledelayedexpansion

echo ============================================
echo 环境变量导出演示
echo ============================================
echo.

echo [1] 创建导出目录
echo ----------------------------------------
set "EXPORT_DIR=%USERPROFILE%\env_export_%date:~0,4%%date:~5,2%%date:~8,2%"
if not exist "!EXPORT_DIR!" mkdir "!EXPORT_DIR!"
echo 导出目录: !EXPORT_DIR!
echo.

echo [2] 导出用户环境变量到文本文件
echo ----------------------------------------
set "USER_ENV_FILE=!EXPORT_DIR!\user_env_vars.txt"
echo 用户环境变量文件: !USER_ENV_FILE!
echo 用户环境变量导出 > "!USER_ENV_FILE!"
echo 导出时间: %date% %time% >> "!USER_ENV_FILE!"
echo ==================== >> "!USER_ENV_FILE!"
reg query "HKCU\Environment" >> "!USER_ENV_FILE!"
echo 导出完成
echo.

echo [3] 导出系统环境变量到文本文件
echo ----------------------------------------
set "SYS_ENV_FILE=!EXPORT_DIR!\system_env_vars.txt"
echo 系统环境变量文件: !SYS_ENV_FILE!
echo 系统环境变量导出 > "!SYS_ENV_FILE!"
echo 导出时间: %date% %time% >> "!SYS_ENV_FILE!"
echo ==================== >> "!SYS_ENV_FILE!"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" >> "!SYS_ENV_FILE!" 2>nul
echo 导出完成
echo.

echo [4] 导出环境变量到注册表文件
echo ----------------------------------------
set "USER_REG_FILE=!EXPORT_DIR!\user_env.reg"
set "SYS_REG_FILE=!EXPORT_DIR!\system_env.reg"
echo 用户环境变量注册表文件: !USER_REG_FILE!
echo 系统环境变量注册表文件: !SYS_REG_FILE!
reg export "HKCU\Environment" "!USER_REG_FILE!" /y
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "!SYS_REG_FILE!" /y 2>nul
echo 导出完成
echo.

echo [5] 创建环境变量批处理文件
echo ----------------------------------------
set "ENV_BATCH_FILE=!EXPORT_DIR!\set_env_vars.bat"
echo 环境变量批处理文件: !ENV_BATCH_FILE!
echo @echo off > "!ENV_BATCH_FILE!"
echo REM 环境变量恢复脚本 >> "!ENV_BATCH_FILE!"
echo REM 导出时间: %date% %time% >> "!ENV_BATCH_FILE!"
echo. >> "!ENV_BATCH_FILE!"

REM 导出用户环境变量到批处理文件
for /f "tokens=1,2,3" %%A in ('reg query "HKCU\Environment" 2^>nul') do (
    if not "%%A"=="" (
        if not "%%B"=="" (
            echo set "%%A=%%C" >> "!ENV_BATCH_FILE!"
        )
    )
)
echo 批处理文件创建完成
echo.

echo [6] 创建环境变量配置文件
echo ----------------------------------------
set "CONFIG_FILE=!EXPORT_DIR!\env_config.json"
echo 配置文件: !CONFIG_FILE!
echo { > "!CONFIG_FILE!"
echo   "export_date": "%date% %time%", >> "!CONFIG_FILE!"
echo   "user": "%USERNAME%", >> "!CONFIG_FILE!"
echo   "computer": "%COMPUTERNAME%", >> "!CONFIG_FILE!"
echo   "environment_variables": { >> "!CONFIG_FILE!"

set first=1
for /f "tokens=1,2,3" %%A in ('reg query "HKCU\Environment" 2^>nul') do (
    if not "%%A"=="" (
        if not "%%B"=="" (
            if !first!==1 (
                echo     "%%A": "%%C" >> "!CONFIG_FILE!"
                set first=0
            ) else (
                echo     ,"%%A": "%%C" >> "!CONFIG_FILE!"
            )
        )
    )
)

echo   } >> "!CONFIG_FILE!"
echo } >> "!CONFIG_FILE!"
echo 配置文件创建完成
echo.

echo [7] 创建环境变量报告
echo ----------------------------------------
set "REPORT_FILE=!EXPORT_DIR!\env_report.txt"
echo 报告文件: !REPORT_FILE!
echo 环境变量报告 > "!REPORT_FILE!"
echo ================ >> "!REPORT_FILE!"
echo 生成时间: %date% %time% >> "!REPORT_FILE!"
echo 用户: %USERNAME% >> "!REPORT_FILE!"
echo 计算机: %COMPUTERNAME% >> "!REPORT_FILE!"
echo. >> "!REPORT_FILE!"

echo 用户环境变量 >> "!REPORT_FILE!"
echo ------------ >> "!REPORT_FILE!"
for /f "tokens=1,2,3" %%A in ('reg query "HKCU\Environment" 2^>nul') do (
    if not "%%A"=="" (
        if not "%%B"=="" (
            echo %%A = %%C >> "!REPORT_FILE!"
        )
    )
)
echo. >> "!REPORT_FILE!"

echo 系统环境变量 >> "!REPORT_FILE!"
echo ------------ >> "!REPORT_FILE!"
for /f "tokens=1,2,3" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" 2^>nul') do (
    if not "%%A"=="" (
        if not "%%B"=="" (
            echo %%A = %%C >> "!REPORT_FILE!"
        )
    )
)
echo. >> "!REPORT_FILE!"

echo PATH变量详情 >> "!REPORT_FILE!"
echo ------------ >> "!REPORT_FILE!"
echo PATH = %PATH% >> "!REPORT_FILE!"
echo. >> "!REPORT_FILE!"

echo 报告创建完成
echo.

echo [8] 创建恢复脚本
echo ----------------------------------------
set "RESTORE_SCRIPT=!EXPORT_DIR!\restore_env.bat"
echo 恢复脚本: !RESTORE_SCRIPT!
echo @echo off > "!RESTORE_SCRIPT!"
echo REM 环境变量恢复脚本 >> "!RESTORE_SCRIPT!"
echo REM 警告: 运行此脚本将恢复导出时的环境变量 >> "!RESTORE_SCRIPT!"
echo. >> "!RESTORE_SCRIPT!"
echo echo 正在恢复环境变量... >> "!RESTORE_SCRIPT!"
echo reg import "!USER_REG_FILE!" >> "!RESTORE_SCRIPT!"
echo if %%errorLevel%% equ 0 ( >> "!RESTORE_SCRIPT!"
echo     echo 用户环境变量恢复成功 >> "!RESTORE_SCRIPT!"
echo ) else ( >> "!RESTORE_SCRIPT!"
echo     echo 用户环境变量恢复失败 >> "!RESTORE_SCRIPT!"
echo ) >> "!RESTORE_SCRIPT!"
echo. >> "!RESTORE_SCRIPT!"
echo echo 恢复完成，请新开CMD窗口查看效果 >> "!RESTORE_SCRIPT!"
echo pause >> "!RESTORE_SCRIPT!"
echo 恢复脚本创建完成
echo.

echo [9] 显示导出结果
echo ----------------------------------------
echo 导出目录内容:
dir "!EXPORT_DIR!" /b
echo.
echo 文件大小信息:
for %%F in ("!EXPORT_DIR!\*") do (
    echo %%~nxF: %%~zF 字节
)
echo.

echo [10] 导出文件验证
echo ----------------------------------------
echo 验证导出文件是否完整...
if exist "!USER_ENV_FILE!" (
    echo ✓ 用户环境变量文件存在
) else (
    echo ✗ 用户环境变量文件缺失
)

if exist "!USER_REG_FILE!" (
    echo ✓ 用户环境变量注册表文件存在
) else (
    echo ✗ 用户环境变量注册表文件缺失
)

if exist "!ENV_BATCH_FILE!" (
    echo ✓ 环境变量批处理文件存在
) else (
    echo ✗ 环境变量批处理文件缺失
)

if exist "!CONFIG_FILE!" (
    echo ✓ 配置文件存在
) else (
    echo ✗ 配置文件缺失
)
echo.

echo ============================================
echo 环境变量导出演示完成
echo ============================================
echo.
echo 导出文件位置: !EXPORT_DIR!
echo.
echo 文件说明:
echo 1. user_env_vars.txt - 用户环境变量文本格式
echo 2. system_env_vars.txt - 系统环境变量文本格式
echo 3. user_env.reg - 用户环境变量注册表格式
echo 4. system_env.reg - 系统环境变量注册表格式
echo 5. set_env_vars.bat - 环境变量批处理脚本
echo 6. env_config.json - JSON格式配置文件
echo 7. env_report.txt - 环境变量详细报告
echo 8. restore_env.bat - 环境变量恢复脚本
echo.
echo 使用建议:
echo 1. 定期备份环境变量
echo 2. 在不同计算机间迁移配置
echo 3. 系统重装前备份
echo 4. 开发环境配置共享
echo.

pause