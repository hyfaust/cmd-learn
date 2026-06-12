@echo off
chcp 65001 >nul 2>&1
:: ============================================================
:: delayed_expansion.bat - 延迟扩展演示
:: 第07章 函数与模块化示例
::
:: 安全提示：本脚本仅进行变量操作和控制流演示
:: ============================================================

setlocal EnableDelayedExpansion

echo ========================================
echo 延迟扩展演示
echo ========================================
echo.

echo === 延迟扩展的必要性 ===
set "count=0"
echo 初始值: count=!count!
echo.

echo 使用延迟扩展（正确）:
for /L %%i in (1,1,5) do (
    set /a "count+=1"
    echo   循环 !count!: count=!count!
)
echo 最终值: count=!count!

echo.
echo === 代码块中的变量更新 ===
set "result="
for /L %%i in (1,1,5) do (
    set "result=!result! %%i"
)
echo 收集的数字: !result!

echo.
echo === 感叹号的处理 ===
set "msg=Hello World!"
echo 包含感叹号的字符串: !msg!

echo.
echo === 延迟扩展在条件语句中的应用 ===
set "status=unknown"
set "score=85"
if !score! GEQ 90 (
    set "status=excellent"
) else if !score! GEQ 80 (
    set "status=good"
) else if !score! GEQ 60 (
    set "status=pass"
) else (
    set "status=fail"
)
echo 分数: !score!, 状态: !status!

echo.
echo === 延迟扩展在函数中的应用 ===
call :count_to_n 10
echo 1到10的和: !sum!

endlocal
goto :eof

REM ============================================================
REM 函数定义区域
REM ============================================================

:count_to_n
REM 计算1到N的和
REM 参数: %1 - 上限N
REM 返回: 设置 sum 变量
set "sum=0"
for /L %%i in (1,1,%~1) do (
    set /a "sum+=%%i"
)
goto :eof
