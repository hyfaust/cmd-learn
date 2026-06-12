@echo off
REM ============================================================
REM temp_file_comm.bat - 临时文件通信演示
REM
REM 功能: 演示通过临时文件在 CMD 和其他语言间交换数据
REM 安全提示: 仅在项目目录内操作
REM ============================================================

chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ========================================
echo   临时文件通信演示
echo ========================================
echo.

REM 设置临时目录和文件
set "TEMP_DIR=%TEMP%\cmd_multilang_demo_%random%"
set "INPUT_FILE=%TEMP_DIR%\input.txt"
set "OUTPUT_FILE=%TEMP_DIR%\output.txt"
set "RESULT_FILE=%TEMP_DIR%\result.json"

REM 创建临时目录
echo [1/5] 创建临时目录...
mkdir "%TEMP_DIR%" 2>nul
echo [信息] 临时目录: %TEMP_DIR%

REM 检查 Python
where python >nul 2>nul
if errorlevel 1 (
    echo [错误] Python 未安装
    goto :cleanup
)

REM 准备输入数据
echo.
echo [2/5] 准备输入数据...
(
echo 这是第一行数据 - Hello
echo 这是第二行数据 - World
echo 这是第三行数据 - 测试
echo 这是第四行数据 - 数据
echo 这是第五行数据 - 结束
) > "%INPUT_FILE%"

echo [信息] 输入数据已写入: %INPUT_FILE%
echo 内容:
type "%INPUT_FILE%"
echo.

REM 调用 Python 处理数据
echo [3/5] 调用 Python 处理数据...
echo ----------------------------------------
python -c "
import os
import json

# 读取输入文件
input_file = r'%INPUT_FILE%'
output_file = r'%OUTPUT_FILE%'
result_file = r'%RESULT_FILE%'

print('[Python] 读取输入文件...')
with open(input_file, 'r', encoding='utf-8') as f:
    lines = f.readlines()

print(f'[Python] 读取到 {len(lines)} 行数据')

# 处理数据
processed = []
for i, line in enumerate(lines, 1):
    processed.append(f'行 {i}: {line.strip()} (长度: {len(line.strip())})')

# 写入输出文件
print('[Python] 写入输出文件...')
with open(output_file, 'w', encoding='utf-8') as f:
    f.write('\n'.join(processed))

# 生成 JSON 结果
result = {
    'status': 'success',
    'input_lines': len(lines),
    'output_lines': len(processed),
    'message': '数据处理完成'
}

with open(result_file, 'w', encoding='utf-8') as f:
    json.dump(result, f, ensure_ascii=False, indent=2)

print('[Python] 处理完成')
"
echo ----------------------------------------

REM 读取处理结果
echo.
echo [4/5] 读取处理结果...
echo ----------------------------------------
echo [输出文件内容:]
if exist "%OUTPUT_FILE%" (
    type "%OUTPUT_FILE%"
) else (
    echo [错误] 输出文件不存在
)

echo.
echo [JSON 结果:]
if exist "%RESULT_FILE%" (
    type "%RESULT_FILE%"
) else (
    echo [错误] 结果文件不存在
)
echo ----------------------------------------

REM 清理临时文件
echo.
echo [5/5] 清理临时文件...
:cleanup
rd /s /q "%TEMP_DIR%" 2>nul
if not exist "%TEMP_DIR%" (
    echo [成功] 临时目录已删除
) else (
    echo [警告] 临时目录删除失败: %TEMP_DIR%
)

echo.
echo ========================================
echo   演示完成
echo ========================================

endlocal
