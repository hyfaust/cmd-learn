@echo off
chcp 65001 >nul
REM ============================================
REM 注册表查询演示
REM 文件: reg_query.bat
REM 作者: 教程工程师
REM 日期: 2026-06-11
REM 安全提示: 本脚本仅查询注册表，不会修改任何注册表项
REM ============================================

setlocal enabledelayedexpansion

echo ============================================
echo 注册表查询演示
echo ============================================
echo.

echo [1] 查询当前用户环境变量
echo ----------------------------------------
echo 查询 HKCU\Environment 注册表项:
reg query "HKCU\Environment"
echo.
echo 查询特定值 Path:
reg query "HKCU\Environment" /v Path
echo.

echo [2] 查询系统环境变量
echo ----------------------------------------
echo 查询系统环境变量注册表项:
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path
echo.

echo [3] 查询注册表子项
echo ----------------------------------------
echo 查询 HKCU\Software\Microsoft 下的子项:
reg query "HKCU\Software\Microsoft" /s /f "" /k 2>nul | findstr /i "HKEY_CURRENT_USER" | head -10
echo.

echo [4] 查询特定注册表值
echo ----------------------------------------
echo 查询 Windows 版本信息:
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName
echo.
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentVersion
echo.

echo [5] 查询注册表数据类型
echo ----------------------------------------
echo 查询环境变量的数据类型:
reg query "HKCU\Environment" /v Path /t
echo.

echo [6] 查询注册表项的所有值
echo ----------------------------------------
echo 查询 HKCU\Environment 的所有值:
for /f "tokens=1,2,3" %%A in ('reg query "HKCU\Environment"') do (
    echo 值名称: %%A
    echo 数据类型: %%B
    echo 数据值: %%C
    echo.
)
echo.

echo [7] 使用findstr过滤注册表查询结果
echo ----------------------------------------
echo 查找包含 "Path" 的环境变量:
reg query "HKCU\Environment" | findstr /i "Path"
echo.
echo 查找包含 "Temp" 的环境变量:
reg query "HKCU\Environment" | findstr /i "Temp"
echo.

echo [8] 查询注册表项权限信息（需要管理员权限）
echo ----------------------------------------
echo 查询 HKCU\Environment 的权限:
reg query "HKCU\Environment" /s 2>nul | findstr /i "权限" || echo 权限查询需要管理员权限
echo.

echo [9] 查询注册表项的详细信息
echo ----------------------------------------
echo 查询 HKCU\Environment 的详细信息:
reg query "HKCU\Environment" /ve
echo.

echo [10] 注册表查询的最佳实践
echo ----------------------------------------
echo 1. 使用 /f 参数进行搜索
echo 2. 使用 /s 参数递归查询子项
echo 3. 使用 /t 参数指定数据类型
echo 4. 使用 /v 参数查询特定值
echo 5. 使用 /ve 参数查询默认值
echo 6. 结合 findstr 进行结果过滤
echo 7. 注意权限问题，某些注册表项需要管理员权限
echo.

echo ============================================
echo 注册表查询演示完成
echo ============================================
echo.
echo 提示: 注册表查询是只读操作，不会修改系统配置
echo 如需修改注册表，请使用 reg add 命令
echo.

pause