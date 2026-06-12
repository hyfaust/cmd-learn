@echo off
chcp 65001 >nul
REM ============================================================
REM 文件名: service_control.bat
REM 功能: 演示服务控制操作（仅查询，不实际启停服务）
REM 作者: CMD教程系列
REM 日期: 2026-06-11
REM
REM 安全提示：
REM   1. 本脚本仅演示服务控制命令的语法
REM   2. 所有启停操作均使用 echo 模拟
REM   3. 实际操作需要管理员权限
REM   4. 请勿在生产环境随意启停服务
REM ============================================================

setlocal enabledelayedexpansion

echo ========================================
echo    服务控制演示（安全模式）
echo ========================================
echo.

REM 检查管理员权限
echo [权限检查]
net session >nul 2>&1
if %errorlevel% equ 0 (
    echo [√] 当前具有管理员权限
) else (
    echo [!] 当前没有管理员权限
    echo     某些操作可能需要管理员权限
)
echo.

pause

REM 第一部分：服务启动命令演示
echo [1] 服务启动命令演示
echo ----------------------------------------
echo.
echo 启动服务的命令格式：
echo.
echo   sc start ^<service_name^>     - 使用sc命令启动
echo   net start ^<service_name^>    - 使用net命令启动
echo.
echo 示例（模拟）:
echo.

REM 模拟启动服务
set "demo_service=Dhcp"
echo [模拟] 执行: sc start %demo_service%
echo [模拟] 预期输出:
echo         SERVICE_NAME: %demo_service%
echo         TYPE          : 20  WIN32_SHARE_PROCESS
echo         STATE         : 4  RUNNING
echo.
echo 注意: 实际执行会真正启动服务
echo.

pause

REM 第二部分：服务停止命令演示
echo [2] 服务停止命令演示
echo ----------------------------------------
echo.
echo 停止服务的命令格式：
echo.
echo   sc stop ^<service_name^>      - 使用sc命令停止
echo   net stop ^<service_name^>     - 使用net命令停止
echo.
echo 示例（模拟）:
echo.

REM 模拟停止服务
echo [模拟] 执行: sc stop %demo_service%
echo [模拟] 预期输出:
echo         SERVICE_NAME: %demo_service%
echo         TYPE          : 20  WIN32_SHARE_PROCESS
echo         STATE         : 3  STOP_PENDING
echo.
echo 警告: 停止服务可能影响系统功能！
echo.

pause

REM 第三部分：服务暂停/继续命令演示
echo [3] 服务暂停/继续命令演示
echo ----------------------------------------
echo.
echo 暂停和继续服务的命令：
echo.
echo   sc pause ^<service_name^>     - 暂停服务
echo   sc continue ^<service_name^>  - 继续服务
echo.
echo 注意: 并非所有服务都支持暂停功能
echo.

REM 检查服务是否支持暂停
echo 检查 %demo_service% 是否支持暂停:
sc query %demo_service% 2>nul | findstr "ACCEPT_PAUSE" >nul
if %errorlevel% equ 0 (
    echo [√] 该服务支持暂停功能
) else (
    echo [×] 该服务不支持暂停功能
)
echo.

pause

REM 第四部分：服务配置修改演示
echo [4] 服务配置修改演示
echo ----------------------------------------
echo.
echo 修改服务启动类型：
echo.
echo   sc config ^<service^> start^= auto      - 自动启动
echo   sc config ^<service^> start^= demand     - 手动启动
echo   sc config ^<service^> start^= disabled   - 禁用
echo.
echo 当前 %demo_service% 的启动类型：
for /f "tokens=3 delims=:" %%a in ('sc qc %demo_service% 2^>nul ^| findstr "START_TYPE"') do (
    echo   启动类型: %%a
)
echo.
echo [模拟] 执行: sc config %demo_service% start= demand
echo [模拟] 注意: 实际执行会修改服务配置
echo.

pause

REM 第五部分：修改服务描述
echo [5] 修改服务描述演示
echo ----------------------------------------
echo.
echo 命令格式：
echo   sc description ^<service^> "新的描述文本"
echo.
echo 当前 %demo_service% 的描述：
sc qc %demo_service% 2>nul | findstr "DESCRIPTION" || echo (无法获取描述)
echo.
echo [模拟] 执行: sc description %demo_service% "自定义服务描述"
echo.

