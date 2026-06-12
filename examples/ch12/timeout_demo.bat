@echo off
chcp 65001 >nul
rem ============================================================
rem timeout_demo.bat - 超时和延时控制演示
rem 本脚本演示批处理中的各种超时控制技术
rem 包括timeout、ping模拟延时和waitfor命令
rem ============================================================

rem 安全提示
echo ============================================================
echo 本脚本演示超时控制技术
echo 部分演示会实际暂停脚本执行
echo ============================================================
echo.

rem 设置变量
set LOG_FILE=%~dp0timeout_demo.log

rem 开始日志
echo [%date% %time%] 开始超时控制演示 >> "%LOG_FILE%"
echo 开始超时控制演示
echo.

rem 显示菜单
:menu
echo.
echo 超时控制演示菜单
echo =================
echo 1. timeout 命令演示
echo 2. ping 模拟延时演示
echo 3. waitfor 命令演示
echo 4. 综合延时示例
echo 5. 退出
echo.
set /p choice="请选择操作 (1-5): "

if "%choice%"=="1" goto timeout_demo
if "%choice%"=="2" goto ping_demo
if "%choice%"=="3" goto waitfor_demo
if "%choice%"=="4" goto combined_demo
if "%choice%"=="5" goto end
echo 无效选择，请重试
goto menu

:timeout_demo
echo.
echo === timeout 命令演示 ===
echo.
echo timeout命令让脚本暂停指定秒数
echo.

echo 示例1: 基本timeout - 暂停3秒
echo 命令: timeout /t 3
echo.
echo 执行中...
timeout /t 3
echo 暂停完成！
echo.

echo 示例2: 带倒计时显示的timeout
echo 命令: timeout /t 5
echo.
echo 执行中（观察倒计时）...
timeout /t 5
echo 暂停完成！
echo.

echo 示例3: 不允许跳过的timeout
echo 命令: timeout /t 3 /nobreak
echo.
echo 执行中（按键不会跳过）...
timeout /t 3 /nobreak
echo 暂停完成！
echo.

echo 示例4: 允许跳过的timeout（默认）
echo 命令: timeout /t 5 /break
echo.
echo 执行中（按任意键可跳过）...
timeout /t 5 /break
echo 暂停完成！
echo.

pause
goto menu

:ping_demo
echo.
echo === ping 模拟延时演示 ===
echo.
echo 在timeout不可用时，可以使用ping模拟延时
echo.

echo 示例1: 延时约1秒
echo 命令: ping 127.0.0.1 -n 2 ^>nul
echo.
echo 执行中...
set start_time=%time%
ping 127.0.0.1 -n 2 >nul
set end_time=%time%
echo 开始时间: %start_time%
echo 结束时间: %end_time%
echo.

echo 示例2: 延时约5秒
echo 命令: ping 127.0.0.1 -n 6 ^>nul
echo.
echo 执行中...
set start_time=%time%
ping 127.0.0.1 -n 6 >nul
set end_time=%time%
echo 开始时间: %start_time%
echo 结束时间: %end_time%
echo.

echo 示例3: 延时约10秒
echo 命令: ping 127.0.0.1 -n 11 ^>nul
echo.
echo 执行中...
set start_time=%time%
ping 127.0.0.1 -n 11 >nul
set end_time=%time%
echo 开始时间: %start_time%
echo 结束时间: %end_time%
echo.

echo 注意事项:
echo   - 每个ping间隔约1秒
echo   - 使用 -n 2 实现约1秒延时
echo   - 使用 -n 6 实现约5秒延时（6-1=5秒）
echo   - 使用 ^>nul 抑制输出
echo.

pause
goto menu

:waitfor_demo
echo.
echo === waitfor 命令演示 ===
echo.
echo waitfor命令等待特定信号或超时
echo.

echo 示例1: 等待信号（超时）
echo 命令: waitfor MySignal /t 5
echo.
echo 等待5秒（超时）...
waitfor MySignal /t 5
echo 超时完成！
echo.

echo 示例2: 发送信号
echo 命令: waitfor MySignal /si
echo.
echo 发送信号...
waitfor MySignal /si
echo 信号已发送！
echo.

echo 示例3: 使用waitfor实现进程间同步
echo.
echo 进程A: waitfor MySignal /t 10
echo 进程B: waitfor MySignal /si
echo.

echo 注意事项:
echo   - waitfor用于进程间通信
echo   - /t 指定超时时间（秒）
echo   - /si 发送信号
echo   - 等待时按Ctrl+C可中断
echo.

pause
goto menu

:combined_demo
echo.
echo === 综合延时示例 ===
echo.
echo 实际应用中的延时控制
echo.

echo 示例1: 循环执行任务，每次间隔2秒
echo.
echo 代码示例:
echo for /l %%i in (1,1,5) do (
echo     echo 执行任务 %%i
echo     timeout /t 2 /nobreak ^>nul
echo )
echo.

echo 实际执行（5次循环，每次2秒）...
for /l %%i in (1,1,5) do (
    echo 任务 %%i 完成
    timeout /t 2 /nobreak >nul
)
echo 循环完成！
echo.

echo 示例2: 带进度显示的延时
echo.
echo 代码示例:
echo set /a count=0
echo :loop
echo set /a count+=1
echo echo 进度: %%count%%/10
echo if %%count%% lss 10 (
echo     timeout /t 1 /nobreak ^>nul
echo     goto loop
echo )
echo.

echo 实际执行...
set /a count=0
:loop
set /a count+=1
echo 进度: %count%/10
if %count% lss 10 (
    timeout /t 1 /nobreak >nul
    goto loop
)
echo 进度完成！
echo.

echo 示例3: 条件延时
echo.
echo 代码示例:
echo set /a attempts=0
echo :retry
echo set /a attempts+=1
echo echo 尝试次数: %%attempts%%
echo echo 执行操作...
echo echo 操作失败！
echo if %%attempts%% lss 3 (
echo     echo 等待后重试...
echo     timeout /t 2 /nobreak ^>nul
echo     goto retry
echo )
echo.

echo 实际执行...
set /a attempts=0
:retry
set /a attempts+=1
echo 尝试次数: %attempts%
echo 执行操作...
echo 操作失败！
if %attempts% lss 3 (
    echo 等待后重试...
    timeout /t 2 /nobreak >nul
    goto retry
)
echo 重试机制演示完成！
echo.

pause
goto menu

:end
echo.
echo === 超时控制最佳实践 ===
echo.
echo 1. 选择合适的延时方法
echo    - timeout: 首选，功能最全
echo    - ping: 兼容性好，简单
echo    - waitfor: 适合进程间同步
echo.
echo 2. 考虑用户体验
echo    - 显示倒计时或进度
echo    - 允许用户中断
echo    - 提供跳过选项
echo.
echo 3. 错误处理
echo    - 检查延时命令是否成功
echo    - 处理中断情况
echo    - 记录延时日志
echo.
echo 4. 性能考虑
echo    - 避免过长的延时
echo    - 使用合适的延时间隔
echo    - 考虑异步执行
echo.

rem 结束日志
echo [%date% %time%] 超时控制演示完成 >> "%LOG_FILE%"
echo.
echo 演示结束。
echo.
pause