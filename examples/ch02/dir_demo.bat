@echo off
chcp 65001 >nul 2>&1
REM ============================================
REM Ŀ¼������ʾ�ű�
REM ����:��ʾmkdir,rmdir,dir��Ŀ¼��������
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
echo Ŀ¼������ʾ
echo ========================================
echo.

REM ����Ŀ¼�ṹ
echo [1] ����Ŀ¼�ṹ
mkdir "%BASE%" 2>nul
mkdir "%BASE%\sub1" 2>nul
mkdir "%BASE%\sub2" 2>nul
mkdir "%BASE%\sub1\deep" 2>nul
mkdir "%BASE%\sub2\data" 2>nul
echo ����Ŀ¼���
echo.

REM ��ʾ������Ŀ¼
echo [2] ��ʾĿ¼�ṹ
dir "%BASE%" /ad
echo.

REM ʹ��tree������ʾĿ¼��
echo [3] ʹ��tree��ʾĿ¼��
tree "%BASE%"
echo.

REM ��ʾpushd/popd
echo [4] ��ʾpushd/popd
echo ��ǰĿ¼: %cd%
pushd "%BASE%"
echo ����Ŀ¼: %cd%
dir /ad
popd
echo ����Ŀ¼: %cd%
echo.

REM ��ʾ���·������
echo [5] ��ʾ���·������
cd /d "%BASE%"
echo ��ǰĿ¼: %cd%
cd sub1
echo ����sub1: %cd%
cd ..
echo �����ϼ�: %cd%
cd ..
echo �ٷ����ϼ�: %cd%
cd /d "%~dp0"
echo.

REM ��ʾĿ¼����
echo [6] ��ʾĿ¼����
dir "%BASE%" /a
echo.

REM ����sandboxĿ¼
echo [7] ����sandboxĿ¼
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