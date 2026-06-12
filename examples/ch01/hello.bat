@echo off
chcp 65001 >nul 2>&1
REM hello.bat - ����Hello Worldʾ��
REM ��ȫ��ʾ:���ű���������ʾ,��ִ���κ��ļ�����

echo ========================================
echo        Hello CMD - ��ʶ�����нű�
echo ========================================
echo.
echo ������ĵ�һ��CMD�ű�!
echo.
echo ��ǰʱ����Ϣ:
echo ����: %DATE%
echo ʱ��: %TIME%
echo.
echo ϵͳ��Ϣ:
echo �������: %COMPUTERNAME%
echo �û���: %USERNAME%
echo.
echo �ű���Ϣ:
echo �ű�·��: %~dp0
echo �ű�����: %~nx0
echo.
echo ========================================
echo �ű�ִ�����!
echo ========================================
pause