@echo off
chcp 65001 >nul 2>&1
:: file_write.bat - 文件写入演示
:: 安全提示：所有文件操作在脚本目录内进行，使用临时文件后自动清理

setlocal

:: 设置输出文件路径
set "OUT=%~dp0test_output.txt"
set "SOURCE=%~dp0test_source.txt"

echo ========================================
echo 文件写入演示
echo ========================================
echo.

:: 清理可能存在的旧文件
del "%OUT%" 2>nul
del "%SOURCE%" 2>nul

echo === 1. echo覆盖写入 (>) ===
echo First line > "%OUT%"
echo Second line >> "%OUT%"
echo Third line >> "%OUT%"
echo 覆盖写入完成，文件内容：
type "%OUT%"
echo.

echo === 2. echo追加写入 (>>) ===
echo Fourth line >> "%OUT%"
echo Fifth line >> "%OUT%"
echo 追加写入完成，文件内容：
type "%OUT%"
echo.

echo === 3. 使用set /p写入（无换行） ===
echo 创建新文件（无换行符）...
<nul set /p "=No newline here" > "%OUT%"
echo. >> "%OUT%"
<nul set /p "=Another line without newline" >> "%OUT%"
echo. >> "%OUT%"
echo set /p写入完成，文件内容：
type "%OUT%"
echo.

echo === 4. type追加文件 ===
echo 创建源文件...
echo Source line 1 > "%SOURCE%"
echo Source line 2 >> "%SOURCE%"
echo 源文件内容：
type "%SOURCE%"
echo.

echo 追加到目标文件...
type "%SOURCE%" >> "%OUT%"
echo 追加后目标文件内容：
type "%OUT%"
echo.

echo === 5. 写入特殊字符 ===
echo 写入包含特殊字符的内容...
echo Characters: ^<^>^&^|^" >> "%OUT%"
echo Path: C:\Windows\System32 >> "%OUT%"
echo Variable: %OS% >> "%OUT%"
echo 特殊字符写入完成，文件内容：
type "%OUT%"
echo.

echo === 6. 写入空行 ===
echo 添加空行...
echo. >> "%OUT%"
echo. >> "%OUT%"
echo 空行添加完成，文件内容（带行号）：
findstr /n "^" "%OUT%"
echo.

echo === 7. 创建CSV文件 ===
set "CSV=%~dp0test_output.csv"
echo Name,Age,City > "%CSV%"
echo Alice,25,Beijing >> "%CSV%"
echo Bob,30,Shanghai >> "%CSV%"
echo Charlie,35,Guangzhou >> "%CSV%"
echo CSV文件创建完成，内容：
type "%CSV%"
echo.

echo === 8. 创建HTML文件 ===
set "HTML=%~dp0test_output.html"
echo ^<!DOCTYPE html^> > "%HTML%"
echo ^<html^> >> "%HTML%"
echo ^<head^> >> "%HTML%"
echo     ^<title^>Test Page^</title^> >> "%HTML%"
echo ^</head^> >> "%HTML%"
echo ^<body^> >> "%HTML%"
echo     ^<h1^>Hello from CMD^</h1^> >> "%HTML%"
echo ^</body^> >> "%HTML%"
echo ^</html^> >> "%HTML%"
echo HTML文件创建完成，内容：
type "%HTML%"
echo.

:: 清理临时文件
echo ========================================
echo 清理临时文件...
del "%OUT%" 2>nul
del "%SOURCE%" 2>nul
del "%CSV%" 2>nul
del "%HTML%" 2>nul
echo 清理完成
echo ========================================

endlocal