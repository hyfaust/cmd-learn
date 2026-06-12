@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 安全提示：本脚本仅进行变量操作，不会修改系统文件
:: 功能：演示CMD中栈（后进先出）模拟的基本操作

echo === CMD栈模拟示例 ===
echo.

echo === 初始化栈 ===
call :stack_init
echo 栈已初始化，大小: !stack_size!
echo.

echo === 入栈操作 ===
call :stack_push "First"
call :stack_push "Second"
call :stack_push "Third"
call :stack_push "Fourth"

echo 入栈4个元素后，栈大小: !stack_size!
echo 当前栈内容:
call :stack_print
echo.

echo === 查看栈顶元素 ===
call :stack_peek
echo 栈顶元素: !stack_top!
echo.

echo === 出栈操作 ===
call :stack_pop
echo 弹出: !stack_top!
call :stack_pop
echo 弹出: !stack_top!

echo.
echo 出栈2个元素后，栈大小: !stack_size!
echo 当前栈内容:
call :stack_print
echo.

echo === 栈应用：括号匹配检查 ===
set "expression1=(a+b)*(c-d)"
set "expression2=(a+b)*(c-d"
set "expression3=a+b)*(c-d)"

echo 检查表达式: !expression1!
call :check_brackets "!expression1!"
echo 结果: !bracket_result!

echo.
echo 检查表达式: !expression2!
call :check_brackets "!expression2!"
echo 结果: !bracket_result!

echo.
echo 检查表达式: !expression3!
call :check_brackets "!expression3!"
echo 结果: !bracket_result!

echo.
echo === 栈应用：简单表达式求值 ===
echo 计算后缀表达式: 3 4 + 2 *
call :eval_postfix "3 4 + 2 *"
echo 结果: !eval_result!

endlocal
goto :eof

:: 栈操作函数
:stack_init
set "stack_size=0"
goto :eof

:stack_push
set /a "stack_size+=1"
set "stack[%stack_size%]=%~1"
goto :eof

:stack_pop
if !stack_size! LEQ 0 (
    echo 栈为空！
    set "stack_top="
    goto :eof
)
set "stack_top=!stack[%stack_size%]!"
set "stack[%stack_size%]="
set /a "stack_size-=1"
goto :eof

:stack_peek
if !stack_size! LEQ 0 (
    echo 栈为空！
    set "stack_top="
    goto :eof
)
set "stack_top=!stack[%stack_size%]!"
goto :eof

:stack_print
if !stack_size! LEQ 0 (
    echo   栈为空
    goto :eof
)
for /L %%i in (!stack_size!,-1,1) do (
    if %%i==!stack_size! (
        echo   栈顶: !stack[%%i]!
    ) else (
        echo         !stack[%%i]!
    )
)
goto :eof

:: 括号匹配检查函数
:check_brackets
call :stack_init
set "expression=%~1"
set "bracket_result=匹配"

for /L %%i in (0,1,100) do (
    set "char=!expression:~%%i,1!"
    if "!char!"=="" goto :check_done
    if "!char!"=="(" call :stack_push "("
    if "!char!"==")" (
        if !stack_size! LEQ 0 (
            set "bracket_result=不匹配"
            goto :check_done
        )
        call :stack_pop
    )
)

:check_done
if !stack_size! NEQ 0 set "bracket_result=不匹配"
goto :eof

:: 简单后缀表达式求值
:eval_postfix
call :stack_init
set "expression=%~1"
set "eval_result=0"

for %%a in (%expression%) do (
    set "token=%%a"
    
    :: 检查是否为数字
    set "is_number=0"
    for /L %%n in (0,1,9) do (
        if "!token!"=="%%n" set "is_number=1"
    )
    
    if !is_number!==1 (
        call :stack_push "!token!"
    ) else (
        :: 弹出两个操作数
        call :stack_pop
        set "operand2=!stack_top!"
        call :stack_pop
        set "operand1=!stack_top!"
        
        :: 执行运算
        if "!token!"=="+" (
            set /a "result=!operand1! + !operand2!"
        ) else if "!token!"=="-" (
            set /a "result=!operand1! - !operand2!"
        ) else if "!token!"=="*" (
            set /a "result=!operand1! * !operand2!"
        ) else if "!token!"=="/" (
            set /a "result=!operand1! / !operand2!"
        )
        
        call :stack_push "!result!"
    )
)

call :stack_pop
set "eval_result=!stack_top!"
goto :eof