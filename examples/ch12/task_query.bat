@echo off
chcp 65001 >nul
rem ============================================================
rem task_query.bat - 查询计划任务示例
rem 本脚本演示如何使用schtasks查询计划任务信息
rem 注意：使用echo模拟命令，不会实际执行查询
rem ============================================================

rem 安全提示
echo ============================================================
echo 本脚本演示查询计划任务的常用方法
echo 所有命令使用echo模拟，不会实际执行
echo ============================================================
echo.

rem 设置变量
set LOG_FILE=%~dp0task_query.log

rem 开始日志
echo [%date% %time%] 开始查询计划任务演示 >> "%LOG_FILE%"
echo 开始查询计划任务演示
echo.

rem 查询所有任务
echo --- 查询所有任务 ---
echo 命令：schtasks /query
echo.
echo 输出示例：
echo 任务名                                   下次运行时间        状态
echo ======================================== ==================== ===============
echo BackupTask                               2024/1/2 02:00:00   就绪
echo CleanupTask                              2024/1/3 01:00:00   就绪
echo ReportTask                               2024/1/1 09:00:00   运行中
echo.
echo 说明：显示系统中所有计划任务的简要信息
echo.

rem 查询所有任务（表格格式）
echo --- 查询所有任务（表格格式） ---
echo 命令：schtasks /query /fo TABLE
echo.
echo 输出示例：
echo 任务名                                   下次运行时间        状态
echo ======================================== ==================== ===============
echo BackupTask                               2024/1/2 02:00:00   就绪
echo CleanupTask                              2024/1/3 01:00:00   就绪
echo ReportTask                               2024/1/1 09:00:00   运行中
echo.
echo 说明：以表格形式显示，更易阅读
echo.

rem 查询所有任务（列表格式）
echo --- 查询所有任务（列表格式） ---
echo 命令：schtasks /query /fo LIST
echo.
echo 输出示例：
echo.
echo 任务名:         BackupTask
echo 下次运行时间:   2024/1/2 02:00:00
echo 状态:           就绪
echo.
echo 任务名:         CleanupTask
echo 下次运行时间:   2024/1/3 01:00:00
echo 状态:           就绪
echo.
echo 说明：以列表形式显示，适合查看详细信息
echo.

rem 查询所有任务（CSV格式）
echo --- 查询所有任务（CSV格式） ---
echo 命令：schtasks /query /fo CSV
echo.
echo 输出示例：
echo "任务名","下次运行时间","状态"
echo "BackupTask","2024/1/2 02:00:00","就绪"
echo "CleanupTask","2024/1/3 01:00:00","就绪"
echo "ReportTask","2024/1/1 09:00:00","运行中"
echo.
echo 说明：CSV格式，便于导入到Excel或其他程序
echo.

rem 查询特定任务
echo --- 查询特定任务 ---
echo 命令：schtasks /query /tn "BackupTask"
echo.
echo 输出示例：
echo 任务名:         BackupTask
echo 下次运行时间:   2024/1/2 02:00:00
echo 状态:           就绪
echo.
echo 说明：查询指定名称的任务
echo.

rem 查询特定任务详细信息
echo --- 查询特定任务详细信息 ---
echo 命令：schtasks /query /tn "BackupTask" /v
echo.
echo 输出示例：
echo 任务名:         BackupTask
echo 下次运行时间:   2024/1/2 02:00:00
echo 状态:           就绪
echo 上次运行时间:   2024/1/1 02:00:00
echo 上次结果:       0
echo 创建者:         Administrator
echo 计划类型:       每日
echo 开始时间:       02:00:00
echo 开始日期:       2024/1/1
echo 运行账户:       SYSTEM
echo.
echo 说明：/v参数显示详细信息（Verbose）
echo.

rem 查询特定任务详细信息（列表格式）
echo --- 查询特定任务详细信息（列表格式） ---
echo 命令：schtasks /query /tn "BackupTask" /fo LIST /v
echo.
echo 输出示例：
echo.
echo 任务名:         BackupTask
echo 下次运行时间:   2024/1/2 02:00:00
echo 状态:           就绪
echo 上次运行时间:   2024/1/1 02:00:00
echo 上次结果:       0
echo 创建者:         Administrator
echo 计划类型:       每日
echo 开始时间:       02:00:00
echo 开始日期:       2024/1/1
echo 运行账户:       SYSTEM
echo.
echo 说明：结合列表格式和详细信息，最适合分析
echo.

rem 查询任务（无表头）
echo --- 查询任务（无表头） ---
echo 命令：schtasks /query /fo CSV /nh
echo.
echo 输出示例：
echo "BackupTask","2024/1/2 02:00:00","就绪"
echo "CleanupTask","2024/1/3 01:00:00","就绪"
echo "ReportTask","2024/1/1 09:00:00","运行中"
echo.
echo 说明：/nh参数不显示表头，便于脚本处理
echo.

rem 查询远程计算机上的任务
echo --- 查询远程计算机上的任务 ---
echo 命令：schtasks /query /s RemotePC /fo TABLE
echo.
echo 说明：/s参数指定远程计算机名称
echo 注意：需要管理员权限和网络访问权限
echo.

rem 查询结果的过滤和处理
echo --- 查询结果的过滤和处理 ---
echo.
echo 1. 使用findstr过滤结果：
echo    schtasks /query /fo CSV | findstr "BackupTask"
echo.
echo 2. 保存结果到文件：
echo    schtasks /query /fo TABLE > task_list.txt
echo.
echo 3. 使用for循环处理结果：
echo    for /f "tokens=1,2,3" %%a in ('schtasks /query /fo CSV /nh') do (
echo        echo 任务名: %%a
echo        echo 下次运行: %%b
echo        echo 状态: %%c
echo    )
echo.

rem 显示查询任务的常见用途
echo.
echo === 查询计划任务的常见用途 ===
echo.
echo 1. 检查任务是否存在
echo    - 在创建任务前先查询确认
echo    - 避免重复创建任务
echo.
echo 2. 监控任务状态
echo    - 定期查询任务状态
echo    - 发现失败或未运行的任务
echo.
echo 3. 生成任务报告
echo    - 导出任务列表到文件
echo    - 创建任务执行统计
echo.
echo 4. 故障排查
echo    - 检查任务配置是否正确
echo    - 查看上次执行结果
echo.
echo 5. 自动化管理
echo    - 脚本中检查任务状态
echo    - 根据状态执行相应操作
echo.

rem 显示实际查询脚本示例
echo === 实际查询脚本示例 ===
echo.
echo @echo off
echo rem 检查任务是否存在
echo schtasks /query /tn "BackupTask" ^>nul 2^>^&1
echo if errorlevel 1 (
echo     echo 任务不存在
echo ) else (
echo     echo 任务存在
echo )
echo.

rem 结束日志
echo [%date% %time%] 查询计划任务演示完成 >> "%LOG_FILE%"
echo.
echo 演示完成。查看日志: %LOG_FILE%
echo.
pause