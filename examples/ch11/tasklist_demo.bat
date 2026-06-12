@echo off
chcp 65001 >nul
REM ============================================================
REM 文件名: tasklist_demo.bat
REM 功能: 演示 tasklist 命令的各种用法
REM 作者: CMD教程系列
REM 日期: 2026-06-11
REM ============================================================

setlocal enabledelayedexpansion

echo ========================================
echo    tasklist 命令演示
echo ========================================
echo.

REM 第一部分：基本进程列表
echo [1] 显示所有进程（表格格式）
echo ----------------------------------------
tasklist /fo TABLE
echo.

pause

REM 第二部分：CSV格式输出
echo [2] CSV格式输出（便于脚本处理）
echo ----------------------------------------
tasklist /fo CSV | more +1
echo.

pause

REM 第三部分：列表格式输出
echo [3] 列表格式输出（详细信息）
echo ----------------------------------------
tasklist /fo LIST
echo.

pause

REM 第四部分：筛选特定进程
echo [4] 筛选特定进程 - cmd.exe
echo ----------------------------------------
tasklist /fi "imagename eq cmd.exe" /fo TABLE
echo.

pause

REM 第五部分：按内存使用筛选
echo [5] 内存使用超过100MB的进程
echo ----------------------------------------
echo 注意：这里只显示前10个结果
set count=0
for /f "skip=3 tokens=1,5" %%a in ('tasklist /fo TABLE') do (
    set /a mem=%%b 2>nul
    if !mem! gtr 100000 (
        if !count! lss 10 (
            echo %%a - %%b KB
            set /a count+=1
        )
    )
)
echo.

pause

REM 第六部分：详细模式
echo [6] 详细模式显示进程
echo ----------------------------------------
tasklist /v /fi "imagename eq explorer.exe"
echo.

pause

REM 第七部分：查看进程加载的模块
echo [7] 查看explorer.exe加载的模块
echo ----------------------------------------
tasklist /m /fi "imagename eq explorer.exe" | more +3
echo.

pause

REM 第八部分：获取进程数量统计
echo [8] 进程数量统计
echo ----------------------------------------
set proc_count=0
for /f "skip=3" %%a in ('tasklist /fo TABLE') do (
    set /a proc_count+=1
)
echo 当前运行的进程数量: !proc_count!
echo.

REM 第九部分：内存使用最多的5个进程
echo [9] 内存使用最多的5个进程
echo ----------------------------------------
echo 正在统计，请稍候...
echo.

REM 创建临时文件存储数据
set tempfile=%temp%\proc_data.txt
type nul > %tempfile%

for /f "skip=3 tokens=1,5" %%a in ('tasklist /fo TABLE') do (
    set name=%%a
    set mem=%%b
    REM 移除逗号分隔符
    set mem=!mem:,=!
    echo !mem! !name! >> %tempfile%
)

REM 排序并显示前5个
echo 内存使用(KB) 进程名
echo -----------------------
sort /r %tempfile% | findstr /n "^" | findstr "^[1-5]:"
echo.

REM 清理临时文件
del %tempfile% 2>nul

echo ========================================
echo    演示完成
echo ========================================
echo.
pause
