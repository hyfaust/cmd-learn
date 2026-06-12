@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 安全提示：本脚本仅进行变量操作和临时文件读写
:: 功能：演示CMD中数据结构的持久化存储

echo === CMD数据持久化示例 ===
echo.

:: 设置临时文件路径
set "DATAFILE=%~dp0data_store.txt"
set "BACKUPFILE=%~dp0data_backup.txt"

echo === 保存数据到文件 ===
echo 创建数据...
set "data[name]=Alice"
set "data[age]=25"
set "data[city]=Beijing"
set "data[role]=Developer"
set "data[score]=95"

echo 数据内容:
for /F "tokens=1,2 delims==" %%a in ('set data[ 2^>nul') do (
    echo   %%a = %%b
)
echo.

:: 保存到文件
echo 保存到文件: %DATAFILE%
(
    echo # CMD数据持久化文件
    echo # 生成时间: %date% %time%
    echo.
    for /F "tokens=1,2 delims==" %%a in ('set data[ 2^>nul') do (
        echo %%a=%%b
    )
) > "%DATAFILE%"

echo 文件内容:
type "%DATAFILE%"
echo.

echo === 从文件恢复数据 ===
echo 清空当前数据...
for /F "tokens=1,2 delims==" %%a in ('set data[ 2^>nul') do (
    set "%%a="
)

echo 恢复前数据:
set data[ 2>nul
echo.

echo 从文件恢复数据...
for /F "tokens=1,2 delims==" %%a in ('findstr /v "^#" "%DATAFILE%"') do (
    if not "%%a"=="" set "%%a=%%b"
)

echo 恢复后数据:
for /F "tokens=1,2 delims==" %%a in ('set data[ 2^>nul') do (
    echo   %%a = %%b
)
echo.

echo === 复杂数据结构持久化 ===
echo 创建复杂数据结构...

:: 创建数组
set "arr[0]=Apple"
set "arr[1]=Banana"
set "arr[2]=Cherry"
set "arr_len=3"

:: 创建字典
set "config[debug]=true"
set "config[timeout]=30"
set "config[retries]=3"

:: 保存复杂数据结构
echo 保存复杂数据结构...
(
    echo # 复杂数据结构持久化
    echo.
    echo [ARRAY]
    echo length=!arr_len!
    for /L %%i in (0,1,!arr_len!-1) do (
        echo item_%%i=!arr[%%i]!
    )
    echo.
    echo [DICTIONARY]
    for /F "tokens=1,2 delims==" %%a in ('set config[ 2^>nul') do (
        echo %%a=%%b
    )
) > "%BACKUPFILE%"

echo 备份文件内容:
type "%BACKUPFILE%"
echo.

echo === 从备份恢复复杂数据 ===
echo 清空当前数据...
for /L %%i in (0,1,10) do (
    set "arr[%%i]="
)
set "arr_len="
for /F "tokens=1,2 delims==" %%a in ('set config[ 2^>nul') do (
    set "%%a="
)

echo 恢复前状态:
echo 数组长度: %arr_len%
echo.

:: 恢复数据
set "current_section="
for /F "tokens=1,* delims==" %%a in ('findstr /v "^#" "%BACKUPFILE%"') do (
    if "%%a"=="[ARRAY]" (
        set "current_section=ARRAY"
    ) else if "%%a"=="[DICTIONARY]" (
        set "current_section=DICTIONARY"
    ) else if not "%%a"=="" (
        if "!current_section!"=="ARRAY" (
            if "%%a"=="length" (
                set "arr_len=%%b"
            ) else (
                set "arr[%%a]=%%b"
            )
        ) else if "!current_section!"=="DICTIONARY" (
            set "%%a=%%b"
        )
    )
)

echo 恢复后状态:
echo 数组长度: !arr_len!
for /L %%i in (0,1,!arr_len!-1) do (
    echo   arr[%%i]=!arr[%%i]!
)
echo.
echo 配置:
for /F "tokens=1,2 delims==" %%a in ('set config[ 2^>nul') do (
    echo   %%a = %%b
)
echo.

echo === 数据持久化函数演示 ===
echo 使用持久化函数保存和恢复数据...

:: 创建测试数据
set "user[name]=Bob"
set "user[age]=30"
set "user[email]=bob@example.com"

:: 保存数据
call :save_to_file "user_data.txt" "user"

:: 清空数据
for /F "tokens=1,2 delims==" %%a in ('set user[ 2^>nul') do (
    set "%%a="
)

:: 恢复数据
call :load_from_file "user_data.txt" "user"

echo 恢复的用户数据:
for /F "tokens=1,2 delims==" %%a in ('set user[ 2^>nul') do (
    echo   %%a = %%b
)

:: 清理临时文件
echo.
echo === 清理临时文件 ===
del "%DATAFILE%" 2>nul
del "%BACKUPFILE%" 2>nul
del "%~dp0user_data.txt" 2>nul
echo 临时文件已清理

endlocal
goto :eof

:: 数据持久化函数
:save_to_file
set "save_file=%~1"
set "save_prefix=%~2"
(
    echo # 数据持久化文件
    echo # 前缀: %save_prefix%
    echo # 时间: %date% %time%
    echo.
    for /F "tokens=1,2 delims==" %%a in ('set %save_prefix%[ 2^>nul') do (
        echo %%a=%%b
    )
) > "%save_file%"
echo 数据已保存到: %save_file%
goto :eof

:load_from_file
set "load_file=%~1"
set "load_prefix=%~2"
if not exist "%load_file%" (
    echo 文件不存在: %load_file%
    goto :eof
)
for /F "tokens=1,2 delims==" %%a in ('findstr /v "^#" "%load_file%"') do (
    if not "%%a"=="" set "%%a=%%b"
)
echo 数据已从文件恢复: %load_file%
goto :eof