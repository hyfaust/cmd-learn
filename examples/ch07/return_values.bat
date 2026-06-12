@echo off
chcp 65001 >nul 2>&1
:: ============================================================
:: return_values.bat - 返回值演示
:: 第07章 函数与模块化示例
::
:: 安全提示：本脚本仅进行变量操作和控制流演示
:: ============================================================

setlocal EnableDelayedExpansion

echo ========================================
echo 返回值演示
echo ========================================
echo.

echo === 通过ERRORLEVEL返回 ===
call :add 3 5
echo 3 + 5 = %ERRORLEVEL%

call :multiply 4 6
echo 4 * 6 = %ERRORLEVEL%
echo.

echo === 通过变量返回 ===
call :multiply_var 4 6
echo 4 * 6 = !result!

call :get_greeting "Alice"
echo 问候语: !greeting!
echo.

echo === 字符串返回 ===
call :get_date
echo 当前日期: !datestr!

call :get_time
echo 当前时间: !timestr!
echo.

echo === 多值返回 ===
call :get_min_max 5 2 8 1 9
echo 最小值: !min_val!, 最大值: !max_val!

endlocal
goto :eof

:: ============================================================
:: 函数定义区域
:: ============================================================

:add
:: 加法函数 - 通过ERRORLEVEL返回结果
:: 参数: %1, %2 - 要相加的两个数
:: 返回: ERRORLEVEL = %1 + %2
set /a "res=%~1 + %~2"
exit /b %res%

:multiply
:: 乘法函数 - 通过ERRORLEVEL返回结果
:: 参数: %1, %2 - 要相乘的两个数
:: 返回: ERRORLEVEL = %1 * %2
set /a "res=%~1 * %~2"
exit /b %res%

:multiply_var
:: 乘法函数 - 通过变量返回结果
:: 参数: %1, %2 - 要相乘的两个数
:: 返回: 设置 result 变量
set /a "result=%~1 * %~2"
goto :eof

:get_greeting
:: 获取问候语 - 通过变量返回字符串
:: 参数: %1 - 姓名
:: 返回: 设置 greeting 变量
set "greeting=Hello, %~1! Welcome to batch scripting!"
goto :eof

:get_date
:: 获取当前日期 - 通过变量返回
:: 返回: 设置 datestr 变量
set "datestr=%DATE%"
goto :eof

:get_time
:: 获取当前时间 - 通过变量返回
:: 返回: 设置 timestr 变量
set "timestr=%TIME%"
goto :eof

:get_min_max
:: 获取最小值和最大值 - 多值返回示例
:: 参数: 多个数字
:: 返回: 设置 min_val 和 max_val 变量
set "min_val=%~1"
set "max_val=%~1"
:min_max_loop
if "%~1"=="" goto :min_max_done
if %~1 LSS %min_val% set "min_val=%~1"
if %~1 GTR %max_val% set "max_val=%~1"
shift
goto :min_max_loop
:min_max_done
goto :eof
