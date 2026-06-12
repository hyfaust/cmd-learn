@echo off
chcp 65001 >nul 2>&1
REM special_vars.bat - ���������ʾʾ��
REM ��ȫ��ʾ:���ű���������ʾ�������,��ִ���κ��ļ�����

echo ========================================
echo        ���������ʾ
echo ========================================
echo.

REM �ű���Ϣ����
echo 1. �ű���ر���:
echo    �ű�����·��: %~f0
echo    �ű�������: %~d0
echo    �ű�·��: %~dp0
echo    �ű�����: %~n0
echo    �ű���չ��: %~x0
echo    �ű��ļ���: %~nx0
echo    �ű���С: %~z0 �ֽ�
echo    �ű�����: %~t0
echo.

REM ϵͳ��������
echo 2. ϵͳ��������:
echo    ��ǰĿ¼: %CD%
echo    ϵͳĿ¼: %SystemRoot%
echo    �����ļ�Ŀ¼: %ProgramFiles%
echo    �û�Ŀ¼: %USERPROFILE%
echo    ��ʱĿ¼: %TEMP%
echo.

REM ʱ�����ڱ���
echo 3. ʱ�������:
echo    ��ǰ����: %DATE%
echo    ��ǰʱ��: %TIME%
echo    �������: %COMPUTERNAME%
echo    �û���: %USERNAME%
echo.

REM �����в�����ʾ
echo 4. �����в���:
echo    �ű�����: %0
echo    ��һ������: %1
echo    �ڶ�������: %2
echo    ����������: %3
echo    ���в���: %*
echo    ��������: ��ȷ��(����shift����)
echo.

REM ��������ʾ
echo 5. ��������ʾ:
echo    ��ǰ������: %ERRORLEVEL%
echo.

REM ִ��һ������鿴������仯
dir C:\Windows >nul 2>&1
echo    ִ��dir�����Ĵ�����: %ERRORLEVEL%

dir C:\NonExistentDir >nul 2>&1
echo    ִ��ʧ�������Ĵ�����: %ERRORLEVEL%
echo.

REM �������ʾ
echo 6. �������ʾ:
echo    �����1: %RANDOM%
echo    �����2: %RANDOM%
echo    �����3: %RANDOM%
echo    ����1-100�������: ʹ�� %%RANDOM%% %% 100 + 1
echo.

REM �����ַ���ʾ
echo 7. �����ַ�����:
echo    �ٷֺ�: %%
echo    ������: ^< ^>
echo    ����: ^|
echo    �����: ^&
echo.

echo ========================================
echo ���������ʾ���!
echo ========================================
echo.
echo ��ʾ:���Գ��Դ��������д˽ű�:
echo   %~nx0 arg1 arg2 arg3
echo.
pause