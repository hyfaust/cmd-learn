@echo off
chcp 65001 >nul
:: 安全提示：此脚本仅进行字符串操作，不会修改任何文件
:: 子串截取演示 - CMD字符串处理基础

setlocal EnableDelayedExpansion

echo === 子串截取演示 ===
echo.

set "str=Hello, World!"
echo 原始字符串: %str%
echo.

echo --- 正数索引（从左开始） ---
echo 前5个字符 (0,5): %str:~0,5%
echo 从索引7开始 (7): %str:~7%
echo 从索引2到5 (2,3): %str:~2,3%
echo.

echo --- 负数索引（从右开始） ---
echo 最后6个字符 (-6): %str:~-6%
echo 最后3个字符 (-3): %str:~-3%
echo 倒数第5个字符开始，取2个 (-5,2): %str:~-5,2%
echo.

echo --- 省略length参数 ---
echo 从索引7到末尾 (7): %str:~7%
echo 从倒数第6个到末尾 (-6): %str:~-6%
echo.

echo --- 实际应用示例 ---
set "filepath=C:\Users\Admin\Documents\file.txt"
echo 文件路径: %filepath%
echo 文件名: %filepath:~-8%
echo 扩展名: %filepath:~-4%

echo.
echo === 演示完成 ===
pause
endlocal