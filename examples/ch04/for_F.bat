@echo off
chcp 65001 >nul 2>&1
REM ============================================================
REM for_F.bat �� for /F �ַ�������ѭ��ʾ��
REM ��ȫ��ʾ:���ű����ڽű�����Ŀ¼������ʱ�ļ�,����������ɾ��
REM ============================================================
setlocal EnableDelayedExpansion

echo === ���ո�ָ�(Ĭ��) ===
for /F "tokens=1,2,3" %%a in ("hello world cmd") do (
    echo ��1��: %%a
    echo ��2��: %%b
    echo ��3��: %%c
)

echo.
echo === �����ŷָ� ===
for /F "tokens=1-3 delims=," %%a in ("apple,banana,cherry") do (
    echo ˮ��: %%a, %%b, %%c
)

echo.
echo === ��ȡ�ض��ֶ� ===
for /F "tokens=1,3 delims=," %%a in ("one,two,three,four,five") do (
    echo ��1��: %%a
    echo ��3��: %%c
)

echo.
echo === ʹ��ͨ�����ȡ ===
for /F "tokens=2-4 delims=," %%a in ("a,b,c,d,e,f") do (
    echo ��2-4��: %%a, %%b, %%c
)

echo.
echo === ��ȡ������� ===
for /F "tokens=*" %%a in ('dir /b "%~dp0*.bat"') do (
    echo �������ļ�: %%a
)

echo.
echo === ��ȡ�ļ����� ===
REM ������ʱ�����ļ�
echo line1 - ��һ�� > "%~dp0temp_test.txt"
echo line2 - �ڶ��� >> "%~dp0temp_test.txt"
echo line3 - ������ >> "%~dp0temp_test.txt"
echo # ����ע���� >> "%~dp0temp_test.txt"
echo line4 - ������ >> "%~dp0temp_test.txt"

echo ��ȡ������:
for /F "usebackq tokens=*" %%a in ("%~dp0temp_test.txt") do (
    echo ��ȡ: %%a
)

echo.
echo ����ǰ2��:
for /F "usebackq skip=2 tokens=*" %%a in ("%~dp0temp_test.txt") do (
    echo ��ȡ: %%a
)

echo.
echo ���� # ��ͷ��ע����:
for /F "usebackq eol=# tokens=*" %%a in ("%~dp0temp_test.txt") do (
    echo ��ȡ: %%a
)

REM ������ʱ�ļ�
del "%~dp0temp_test.txt" 2>nul

echo.
echo === �������ո��·�� ===
for /F "tokens=*" %%a in ('dir /b /s "%~dp0*.bat" 2^>nul') do (
    echo �ļ�: %%~nxa
)

endlocal
