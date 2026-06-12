@echo off
chcp 65001 >nul 2>&1
:: redirect_basic.bat - 基础重定向演示
:: 安全提示：所有文件操作在脚本目录内进行，使用临时文件后自动清理

setlocal

:: 设置输出文件路径（使用脚本所在目录）
set "OUT=%~dp0output.txt"
set "ERR=%~dp0error.txt"
set "FULL=%~dp0full.txt"

echo ========================================
echo 基础重定向演示
echo ========================================
echo.

echo === 1. 覆盖写入 (>) ===
echo Hello > "%OUT%"
echo World >> "%OUT%"
echo 覆盖写入完成，文件内容：
type "%OUT%"
echo.

echo === 2. 追加写入 (>>) ===
echo This is line 3 >> "%OUT%"
echo This is line 4 >> "%OUT%"
echo 追加写入完成，文件内容：
type "%OUT%"
echo.

echo === 3. 错误重定向 (2>) ===
echo 尝试访问不存在的目录...
dir nonexistent_directory 2> "%ERR%"
echo 错误信息已写入文件：
type "%ERR%"
echo.

echo === 4. 合并输出 (2>&1) ===
echo 将标准输出和错误输出合并到同一文件...
dir "%~dp0" > "%FULL%" 2>&1
echo 合并输出完成，文件内容（前5行）：
more +0 "%FULL%" | findstr /n "^" | findstr "^[1-5]:"
echo.

echo === 5. 丢弃输出 (>nul) ===
echo 这条消息会被丢弃 >nul
echo 2>nul
echo 静默操作完成
echo.

echo === 6. 分离输出和错误 ===
echo 分离输出演示：
echo 正常输出到屏幕
dir nonexistent 2>nul
echo 如果上面没有错误信息，说明错误已被丢弃
echo.

:: 清理临时文件
echo ========================================
echo 清理临时文件...
del "%OUT%" 2>nul
del "%ERR%" 2>nul
del "%FULL%" 2>nul
echo 清理完成
echo ========================================

endlocal