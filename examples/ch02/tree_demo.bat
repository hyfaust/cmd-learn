@echo off
chcp 65001 >nul 2>&1
REM ============================================
REM Ŀ¼��������ʾ�ű�
REM ����:��ʾtree,dir /S /B��Ŀ¼��������
REM ��ȫ:���鿴,���޸��κ��ļ�
REM ============================================

setlocal

echo ========================================
echo Ŀ¼��������ʾ
echo ========================================
echo.

REM ��ʾ��ǰĿ¼�ṹ
echo [1] ʹ��tree��ʾ��ǰĿ¼�ṹ
echo.
tree "%~dp0" /F
echo.

REM ʹ��dir�ݹ��г������ļ�
echo [2] ʹ��dir�ݹ��г������ļ�
echo.
dir "%~dp0" /S /B
echo.

REM ʹ��dir�ݹ��г��ض������ļ�
echo [3] ʹ��dir�ݹ��г�����.bat�ļ�
echo.
dir "%~dp0" /S /B *.bat
echo.

REM ʹ��dir�ݹ��г�����Ŀ¼
echo [4] ʹ��dir�ݹ��г�����Ŀ¼
echo.
dir "%~dp0" /S /B /AD
echo.

REM ʹ��tree��ʾASCII�ַ�����
echo [5] ʹ��tree��ʾASCII�ַ�����
echo.
tree "%~dp0" /A
echo.

REM ʹ��forѭ������Ŀ¼
echo [6] ʹ��forѭ����������.txt�ļ�
echo.
for /R "%~dp0" %%f in (*.txt) do (
    echo �����ļ�: %%f
)
echo.

REM ʹ��forѭ����������.bat�ļ�
echo [7] ʹ��forѭ����������.bat�ļ�
echo.
for /R "%~dp0" %%f in (*.bat) do (
    echo �ű��ļ�: %%f
)
echo.

REM ʹ��for /D����Ŀ¼
echo [8] ʹ��for /D������Ŀ¼
echo.
for /D %%d in ("%~dp0*") do (
    echo Ŀ¼: %%d
)
echo.

REM ͳ���ļ�����
echo [9] ͳ���ļ�����
echo.
set count=0
for /R "%~dp0" %%f in (*.*) do (
    set /a count+=1
)
echo ���ļ���: %count%
echo.

setlocal
echo ��ʾ����
pause