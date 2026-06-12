@echo off
chcp 65001 >nul 2>&1
:: ============================================================
:: setlocal_demo.bat - 作用域演示
:: 第07章 函数与模块化示例
::
:: 安全提示：本脚本仅进行变量操作和控制流演示
:: ============================================================

echo ========================================
echo setlocal/endlocal 作用域演示
echo ========================================
echo.

REM 设置全局变量
set "global_var=I am global"
echo 全局变量: %global_var%

echo.
echo === 第一层 setlocal ===
setlocal
set "local_var=inside first setlocal"
echo 局部变量: %local_var%
echo 全局变量仍然可访问: %global_var%

echo.
echo === 第二层 setlocal ===
setlocal
set "local_var=inside second setlocal"
set "global_var=modified in second setlocal"
echo 局部变量: %local_var%
echo 全局变量被修改: %global_var%

echo.
echo === 退出第二层 endlocal ===
endlocal
echo 局部变量: %local_var%
echo 全局变量: %global_var%

echo.
echo === 退出第一层 endlocal ===
endlocal
echo 局部变量: %local_var%
echo 全局变量: %global_var%

echo.
echo === 演示函数中的作用域 ===
set "x=100"
echo 主程序 x=%x%

call :my_function
echo 调用后 x=%x%

goto :eof

:: ============================================================
:: 函数定义区域
:: ============================================================

:my_function
:: 演示函数中的变量作用域
setlocal
set "x=200"
set "local_func_var=function local"
echo 函数内 x=%x%
echo 函数内局部变量: %local_func_var%
endlocal
goto :eof