pause

REM 第六部分：服务控制的完整流程
echo [6] 服务控制完整流程示例
echo ----------------------------------------
echo.
echo 安全的服务操作流程：
echo.
echo   1. 检查服务当前状态
echo   2. 检查服务依赖关系
echo   3. 通知相关用户（如果需要）
echo   4. 执行操作
echo   5. 验证操作结果
echo   6. 记录操作日志
echo.

REM 演示完整流程
echo 演示: 安全停止服务的完整流程
echo.

REM 步骤1：检查状态
echo 步骤1: 检查服务当前状态
for /f "tokens=3 delims=:" %%a in ('sc query %demo_service% 2^>nul ^| findstr "STATE"') do (
    echo   当前状态: %%a
)
echo.

REM 步骤2：检查依赖
echo 步骤2: 检查依赖服务
sc enumdepend %demo_service% 2>nul | findstr "SERVICE_NAME" || echo   无依赖服务
echo.

REM 步骤3：模拟操作
echo 步骤3: 执行操作（模拟）
echo   [模拟] sc stop %demo_service%
echo.

REM 步骤4：验证结果
echo 步骤4: 验证结果
echo   [模拟] 等待服务停止...
echo   [模拟] 验证状态: STOPPED
echo.

REM 步骤5：记录日志
echo 步骤5: 记录日志
echo   [模拟] 写入日志: %date% %time% - 停止服务 %demo_service%
echo.

pause

REM 第七部分：批量服务操作演示
echo [7] 批量服务操作演示
echo ----------------------------------------
echo.
echo 可以使用循环批量操作服务：
echo.
echo   set services=Service1 Service2 Service3
echo   for %%s in (%%services%%) do (
echo       echo 处理服务: %%s
echo       sc stop %%s
echo   ^)
echo.
echo [模拟] 批量停止非关键服务：
echo.

set "non_critical_services=Fax XblGameSave XboxGipSvc"
for %%s in (%non_critical_services%) do (
    echo   [模拟] 停止服务: %%s
)
echo.

pause

REM 第八部分：错误处理示例
echo [8] 服务操作错误处理
echo ----------------------------------------
echo.
echo 常见错误及处理：
echo.

REM 演示错误处理
echo [演示] 尝试操作不存在的服务：
sc query NonExistentService >nul 2>&1
if %errorlevel% neq 0 (
    echo   错误: 服务不存在 (错误代码: %errorlevel%)
)
echo.

echo [演示] 尝试操作无权限的服务：
echo   注意: 某些系统服务需要 TrustedInstaller 权限
echo.

pause

REM 第九部分：生成服务操作脚本模板
echo [9] 服务操作脚本模板
echo ----------------------------------------
echo.
echo 以下是安全的服务操作脚本模板：
echo.
echo -------------------------------------------------------
echo   @echo off
echo   REM 检查管理员权限
echo   net session ^>nul 2^>^&1
echo   if %%errorlevel%% neq 0 (
echo       echo 请以管理员身份运行！
echo       exit /b 1
echo   ^)
echo.
echo   set "service_name=YourService"
echo.
echo   REM 检查服务是否存在
echo   sc query %%service_name%% ^>nul 2^>^&1
echo   if %%errorlevel%% neq 0 (
echo       echo 服务 %%service_name%% 不存在
echo       exit /b 1
echo   ^)
echo.
echo   REM 执行操作
echo   sc stop %%service_name%%
echo.
echo   REM 验证结果
echo   timeout /t 3 ^>nul
echo   for /f "tokens=3 delims=:" %%%%a in ^(
echo       'sc query %%service_name%% ^| findstr "STATE"'
echo   ^) do (
echo       echo 服务状态: %%%%a
echo   ^)
echo -------------------------------------------------------
echo.

echo ========================================
echo    演示完成
echo ========================================
echo.
echo 关键要点:
echo   1. 服务操作需要管理员权限
echo   2. 操作前检查服务状态和依赖
echo   3. 使用 echo 模拟危险操作
echo   4. 添加完善的错误处理
echo   5. 记录所有操作日志
echo.
pause
