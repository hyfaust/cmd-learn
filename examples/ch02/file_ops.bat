@echo off
chcp 65001 >nul 2>&1
REM ============================================
REM �ļ�������ʾ�ű�
REM ����:��ʾcopy,move,ren,del���ļ���������
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

REM ����Ŀ¼�ṹ
echo [1] ����Ŀ¼�ṹ
mkdir "%BASE%" 2>nul
mkdir "%BASE%\backup" 2>nul
mkdir "%BASE%\sub" 2>nul
echo.

REM ���������ļ�
echo [2] ���������ļ�
echo ���ǵ�һ�������ļ� > "%BASE%\test1.txt"
echo ���ǵڶ��������ļ� > "%BASE%\test2.txt"
echo ���ǵ����������ļ� > "%BASE%\test3.txt"
echo Hello World > "%BASE%\hello.txt"
echo �������
echo.

REM ��ʾ�������ļ�
echo [3] ��ʾ�������ļ�
dir "%BASE%\*.txt"
echo.

REM ��ʾcopy����
echo [4] ��ʾcopy����
echo ����test1.txt��backupĿ¼
copy "%BASE%\test1.txt" "%BASE%\backup\test1_backup.txt"
echo �������
echo.

REM ��ʾmove����
echo [5] ��ʾmove����
echo �ƶ�test2.txt��subĿ¼
move "%BASE%\test2.txt" "%BASE%\sub\test2.txt"
echo �ƶ����
echo.

REM ��ʾren����
echo [6] ��ʾren����
echo ������test3.txtΪtest3_renamed.txt
ren "%BASE%\test3.txt" "test3_renamed.txt"
echo ���������
echo.

REM ��ʾtype����鿴�ļ�����
echo [7] ��ʾtype����鿴�ļ�����
echo --- test1.txt���� ---
type "%BASE%\test1.txt"
echo --- hello.txt���� ---
type "%BASE%\hello.txt"
echo.

REM ��ʾcopy�ϲ��ļ�
echo [8] ��ʾcopy�ϲ��ļ�
echo �ϲ�test1.txt��hello.txt��combined.txt
copy "%BASE%\test1.txt" + "%BASE%\hello.txt" "%BASE%\combined.txt"
echo �ϲ��������:
type "%BASE%\combined.txt"
echo.

REM ��ʾ��������
echo [9] ��ʾ��������
copy "%BASE%\*.txt" "%BASE%\backup\"
echo �����������
echo.

REM ��ʾ����Ŀ¼�ṹ
echo [10] ����Ŀ¼�ṹ
tree "%BASE%" /F
echo.

REM ����sandboxĿ¼
echo [11] ����sandboxĿ¼
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