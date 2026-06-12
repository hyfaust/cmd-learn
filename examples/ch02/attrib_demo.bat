@echo off
chcp 65001 >nul 2>&1
REM ============================================
REM �ļ�������ʾ�ű�
REM ����:��ʾattrib������ļ����Բ���
REM ��ȫ:���в�������sandbox��Ŀ¼�ڽ���
REM ============================================

setlocal

REM ���û�׼Ŀ¼Ϊ�ű�����Ŀ¼�µ�sandbox
set "BASE=%~dp0sandbox"

REM �������ܴ��ڵľ�sandbox
if exist "%BASE%" (
    echo �����ɵ�sandboxĿ¼...
    rd /s /q "%BASE%"
)

echo ========================================
echo �ļ�������ʾ
echo ========================================
echo.

REM ����Ŀ¼�Ͳ����ļ�
echo [1] ���������ļ�
mkdir "%BASE%" 2>nul
echo ��ͨ�ļ� > "%BASE%\normal.txt"
echo ֻ���ļ� > "%BASE%\readonly.txt"
echo �����ļ� > "%BASE%\hidden.txt"
echo ϵͳ�ļ� > "%BASE%\system.txt"
echo ��������ļ� > "%BASE%\combined.txt"
echo �������
echo.

REM ��ʾ��ʼ����
echo [2] ��ʾ��ʼ�ļ�����
attrib "%BASE%\*.*"
echo.

REM ����ֻ������
echo [3] ����ֻ������
attrib +R "%BASE%\readonly.txt"
echo �������
attrib "%BASE%\readonly.txt"
echo.

REM ������������
echo [4] ������������
attrib +H "%BASE%\hidden.txt"
echo �������
attrib "%BASE%\hidden.txt"
echo.

REM ����ϵͳ����
echo [5] ����ϵͳ����
attrib +S "%BASE%\system.txt"
echo �������
attrib "%BASE%\system.txt"
echo.

REM �����������
echo [6] �����������(ֻ��+����+ϵͳ)
attrib +R +H +S "%BASE%\combined.txt"
echo �������
attrib "%BASE%\combined.txt"
echo.

REM ��ʾ�����ļ�
echo [7] ʹ��dir��ʾ�����ļ�
dir "%BASE%" /a:h
echo.

REM ��ʾϵͳ�ļ�
echo [8] ʹ��dir��ʾϵͳ�ļ�
dir "%BASE%" /a:s
echo.

REM ��ʾֻ���ļ�
echo [9] ʹ��dir��ʾֻ���ļ�
dir "%BASE%" /a:r
echo.

REM ����ɾ��ֻ���ļ�(��ʧ��)
echo [10] ����ɾ��ֻ���ļ�(��ʧ��)
del "%BASE%\readonly.txt" 2>nul
if exist "%BASE%\readonly.txt" (
    echo ɾ��ʧ��:�ļ���ֻ����
) else (
    echo ɾ���ɹ�
)
echo.

REM �Ƴ�ֻ�����Ժ�ɾ��
echo [11] �Ƴ�ֻ�����Ժ�ɾ��
attrib -R "%BASE%\readonly.txt"
del "%BASE%\readonly.txt"
if not exist "%BASE%\readonly.txt" (
    echo ɾ���ɹ�
) else (
    echo ɾ��ʧ��
)
echo.

REM �Ƴ���������
echo [12] �Ƴ���������
attrib -R -H -S "%BASE%\combined.txt"
echo �Ƴ�������:
attrib "%BASE%\combined.txt"
echo.

REM ��ʾ����״̬
echo [13] �����ļ�״̬
dir "%BASE%"
echo.
attrib "%BASE%\*.*"
echo.

REM ����sandboxĿ¼
echo [14] ����sandboxĿ¼
rd /s /q "%BASE%"
if not exist "%BASE%" (
    echo �������
) else (
    echo ����ʧ��!
)

endlocal
echo.
echo ��ʾ����
pause