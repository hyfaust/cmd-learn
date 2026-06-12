@echo off
chcp 65001 >nul 2>&1
REM ============================================================
REM for_L.bat �� for /L ��ֵ��Χѭ��ʾ��
REM ��ȫ��ʾ:���ű����ڿ���̨���,���޸��κ��ļ�
REM ============================================================
setlocal EnableDelayedExpansion

echo === ������ֵѭ�� ===
for /L %%i in (1,1,5) do (
    echo �� %%i ��ѭ��
)

echo.
echo === �Զ��岽�� ===
for /L %%i in (0,5,25) do (
    echo %%i
)

echo.
echo === ����ѭ�� ===
for /L %%i in (10,-1,1) do (
    echo ����ʱ: %%i
)

echo.
echo === �ۼ����ʾ�� ===
set "sum=0"
for /L %%i in (1,1,10) do (
    set /a "sum+=%%i"
    echo �ۼ� !sum! (��ǰֵ: %%i)
)
echo.
echo 1��10���ܺ�: !sum!

echo.
echo === Ƕ��ѭ��:�˷���Ƭ�� ===
for /L %%i in (1,1,3) do (
    for /L %%j in (1,1,3) do (
        set /a "product=%%i * %%j"
        echo %%i x %%j = !product!
    )
    echo.
)

endlocal
