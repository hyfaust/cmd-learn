@echo off
:: ============================================================
:: 日志分析工具 - 项目2
:: 功能：分析日志文件，统计错误和警告，生成报告
:: 用法：log_analyzer.bat [日志文件路径]
:: 安全约束：只读取日志，不修改原文件
:: ============================================================

chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: 初始化变量
set "SCRIPT_DIR=%~dp0"
set "LOG_FILE=%~1"
if "%LOG_FILE%"=="" set "LOG_FILE=%SCRIPT_DIR%logs\sample.log"
set "REPORT_FILE=%SCRIPT_DIR%output\analysis_report.txt"
set "TEMP_DIR=%SCRIPT_DIR%temp"

:: 检查日志文件是否存在
if not exist "%LOG_FILE%" (
    echo [ERROR] 日志文件不存在: %LOG_FILE%
    echo 请确保日志文件路径正确，或创建示例日志文件。
    pause
    exit /b 1
)

:: 创建临时目录
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
if not exist "%SCRIPT_DIR%output" mkdir "%SCRIPT_DIR%output"

:: 显示欢迎信息
echo ============================================================
echo                      日志分析工具
echo ============================================================
echo 正在分析日志文件: %LOG_FILE%
echo.

:: 初始化统计变量
set "TOTAL_LINES=0"
set "ERROR_COUNT=0"
set "WARNING_COUNT=0"
set "INFO_COUNT=0"
set "DEBUG_COUNT=0"
set "FATAL_COUNT=0"
set "FIRST_TIMESTAMP="
set "LAST_TIMESTAMP="
set "ERROR_MESSAGES="

:: 第一遍：统计各类日志数量
echo [1/3] 统计日志级别...
for /f "usebackq delims=" %%a in ("%LOG_FILE%") do (
    set "line=%%a"
    set /a "TOTAL_LINES+=1"
    
    :: 检查日志级别（假设日志格式：[时间] [级别] 消息）
    echo "!line!" | findstr /i /c:"[ERROR]" > nul && (
        set /a "ERROR_COUNT+=1"
        set "ERROR_MESSAGES=!ERROR_MESSAGES!%%a\n"
    )
    echo "!line!" | findstr /i /c:"[WARNING]" > nul && set /a "WARNING_COUNT+=1"
    echo "!line!" | findstr /i /c:"[INFO]" > nul && set /a "INFO_COUNT+=1"
    echo "!line!" | findstr /i /c:"[DEBUG]" > nul && set /a "DEBUG_COUNT+=1"
    echo "!line!" | findstr /i /c:"[FATAL]" > nul && set /a "FATAL_COUNT+=1"
    
    :: 提取时间戳（假设格式：[YYYY-MM-DD HH:MM:SS]）
    for /f "tokens=1,2 delims=[]" %%b in ("!line!") do (
        if "%%b" neq "" (
            if "!FIRST_TIMESTAMP!"=="" set "FIRST_TIMESTAMP=%%b"
            set "LAST_TIMESTAMP=%%b"
        )
    )
)

:: 第二遍：提取错误详情
echo [2/3] 提取错误详情...
set "ERROR_DETAILS="
for /f "usebackq delims=" %%a in ("%LOG_FILE%") do (
    set "line=%%a"
    echo "!line!" | findstr /i /c:"[ERROR]" > nul && (
        set "ERROR_DETAILS=!ERROR_DETAILS!%%a\n"
    )
)

:: 第三遍：按时间排序（简单排序，假设时间格式一致）
echo [3/3] 生成分析报告...

:: 生成报告
(
echo ============================================================
echo                    日志分析报告
echo ============================================================
echo 生成时间: %DATE% %TIME%
echo 日志文件: %LOG_FILE%
echo ============================================================
echo.
echo 【基本信息】
echo 总行数: %TOTAL_LINES%
echo 分析时间范围: %FIRST_TIMESTAMP% 至 %LAST_TIMESTAMP%
echo.
echo 【日志级别统计】
echo ┌─────────────┬──────────┐
echo │ 日志级别    │ 数量     │
echo ├─────────────┼──────────┤
echo │ FATAL       │ %FATAL_COUNT%        │
echo │ ERROR       │ %ERROR_COUNT%        │
echo │ WARNING     │ %WARNING_COUNT%        │
echo │ INFO        │ %INFO_COUNT%        │
echo │ DEBUG       │ %DEBUG_COUNT%        │
echo └─────────────┴──────────┘
echo.
echo 【错误率分析】
set /a "ERROR_RATE=0"
if %TOTAL_LINES% gtr 0 (
    set /a "ERROR_RATE=(ERROR_COUNT + FATAL_COUNT) * 100 / TOTAL_LINES"
)
echo 错误率: !ERROR_RATE!%%
if !ERROR_RATE! gtr 10 (
    echo [警告] 错误率较高，建议检查系统状态！
) else if !ERROR_RATE! gtr 5 (
    echo [注意] 错误率中等，建议关注。
) else (
    echo [正常] 错误率在正常范围内。
)
echo.
echo 【错误详情】
if %ERROR_COUNT% gtr 0 (
    echo 以下是错误日志详情：
    echo ------------------------------------------------------------
    for /f "usebackq delims=" %%a in ("%LOG_FILE%") do (
        set "line=%%a"
        echo "!line!" | findstr /i /c:"[ERROR]" > nul && echo %%a
    )
    echo ------------------------------------------------------------
) else (
    echo 未发现错误日志。
)
echo.
echo 【严重错误详情】
if %FATAL_COUNT% gtr 0 (
    echo 以下是严重错误日志详情：
    echo ------------------------------------------------------------
    for /f "usebackq delims=" %%a in ("%LOG_FILE%") do (
        set "line=%%a"
        echo "!line!" | findstr /i /c:"[FATAL]" > nul && echo %%a
    )
    echo ------------------------------------------------------------
) else (
    echo 未发现严重错误日志。
)
echo.
echo 【建议操作】
if %FATAL_COUNT% gtr 0 (
    echo 1. 立即检查严重错误，可能影响系统运行
    echo 2. 查看错误日志详情，定位问题根源
    echo 3. 考虑重启相关服务或系统
) else if %ERROR_COUNT% gtr 0 (
    echo 1. 检查错误日志，修复潜在问题
    echo 2. 监控错误频率，防止问题恶化
    echo 3. 定期清理日志文件
) else (
    echo 1. 系统运行正常
    echo 2. 定期检查日志，预防问题发生
    echo 3. 保持日志文件备份
)
echo.
echo ============================================================
echo                    分析完成
echo ============================================================
) > "%REPORT_FILE%"

:: 保存错误详情到单独文件
if %ERROR_COUNT% gtr 0 (
    echo [INFO] 保存错误详情到: %TEMP_DIR%\error_details.txt
    for /f "usebackq delims=" %%a in ("%LOG_FILE%") do (
        set "line=%%a"
        echo "!line!" | findstr /i /c:"[ERROR]" > nul && echo %%a >> "%TEMP_DIR%\error_details.txt"
    )
)

:: 显示完成信息
echo.
echo ============================================================
echo                    分析完成！
echo ============================================================
echo 分析报告已保存到: %REPORT_FILE%
echo.
echo 统计摘要：
echo   - 总行数: %TOTAL_LINES%
echo   - 错误数: %ERROR_COUNT%
echo   - 警告数: %WARNING_COUNT%
echo   - 严重错误: %FATAL_COUNT%
echo.
echo 按任意键查看报告...
pause > nul
notepad "%REPORT_FILE%"

endlocal
exit /b 0