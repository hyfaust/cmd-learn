@echo off
:: ============================================================
:: 文件批量处理工具 - 项目3
:: 功能：批量重命名、修改扩展名、移动/复制文件
:: 用法：file_batch.bat [目标目录]
:: 安全约束：操作前显示预览，需用户确认
:: ============================================================

chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 初始化变量
set "SCRIPT_DIR=%~dp0"
set "TARGET_DIR=%~1"
if "%TARGET_DIR%"=="" set "TARGET_DIR=%SCRIPT_DIR%test_files"
set "LOG_FILE=%SCRIPT_DIR%output\batch_operations.log"
set "BACKUP_DIR=%SCRIPT_DIR%backup"

:: 创建必要目录
if not exist "%SCRIPT_DIR%output" mkdir "%SCRIPT_DIR%output"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

:: 初始化日志
echo [%DATE% %TIME%] 文件批量处理工具启动 > "%LOG_FILE%"

:: 检查目标目录
if not exist "%TARGET_DIR%" (
    echo [ERROR] 目标目录不存在: %TARGET_DIR%
    echo 正在创建测试目录...
    mkdir "%TARGET_DIR%"
    echo [INFO] 已创建测试目录: %TARGET_DIR%
    echo [%DATE% %TIME%] 创建测试目录: %TARGET_DIR% >> "%LOG_FILE%"
)

:: 显示欢迎信息
echo ============================================================
echo                    文件批量处理工具
echo ============================================================
echo 目标目录: %TARGET_DIR%
echo 日志文件: %LOG_FILE%
echo.

:: 主菜单循环
:MAIN_MENU
echo ============================================================
echo                        主菜单
echo ============================================================
echo 1. 批量重命名文件
echo 2. 批量修改扩展名
echo 3. 批量移动文件
echo 4. 批量复制文件
echo 5. 查看目录文件列表
echo 6. 退出
echo ============================================================
set /p "CHOICE=请选择操作 (1-6): "

if "%CHOICE%"=="1" goto RENAME_FILES
if "%CHOICE%"=="2" goto CHANGE_EXTENSION
if "%CHOICE%"=="3" goto MOVE_FILES
if "%CHOICE%"=="4" goto COPY_FILES
if "%CHOICE%"=="5" goto LIST_FILES
if "%CHOICE%"=="6" goto EXIT
echo [ERROR] 无效选择，请重新输入
goto MAIN_MENU

:RENAME_FILES
echo.
echo ============================================================
echo                    批量重命名文件
echo ============================================================
echo 1. 添加前缀
echo 2. 添加后缀
echo 3. 添加序号
echo 4. 返回主菜单
echo ============================================================
set /p "RENAME_CHOICE=请选择重命名方式 (1-4): "

if "%RENAME_CHOICE%"=="1" goto ADD_PREFIX
if "%RENAME_CHOICE%"=="2" goto ADD_SUFFIX
if "%RENAME_CHOICE%"=="3" goto ADD_SEQUENCE
if "%RENAME_CHOICE%"=="4" goto MAIN_MENU
echo [ERROR] 无效选择
goto RENAME_FILES

:ADD_PREFIX
set /p "PREFIX=请输入前缀: "
echo.
echo 预览重命名结果：
echo ------------------------------------------------------------
set "COUNT=0"
for %%f in ("%TARGET_DIR%\*.*") do (
    set "FILENAME=%%~nxf"
    echo !FILENAME! -^> %PREFIX%!FILENAME!
    set /a "COUNT+=1"
)
echo ------------------------------------------------------------
echo 共 %COUNT% 个文件
echo.
set /p "CONFIRM=确认执行重命名？(Y/N): "
if /i "%CONFIRM%" neq "Y" goto RENAME_FILES

echo 正在重命名...
set "RENAMED=0"
for %%f in ("%TARGET_DIR%\*.*") do (
    set "FILENAME=%%~nxf"
    ren "%%f" "%PREFIX%!FILENAME!"
    set /a "RENAMED+=1"
    echo [%DATE% %TIME%] 重命名: !FILENAME! -^> %PREFIX%!FILENAME! >> "%LOG_FILE%"
)
echo 完成！已重命名 %RENAMED% 个文件。
goto RENAME_FILES

