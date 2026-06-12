@echo off
:: ============================================================
:: 自动化部署脚本 - 项目5
:: 功能：自动化部署、配置文件读取、错误处理和回滚
:: 用法：deploy.bat [环境] [配置文件]
:: 安全约束：使用echo模拟危险操作，实际部署需谨慎
:: ============================================================

chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 初始化变量
set "SCRIPT_DIR=%~dp0"
set "ENVIRONMENT=%~1"
set "CONFIG_FILE=%~2"
set "LOG_FILE=%SCRIPT_DIR%output\deploy.log"
set "BACKUP_DIR=%SCRIPT_DIR%backup\deploy_%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
set "DEPLOY_DIR=%SCRIPT_DIR%deploy_target"
set "ROLLBACK_DIR=%SCRIPT_DIR%rollback"

:: 设置默认值
if "%ENVIRONMENT%"=="" set "ENVIRONMENT=development"
if "%CONFIG_FILE%"=="" set "CONFIG_FILE=%SCRIPT_DIR%config\deploy_config.ini"

:: 创建必要目录
if not exist "%SCRIPT_DIR%output" mkdir "%SCRIPT_DIR%output"
if not exist "%SCRIPT_DIR%config" mkdir "%SCRIPT_DIR%config"
if not exist "%SCRIPT_DIR%backup" mkdir "%SCRIPT_DIR%backup"
if not exist "%ROLLBACK_DIR%" mkdir "%ROLLBACK_DIR%"

:: 初始化日志
echo [%DATE% %TIME%] 自动化部署脚本启动 > "%LOG_FILE%"
echo [%DATE% %TIME%] 部署环境: %ENVIRONMENT% >> "%LOG_FILE%"
echo [%DATE% %TIME%] 配置文件: %CONFIG_FILE% >> "%LOG_FILE%"

:: 显示欢迎信息
echo ============================================================
echo                      自动化部署脚本
echo ============================================================
echo 部署环境: %ENVIRONMENT%
echo 配置文件: %CONFIG_FILE%
echo 部署目录: %DEPLOY_DIR%
echo.

:: 检查配置文件
if not exist "%CONFIG_FILE%" (
    echo [WARNING] 配置文件不存在，将创建默认配置
    echo [%DATE% %TIME%] 警告：配置文件不存在，创建默认配置 >> "%LOG_FILE%"
    goto CREATE_DEFAULT_CONFIG
)

:: 读取配置文件
echo [INFO] 读取配置文件...
set "APP_NAME="
set "APP_VERSION="
set "DEPLOY_STEPS="
set "HEALTH_CHECK_URL="
set "ROLLBACK_ENABLED="

for /f "tokens=1,2 delims==" %%a in ('type "%CONFIG_FILE%" 2^>nul') do (
    set "KEY=%%a"
    set "VALUE=%%b"
    
    if "!KEY!"=="app_name" set "APP_NAME=!VALUE!"
    if "!KEY!"=="app_version" set "APP_VERSION=!VALUE!"
    if "!KEY!"=="deploy_steps" set "DEPLOY_STEPS=!VALUE!"
    if "!KEY!"=="health_check_url" set "HEALTH_CHECK_URL=!VALUE!"
    if "!KEY!"=="rollback_enabled" set "ROLLBACK_ENABLED=!VALUE!"
)

:: 显示配置信息
echo 配置信息：
echo   应用名称: %APP_NAME%
echo   应用版本: %APP_VERSION%
echo   部署步骤: %DEPLOY_STEPS%
echo   健康检查: %HEALTH_CHECK_URL%
echo   回滚启用: %ROLLBACK_ENABLED%
echo.

:: 主菜单循环
:MAIN_MENU
echo ============================================================
echo                        主菜单
echo ============================================================
echo 1. 执行完整部署
echo 2. 执行单个步骤
echo 3. 健康检查
echo 4. 回滚部署
echo 5. 查看部署日志
echo 6. 退出
echo ============================================================
set /p "CHOICE=请选择操作 (1-6): "

if "%CHOICE%"=="1" goto FULL_DEPLOY
if "%CHOICE%"=="2" goto SINGLE_STEP
if "%CHOICE%"=="3" goto HEALTH_CHECK
if "%CHOICE%"=="4" goto ROLLBACK_DEPLOY
if "%CHOICE%"=="5" goto VIEW_LOG
if "%CHOICE%"=="6" goto EXIT
echo [ERROR] 无效选择，请重新输入
goto MAIN_MENU

:CREATE_DEFAULT_CONFIG
echo [INFO] 创建默认配置文件...
(
echo [deploy_config]
echo app_name=MyApplication
echo app_version=1.0.0
echo deploy_steps=backup,stop,deploy,start,verify
echo health_check_url=http://localhost:8080/health
echo rollback_enabled=true
echo.
echo [environment_%ENVIRONMENT%]
echo server=localhost
echo port=8080
echo debug=true
) > "%CONFIG_FILE%"

