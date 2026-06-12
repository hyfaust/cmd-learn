@echo off
chcp 65001 >nul
:: 安全提示：此脚本仅进行字符串操作，不会修改任何文件
:: 字符串替换演示 - CMD字符串处理核心功能

setlocal EnableDelayedExpansion

echo === 字符串替换演示 ===
echo.

echo --- 基本替换 ---
set "str=Hello World Hello CMD"
echo 原始字符串: %str%
echo 替换Hello为Hi: %str:Hello=Hi%
echo.

echo --- 替换特殊字符 ---
set "str2=aaa.bbb.ccc"
echo 原始字符串: %str2%
echo 替换点为横杠: %str2:.=-%
echo.

echo --- 删除子串 ---
echo 删除所有点: %str2:.=%
echo.

echo --- 实际应用示例 ---
set "date=2024-01-15"
echo 日期格式: %date%
echo 替换为斜杠格式: %date:-=/%
echo.

set "filename=document.backup.txt"
echo 文件名: %filename%
echo 删除.backup: %filename:.backup=%
echo.

echo --- 替换所有匹配 ---
set "sentence=the cat sat on the mat"
echo 原始句子: %sentence%
echo 替换the为a: %sentence:the=a%
echo.

echo --- 替换并赋值 ---
set "original=Hello World"
set "modified=%original:World=CMD%"
echo 原始: %original%
echo 修改后: %modified%

echo.
echo === 演示完成 ===
pause
endlocal