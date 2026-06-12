@echo off
chcp 65001 >nul
:: 安全提示：此脚本仅进行字符串操作，不会修改任何文件
:: 字符串修剪演示 - CMD字符串处理技巧

setlocal EnableDelayedExpansion

echo === 字符串修剪演示 ===
echo.

echo --- 去除首尾空格（使用for /F） ---
set "str=   Hello World   "
echo 原始: [%str%]

:: 去除首尾空格
for /f "tokens=*" %%a in ("%str%") do set "trimmed=%%a"
echo 修剪后: [%trimmed%]
echo.

echo --- 去除前导空格 ---
set "str2=   Hello World"
echo 原始: [%str2%]

:: 使用循环去除前导空格
set "trimmed2=%str2%"
:trim_leading_loop
if "!trimmed2:~0,1!"==" " (
    set "trimmed2=!trimmed2:~1!"
    goto :trim_leading_loop
)
echo 修剪后: [%trimmed2%]
echo.

echo --- 去除尾随空格 ---
set "str3=Hello World   "
echo 原始: [%str3%]

:: 使用循环去除尾随空格
set "trimmed3=%str3%"
:trim_trailing_loop
if "!trimmed3:~-1!"==" " (
    set "trimmed3=!trimmed3:~0,-1!"
    goto :trim_trailing_loop
)
echo 修剪后: [%trimmed3%]
echo.

echo --- 实际应用示例 ---
set "user_input=   user@example.com   "
echo 用户输入: [%user_input%]
for /f "tokens=*" %%a in ("%user_input%") do set "clean_email=%%a"
echo 清理后: [%clean_email%]
echo.

echo --- 处理制表符 ---
set "tab_str=	Hello World	"
echo 制表符字符串: [%tab_str%]
echo 注意：for /F也会去除制表符
for /f "tokens=*" %%a in ("%tab_str%") do set "tab_trimmed=%%a"
echo 修剪后: [%tab_trimmed%]

echo.
echo === 演示完成 ===
pause
endlocal