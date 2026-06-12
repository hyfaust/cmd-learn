@echo off
chcp 65001 >nul 2>&1
REM ��ȫ��ʾ:���ű������б����ȽϺ����,�����޸��κ��ļ�
REM ������ʾ���бȽ������

setlocal

echo �Ƚ������������ʾ
echo =================

set /a "a=10"
set /a "b=20"

echo �Ƚ� %a% �� %b%:
echo.

REM EQU - ����
echo 1. EQU (����):
if %a% EQU %b% (
    echo   %a% EQU %b% = ����
) else (
    echo   %a% EQU %b% = ������
)

REM NEQ - ������
echo.
echo 2. NEQ (������):
if %a% NEQ %b% (
    echo   %a% NEQ %b% = ����
) else (
    echo   %a% NEQ %b% = ������
)

REM LSS - С��
echo.
echo 3. LSS (С��):
if %a% LSS %b% (
    echo   %a% LSS %b% = ����
) else (
    echo   %a% LSS %b% = ������
)

REM LEQ - С�ڵ���
echo.
echo 4. LEQ (С�ڵ���):
if %a% LEQ %b% (
    echo   %a% LEQ %b% = ����
) else (
    echo   %a% LEQ %b% = ������
)

REM GTR - ����
echo.
echo 5. GTR (����):
if %a% GTR %b% (
    echo   %a% GTR %b% = ����
) else (
    echo   %a% GTR %b% = ������
)

REM GEQ - ���ڵ���
echo.
echo 6. GEQ (���ڵ���):
if %a% GEQ %b% (
    echo   %a% GEQ %b% = ����
) else (
    echo   %a% GEQ %b% = ������
)

REM �ַ����Ƚ�����ֵ�Ƚϵ�����
echo.
echo ================================
echo �ַ����Ƚ�����ֵ�Ƚϵ�����:
echo ================================

set "str1=10"
set "str2=010"

echo �ַ����Ƚ� (==):
if "%str1%"=="%str2%" (
    echo   "%str1%" == "%str2%" = ����
) else (
    echo   "%str1%" == "%str2%" = ������
)

echo ��ֵ�Ƚ� (EQU):
if %str1% EQU %str2% (
    echo   %str1% EQU %str2% = ����
) else (
    echo   %str1% EQU %str2% = ������
)

REM �ֵ���Ƚ�ʾ��
echo.
echo ================================
echo �ֵ���Ƚ�ʾ��:
echo ================================

set "word1=apple"
set "word2=banana"

echo �Ƚ� "%word1%" �� "%word2%":
if "%word1%" LSS "%word2%" (
    echo   "%word1%" LSS "%word2%" = ���� (�ֵ���)
) else (
    echo   "%word1%" LSS "%word2%" = ������ (�ֵ���)
)

REM �����ַ������ֵ���Ƚ�
set "num1=2"
set "num2=10"

echo �Ƚ� "%num1%" �� "%num2%" (�ֵ���):
if "%num1%" LSS "%num2%" (
    echo   "%num1%" LSS "%num2%" = ����
) else (
    echo   "%num1%" LSS "%num2%" = ������
)

echo �Ƚ� %num1% �� %num2% (��ֵ):
if %num1% LSS %num2% (
    echo   %num1% LSS %num2% = ����
) else (
    echo   %num1% LSS %num2% = ������
)

endlocal
echo.
echo �Ƚ��������ʾ���