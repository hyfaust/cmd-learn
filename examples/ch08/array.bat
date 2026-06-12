@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 安全提示：本脚本仅进行变量操作，不会修改系统文件
:: 功能：演示CMD中数组模拟的基本操作

echo === CMD数组模拟示例 ===
echo.

echo === 创建数组 ===
set "arr[0]=Apple"
set "arr[1]=Banana"
set "arr[2]=Cherry"
set "arr[3]=Date"
set "arr_len=4"

echo 数组已创建，长度: %arr_len%
echo.

echo === 遍历数组 ===
for /L %%i in (0,1,%arr_len%-1) do (
    echo arr[%%i]=!arr[%%i]!
)
echo.

echo === 修改数组元素 ===
echo 修改前 arr[1]=!arr[1]!
set "arr[1]=Blueberry"
echo 修改后 arr[1]=!arr[1]!
echo.

echo === 添加元素 ===
set "arr[4]=Elderberry"
set /a "arr_len+=1"
echo 添加元素后数组长度: !arr_len!
echo.

echo === 删除元素 ===
echo 删除 arr[2]...
set "arr[2]="
set /a "arr_len-=1"
echo 删除后数组长度: !arr_len!
echo.

echo === 重新遍历数组（跳过空元素）===
echo 遍历结果:
for /L %%i in (0,1,9) do (
    if defined arr[%%i] (
        echo arr[%%i]=!arr[%%i]!
    )
)
echo.

echo === 数组操作函数演示 ===
call :array_init
call :array_add "Red"
call :array_add "Green"
call :array_add "Blue"
call :array_add "Yellow"

echo 使用函数创建的数组:
call :array_print

echo.
echo 获取元素 arr[2]:
call :array_get 2
echo 结果: !array_value!

echo.
echo 修改元素 arr[1] 为 "Purple":
call :array_set 1 "Purple"
echo 修改后:
call :array_print

endlocal
goto :eof

:: 数组操作函数
:array_init
set "array_len=0"
goto :eof

:array_add
set "array[!array_len!]=%~1"
set /a "array_len+=1"
goto :eof

:array_get
set "array_value=!array[%~1]!"
goto :eof

:array_set
set "array[%~1]=%~2"
goto :eof

:array_print
for /L %%i in (0,1,!array_len!-1) do (
    echo   array[%%i]=!array[%%i]!
)
goto :eof