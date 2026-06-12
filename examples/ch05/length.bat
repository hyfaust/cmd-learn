@echo off
chcp 65001 >nul
:: 安全提示：此脚本仅进行字符串操作，不会修改任何文件
:: 字符串长度计算演示 - CMD字符串处理技巧

setlocal EnableDelayedExpansion

echo === 字符串长度计算演示 ===
echo.

set "str=Hello World"
echo 原始字符串: "%str%"
echo.

echo --- 方法一：单词计数（使用for循环） ---
set "word_count=0"
for %%A in (%str%) do set /a "word_count+=1"
echo 单词数: %word_count%
echo.

echo --- 方法二：字符长度计算（循环方法） ---
set "tmp=%str%"
set "char_len=0"
:count_loop
if defined tmp (
    set "tmp=%tmp:~1%"
    set /a "char_len+=1"
    goto :count_loop
)
echo 字符长度: %char_len%
echo.

echo --- 实际应用示例 ---
set "email=user@example.com"
set "tmp=%email%"
set "email_len=0"
:email_count_loop
if defined tmp (
    set "tmp=%tmp:~1%"
    set /a "email_len+=1"
    goto :email_count_loop
)
echo 邮箱地址: %email%
echo 邮箱长度: %email_len%
echo.

echo --- 长度检查示例 ---
set "password=abc123"
set "tmp=%password%"
set "pass_len=0"
:pass_count_loop
if defined tmp (
    set "tmp=%tmp:~1%"
    set /a "pass_len+=1"
    goto :pass_count_loop
)
echo 密码: %password%
echo 密码长度: %pass_len%
if %pass_len% LSS 6 (
    echo 警告：密码长度不足6个字符！
) else (
    echo 密码长度符合要求。
)

echo.
echo === 演示完成 ===
pause
endlocal