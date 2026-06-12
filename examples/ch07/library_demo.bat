@echo off
chcp 65001 >nul 2>&1
:: ============================================================
:: library_demo.bat - 库文件使用演示
:: 第07章 函数与模块化示例
::
:: 安全提示：本脚本仅进行变量操作和控制流演示
::
:: 本脚本演示如何使用外部库文件中的函数
:: ============================================================

setlocal EnableDelayedExpansion

echo ========================================
echo 函数库使用演示
echo ========================================
echo.

:: 获取脚本所在目录
set "script_dir=%~dp0"

echo === 调用数学库函数 ===
echo.

:: 调用加法函数
call "%script_dir%lib\math_lib.bat" add 10 20
echo 10 + 20 = !result!

:: 调用减法函数
call "%script_dir%lib\math_lib.bat" subtract 50 15
echo 50 - 15 = !result!

:: 调用乘法函数
call "%script_dir%lib\math_lib.bat" multiply 3 7
echo 3 * 7 = !result!

:: 调用除法函数
call "%script_dir%lib\math_lib.bat" divide 100 4
echo 100 / 4 = !result!

:: 调用幂运算函数
call "%script_dir%lib\math_lib.bat" power 2 8
echo 2^8 = !result!

:: 调用绝对值函数
call "%script_dir%lib\math_lib.bat" abs -42
echo abs(-42) = !result!

echo.
echo === 组合使用多个函数 ===
echo.

:: 计算 (10 + 20) * 3
call "%script_dir%lib\math_lib.bat" add 10 20
set "temp=!result!"
call "%script_dir%lib\math_lib.bat" multiply !temp! 3
echo (10 + 20) * 3 = !result!

:: 计算 100 / (5 + 5)
call "%script_dir%lib\math_lib.bat" add 5 5
set "temp=!result!"
call "%script_dir%lib\math_lib.bat" divide 100 !temp!
echo 100 / (5 + 5) = !result!

echo.
echo === 错误处理演示 ===
echo.

:: 除零错误
call "%script_dir%lib\math_lib.bat" divide 10 0
echo 10 / 0 = !result!

echo.
echo === 查看库函数帮助 ===
echo.
call "%script_dir%lib\math_lib.bat"

endlocal
goto :eof
