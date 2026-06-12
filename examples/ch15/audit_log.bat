@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: audit_log.bat - 审计日志记录演示
::
:: 安全提示：本脚本演示安全审计日志记录
:: 用于记录安全事件和操作审计
:: ============================================================

chcp 65001 >nul 2>&1

echo ============================================================
echo 审计日志记录演示
echo ============================================================
echo.

:: 设置日志目录
set "log_dir=%~dp0audit_logs"
set "audit_log=%log_dir%\audit_%date:~0,4%%date:~5,2%%date:~8,2%.log"
set "security_log=%log_dir%\security_%date:~0,4%%date:~5,2%%date:~8,2%.log"
set "error_log=%log_dir%\error_%date:~0,4%%date:~5,2%%date:~8,2%.log"

:: 创建日志目录
if not exist "%log_dir%" (
    echo [INFO] 创建日志目录: %log_dir%
    mkdir "%log_dir%"
)

:: 记录开始时间
call :log_audit "AUDIT_SYSTEM_START" "审计系统启动"
call :log_security "SECURITY_INIT" "安全日志初始化"

:: 演示1：基本日志记录
echo [演示1] 基本日志记录
echo ----------------------------------------
echo 记录各种类型的日志：
echo.

:: 记录信息日志
call :log_audit "INFO" "用户 %USERNAME% 登录系统"
call :log_audit "INFO" "工作目录: %CD%"
call :log_audit "INFO" "计算机名: %COMPUTERNAME%"

:: 记录安全事件
call :log_security "LOGIN_SUCCESS" "用户登录成功"
call :log_security "ACCESS_GRANTED" "访问权限授予"

:: 记录错误事件
call :log_error "FILE_NOT_FOUND" "找不到文件: test.txt"

echo [INFO] 基本日志记录完成
echo.

:: 演示2：用户活动日志
echo [演示2] 用户活动日志
echo ----------------------------------------
echo 记录用户活动：
echo.

:: 记录用户操作
call :log_audit "USER_ACTION" "用户执行了文件操作"
call :log_audit "USER_ACTION" "用户查看了目录列表"
call :log_audit "USER_ACTION" "用户修改了配置文件"

:: 记录用户会话
call :log_security "SESSION_START" "用户会话开始"
call :log_security "SESSION_ACTIVITY" "会话活动记录"
call :log_security "SESSION_END" "用户会话结束"

echo [INFO] 用户活动日志记录完成
echo.

:: 演示3：文件操作日志
echo [演示3] 文件操作日志
echo ----------------------------------------
echo 记录文件操作：
echo.

:: 创建测试文件
echo Test content > "%log_dir%\test_file.txt"

:: 记录文件创建
call :log_audit "FILE_CREATE" "创建文件: test_file.txt"

:: 记录文件读取
call :log_audit "FILE_READ" "读取文件: test_file.txt"

:: 记录文件修改
echo Modified content >> "%log_dir%\test_file.txt"
call :log_audit "FILE_MODIFY" "修改文件: test_file.txt"

:: 记录文件删除
del "%log_dir%\test_file.txt" 2>nul
call :log_audit "FILE_DELETE" "删除文件: test_file.txt"

echo [INFO] 文件操作日志记录完成
echo.

:: 演示4：权限变更日志
echo [演示4] 权限变更日志
echo ----------------------------------------
echo 记录权限变更：
echo.

:: 模拟权限变更
call :log_security "PERMISSION_CHANGE" "用户权限变更"
call :log_security "ACCESS_CONTROL" "访问控制列表修改"
call :log_security "OWNERSHIP_CHANGE" "文件所有权变更"

:: 记录管理员操作
call :log_security "ADMIN_ACTION" "管理员执行特权操作"
call :log_security "ELEVATION_REQUEST" "权限提升请求"

echo [INFO] 权限变更日志记录完成
echo.

