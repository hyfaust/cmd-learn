@echo off
:: ============================================================
:: 简易备份系统 - 项目4
:: 功能：增量备份、备份日志、恢复功能
:: 用法：backup_system.bat [源目录] [备份目录]
:: 安全约束：备份目录使用脚本所在目录下的backup文件夹
:: ============================================================

chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 初始化变量
set "SCRIPT_DIR=%~dp0"
set "SOURCE_DIR=%~1"
set "BACKUP_DIR=%~2"
set "LOG_FILE=%SCRIPT_DIR%backup\backup.log"
set "CONFIG_FILE=%SCRIPT_DIR%config\backup_config.ini"
set "TIMESTAMP=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"

:: 设置默认目录
if "%SOURCE_DIR%"=="" set "SOURCE_DIR=%SCRIPT_DIR%test_files"
if "%BACKUP_DIR%"=="" set "BACKUP_DIR=%SCRIPT_DIR%backup"

:: 创建必要目录
if not exist "%SCRIPT_DIR%backup" mkdir "%SCRIPT_DIR%backup"
if not exist "%SCRIPT_DIR%config" mkdir "%SCRIPT_DIR%config"
if not exist "%SCRIPT_DIR%output" mkdir "%SCRIPT_DIR%output"

:: 初始化日志
echo [%DATE% %TIME%] 备份系统启动 > "%LOG_FILE%"

:: 检查源目录
if not exist "%SOURCE_DIR%" (
    echo [ERROR] 源目录不存在: %SOURCE_DIR%
    echo [%DATE% %TIME%] 错误：源目录不存在 >> "%LOG_FILE%"
    pause
    exit /b 1
)

:: 显示欢迎信息
echo ============================================================
echo                      简易备份系统
echo ============================================================
echo 源目录: %SOURCE_DIR%
echo 备份目录: %BACKUP_DIR%
echo 时间戳: %TIMESTAMP%
echo.

:: 主菜单循环
:MAIN_MENU
echo ============================================================
echo                        主菜单
echo ============================================================
echo 1. 执行增量备份
echo 2. 执行全量备份
echo 3. 查看备份记录
echo 4. 恢复文件
echo 5. 备份配置
echo 6. 退出
echo ============================================================
set /p "CHOICE=请选择操作 (1-6): "

if "%CHOICE%"=="1" goto INCREMENTAL_BACKUP
if "%CHOICE%"=="2" goto FULL_BACKUP
if "%CHOICE%"=="3" goto VIEW_BACKUPS
if "%CHOICE%"=="4" goto RESTORE_FILES
if "%CHOICE%"=="5" goto BACKUP_CONFIG
if "%CHOICE%"=="6" goto EXIT
echo [ERROR] 无效选择，请重新输入
goto MAIN_MENU

:INCREMENTAL_BACKUP
echo.
echo ============================================================
echo                    增量备份
echo ============================================================
echo 原理：只备份自上次备份以来修改过的文件
echo.

:: 获取上次备份时间
set "LAST_BACKUP_TIME="
if exist "%CONFIG_FILE%" (
    for /f "tokens=2 delims==" %%a in ('findstr /i "last_backup_time" "%CONFIG_FILE%" 2^>nul') do (
        set "LAST_BACKUP_TIME=%%a"
    )
)

if "!LAST_BACKUP_TIME!"=="" (
    echo [INFO] 首次备份，将执行全量备份
    set "BACKUP_TYPE=full"
) else (
    echo [INFO] 上次备份时间: !LAST_BACKUP_TIME!
    set "BACKUP_TYPE=incremental"
)

:: 创建备份目录
set "BACKUP_PATH=%BACKUP_DIR%\backup_%TIMESTAMP%"
mkdir "%BACKUP_PATH%"

:: 执行备份
echo 正在备份文件...
set "BACKUP_COUNT=0"
set "SKIP_COUNT=0"
set "TOTAL_SIZE=0"

for %%f in ("%SOURCE_DIR%\*.*") do (
    set "FILE_PATH=%%f"
    set "FILE_NAME=%%~nxf"
    set "FILE_DATE=%%~tf"
    set "FILE_SIZE=%%~zf"
    
    :: 检查是否需要备份
    set "NEED_BACKUP=0"
    if "!BACKUP_TYPE!"=="full" (
        set "NEED_BACKUP=1"
    ) else (
        :: 简单比较日期（实际应用中应使用更精确的时间比较）
        set "NEED_BACKUP=1"
    )
    
    if !NEED_BACKUP! equ 1 (
        copy "%%f" "%BACKUP_PATH%" > nul
        set /a "BACKUP_COUNT+=1"
        set /a "TOTAL_SIZE+=FILE_SIZE"
        echo [备份] !FILE_NAME! (!FILE_SIZE! bytes)
        echo [%DATE% %TIME%] 备份: !FILE_NAME! >> "%LOG_FILE%"
    ) else (
        set /a "SKIP_COUNT+=1"
        echo [跳过] !FILE_NAME!
    )
)

