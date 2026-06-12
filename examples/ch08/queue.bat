@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 安全提示：本脚本仅进行变量操作，不会修改系统文件
:: 功能：演示CMD中队列（先进先出）模拟的基本操作

echo === CMD队列模拟示例 ===
echo.

echo === 初始化队列 ===
call :queue_init
echo 队列已初始化，大小: !queue_size!
echo.

echo === 入队操作 ===
call :enqueue "Task A"
call :enqueue "Task B"
call :enqueue "Task C"
call :enqueue "Task D"
call :enqueue "Task E"

echo 入队5个任务后，队列大小: !queue_size!
echo 当前队列内容:
call :queue_print
echo.

echo === 查看队首元素 ===
call :queue_peek
echo 队首元素: !queue_front!
echo.

echo === 出队操作 ===
call :dequeue
echo 出队: !queue_front!
call :dequeue
echo 出队: !queue_front!
call :dequeue
echo 出队: !queue_front!

echo.
echo 出队3个任务后，队列大小: !queue_size!
echo 当前队列内容:
call :queue_print
echo.

echo === 继续入队操作 ===
call :enqueue "Task F"
call :enqueue "Task G"

echo 入队2个新任务后，队列大小: !queue_size!
echo 当前队列内容:
call :queue_print
echo.

echo === 循环队列演示 ===
echo 循环队列可以更有效地利用空间...
call :circular_queue_demo

endlocal
goto :eof

:: 普通队列操作函数
:queue_init
set "queue_head=1"
set "queue_tail=0"
set "queue_size=0"
goto :eof

:enqueue
set /a "queue_tail+=1"
set /a "queue_size+=1"
set "queue[%queue_tail%]=%~1"
goto :eof

:dequeue
if !queue_size! LEQ 0 (
    echo 队列为空！
    set "queue_front="
    goto :eof
)
set /a "queue_head+=1"
set "queue_front=!queue[%queue_head%]!"
set "queue[%queue_head%]="
set /a "queue_size-=1"
goto :eof

:queue_peek
if !queue_size! LEQ 0 (
    echo 队列为空！
    set "queue_front="
    goto :eof
)
set "queue_front=!queue[%queue_head%]!"
goto :eof

:queue_print
if !queue_size! LEQ 0 (
    echo   队列为空
    goto :eof
)
echo   队首 ^
<^-
for /L %%i in (!queue_head!,1,!queue_tail!) do (
    if defined queue[%%i] (
        echo   [!queue[%%i]!]
    )
)
echo   -^> 队尾
goto :eof

:: 循环队列演示函数
:circular_queue_demo
echo.
echo === 循环队列演示 ===
set "cq_capacity=5"
set "cq_head=0"
set "cq_tail=0"
set "cq_size=0"

echo 循环队列容量: !cq_capacity!

echo.
echo 入队操作:
call :cq_enqueue "Item1"
call :cq_enqueue "Item2"
call :cq_enqueue "Item3"
echo 入队3个元素，大小: !cq_size!

echo.
echo 出队操作:
call :cq_dequeue
echo 出队: !cq_front!
echo 大小: !cq_size!

echo.
echo 继续入队:
call :cq_enqueue "Item4"
call :cq_enqueue "Item5"
call :cq_enqueue "Item6"
echo 入队3个元素，大小: !cq_size!
echo 当前队列内容:
call :cq_print

goto :eof

:cq_enqueue
if !cq_size! GEQ !cq_capacity! (
    echo 循环队列已满！
    goto :eof
)
set "cq[!cq_tail!]=%~1"
set /a "cq_tail=(cq_tail + 1) %% cq_capacity"
set /a "cq_size+=1"
goto :eof

:cq_dequeue
if !cq_size! LEQ 0 (
    echo 循环队列为空！
    set "cq_front="
    goto :eof
)
set "cq_front=!cq[%cq_head%]!"
set "cq[%cq_head%]="
set /a "cq_head=(cq_head + 1) %% cq_capacity"
set /a "cq_size-=1"
goto :eof

:cq_print
if !cq_size! LEQ 0 (
    echo   循环队列为空
    goto :eof
)
echo   循环队列内容:
set "current=!cq_head!"
for /L %%i in (0,1,!cq_size!-1) do (
    call echo   [%%cq[!current!]%%] 位于位置 !current!
    set /a "current=(current + 1) %% cq_capacity"
)
goto :eof