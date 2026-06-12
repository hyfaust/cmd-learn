@echo off
chcp 65001 >nul 2>&1
REM variables.bat - ������ʾʾ��
REM ��ȫ��ʾ:���ű���������ʾ��������,��ִ���κ��ļ�����

echo ========================================
echo        ����������ʾ
echo ========================================
echo.

REM �����ӳ���չ
setlocal EnableDelayedExpansion

REM �����ַ�������
set "name=CMDѧϰ��"
set "greeting=���"
set "language=�������ű�"

REM �������
echo 1. �ַ���������ʾ:
echo    ����: %name%
echo    �ʺ�: %greeting%
echo    ����: %language%
echo.

REM ����������ʾ
echo 2. ����������ʾ:
set /a "addition=5+3"
set /a "subtraction=10-4"
set /a "multiplication=6*7"
set /a "division=100/3"
set /a "modulo=100%%3"

echo    �ӷ�: 5+3 = %addition%
echo    ����: 10-4 = %subtraction%
echo    �˷�: 6*7 = %multiplication%
echo    ����: 100/3 = %division%
echo    ȡģ: 100%%3 = %modulo%
echo.

REM ������������
echo 3. ����������ʾ:
set /a "complex=(5+3)*2"
set /a "power=2*2*2*2"
echo    (5+3)*2 = %complex%
echo    2^4 = %power%
echo.

REM �û�������ʾ
echo 4. �û�������ʾ:
set /p "user_name=�������������: "
set /p "user_age=�������������: "

echo.
echo ���, %user_name%
echo ����� %user_age% ��.
echo.

REM ����ƴ����ʾ
echo 5. ����ƴ����ʾ:
set "full_message=%greeting%, %user_name%!��ӭѧϰ%language%!"
echo    %full_message%
echo.

REM �ӳ���չʾ��
echo 6. �ӳ���չʾ��:
set "counter=0"
for /l %%i in (1,1,5) do (
    set /a "counter+=1"
    echo    ���� !counter!: ��ǰ���� = !counter!
)
echo.

echo ========================================
echo ������ʾ���
echo ========================================
pause