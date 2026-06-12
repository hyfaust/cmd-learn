@echo off
chcp 65001 >nul 2>&1
REM ============================================================
REM shift_demo.bat �� shift ������λʾ��
REM ��ȫ��ʾ:���ű����ڿ���̨���,���޸��κ��ļ�
REM �÷�: shift_demo.bat arg1 arg2 arg3 ...
REM ============================================================

echo === ������λ��ʾ ===
echo.
echo ԭʼ����: %*
echo ��������: %~0
echo.

echo === ����������� ===
setlocal EnableDelayedExpansion
set "index=0"
:loop
if "%~1"=="" goto :summary
set /a "index+=1"
echo ���� !index!: %~1
shift
goto :loop

:summary
echo.
echo �������� %index% ������

echo.
echo === ʹ�� shift /1 ������һ������ ===
echo �ű���: %~0
echo ��һ������: %~1
echo.
echo ʣ�����:
shift /1
:loop2
if "%~1"=="" goto :end
echo   - %~1
shift
goto :loop2

:end
echo.
echo ��ʾ����
endlocal

