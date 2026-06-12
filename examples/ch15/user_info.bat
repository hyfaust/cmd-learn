@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: user_info.bat - 用户信息查看
::
:: 安全提示：本脚本仅用于查看用户信息，不会修改任何用户设置
:: 所有操作都是只读的
:: ============================================================

chcp 65001 >nul 2>&1

echo ============================================================
echo 用户信息查看工具
echo ============================================================
echo.

:: 设置日志文件
set "log_file=%~dp0user_info.log"

:: 记录开始时间
echo [%date% %time%] 用户信息查看开始 >> "%log_file%"

:: 演示1：基本用户信息
echo [演示1] 基本用户信息
echo ----------------------------------------
echo 当前用户名: %USERNAME%
echo 用户域名: %USERDOMAIN%
echo 用户配置文件: %USERPROFILE%
echo 用户主目录: %HOMEDRIVE%%HOMEPATH%
echo.

:: 记录基本信息
echo [%date% %time%] 用户: %USERNAME%, 域: %USERDOMAIN% >> "%log_file%"

:: 演示2：使用whoami命令
echo [演示2] whoami命令详细信息
echo ----------------------------------------
echo [命令] whoami
whoami
echo.

echo [命令] whoami /user
whoami /user
echo.

echo [命令] whoami /groups
whoami /groups
echo.

echo [命令] whoami /priv
whoami /priv
echo.

:: 记录whoami信息
echo [%date% %time%] whoami命令执行完成 >> "%log_file%"

:: 演示3：环境变量中的用户信息
echo [演示3] 环境变量中的用户信息
echo ----------------------------------------
echo USERNAME: %USERNAME%
echo USERDOMAIN: %USERDOMAIN%
echo USERPROFILE: %USERPROFILE%
echo APPDATA: %APPDATA%
echo LOCALAPPDATA: %LOCALAPPDATA%
echo TEMP: %TEMP%
echo TMP: %TMP%
echo.

:: 演示4：用户组信息
echo [演示4] 用户组信息
echo ----------------------------------------
echo [命令] net user %USERNAME%
net user %USERNAME% 2>nul
if %errorLevel% neq 0 (
    echo [WARNING] 无法获取用户详细信息（可能需要管理员权限）
)
echo.

:: 演示5：本地用户组列表
echo [演示5] 本地用户组列表
echo ----------------------------------------
echo [命令] net localgroup
net localgroup
echo.

:: 演示6：管理员组成员
echo [演示6] 管理员组成员
echo ----------------------------------------
echo [命令] net localgroup "Administrators"
net localgroup "Administrators" 2>nul
if %errorLevel% neq 0 (
    echo [WARNING] 无法获取管理员组信息（可能需要管理员权限）
)
echo.

:: 演示7：当前用户的安全标识符（SID）
echo [演示7] 当前用户的安全标识符
echo ----------------------------------------
echo [命令] whoami /user
for /f "tokens=2" %%s in ('whoami /user ^| findstr /i "%USERNAME%"') do (
    echo 用户SID: %%s
)
echo.

:: 演示8：用户权限信息
echo [演示8] 用户权限信息
echo ----------------------------------------
echo [命令] whoami /priv | findstr /i "Enabled"
for /f "tokens=1,2" %%a in ('whoami /priv ^| findstr /i "Enabled"') do (
    echo 权限: %%a - 状态: %%b
)
echo.

:: 演示9：用户配置文件信息
echo [演示9] 用户配置文件信息
echo ----------------------------------------
echo 用户配置文件目录: %USERPROFILE%
echo 桌面目录: %USERPROFILE%\Desktop
echo 文档目录: %USERPROFILE%\Documents
echo 下载目录: %USERPROFILE%\Downloads
echo.

:: 演示10：登录会话信息
echo [演示10] 登录会话信息
echo ----------------------------------------
echo [命令] query user 2>nul
query user 2>nul
if %errorLevel% neq 0 (
    echo [WARNING] 无法获取会话信息（可能需要管理员权限）
)
echo.

:: 演示11：系统用户列表
echo [演示11] 系统用户列表
echo ----------------------------------------
echo [命令] net user
net user
echo.

:: 演示12：安全建议
echo [演示12] 安全建议
echo ----------------------------------------
echo [BEST PRACTICE] 用户安全最佳实践：
echo 1. 使用标准用户账户进行日常操作
echo 2. 仅在必要时使用管理员权限
echo 3. 定期更改密码
echo 4. 使用强密码策略
echo 5. 启用账户锁定策略
echo 6. 监控用户登录活动
echo 7. 定期审查用户权限
echo 8. 删除不再需要的用户账户
echo.

:: 检查是否以管理员身份运行
echo [演示13] 管理员权限检查
echo ----------------------------------------
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [SUCCESS] 以管理员身份运行
    echo 您可以执行需要管理员权限的操作
) else (
    echo [INFO] 以标准用户身份运行
    echo 某些操作可能需要管理员权限
)
echo.

:: 记录结束时间
echo [%date% %time%] 用户信息查看完成 >> "%log_file%"

:: 生成用户信息报告
echo [INFO] 生成用户信息报告...
set "report_file=%~dp0user_report_%date:~0,4%%date:~5,2%%date:~8,2%.txt"

(
    echo 用户信息报告
    echo 生成时间: %date% %time%
    echo.
    echo ====================
    echo 基本信息
    echo ====================
    echo 用户名: %USERNAME%
    echo 域: %USERDOMAIN%
    echo 配置文件: %USERPROFILE%
    echo.
    echo ====================
    echo 用户组信息
    echo ====================
    whoami /groups
    echo.
    echo ====================
    echo 用户权限
    echo ====================
    whoami /priv
) > "%report_file%"

echo 用户信息报告已保存到: %report_file%
echo.

echo ============================================================
echo 用户信息查看完成
echo ============================================================
echo.
echo 日志文件: %log_file%
echo 报告文件: %report_file%
echo.
echo 按任意键退出...
pause >nul