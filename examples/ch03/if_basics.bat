@echo off
chcp 65001 >nul 2>&1
REM ��ȫ��ʾ:���ű������б��������������ж�,�����޸��κ��ļ�
REM ������ʾif���Ļ����÷�

setlocal EnableDelayedExpansion

REM �ַ����Ƚ�ʾ��
set "name=test"
if "%name%"=="test" (
    echo �ַ����Ƚ�:��������test
) else (
    echo �ַ����Ƚ�:����������test
)

REM ��ֵ�Ƚ�ʾ��
set /a "num=42"
echo ��ֵ�Ƚ�ʾ��(num=%num%):
if %num% GTR 40 echo   ����40:����
if %num% LSS 50 echo   С��50:����
if %num% EQU 42 echo   ����42:����
if %num% NEQ 43 echo   ������43:����
if %num% LEQ 42 echo   С�ڵ���42:����
if %num% GEQ 42 echo   ���ڵ���42:����

REM �ַ����Ƚ�����ֵ�Ƚϵ�����
echo.
echo �ַ����Ƚ�����ֵ�Ƚϵ�����:
set "str1=10"
set "str2=010"

if "%str1%"=="%str2%" (
    echo �ַ����Ƚ�:10 ���� 010
) else (
    echo �ַ����Ƚ�:10 ������ 010
)

if %str1% EQU %str2% (
    echo ��ֵ�Ƚ�:10 ���� 010
) else (
    echo ��ֵ�Ƚ�:10 ������ 010
)

REM ����Ϊ��ʱ�Ĵ���
echo.
echo ����Ϊ��ʱ�Ĵ���:
set "emptyvar="
if "%emptyvar%"=="" (
    echo ����Ϊ��:��ȷ����
) else (
    echo ������Ϊ��:����
)

REM ʹ��defined������
if defined emptyvar (
    echo defined���:�����Ѷ���
) else (
    echo defined���:����δ����
)

REM �������ж�ʾ��
echo.
echo �������ж�ʾ��:
set /a "score=85"
if %score% GEQ 90 (
    echo �ɼ�����
) else if %score% GEQ 80 (
    echo �ɼ�����
) else if %score% GEQ 60 (
    echo �ɼ�����
) else (
    echo �ɼ�������
)

endlocal
echo.
echo if������ʾ���