:: 演示5：安全事件日志
echo [演示5] 安全事件日志
echo ----------------------------------------
echo 记录安全事件：
echo.

:: 记录登录尝试
call :log_security "LOGIN_ATTEMPT" "登录尝试 - 用户: %USERNAME%"
call :log_security "LOGIN_SUCCESS" "登录成功 - 用户: %USERNAME%"
call :log_security "LOGIN_FAILURE" "登录失败 - 用户: unknown"

:: 记录访问控制
call :log_security "ACCESS_DENIED" "访问被拒绝 - 资源: protected_file"
call :log_security "ACCESS_GRANTED" "访问被授予 - 资源: public_file"

:: 记录可疑活动
call :log_security "SUSPICIOUS_ACTIVITY" "可疑活动检测"
call :log_security "BRUTE_FORCE_ATTEMPT" "暴力破解尝试检测"

echo [INFO] 安全事件日志记录完成
echo.

:: 演示6：错误日志
echo [演示6] 错误日志
echo ----------------------------------------
echo 记录错误事件：
echo.

:: 记录各种错误
call :log_error "FILE_NOT_FOUND" "找不到文件: missing.txt"
call :log_error "PERMISSION_DENIED" "权限被拒绝: 资源访问"
call :log_error "INVALID_INPUT" "无效输入: 参数验证失败"
call :log_error "NETWORK_ERROR" "网络错误: 连接超时"
call :log_error "SYSTEM_ERROR" "系统错误: 内存不足"

echo [INFO] 错误日志记录完成
echo.

:: 演示7：日志查询和分析
echo [演示7] 日志查询和分析
echo ----------------------------------------
echo 查询和分析日志：
echo.

:: 显示审计日志内容
echo [INFO] 审计日志内容:
if exist "%audit_log%" (
    type "%audit_log%"
) else (
    echo 审计日志文件不存在
)
echo.

:: 显示安全日志内容
echo [INFO] 安全日志内容:
if exist "%security_log%" (
    type "%security_log%"
) else (
    echo 安全日志文件不存在
)
echo.

:: 显示错误日志内容
echo [INFO] 错误日志内容:
if exist "%error_log%" (
    type "%error_log%"
) else (
    echo 错误日志文件不存在
)
echo.

:: 演示8：日志统计
echo [演示8] 日志统计
echo ----------------------------------------
echo 统计日志信息：
echo.

:: 统计审计日志行数
if exist "%audit_log%" (
    set "audit_count=0"
    for /f %%a in ('type "%audit_log%" ^| find /c /v ""') do set "audit_count=%%a"
    echo 审计日志条目数: !audit_count!
)

:: 统计安全日志行数
if exist "%security_log%" (
    set "security_count=0"
    for /f %%a in ('type "%security_log%" ^| find /c /v ""') do set "security_count=%%a"
    echo 安全日志条目数: !security_count!
)

:: 统计错误日志行数
if exist "%error_log%" (
    set "error_count=0"
    for /f %%a in ('type "%error_log%" ^| find /c /v ""') do set "error_count=%%a"
    echo 错误日志条目数: !error_count!
)

echo.

:: 演示9：日志轮转
echo [演示9] 日志轮转
echo ----------------------------------------
echo 日志轮转管理：
echo.

:: 显示当前日志文件
echo [INFO] 当前日志文件:
dir "%log_dir%\*.log" /b
echo.

:: 模拟日志轮转
echo [INFO] 模拟日志轮转...
set "rotation_date=%date:~0,4%%date:~5,2%%date:~8,2%"

:: 创建轮转备份
if exist "%audit_log%" (
    copy "%audit_log%" "%log_dir%\audit_%rotation_date%_backup.log" >nul
    echo [INFO] 审计日志已备份
)

:: 清理旧日志（保留7天）
echo [INFO] 清理超过7天的旧日志...
forfiles /p "%log_dir%" /m "*.log" /d -7 /c "cmd /c echo 删除旧日志: @path" 2>nul