echo [INFO] 默认配置文件已创建: %CONFIG_FILE%
echo 请根据实际情况修改配置文件后重新运行脚本。
pause
goto MAIN_MENU

:FULL_DEPLOY
echo.
echo ============================================================
echo                    执行完整部署
echo ============================================================
echo 应用: %APP_NAME% v%APP_VERSION%
echo 环境: %ENVIRONMENT%
echo.
echo [WARNING] 即将执行完整部署，请确认！
set /p "CONFIRM=确认部署？(Y/N): "
if /i "%CONFIRM%" neq "Y" goto MAIN_MENU

:: 记录部署开始
echo [%DATE% %TIME%] 开始完整部署 >> "%LOG_FILE%"
set "DEPLOY_START_TIME=%DATE% %TIME%"
set "DEPLOY_STATUS=SUCCESS"
set "FAILED_STEP="

:: 执行部署步骤
for %%s in (%DEPLOY_STEPS%) do (
    echo.
    echo [步骤] 执行: %%s
    echo [%DATE% %TIME%] 执行步骤: %%s >> "%LOG_FILE%"
    
    call :EXECUTE_STEP %%s
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] 步骤 %%s 执行失败！
        echo [%DATE% %TIME%] 错误：步骤 %%s 执行失败 >> "%LOG_FILE%"
        set "DEPLOY_STATUS=FAILED"
        set "FAILED_STEP=%%s"
        
        :: 检查是否需要回滚
        if "%ROLLBACK_ENABLED%"=="true" (
            echo [INFO] 自动回滚已启用，开始回滚...
            goto AUTO_ROLLBACK
        ) else (
            echo [ERROR] 部署失败，请手动处理。
            goto DEPLOY_COMPLETE
        )
    )
    
    echo [成功] 步骤 %%s 完成
    echo [%DATE% %TIME%] 步骤 %%s 完成 >> "%LOG_FILE%"
)

:DEPLOY_COMPLETE
echo.
echo ============================================================
echo                    部署完成
echo ============================================================
echo 部署状态: %DEPLOY_STATUS%
echo 开始时间: %DEPLOY_START_TIME%
echo 结束时间: %DATE% %TIME%
if "%DEPLOY_STATUS%"=="FAILED" (
    echo 失败步骤: %FAILED_STEP%
)
echo.
echo [%DATE% %TIME%] 部署完成，状态: %DEPLOY_STATUS% >> "%LOG_FILE%"

set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:EXECUTE_STEP
set "STEP_NAME=%1"
set "STEP_RESULT=0"

if "%STEP_NAME%"=="backup" (
    echo [执行] 创建备份...
    if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
    :: 模拟备份操作
    echo [模拟] 备份应用文件到 %BACKUP_DIR%
    timeout /t 2 > nul
    echo [完成] 备份完成
) else if "%STEP_NAME%"=="stop" (
    echo [执行] 停止应用...
    :: 模拟停止应用
    echo [模拟] 停止应用服务
    timeout /t 1 > nul
    echo [完成] 应用已停止
) else if "%STEP_NAME%"=="deploy" (
    echo [执行] 部署新版本...
    :: 模拟部署操作
    echo [模拟] 复制新版本文件到部署目录
    if not exist "%DEPLOY_DIR%" mkdir "%DEPLOY_DIR%"
    timeout /t 3 > nul
    echo [完成] 部署完成
) else if "%STEP_NAME%"=="start" (
    echo [执行] 启动应用...
    :: 模拟启动应用
    echo [模拟] 启动应用服务
    timeout /t 2 > nul
    echo [完成] 应用已启动
) else if "%STEP_NAME%"=="verify" (
    echo [执行] 验证部署...
    :: 模拟验证操作
    echo [模拟] 检查应用状态
    timeout /t 1 > nul
    echo [完成] 验证通过
) else (
    echo [ERROR] 未知步骤: %STEP_NAME%
    set "STEP_RESULT=1"
)

exit /b !STEP_RESULT!

:SINGLE_STEP
echo.
echo ============================================================
echo                    执行单个步骤
echo ============================================================
echo 可用步骤：
echo 1. backup - 创建备份
echo 2. stop - 停止应用
echo 3. deploy - 部署新版本
echo 4. start - 启动应用
echo 5. verify - 验证部署
echo 6. 返回主菜单
echo.
set /p "STEP_CHOICE=请选择要执行的步骤 (1-6): "

