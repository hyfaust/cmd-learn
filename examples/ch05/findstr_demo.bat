@echo off
chcp 65001 >nul
:: 安全提示：此脚本仅进行字符串操作，不会修改任何文件
:: findstr查找演示 - CMD字符串查找功能

setlocal EnableDelayedExpansion

echo === findstr查找演示 ===
echo.

echo --- 基本查找 ---
echo hello world | findstr "hello"
echo.

echo --- 忽略大小写 ---
echo Hello World | findstr /I "hello"
echo.

echo --- 正则表达式 ---
echo abc123def | findstr /R "[0-9]"
echo.

echo --- 字母匹配 ---
echo 123abc456 | findstr /R "[a-z]"
echo.

echo --- 行开头匹配 ---
echo hello world | findstr /R "^hello"
echo.

echo --- 行结尾匹配 ---
echo hello world | findstr /R "world$"
echo.

echo --- 从文件查找 ---
findstr /I /N "echo" "%~dp0..\ch01\hello.bat" 2>nul
echo.

echo --- 多模式查找 ---
echo apple banana cherry | findstr /C:"apple" /C:"cherry"
echo.

echo --- 显示行号 ---
echo line1
echo line2
echo line3 | findstr /N "line"
echo.

echo --- 实际应用示例 ---
echo 检查字符串是否包含数字:
set "test_str=abc123"
echo %test_str% | findstr /R "[0-9]" >nul
if %errorlevel% equ 0 (
    echo 字符串包含数字
) else (
    echo 字符串不包含数字
)

echo.
echo === 演示完成 ===
pause
endlocal