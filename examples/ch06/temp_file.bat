@echo off
chcp 65001 >nul 2>&1
:: temp_file.bat - 临时文件使用演示
:: 安全提示：演示临时文件的创建、使用和清理，确保不会残留临时文件

setlocal EnableDelayedExpansion

echo ========================================
echo 临时文件使用演示
echo ========================================
echo.

echo === 1. 环境变量信息 ===
echo TEMP目录: %TEMP%
echo TMP目录: %TMP%
echo USERPROFILE: %USERPROFILE%
echo.

echo === 2. 创建唯一临时文件名 ===
:: 方法1：使用RANDOM
set "TMPFILE1=%TEMP%\demo1_%RANDOM%.txt"
echo 方法1（RANDOM）: !TMPFILE1!

:: 方法2：使用TIME（去除特殊字符）
set "TIME_STR=%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
set "TIME_STR=!TIME_STR: =0!"
set "TMPFILE2=%TEMP%\demo2_!TIME_STR!.txt"
echo 方法2（TIME）: !TMPFILE2!

:: 方法3：组合RANDOM和TIME
set "TMPFILE3=%TEMP%\demo3_%RANDOM%_!TIME_STR!.txt"
echo 方法3（组合）: !TMPFILE3!
echo.

echo === 3. 创建和使用临时文件 ===
echo 创建临时文件并写入数据...
echo This is temporary data > "!TMPFILE1!"
echo Created at: %date% %time% >> "!TMPFILE1!"
echo Process ID: %PROCESSOR_ARCHITECTURE% >> "!TMPFILE1!"

echo 临时文件内容：
type "!TMPFILE1!"
echo.

echo === 4. 临时文件用于中间处理 ===
echo 创建测试数据...
set "DATAFILE=%TEMP%\data_%RANDOM%.txt"
echo 5 > "!DATAFILE!"
echo 3 >> "!DATAFILE!"
echo 8 >> "!DATAFILE!"
echo 1 >> "!DATAFILE!"
echo 9 >> "!DATAFILE!"
echo 2 >> "!DATAFILE!"
echo 7 >> "!DATAFILE!"
echo 4 >> "!DATAFILE!"
echo 6 >> "!DATAFILE!"
echo 10 >> "!DATAFILE!"

echo 原始数据：
type "!DATAFILE!"
echo.

echo 排序后的数据（使用临时文件）：
set "SORTEDFILE=%TEMP%\sorted_%RANDOM%.txt"
sort "!DATAFILE!" > "!SORTEDFILE!"
type "!SORTEDFILE!"
echo.

echo 查找大于5的数字（使用临时文件）：
set "FILTEREDFILE=%TEMP%\filtered_%RANDOM%.txt"
findstr /v "^[1-5]$" "!SORTEDFILE!" > "!FILTEREDFILE!" 2>nul
type "!FILTEREDFILE!"
echo.

echo === 5. 临时文件用于日志记录 ===
set "LOGFILE=%TEMP%\log_%RANDOM%.txt"
echo [%date% %time%] Script started > "!LOGFILE!"
echo [%date% %time%] Processing data... >> "!LOGFILE!"
echo [%date% %time%] Data processed successfully >> "!LOGFILE!"
echo [%date% %time%] Script completed >> "!LOGFILE!"

echo 日志文件内容：
type "!LOGFILE!"
echo.

echo === 6. 临时文件用于错误捕获 ===
set "ERRFILE=%TEMP%\error_%RANDOM%.txt"
echo 执行可能出错的命令...
dir nonexistent_directory 2> "!ERRFILE!"
if exist "!ERRFILE!" (
    echo 检测到错误，错误信息：
    type "!ERRFILE!"
) else (
    echo 没有错误发生
)
echo.

echo === 7. 临时文件用于数据交换 ===
echo 创建两个临时文件用于数据交换...
set "FILE_A=%TEMP%\exchange_a_%RANDOM%.txt"
set "FILE_B=%TEMP%\exchange_b_%RANDOM%.txt"

echo Data from process A > "!FILE_A!"
echo Data from process B > "!FILE_B!"

echo 交换前：
echo File A: & type "!FILE_A!"
echo File B: & type "!FILE_B!"
echo.

echo 交换数据...
set "TEMP_CONTENT="
for /f "tokens=*" %%x in ('type "!FILE_A!"') do set "TEMP_CONTENT=%%x"
for /f "tokens=*" %%x in ('type "!FILE_B!"') do echo %%x > "!FILE_A!"
echo !TEMP_CONTENT! > "!FILE_B!"

echo 交换后：
echo File A: & type "!FILE_A!"
echo File B: & type "!FILE_B!"
echo.

echo === 8. 批量临时文件管理 ===
echo 创建多个临时文件...
set "BATCH_DIR=%TEMP%\batch_test_%RANDOM%"
mkdir "!BATCH_DIR!" 2>nul

for /l %%i in (1,1,5) do (
    echo File %%i content > "!BATCH_DIR!\file_%%i.txt"
)

echo 创建的临时文件：
dir /b "!BATCH_DIR!"
echo.

echo 临时文件内容：
for %%f in ("!BATCH_DIR!\*.txt") do (
    echo [%%~nxf]
    type "%%f"
)
echo.

:: 清理所有临时文件
echo ========================================
echo 清理所有临时文件...
del "!TMPFILE1!" 2>nul
del "!TMPFILE2!" 2>nul
del "!TMPFILE3!" 2>nul
del "!DATAFILE!" 2>nul
del "!SORTEDFILE!" 2>nul
del "!FILTEREDFILE!" 2>nul
del "!LOGFILE!" 2>nul
del "!ERRFILE!" 2>nul
del "!FILE_A!" 2>nul
del "!FILE_B!" 2>nul
rd /s /q "!BATCH_DIR!" 2>nul
echo 所有临时文件已清理
echo ========================================

endlocal