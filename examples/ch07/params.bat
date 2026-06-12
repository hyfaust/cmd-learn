@echo off
chcp 65001 >nul 2>&1
:: ============================================================
:: params.bat - 参数传递演示
:: 第07章 函数与模块化示例
::
:: 安全提示：本脚本仅进行变量操作和控制流演示
:: ============================================================

setlocal

echo ========================================
echo 参数传递演示
echo ========================================
echo.

echo === 基本参数 ===
call :show_params arg1 arg2 "arg with spaces"
echo.

echo === 参数个数统计 ===
call :count_params a b c d e
echo.

echo === 命名参数模拟 ===
call :named_params /name:Alice /age:25
echo.

echo === 参数修饰符演示 ===
call :show_modifiers "C:\My Documents\report.txt"

endlocal
goto :eof

:: ============================================================
:: 函数定义区域
:: ============================================================

:show_params
:: 显示传递的参数
:: 参数: 任意数量的参数
echo 参数1: %~1
echo 参数2: %~2
echo 参数3: %~3
echo 所有参数: %*
goto :eof

:count_params
:: 统计参数个数
:: 参数: 任意数量的参数
:: 返回: 通过echo输出参数个数
set "count=0"
:params_loop
if "%~1"=="" goto :params_done
set /a "count+=1"
shift
goto :params_loop
:params_done
echo 参数个数: %count%
goto :eof

:named_params
:: 模拟命名参数解析
:: 参数: /name:value /age:value 格式的参数
set "name="
set "age="
:named_loop
if "%~1"=="" goto :named_done
if /i "%~1"=="/name" set "name=%~2" & shift & shift & goto :named_loop
if /i "%~1"=="/age" set "age=%~2" & shift & shift & goto :named_loop
shift
goto :named_loop
:named_done
echo 姓名: %name%, 年龄: %age%
goto :eof

:show_modifiers
:: 演示参数修饰符的使用
:: 参数: %1 - 文件路径
echo 完整路径: %~f1
echo 驱动器: %~d1
echo 路径: %~p1
echo 文件名: %~n1
echo 扩展名: %~x1
goto :eof
