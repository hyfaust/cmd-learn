@echo off
chcp 65001 >nul
rem ============================================================
rem task_create.bat - 创建计划任务示例
rem 本脚本演示如何使用schtasks创建各种类型的计划任务
rem 注意：使用echo模拟命令，不会实际创建任务
rem ============================================================

rem 安全提示
echo ============================================================
rem 本脚本演示创建计划任务的常用模式
echo 注意：所有命令使用echo模拟，不会实际执行
echo ============================================================
echo.

rem 设置变量
set TASK_NAME=DemoTask
set SCRIPT_PATH=C:\scripts\demo.bat
set LOG_FILE=%~dp0task_create.log

rem 开始日志
echo [%date% %time%] 开始创建计划任务演示 >> "%LOG_FILE%"
echo 开始创建计划任务演示
echo.

rem 创建每日任务
echo --- 创建每日任务 ---
echo 命令：schtasks /create /tn "%TASK_NAME%_Daily" /tr "%SCRIPT_PATH%" /sc daily /st 02:00
echo.
echo 参数说明：
echo   /tn - 任务名称
echo   /tr - 要执行的脚本路径
echo   /sc daily - 每日计划
echo   /st 02:00 - 执行时间（凌晨2点）
echo.
echo 执行结果：模拟成功
echo.

rem 创建每周任务
echo --- 创建每周任务 ---
echo 命令：schtasks /create /tn "%TASK_NAME%_Weekly" /tr "%SCRIPT_PATH%" /sc weekly /d MON,FRI /st 09:00
echo.
echo 参数说明：
echo   /sc weekly - 每周计划
echo   /d MON,FRI - 每周一和周五
echo   /st 09:00 - 执行时间（上午9点）
echo.
echo 执行结果：模拟成功
echo.

rem 创建每月任务
echo --- 创建每月任务 ---
echo 命令：schtasks /create /tn "%TASK_NAME%_Monthly" /tr "%SCRIPT_PATH%" /sc monthly /d 1,15 /st 10:00
echo.
echo 参数说明：
echo   /sc monthly - 每月计划
echo   /d 1,15 - 每月1号和15号
echo   /st 10:00 - 执行时间（上午10点）
echo.
echo 执行结果：模拟成功
echo.

rem 创建一次性任务
echo --- 创建一次性任务 ---
echo 命令：schtasks /create /tn "%TASK_NAME%_Once" /tr "%SCRIPT_PATH%" /sc once /st 14:30
echo.
echo 参数说明：
echo   /sc once - 只执行一次
echo   /st 14:30 - 执行时间（下午2:30）
echo.
echo 执行结果：模拟成功
echo.

rem 创建系统启动任务
echo --- 创建系统启动任务 ---
echo 命令：schtasks /create /tn "%TASK_NAME%_Startup" /tr "%SCRIPT_PATH%" /sc onstart
echo.
echo 参数说明：
echo   /sc onstart - 系统启动时执行
echo   注意：此任务需要管理员权限
echo.
echo 执行结果：模拟成功
echo.

rem 创建用户登录任务
echo --- 创建用户登录任务 ---
echo 命令：schtasks /create /tn "%TASK_NAME%_Logon" /tr "%SCRIPT_PATH%" /sc onlogon
echo.
echo 参数说明：
echo   /sc onlogon - 用户登录时执行
echo.
echo 执行结果：模拟成功
echo.

rem 创建系统空闲任务
echo --- 创建系统空闲任务 ---
echo 命令：schtasks /create /tn "%TASK_NAME%_Idle" /tr "%SCRIPT_PATH%" /sc onidle /i 10
echo.
echo 参数说明：
echo   /sc onidle - 系统空闲时执行
echo   /i 10 - 空闲10分钟后执行
echo.
echo 执行结果：模拟成功
echo.

rem 创建带高级选项的任务
echo --- 创建带高级选项的任务 ---
echo 命令：schtasks /create /tn "%TASK_NAME%_Advanced" /tr "%SCRIPT_PATH%" /sc daily /st 02:00 /ru SYSTEM /rp
echo.
echo 参数说明：
echo   /ru SYSTEM - 以SYSTEM账户运行
echo   /rp - 提示输入密码（可选）
echo   注意：使用SYSTEM账户运行需要管理员权限
echo.
echo 执行结果：模拟成功
echo.

rem 显示创建任务的最佳实践
echo.
echo === 创建计划任务的最佳实践 ===
echo.
echo 1. 使用有意义的任务名称
echo    - 包含功能描述和频率
echo    - 例如：DailyBackup_0200, WeeklyReport_Mon9AM
echo.
echo 2. 使用绝对路径
echo    - 避免相对路径导致的路径错误
echo    - 确保脚本路径在所有环境中有效
echo.
echo 3. 测试任务执行
echo    - 使用 schtasks /run 立即测试
echo    - 检查任务日志和输出
echo.
echo 4. 设置适当的权限
echo    - 根据需要选择运行账户
echo    - 避免使用过高权限
echo.
echo 5. 添加错误处理
echo    - 脚本中包含错误检查
echo    - 记录执行日志
echo.

rem 结束日志
echo [%date% %time%] 创建计划任务演示完成 >> "%LOG_FILE%"
echo.
echo 演示完成。查看日志: %LOG_FILE%
echo.
pause