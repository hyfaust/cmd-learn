@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 安全提示：本脚本仅进行变量操作，不会修改系统文件
:: 功能：演示CMD中关联数组（字典）模拟的基本操作

echo === CMD关联数组（字典）模拟示例 ===
echo.

echo === 创建字典 ===
set "dict[name]=Alice"
set "dict[age]=25"
set "dict[city]=Beijing"
set "dict[role]=Developer"
set "dict[email]=alice@example.com"

echo 字典已创建，包含5个键值对
echo.

echo === 查询字典 ===
echo 姓名: !dict[name]!
echo 年龄: !dict[age]!
echo 城市: !dict[city]!
echo 角色: !dict[role]!
echo 邮箱: !dict[email]!
echo.

echo === 修改字典 ===
echo 修改前年龄: !dict[age]!
set "dict[age]=26"
echo 修改后年龄: !dict[age]!
echo.

echo === 添加新的键值对 ===
set "dict[phone]=123-456-7890"
set "dict[department]=Engineering"
echo 添加后字典大小: 
set dict[ 2>nul | find /c "="
echo.

echo === 删除键值对 ===
echo 删除邮箱字段...
set "dict[email]="
echo 删除后字典内容:
for /F "tokens=1,2 delims==" %%a in ('set dict[ 2^>nul') do (
    echo   %%a = %%b
)
echo.

echo === 遍历字典 ===
echo 字典的所有键值对:
for /F "tokens=1,2 delims==" %%a in ('set dict[ 2^>nul') do (
    echo   键: %%a, 值: %%b
)
echo.

echo === 字典操作函数演示 ===
call :dict_init "mydict"

call :dict_set "fruit" "Apple"
call :dict_set "vegetable" "Carrot"
call :dict_set "color" "Red"
call :dict_set "size" "Large"

echo 使用函数创建的字典:
call :dict_print

echo.
echo 获取 fruit 的值:
call :dict_get "fruit"
echo 结果: !dict_value!

echo.
echo 检查 vegetable 是否存在:
call :dict_exists "vegetable"
echo 存在: !dict_exists_result!

echo.
echo 删除 color:
call :dict_delete "color"
echo 删除后字典:
call :dict_print

endlocal
goto :eof

:: 字典操作函数
:dict_init
set "dict_prefix=%~1"
goto :eof

:dict_set
set "%dict_prefix%[%~1]=%~2"
goto :eof

:dict_get
set "dict_value=!%dict_prefix%[%~1]!"
goto :eof

:dict_delete
set "%dict_prefix%[%~1]="
goto :eof

:dict_exists
if defined %dict_prefix%[%~1] (
    set "dict_exists_result=true"
) else (
    set "dict_exists_result=false"
)
goto :eof

:dict_print
for /F "tokens=1,2 delims==" %%a in ('set %dict_prefix%[ 2^>nul') do (
    echo   %%a = %%b
)
goto :eof