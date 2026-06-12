@echo off
chcp 65001 >nul 2>&1
REM ��ȫ��ʾ:���ű��������ļ������Լ��,�����޸��κ��ļ�
REM ������ʾif exist���÷�

echo �ļ������Լ����ʾ
echo ===================

REM ����ļ��Ƿ����
echo 1. ��鵱ǰĿ¼���ļ�:
if exist "%~dp0if_basics.bat" (
    echo   if_basics.bat ����
) else (
    echo   if_basics.bat ������
)

REM ���Ŀ¼�Ƿ����
echo.
echo 2. ���Ŀ¼�Ƿ����:
if exist "%~dp0..\ch02" (
    echo   ch02Ŀ¼����
) else (
    echo   ch02Ŀ¼������
)

REM ���ϵͳ�ļ�
echo.
echo 3. ���ϵͳ�ļ�:
if exist "C:\Windows\notepad.exe" (
    echo   notepad.exe ����
) else (
    echo   notepad.exe ������
)

REM ʹ��ͨ������
echo.
echo 4. ʹ��ͨ������:
if exist "%~dp0*.bat" (
    echo   ����.bat�ļ�
) else (
    echo   ������.bat�ļ�
)

REM ���������
echo.
echo 5. ���������:
if exist "%~dp0*.bat" if exist "%~dp0*.py" (
    echo   ͬʱ����.bat��.py�ļ�
) else (
    echo   ��ͬʱ����.bat��.py�ļ�
)

REM ��鲻���ڵ��ļ�
echo.
echo 6. ��鲻���ڵ��ļ�:
if exist "%~dp0nonexistent.txt" (
    echo   nonexistent.txt ����
) else (
    echo   nonexistent.txt ������
)

REM ʹ������·������
echo.
echo 7. ����·��������ʾ:
echo   ��ǰ�ű�·��: %~f0
echo   ��ǰ�ű�Ŀ¼: %~dp0
echo   �ű��ļ���: %~nx0

echo.
echo �ļ������ʾ���