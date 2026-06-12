@echo off
chcp 65001 >nul 2>&1
:: ============================================================
:: math_lib.bat - Math Function Library
:: Chapter 07 - Functions and Modularization
::
:: Usage:
::   call math_lib.bat function_name param1 param2
::   Result returned via !result! variable
:: ============================================================

:: If no function specified, show help
if "%~1"=="" (
    echo Math Function Library - Available Functions:
    echo   add - Addition
    echo   subtract - Subtraction
    echo   multiply - Multiplication
    echo   divide - Division
    echo   power - Power
    echo   abs - Absolute Value
    goto :eof
)

:: Jump to specified function
goto %~1

:add
:: Addition function
set /a "result=%~2 + %~3"
goto :eof

:subtract
:: Subtraction function
set /a "result=%~2 - %~3"
goto :eof

:multiply
:: Multiplication function
set /a "result=%~2 * %~3"
goto :eof

:divide
:: Division function (integer division)
if "%~3"=="0" (
    set "result=0"
    echo Error: Division by zero
    goto :eof
)
set /a "result=%~2 / %~3"
goto :eof

:power
:: Power function
set "result=1"
for /L %%i in (1,1,%~3) do (
    set /a "result*=%~2"
)
goto :eof

:abs
:: Absolute value function
if %~2 LSS 0 (
    set /a "result=-1 * %~2"
) else (
    set /a "result=%~2"
)
goto :eof