echo.

:: 演示10：日志保护
echo [演示10] 日志保护
echo ----------------------------------------
echo 日志文件保护：
echo.

:: 设置日志文件权限（模拟）
echo [INFO] 设置日志文件权限...
echo [命令] icacls "%audit_log%" /grant:r "Administrators:(R,W)"
echo [命令] icacls "%audit_log%" /grant:r "SYSTEM:(R,W)"
echo [命令] icacls "%audit_log%" /inheritance:r

:: 计算日志文件哈希
echo [INFO] 计算日志文件哈希...
if exist "%audit_log%" (
    certutil -hashfile "%audit_log%" SHA256
)
echo.

:: 演示11：安全最佳实践
echo [演示11] 审计日志最佳实践
echo ----------------------------------------
echo [BEST PRACTICE] 审计日志最佳实践：
echo 1. 记录所有安全相关事件
echo 2. 使用时间戳标记每条日志
echo 3. 包含用户、计算机、操作信息
echo 4. 保护日志文件不被篡改
echo 5. 定期备份日志文件
echo 6. 实施日志轮转策略
echo 7. 监控日志中的异常模式
echo 8. 保留日志至少90天
echo 9. 加密敏感日志信息
echo 10. 定期审查日志内容
echo.

:: 记录结束时间
call :log_audit "AUDIT_SYSTEM_END" "审计系统关闭"
call :log_security "SECURITY_SHUTDOWN" "安全日志关闭"

:: 清理测试文件
echo [INFO] 清理测试文件...
if exist "%log_dir%\test_file.txt" del "%log_dir%\test_file.txt"

echo ============================================================
echo 审计日志记录演示完成
echo ============================================================
echo.
echo 日志目录: %log_dir%
echo 审计日志: %audit_log%
echo 安全日志: %security_log%
echo 错误日志: %error_log%
echo.
echo 按任意键退出...
pause >nul
exit /b 0

:: ============================================================
:: 日志记录函数
:: ============================================================

:log_audit
:: 记录审计日志
set "event_type=%~1"
set "message=%~2"
set "timestamp=%date% %time%"
set "user=%USERNAME%"
set "computer=%COMPUTERNAME%"

:: 格式化日志条目
set "log_entry=[%timestamp%] [%event_type%] User: %user% Computer: %computer% Message: %message%"

:: 写入审计日志
echo %log_entry% >> "%audit_log%"

:: 同时输出到控制台
echo [AUDIT] %log_entry%

exit /b 0

:log_security
:: 记录安全日志
set "event_type=%~1"
set "message=%~2"
set "timestamp=%date% %time%"
set "user=%USERNAME%"
set "computer=%COMPUTERNAME%"
set "session_id=%RANDOM%"

:: 格式化安全日志条目
set "log_entry=[%timestamp%] [%event_type%] SessionID: %session_id% User: %user% Computer: %computer% Message: %message%"

:: 写入安全日志
echo %log_entry% >> "%security_log%"

:: 同时输出到控制台
echo [SECURITY] %log_entry%

exit /b 0

:log_error
:: 记录错误日志
set "error_code=%~1"
set "message=%~2"
set "timestamp=%date% %time%"
set "user=%USERNAME%"
set "computer=%COMPUTERNAME%"

:: 格式化错误日志条目
set "log_entry=[%timestamp%] [ERROR] Code: %error_code% User: %user% Computer: %computer% Message: %message%"

:: 写入错误日志
echo %log_entry% >> "%error_log%"

:: 同时输出到控制台
echo [ERROR] %log_entry%

exit /b 0

:log_info
:: 记录信息日志
set "message=%~1"
set "timestamp=%date% %time%"

:: 格式化信息日志条目
set "log_entry=[%timestamp%] [INFO] %message%"

:: 写入审计日志
echo %log_entry% >> "%audit_log%"

:: 同时输出到控制台
echo [INFO] %log_entry%

exit /b 0