@echo off
chcp 65001 >nul 2>&1
REM ��ȫ��ʾ:���ű��������û�������ֻ������,�����޸��κ��ļ�
REM ������ʾchoice������÷�

echo �û�ѡ����ʾ
echo ============

:menu
echo.
echo ��ѡ�����:
echo 1. �鿴��ǰĿ¼
echo 2. �鿴��ǰʱ��
echo 3. �鿴ϵͳ��Ϣ
echo 4. �˳�
echo.

choice /c 1234 /n /m "������ѡ��(1-4): "

if errorlevel 4 goto :end
if errorlevel 3 (
    echo.
    echo ϵͳ��Ϣ:
    echo   �������: %COMPUTERNAME%
    echo   �û���: %USERNAME%
    echo   ����ϵͳ: %OS%
    echo   ������: %PROCESSOR_IDENTIFIER%
    goto :menu
)
if errorlevel 2 (
    echo.
    echo ��ǰʱ��: %TIME%
    echo ��ǰ����: %DATE%
    goto :menu
)
if errorlevel 1 (
    echo.
    echo ��ǰĿ¼����:
    dir "%~dp0" /b
    goto :menu
)

:end
echo.
echo �������,��лʹ��!