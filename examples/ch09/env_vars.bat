@echo off
chcp 65001 >nul
REM ============================================
REM 环境变量操作演示
REM 文件: env_vars.bat
REM 作者: 教程工程师
REM 日期: 2026-06-11 (避免使用 %date% 变量)
REM 安全提示: 本脚本仅演示环境变量操作，不会修改系统配置
REM ============================================

setlocal enabledelayedexpansion

echo ============================================
echo 环境变量操作演示
echo ============================================
echo.

echo [1] 查看系统环境变量
echo ----------------------------------------
echo 系统根目录: %SystemRoot%
echo 程序文件目录: %ProgramFiles%
echo 用户配置文件: %USERPROFILE%
echo 临时目录: %TEMP%
echo 计算机名: %COMPUTERNAME%
echo 用户名: %USERNAME%
echo 处理器架构: %PROCESSOR_ARCHITECTURE%
echo.

echo [2] 查看PATH变量（简化显示）
echo ----------------------------------------
echo PATH变量包含以下目录:
echo %PATH:;=&echo.%
echo.

echo [3] 创建临时环境变量
echo ----------------------------------------
set MY_TEMP_VAR=Hello, CMD Environment!
echo 创建临时变量 MY_TEMP_VAR = !MY_TEMP_VAR!
echo.

echo [4] 修改临时环境变量
echo ----------------------------------------
set MY_TEMP_VAR=Modified Value
echo 修改后 MY_TEMP_VAR = !MY_TEMP_VAR!
echo.

echo [5] 删除临时环境变量
echo ----------------------------------------
set MY_TEMP_VAR=
echo 删除后 MY_TEMP_VAR = !MY_TEMP_VAR!
if not defined MY_TEMP_VAR (
    echo 变量 MY_TEMP_VAR 已成功删除
) else (
    echo 变量 MY_TEMP_VAR 删除失败
)
echo.

echo [6] 使用setx创建永久环境变量（模拟）
echo ----------------------------------------
echo 注意: setx命令会永久修改注册表中的环境变量
echo 本演示仅显示命令，不实际执行
echo.
echo 命令: setx MY_PERMANENT_VAR "Permanent Value"
echo.

echo [7] 环境变量的作用域演示
echo ----------------------------------------
echo 系统环境变量: 影响所有用户
echo 用户环境变量: 仅影响当前用户
echo 进程环境变量: 仅影响当前进程（如本脚本）
echo.

echo [8] 环境变量的继承演示
echo ----------------------------------------
echo 子进程会继承父进程的环境变量
echo 但子进程的修改不会影响父进程
echo.

echo [9] 常见环境变量使用示例
echo ----------------------------------------
echo 使用环境变量构建路径:
set "APP_CONFIG=%USERPROFILE%\AppData\Local\MyApp"
echo 应用程序配置目录: !APP_CONFIG!
echo.

echo 使用临时目录:
set "TEMP_FILE=%TEMP%\my_temp_file.txt"
echo 临时文件路径: !TEMP_FILE!
echo.

echo [10] 环境变量的安全使用
echo ----------------------------------------
echo 1. 使用引号包裹包含空格的路径
echo 2. 使用延迟展开处理括号内的变量
echo 3. 检查变量是否存在再使用
echo 4. 避免修改系统关键环境变量
echo.

echo ============================================
echo 演示完成
echo ============================================
echo 提示: 关闭本窗口后，所有临时环境变量将丢失
echo.

pause