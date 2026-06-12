@echo off
chcp 65001 >nul
REM ============================================
REM PATH变量管理演示
REM 文件: path_manage.bat
REM 作者: 教程工程师
REM 日期: 2026-06-11
REM 安全提示: 本脚本仅演示PATH变量操作，不会永久修改系统PATH
REM ============================================

setlocal enabledelayedexpansion

echo ============================================
echo PATH变量管理演示
echo ============================================
echo.

echo [1] 当前PATH变量分析
echo ----------------------------------------
echo PATH变量长度: %PATH:~0,100%...（截断显示）
echo.
echo PATH变量包含以下目录（逐行显示）:
echo.
set count=0
for %%i in ("%PATH:;=" "%") do (
    set /a count+=1
    echo !count!. %%~i
)
echo.
echo PATH变量共包含 !count! 个目录
echo.

echo [2] 检查PATH目录是否存在
echo ----------------------------------------
set missing=0
for %%i in ("%PATH:;=" "%") do (
    if not exist "%%~i" (
        echo [缺失] %%~i
        set /a missing+=1
    )
)
echo.
if !missing! equ 0 (
    echo 所有PATH目录都存在
) else (
    echo 发现 !missing! 个缺失的目录
)
echo.

echo [3] 临时添加目录到PATH
echo ----------------------------------------
echo 当前目录: %CD%
echo.
echo 添加当前目录到PATH...
set "PATH=%PATH%;%CD%"
echo 已添加: %CD%
echo.
echo 新PATH变量（前100字符）: %PATH:~0,100%...
echo.

echo [4] 查找特定命令的位置
echo ----------------------------------------
echo 查找 cmd.exe 的位置:
where cmd.exe
echo.
echo 查找 notepad.exe 的位置:
where notepad.exe
echo.
echo 查找 python.exe 的位置（如果存在）:
where python.exe 2>nul || echo Python未找到或不在PATH中
echo.

echo [5] PATH变量优化建议
echo ----------------------------------------
echo 1. 移除不存在的目录以加快搜索速度
echo 2. 将常用工具目录放在PATH前面
echo 3. 避免添加过多目录（影响性能）
echo 4. 定期清理不再使用的PATH条目
echo 5. 使用相对路径而非绝对路径（如果可能）
echo.

echo [6] 永久修改PATH的注意事项
echo ----------------------------------------
echo 使用setx命令可以永久修改PATH:
echo   setx PATH "%PATH%;新目录"
echo.
echo 注意事项:
echo   1. 修改后需要新开CMD窗口才能生效
echo   2. 路径中包含空格需要用引号包裹
echo   3. 系统PATH需要管理员权限
echo   4. 错误修改可能导致命令无法找到
echo.

echo [7] PATH变量备份示例
echo ----------------------------------------
echo 备份当前PATH到文件...
set "BACKUP_FILE=%USERPROFILE%\path_backup_%date:~0,4%%date:~5,2%%date:~8,2%.txt"
echo PATH备份文件: !BACKUP_FILE!
echo %PATH% > "!BACKUP_FILE!"
echo 备份完成
echo.

echo [8] 恢复PATH变量（模拟）
echo ----------------------------------------
echo 如果需要恢复PATH变量，可以:
echo 1. 使用备份文件: type "!BACKUP_FILE!"
echo 2. 手动编辑PATH: set PATH=备份内容
echo 3. 系统还原点: 如果创建过还原点
echo.

echo ============================================
echo PATH管理演示完成
echo ============================================
echo.
echo 提示: 本演示中的修改仅在当前会话有效
echo 如需永久修改PATH，请使用setx命令并谨慎操作
echo.

pause