:ADD_SUFFIX
set /p "SUFFIX=请输入后缀（不含点号）: "
echo.
echo 预览重命名结果：
echo ------------------------------------------------------------
set "COUNT=0"
for %%f in ("%TARGET_DIR%\*.*") do (
    set "FILENAME=%%~nf"
    set "EXT=%%~xf"
    echo !FILENAME!!EXT! -^> !FILENAME!%SUFFIX%!EXT!
    set /a "COUNT+=1"
)
echo ------------------------------------------------------------
echo 共 %COUNT% 个文件
echo.
set /p "CONFIRM=确认执行重命名？(Y/N): "
if /i "%CONFIRM%" neq "Y" goto RENAME_FILES

echo 正在重命名...
set "RENAMED=0"
for %%f in ("%TARGET_DIR%\*.*") do (
    set "FILENAME=%%~nf"
    set "EXT=%%~xf"
    ren "%%f" "!FILENAME!%SUFFIX%!EXT!"
    set /a "RENAMED+=1"
    echo [%DATE% %TIME%] 重命名: !FILENAME!!EXT! -^> !FILENAME!%SUFFIX%!EXT! >> "%LOG_FILE%"
)
echo 完成！已重命名 %RENAMED% 个文件。
goto RENAME_FILES

:ADD_SEQUENCE
set /p "SEQ_START=请输入起始序号 (默认1): "
if "%SEQ_START%"=="" set "SEQ_START=1"
set /p "SEQ_PREFIX=请输入序号前缀 (默认为空): "
set /p "SEQ_DIGITS=请输入序号位数 (默认3): "
if "%SEQ_DIGITS%"=="" set "SEQ_DIGITS=3"

echo.
echo 预览重命名结果：
echo ------------------------------------------------------------
set "COUNT=0"
set "SEQ=%SEQ_START%"
for %%f in ("%TARGET_DIR%\*.*") do (
    set "FILENAME=%%~nxf"
    set "SEQ_NUM=000000!SEQ!"
    set "SEQ_NUM=!SEQ_NUM:~-%SEQ_DIGITS%!"
    echo !FILENAME! -^> %SEQ_PREFIX%!SEQ_NUM!_!FILENAME!
    set /a "SEQ+=1"
    set /a "COUNT+=1"
)
echo ------------------------------------------------------------
echo 共 %COUNT% 个文件
echo.
set /p "CONFIRM=确认执行重命名？(Y/N): "
if /i "%CONFIRM%" neq "Y" goto RENAME_FILES

echo 正在重命名...
set "RENAMED=0"
set "SEQ=%SEQ_START%"
for %%f in ("%TARGET_DIR%\*.*") do (
    set "FILENAME=%%~nxf"
    set "SEQ_NUM=000000!SEQ!"
    set "SEQ_NUM=!SEQ_NUM:~-%SEQ_DIGITS%!"
    ren "%%f" "%SEQ_PREFIX%!SEQ_NUM!_!FILENAME!"
    set /a "RENAMED+=1"
    set /a "SEQ+=1"
    echo [%DATE% %TIME%] 重命名: !FILENAME! -^> %SEQ_PREFIX%!SEQ_NUM!_!FILENAME! >> "%LOG_FILE%"
)
echo 完成！已重命名 %RENAMED% 个文件。
goto RENAME_FILES

:CHANGE_EXTENSION
echo.
echo ============================================================
echo                    批量修改扩展名
echo ============================================================
set /p "OLD_EXT=请输入原扩展名 (如 .txt): "
set /p "NEW_EXT=请输入新扩展名 (如 .bak): "

echo.
echo 预览修改结果：
echo ------------------------------------------------------------
set "COUNT=0"
for %%f in ("%TARGET_DIR%\*%OLD_EXT%") do (
    set "FILENAME=%%~nf"
    echo !FILENAME!%OLD_EXT% -^> !FILENAME!%NEW_EXT%
    set /a "COUNT+=1"
)
echo ------------------------------------------------------------
echo 共 %COUNT% 个文件
echo.
if %COUNT%==0 (
    echo 未找到匹配的文件。
    goto MAIN_MENU
)

set /p "CONFIRM=确认执行修改？(Y/N): "
if /i "%CONFIRM%" neq "Y" goto MAIN_MENU

