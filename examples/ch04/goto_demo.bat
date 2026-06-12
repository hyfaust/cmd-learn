@echo off
chcp 65001 >nul 2>&1
REM ============================================================
REM goto_demo.bat �� goto�ͱ�ǩʾ��
REM ��ȫ��ʾ:���ű����ڿ���̨���,���޸��κ��ļ�
REM ============================================================
setlocal

echo === goto ʵ�ּ�ѭ�� ===
set /a "count=0"
:loop
set /a "count+=1"
echo ѭ������: %count%
if %count% LSS 5 goto :loop
echo ѭ������

echo.
echo === goto ʵ�ֲ˵�ϵͳ ===
goto :menu

:menu
echo.
echo ============================
echo         ���˵�
echo ============================
echo 1. ��ʾʱ��
echo 2. ��ʾ����
echo 3. ��ʾ��ǰĿ¼
echo 4. �˳�
echo ============================
choice /c 1234 /n /m "��ѡ�� [1-4]: "
if errorlevel 4 goto :end
if errorlevel 3 goto :showdir
if errorlevel 2 goto :showdate
if errorlevel 1 goto :showtime

:showtime
echo.
echo ��ǰʱ��: %TIME%
goto :menu

:showdate
echo.
echo ��ǰ����: %DATE%
goto :menu

:showdir
echo.
echo ��ǰĿ¼: %CD%
goto :menu

:end
echo.
echo �������,�ټ�!
endlocal

