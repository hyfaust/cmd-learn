@echo off
chcp 65001 >nul 2>&1
REM ============================================================
REM for_D.bat �� for /D Ŀ¼����ѭ��ʾ��
REM ��ȫ��ʾ:���ű�����ȡĿ¼��Ϣ,���޸��κ��ļ�
REM ============================================================

echo === ������ǰĿ¼�µ���Ŀ¼ ===
for /D %%d in ("%~dp0*") do (
    echo Ŀ¼: %%~nxd
)

echo.
echo === ������Ŀ¼�µ���Ŀ¼ ===
for %%I in ("%~dp0..") do set "parent=%%~fI"
for /D %%d in ("%parent%\*") do (
    echo ��Ŀ¼�µ�Ŀ¼: %%~nxd
)

echo.
echo === ʹ��ͨ���ɸѡĿ¼ ===
for /D %%d in ("%~dp0ch0*") do (
    echo ��ch0��ͷ��Ŀ¼: %%~nxd
)

echo.
echo === ��ȡĿ¼����·�� ===
for /D %%d in ("%~dp0ch04") do (
    echo Ŀ¼��: %%~nxd
    echo ����·��: %%~fd
)

echo.
echo === �ݹ��������Ŀ¼(������Ŀ¼) ===
for /D /R "%~dp0" %%d in (*) do (
    echo Ŀ¼: %%d
)