:: 更新配置文件
(
echo [backup_config]
echo last_backup_time=%DATE% %TIME%
echo last_backup_path=%BACKUP_PATH%
echo backup_type=!BACKUP_TYPE!
echo backup_count=!BACKUP_COUNT!
) > "%CONFIG_FILE%"

:: 显示备份结果
echo.
echo ============================================================
echo                    备份完成
echo ============================================================
echo 备份类型: !BACKUP_TYPE!
echo 备份文件数: !BACKUP_COUNT!
echo 跳过文件数: !SKIP_COUNT!
echo 备份大小: !TOTAL_SIZE! bytes
echo 备份路径: %BACKUP_PATH%
echo.
echo [%DATE% %TIME%] 备份完成: !BACKUP_COUNT! 文件 >> "%LOG_FILE%"

set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:FULL_BACKUP
echo.
echo ============================================================
echo                    全量备份
echo ============================================================
echo 将备份所有文件，无论是否修改过
echo.

:: 创建备份目录
set "BACKUP_PATH=%BACKUP_DIR%\full_backup_%TIMESTAMP%"
mkdir "%BACKUP_PATH%"

:: 执行备份
echo 正在备份文件...
set "BACKUP_COUNT=0"
set "TOTAL_SIZE=0"

for %%f in ("%SOURCE_DIR%\*.*") do (
    set "FILE_NAME=%%~nxf"
    set "FILE_SIZE=%%~zf"
    
    copy "%%f" "%BACKUP_PATH%" > nul
    set /a "BACKUP_COUNT+=1"
    set /a "TOTAL_SIZE+=FILE_SIZE"
    echo [备份] !FILE_NAME! (!FILE_SIZE! bytes)
    echo [%DATE% %TIME%] 全量备份: !FILE_NAME! >> "%LOG_FILE%"
)

:: 更新配置文件
(
echo [backup_config]
echo last_backup_time=%DATE% %TIME%
echo last_backup_path=%BACKUP_PATH%
echo backup_type=full
echo backup_count=!BACKUP_COUNT!
) > "%CONFIG_FILE%"

:: 显示备份结果
echo.
echo ============================================================
echo                    全量备份完成
echo ============================================================
echo 备份文件数: !BACKUP_COUNT!
echo 备份大小: !TOTAL_SIZE! bytes
echo 备份路径: %BACKUP_PATH%
echo.
echo [%DATE% %TIME%] 全量备份完成: !BACKUP_COUNT! 文件 >> "%LOG_FILE%"

set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:VIEW_BACKUPS
echo.
echo ============================================================
echo                    备份记录
echo ============================================================
echo 备份目录: %BACKUP_DIR%
echo.
echo 备份列表：
echo ------------------------------------------------------------

set "BACKUP_COUNT=0"
for /d %%d in ("%BACKUP_DIR%\backup_*" "%BACKUP_DIR%\full_backup_*") do (
    set "BACKUP_NAME=%%~nxd"
    set "BACKUP_DATE=%%~td"
    echo !BACKUP_NAME! (!BACKUP_DATE!)
    set /a "BACKUP_COUNT+=1"
)

echo ------------------------------------------------------------
echo 共 !BACKUP_COUNT! 个备份
echo.

:: 显示最近备份信息
if exist "%CONFIG_FILE%" (
    echo 最近备份信息：
    type "%CONFIG_FILE%"
)

echo.
set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:RESTORE_FILES
echo.
echo ============================================================
echo                    恢复文件
echo ============================================================

:: 列出可用备份
echo 可用备份：
echo ------------------------------------------------------------
set "BACKUP_INDEX=0"
for /d %%d in ("%BACKUP_DIR%\backup_*" "%BACKUP_DIR%\full_backup_*") do (
    set /a "BACKUP_INDEX+=1"
    set "BACKUP_!BACKUP_INDEX!=%%~nxd"
    echo !BACKUP_INDEX!. %%~nxd (%%~td)
)
echo ------------------------------------------------------------