echo 正在修改扩展名...
set "CHANGED=0"
for %%f in ("%TARGET_DIR%\*%OLD_EXT%") do (
    set "FILENAME=%%~nf"
    ren "%%f" "!FILENAME!%NEW_EXT%"
    set /a "CHANGED+=1"
    echo [%DATE% %TIME%] 修改扩展名: !FILENAME!%OLD_EXT% -^> !FILENAME!%NEW_EXT% >> "%LOG_FILE%"
)
echo 完成！已修改 %CHANGED% 个文件的扩展名。
goto MAIN_MENU

:MOVE_FILES
echo.
echo ============================================================
echo                    批量移动文件
echo ============================================================
set /p "MOVE_PATTERN=请输入文件匹配模式 (如 *.txt, 默认所有文件): "
if "%MOVE_PATTERN%"=="" set "MOVE_PATTERN=*.*"
set /p "DEST_DIR=请输入目标目录: "

if not exist "%DEST_DIR%" (
    echo 目标目录不存在，正在创建...
    mkdir "%DEST_DIR%"
)

echo.
echo 预览移动结果：
echo ------------------------------------------------------------
set "COUNT=0"
for %%f in ("%TARGET_DIR%\%MOVE_PATTERN%") do (
    echo %%~nxf -^> %DEST_DIR%\%%~nxf
    set /a "COUNT+=1"
)
echo ------------------------------------------------------------
echo 共 %COUNT% 个文件
echo.
if %COUNT%==0 (
    echo 未找到匹配的文件。
    goto MAIN_MENU
)

set /p "CONFIRM=确认执行移动？(Y/N): "
if /i "%CONFIRM%" neq "Y" goto MAIN_MENU

echo 正在移动文件...
set "MOVED=0"
for %%f in ("%TARGET_DIR%\%MOVE_PATTERN%") do (
    move "%%f" "%DEST_DIR%" > nul
    set /a "MOVED+=1"
    echo [%DATE% %TIME%] 移动: %%~nxf -^> %DEST_DIR% >> "%LOG_FILE%"
)
echo 完成！已移动 %MOVED% 个文件。
goto MAIN_MENU

:COPY_FILES
echo.
echo ============================================================
echo                    批量复制文件
echo ============================================================
set /p "COPY_PATTERN=请输入文件匹配模式 (如 *.txt, 默认所有文件): "
if "%COPY_PATTERN%"=="" set "COPY_PATTERN=*.*"
set /p "DEST_DIR=请输入目标目录: "

if not exist "%DEST_DIR%" (
    echo 目标目录不存在，正在创建...
    mkdir "%DEST_DIR%"
)

echo.
echo 预览复制结果：
echo ------------------------------------------------------------
set "COUNT=0"
for %%f in ("%TARGET_DIR%\%COPY_PATTERN%") do (
    echo %%~nxf -^> %DEST_DIR%\%%~nxf
    set /a "COUNT+=1"
)
echo ------------------------------------------------------------
echo 共 %COUNT% 个文件
echo.
if %COUNT%==0 (
    echo 未找到匹配的文件。
    goto MAIN_MENU
)

set /p "CONFIRM=确认执行复制？(Y/N): "
if /i "%CONFIRM%" neq "Y" goto MAIN_MENU

echo 正在复制文件...
set "COPIED=0"
for %%f in ("%TARGET_DIR%\%COPY_PATTERN%") do (
    copy "%%f" "%DEST_DIR%" > nul
    set /a "COPIED+=1"
    echo [%DATE% %TIME%] 复制: %%~nxf -^> %DEST_DIR% >> "%LOG_FILE%"
)
echo 完成！已复制 %COPIED% 个文件。
goto MAIN_MENU

:LIST_FILES
echo.
echo ============================================================
echo                    目录文件列表
echo ============================================================
echo 目录: %TARGET_DIR%
echo ------------------------------------------------------------
dir /b "%TARGET_DIR%"
echo ------------------------------------------------------------
echo.
set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:EXIT
echo.
echo [%DATE% %TIME%] 文件批量处理工具退出 >> "%LOG_FILE%"
echo 感谢使用文件批量处理工具！
echo 操作日志已保存到: %LOG_FILE%
echo.
pause
endlocal
exit /b 0