if "%STEP_CHOICE%"=="1" set "STEP=backup"
if "%STEP_CHOICE%"=="2" set "STEP=stop"
if "%STEP_CHOICE%"=="3" set "STEP=deploy"
if "%STEP_CHOICE%"=="4" set "STEP=start"
if "%STEP_CHOICE%"=="5" set "STEP=verify"
if "%STEP_CHOICE%"=="6" goto MAIN_MENU

echo.
echo [INFO] 执行步骤: %STEP%
call :EXECUTE_STEP %STEP%
if !ERRORLEVEL! equ 0 (
    echo [成功] 步骤 %STEP% 完成
) else (
    echo [失败] 步骤 %STEP% 执行失败
)

set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:HEALTH_CHECK
echo.
echo ============================================================
echo                    健康检查
echo ============================================================
echo 检查URL: %HEALTH_CHECK_URL%
echo.

:: 模拟健康检查
echo [执行] 发送健康检查请求...
timeout /t 2 > nul

:: 模拟检查结果
set "HEALTH_STATUS=HEALTHY"
set "HEALTH_MESSAGE=应用运行正常"

echo 健康检查结果：
echo   状态: %HEALTH_STATUS%
echo   消息: %HEALTH_MESSAGE%
echo   检查时间: %DATE% %TIME%
echo.
echo [%DATE% %TIME%] 健康检查: %HEALTH_STATUS% >> "%LOG_FILE%"

set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:AUTO_ROLLBACK
echo.
echo [INFO] 开始自动回滚...
echo [%DATE% %TIME%] 开始自动回滚 >> "%LOG_FILE%"

:ROLLBACK_DEPLOY
echo.
echo ============================================================
echo                    回滚部署
echo ============================================================

:: 查找可用的备份
echo 查找可用的备份...
set "BACKUP_COUNT=0"
for /d %%d in ("%SCRIPT_DIR%backup\deploy_*") do (
    set /a "BACKUP_COUNT+=1"
    set "BACKUP_!BACKUP_COUNT!=%%~nxd"
    echo !BACKUP_COUNT!. %%~nxd (%%~td)
)

if !BACKUP_COUNT! equ 0 (
    echo [ERROR] 未找到可用的备份。
    set /p "PRESS_ENTER=按回车键返回主菜单..."
    goto MAIN_MENU
)

echo.
set /p "BACKUP_CHOICE=请选择要回滚到的备份 (1-!BACKUP_COUNT!): "
if !BACKUP_CHOICE! lss 1 goto ROLLBACK_DEPLOY
if !BACKUP_CHOICE! gtr !BACKUP_COUNT! goto ROLLBACK_DEPLOY

set "SELECTED_BACKUP=!BACKUP_%BACKUP_CHOICE%!"
set "BACKUP_PATH=%SCRIPT_DIR%backup\!SELECTED_BACKUP!"

echo.
echo 选择的备份: !SELECTED_BACKUP!
echo 备份路径: !BACKUP_PATH!
echo.
echo [WARNING] 即将执行回滚，当前部署将被覆盖！
set /p "CONFIRM=确认回滚？(Y/N): "
if /i "%CONFIRM%" neq "Y" goto MAIN_MENU

:: 执行回滚
echo [执行] 开始回滚...
echo [%DATE% %TIME%] 开始回滚到: !SELECTED_BACKUP! >> "%LOG_FILE%"

:: 模拟回滚操作
echo [模拟] 停止当前应用
timeout /t 1 > nul
echo [模拟] 恢复备份文件
timeout /t 2 > nul
echo [模拟] 重启应用
timeout /t 1 > nul

echo.
echo [完成] 回滚完成！
echo [%DATE% %TIME%] 回滚完成 >> "%LOG_FILE%"

set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:VIEW_LOG
echo.
echo ============================================================
echo                    部署日志
echo ============================================================
echo 日志文件: %LOG_FILE%
echo.
echo 最近日志：
echo ------------------------------------------------------------

:: 显示最后20行日志
set "LINE_COUNT=0"
for /f "usebackq delims=" %%a in ("%LOG_FILE%") do (
    set /a "LINE_COUNT+=1"
)
set /a "START_LINE=LINE_COUNT-20"
if !START_LINE! lss 0 set "START_LINE=0"

set "CURRENT_LINE=0"
for /f "usebackq delims=" %%a in ("%LOG_FILE%") do (
    set /a "CURRENT_LINE+=1"
    if !CURRENT_LINE! gtr !START_LINE! echo %%a
)

echo ------------------------------------------------------------
echo.
set /p "PRESS_ENTER=按回车键返回主菜单..."
goto MAIN_MENU

:EXIT
echo.
echo [%DATE% %TIME%] 自动化部署脚本退出 >> "%LOG_FILE%"
echo 感谢使用自动化部署脚本！
echo 部署日志已保存到: %LOG_FILE%
echo.
pause
endlocal
exit /b 0