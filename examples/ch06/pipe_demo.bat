@echo off
chcp 65001 >nul 2>&1
:: pipe_demo.bat - 管道演示
:: 安全提示：仅演示管道操作，不创建/删除文件

setlocal

echo ========================================
echo 管道（Pipe）演示
echo ========================================
echo.

echo === 1. 基本管道用法 ===
echo 将echo输出通过管道传递给findstr
echo hello world | findstr "hello"
echo.

echo === 2. 多级管道 ===
echo 当前目录中的.bat文件（多级管道）：
dir "%~dp0" | findstr ".bat" | sort
echo.

echo === 3. 统计行数 ===
echo 统计多行输出的行数：
echo line1 & echo line2 & echo line3 | find /c /v ""
echo.

echo === 4. 管道组合示例 ===
echo 当前目录文件数量（不包括子目录）：
dir /b "%~dp0" | find /c /v ""
echo.

echo === 5. 管道排序 ===
echo 当前目录文件按名称排序（前5个）：
dir /b "%~dp0" | sort | findstr /n "^" | findstr "^[1-5]:"
echo.

echo === 6. 管道过滤 ===
echo 查找包含"bat"的文件：
dir /b "%~dp0" | findstr /i "bat"
echo.

echo === 7. 管道与重定向结合 ===
echo 将管道结果保存到文件：
dir /b "%~dp0" | sort > "%~dp0sorted_files.txt"
echo 排序后的文件列表：
type "%~dp0sorted_files.txt"
echo.

echo === 8. 复杂管道示例 ===
echo 统计当前目录中不同扩展名的文件数量：
echo 扩展名统计：
dir /b "%~dp0" | findstr "\." | for /f "tokens=2 delims=." %%a in ('more') do @echo %%a
echo.

:: 清理临时文件
del "%~dp0sorted_files.txt" 2>nul

echo ========================================
echo 管道演示完成
echo ========================================

endlocal