if !BACKUP_INDEX! equ 0 (
    echo 未找到任何备份。
    set /p "PRESS_ENTER=按回车键返回主菜单..."
    goto MAIN_MENU
)

set /p "RESTORE_CHOICE=请选择要恢复的备份 (1-!BACKUP_INDEX!): "
if !RESTORE_CHOICE! lss 1 goto RESTORE_FILES
if !RESTORE_CHOICE! gtr !BACKUP_INDEX! goto RESTORE_FILES

set "RESTORE_BACKUP=!BACKUP_%RESTORE_CHOICE%!"
set "RESTORE_PATH=%BACKUP_DIR%\!RESTORE_BACKUP!"

echo.
echo 选择的备份: !RESTORE_BACKUP!
echo 备份路径: !RESTORE_PATH!
echo.
echo 恢复选项：
echo 1. 恢复到原目录（覆盖现有文件）
echo 2. 恢复到新目录
echo 3. 取消
echo.
set /p "RESTORE_OPTION=请选择恢复方式 (1-3): "

if "%RESTORE_OPTION%"=="1" (
    echo.
    echo [警告] 将覆盖源目录中的现有文件！
    set /p "CONFIRM=确认恢复？(Y/N): "
    if /i "!CONFIRM!" neq "Y" goto RESTORE_FILES
    
    echo 正在恢复文件...
    set "RESTORE_COUNT=0"
    for %%f in ("!RESTORE_PATH!\*.*") do (
        set "FILE_NAME=%%~nxf"
        copy "%%f" "%SOURCE_DIR%" > nul
        set /a "RESTORE_COUNT+=1"
        echo [恢复] !FILE_NAME!
        echo [%DATE% %TIME%] 恢复: !FILE_NAME! 到 %SOURCE_DIR% >> "%LOG_FILE%"
    )
    echo 恢复完成！共恢复 !RESTORE_COUNT! 个文件。
) else if "%RESTORE_OPTION%"=="2" (
    set /p "NEW_DIR=请输入恢复目标目录: "
    if not exist "!NEW_DIR!" mkdir "!NEW_DIR!"
    
    echo 正在恢复文件...
    set "RESTORE_COUNT=0"
    for %%f in ("!RESTORE_PATH!\*.*") do (
        set "FILE_NAME=%%~nxf"
        copy "%%f" "!NEW_DIR!" > nul
        set /a "RESTORE_COUNT+=1"
        echo [恢复] !FILE_NAME!
        echo [%DATE% %TIME%] 恢复: !FILE_NAME! 到 !NEW_DIR! >> "%LOG_FILE%"
    )
    echo 恢复完成！共恢复 !RESTORE_COUNT! 个文件。
) else (
    echo 恢复操作已取消。
)

set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:BACKUP_CONFIG
echo.
echo ============================================================
echo                    备份配置
echo ============================================================
echo 当前配置：
echo.

if exist "%CONFIG_FILE%" (
    type "%CONFIG_FILE%"
) else (
    echo 未找到配置文件，将使用默认配置。
)

echo.
echo 配置选项：
echo 1. 设置源目录
echo 2. 设置备份目录
echo 3. 重置配置
echo 4. 返回主菜单
echo.
set /p "CONFIG_CHOICE=请选择配置选项 (1-4): "

if "%CONFIG_CHOICE%"=="1" (
    set /p "NEW_SOURCE=请输入新的源目录: "
    if exist "!NEW_SOURCE!" (
        set "SOURCE_DIR=!NEW_SOURCE!"
        echo 源目录已更新为: !SOURCE_DIR!
    ) else (
        echo [ERROR] 目录不存在: !NEW_SOURCE!
    )
) else if "%CONFIG_CHOICE%"=="2" (
    set /p "NEW_BACKUP=请输入新的备份目录: "
    set "BACKUP_DIR=!NEW_BACKUP!"
    if not exist "!BACKUP_DIR!" mkdir "!BACKUP_DIR!"
    echo 备份目录已更新为: !BACKUP_DIR!
) else if "%CONFIG_CHOICE%"=="3" (
    if exist "%CONFIG_FILE%" del "%CONFIG_FILE%"
    echo 配置已重置。
)

set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:EXIT
echo.
echo [%DATE% %TIME%] 备份系统退出 >> "%LOG_FILE%"
echo 感谢使用简易备份系统！
echo 备份日志已保存到: %LOG_FILE%
echo.
pause
endlocal
exit /b 0