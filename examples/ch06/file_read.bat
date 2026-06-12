@echo off
chcp 65001 >nul 2>&1
:: file_read.bat - 文件读取演示
:: 安全提示：创建临时测试文件，使用后自动清理

setlocal EnableDelayedExpansion

:: 设置测试文件路径
set "TEST=%~dp0test_input.txt"

echo ========================================
echo 文件读取演示
echo ========================================
echo.

:: 创建测试文件
echo 创建测试文件...
echo Line 1: Hello > "%TEST%"
echo Line 2: World >> "%TEST%"
echo Line 3: CMD Scripting >> "%TEST%"
echo   Line 4: with leading spaces  >> "%TEST%"
echo Line 5: Special chars ^<^>^&^| >> "%TEST%"
echo. >> "%TEST%"
echo Line 7: After empty line >> "%TEST%"
echo 测试文件创建完成
echo.

echo === 1. type命令读取整个文件 ===
echo 文件内容：
type "%TEST%"
echo.

echo === 2. more命令分页读取 ===
echo 使用more读取（自动分页）：
more "%TEST%"
echo.

echo === 3. for /F逐行读取 ===
echo 使用for /F逐行读取：
for /F "usebackq tokens=*" %%a in ("%TEST%") do (
    echo 读取: %%a
)
echo.

echo === 4. 带行号读取 ===
echo 带行号显示：
set "linenum=0"
for /F "usebackq tokens=*" %%a in ("%TEST%") do (
    set /a "linenum+=1"
    echo !linenum!: %%a
)
echo 总行数: !linenum!
echo.

echo === 5. 提取特定列 ===
echo 创建CSV测试文件...
set "CSV=%~dp0test_data.csv"
echo Name,Age,City > "%CSV%"
echo Alice,25,Beijing >> "%CSV%"
echo Bob,30,Shanghai >> "%CSV%"
echo Charlie,35,Guangzhou >> "%CSV%"

echo CSV文件内容：
type "%CSV%"
echo.

echo 提取第1列和第3列：
for /F "usebackq skip=1 tokens=1,3 delims=," %%a in ("%CSV%") do (
    echo 姓名: %%a, 城市: %%c
)
echo.

echo === 6. 跳过标题行 ===
echo 跳过第一行读取：
for /F "usebackq skip=1 tokens=*" %%a in ("%TEST%") do (
    echo %%a
)
echo.

echo === 7. 条件过滤 ===
echo 查找包含"Line"的行：
for /F "usebackq tokens=*" %%a in ("%TEST%") do (
    set "line=%%a"
    echo !line! | findstr /i "Line" >nul
    if !errorlevel! equ 0 (
        echo 找到: %%a
    )
)
echo.

:: 清理临时文件
echo ========================================
echo 清理临时文件...
del "%TEST%" 2>nul
del "%CSV%" 2>nul
echo 清理完成
echo ========================================

endlocal