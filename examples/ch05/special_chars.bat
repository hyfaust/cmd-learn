@echo off
chcp 65001 >nul
:: 安全提示：此脚本仅进行字符串操作，不会修改任何文件
:: 特殊字符处理演示 - CMD字符串处理难点

setlocal EnableDelayedExpansion

echo === 特殊字符处理演示 ===
echo.

echo --- 基本特殊字符转义 ---
echo 使用 ^ 转义特殊字符:
echo ^& 表示 AND 运算符
echo ^| 表示 OR 运算符
echo ^^^< 表示输入重定向
echo ^^^> 表示输出重定向
echo.

echo --- 百分号处理 ---
echo 百分号需要双写: 100%%
echo 变量中的百分号: %%PATH%%
echo.

echo --- 感叹号处理（延迟扩展） ---
set "var=Hello"
echo 正常变量: %var%
echo 延迟扩展变量: !var!
echo 转义感叹号: ^^^!
echo.

echo --- 双引号处理 ---
echo 双引号: "quoted text"
echo 单引号: 'single quotes'
echo.

echo --- 括号处理 ---
echo 左括号: ^(
echo 右括号: ^)
echo 花括号: { }
echo 方括号: [ ]
echo.

echo --- 实际应用示例 ---
set "command=dir /b"
echo 命令字符串: %command%
echo.

set "path=C:\Program Files\App"
echo 包含空格的路径: "%path%"
echo.

echo --- 特殊字符组合 ---
echo 组合1: ^& ^| ^< ^>
echo 组合2: ^( ^) ^{ ^}
echo 组合3: ^^ ^! ^@ ^#
echo.

echo === 演示完成 ===
pause
endlocal