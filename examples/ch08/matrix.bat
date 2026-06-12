@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 安全提示：本脚本仅进行变量操作，不会修改系统文件
:: 功能：演示CMD中多维数组（矩阵）的基本操作

echo === CMD多维数组（矩阵）示例 ===
echo.

echo === 创建3x3矩阵 ===
for /L %%i in (1,1,3) do (
    for /L %%j in (1,1,3) do (
        set /a "mat[%%i][%%j]=%%i * 10 + %%j"
    )
)

echo 矩阵已创建
echo.

echo === 打印矩阵 ===
echo 矩阵 A:
for /L %%i in (1,1,3) do (
    set "line="
    for /L %%j in (1,1,3) do (
        set "line=!line! !mat[%%i][%%j]!"
    )
    echo   !line!
)
echo.

echo === 矩阵转置 ===
for /L %%i in (1,1,3) do (
    for /L %%j in (1,1,3) do (
        set "trans[%%j][%%i]=!mat[%%i][%%j]!"
    )
)

echo 转置矩阵 A^T:
for /L %%i in (1,1,3) do (
    set "line="
    for /L %%j in (1,1,3) do (
        set "line=!line! !trans[%%i][%%j]!"
    )
    echo   !line!
)
echo.

echo === 创建第二个矩阵 ===
set "matB[1][1]=5" & set "matB[1][2]=6" & set "matB[1][3]=7"
set "matB[2][1]=8" & set "matB[2][2]=9" & set "matB[2][3]=10"
set "matB[3][1]=11" & set "matB[3][2]=12" & set "matB[3][3]=13"

echo 矩阵 B:
for /L %%i in (1,1,3) do (
    set "line="
    for /L %%j in (1,1,3) do (
        set "line=!line! !matB[%%i][%%j]!"
    )
    echo   !line!
)
echo.

echo === 矩阵加法 A + B ===
for /L %%i in (1,1,3) do (
    for /L %%j in (1,1,3) do (
        set /a "sum[%%i][%%j]=!mat[%%i][%%j]! + !matB[%%i][%%j]!"
    )
)

echo 结果矩阵 A + B:
for /L %%i in (1,1,3) do (
    set "line="
    for /L %%j in (1,1,3) do (
        set "line=!line! !sum[%%i][%%j]!"
    )
    echo   !line!
)
echo.

echo === 矩阵乘法 A * B ===
for /L %%i in (1,1,3) do (
    for /L %%j in (1,1,3) do (
        set "mul[%%i][%%j]=0"
        for /L %%k in (1,1,3) do (
            set /a "mul[%%i][%%j]+=!mat[%%i][%%k]! * !matB[%%k][%%j]!"
        )
    )
)

echo 结果矩阵 A * B:
for /L %%i in (1,1,3) do (
    set "line="
    for /L %%j in (1,1,3) do (
        set "line=!line! !mul[%%i][%%j]!"
    )
    echo   !line!
)
echo.

echo === 矩阵函数演示 ===
echo 创建自定义矩阵:
call :matrix_create 2 3
call :matrix_set 1 1 10
call :matrix_set 1 2 20
call :matrix_set 1 3 30
call :matrix_set 2 1 40
call :matrix_set 2 2 50
call :matrix_set 2 3 60

echo 自定义矩阵 (2x3):
call :matrix_print 2 3

echo.
echo 获取元素 [1][2]:
call :matrix_get 1 2
echo 结果: !matrix_value!

echo.
echo 计算矩阵所有元素的和:
call :matrix_sum 2 3
echo 矩阵和: !matrix_sum_result!

endlocal
goto :eof

:: 矩阵操作函数
:matrix_create
set "matrix_rows=%~1"
set "matrix_cols=%~2"
for /L %%i in (1,1,!matrix_rows!) do (
    for /L %%j in (1,1,!matrix_cols!) do (
        set "custom[%%i][%%j]=0"
    )
)
goto :eof

:matrix_set
set "custom[%~1][%~2]=%~3"
goto :eof

:matrix_get
set "matrix_value=!custom[%~1][%~2]!"
goto :eof

:matrix_print
set "rows=%~1"
set "cols=%~2"
for /L %%i in (1,1,!rows!) do (
    set "line="
    for /L %%j in (1,1,!cols!) do (
        set "line=!line! !custom[%%i][%%j]!"
    )
    echo   !line!
)
goto :eof

:matrix_sum
set "rows=%~1"
set "cols=%~2"
set "matrix_sum_result=0"
for /L %%i in (1,1,!rows!) do (
    for /L %%j in (1,1,!cols!) do (
        set /a "matrix_sum_result+=!custom[%%i][%%j]!"
    )
)
goto :eof