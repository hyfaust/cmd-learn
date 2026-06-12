@echo off
chcp 65001 >nul 2>&1
REM ============================================================
REM for_R.bat �� for /R �ݹ��ļ�����ʾ��
REM ��ȫ��ʾ:���ű�����ȡ�ļ���Ϣ,���޸��κ��ļ�
REM ============================================================

echo === ������ǰĿ¼����Ŀ¼�е�����.bat�ļ� ===
for /R "%~dp0" %%f in (*.bat) do (
    echo �ļ�: %%~nxf
    echo   ·��: %%~dpf
    echo   ��С: %%~zf �ֽ�
    echo.
)

echo.
echo === ��������.txt�ļ� ===
for /R "%~dp0" %%f in (*.txt) do (
    echo �ļ�: %%~nxf
)

echo.
echo === ��������.md�ļ� ===
for /R "%~dp0..\.." %%f in (*.md) do (
    echo �ĵ�: %%~nxf
)

echo.
echo === ͳ���ļ����� ===
setlocal EnableDelayedExpansion
set "count=0"
for /R "%~dp0" %%f in (*.bat) do (
    set /a "count+=1"
)
echo �������ļ�����: !count!
endlocal

echo.
echo === ���Ҵ��ļ�(ʾ��:����1000�ֽ�) ===
setlocal EnableDelayedExpansion
for /R "%~dp0" %%f in (*.bat) do (
    if %%~zf GTR 1000 (
        echo ���ļ�: %%~nxf (%%~zf �ֽ�)
    )
)
endlocal

