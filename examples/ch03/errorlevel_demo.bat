@echo off
chcp 65001 >nul 2>&1
REM ��ȫ��ʾ:���ű���ִ��ֻ����������󼶱�,�����޸��κ��ļ�
REM ������ʾERRORLEVEL����

echo ERRORLEVEL������ʾ
echo ===================

REM ��ʼERRORLEVELֵ
echo 1. ��ʼERRORLEVELֵ:
echo   ��ǰERRORLEVEL: %ERRORLEVEL%

REM ִ�гɹ�����
echo.
echo 2. ִ�гɹ�����:
dir "%~dp0" >nul 2>&1
echo   dir������ERRORLEVEL: %ERRORLEVEL%

REM ִ��ʧ������
echo.
echo 3. ִ��ʧ������:
dir "%~dp0nonexistent" >nul 2>&1
echo   ����������ERRORLEVEL: %ERRORLEVEL%

REM ʹ��if errorlevel���
echo.
echo 4. ʹ��if errorlevel���:
dir "%~dp0nonexistent" >nul 2>&1
if errorlevel 1 (
    echo   ����ִ��ʧ��,ERRORLEVEL=%ERRORLEVEL%
) else (
    echo   ����ִ�гɹ�
)

REM ʹ�þ�ȷ�Ƚ�
echo.
echo 5. ʹ�þ�ȷ�Ƚ�:
dir "%~dp0" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   ����ִ�гɹ�(��ȷ�Ƚ�)
) else (
    echo   ����ִ��ʧ��
)

REM ʹ��&&��||��
echo.
echo 6. ʹ��^&^&��^|^|��:
dir "%~dp0nonexistent" >nul 2>&1 && echo   ���� || echo   ������

REM ��������ERRORLEVEL
echo.
echo 7. ��������ERRORLEVEL:
echo   ִ��dir����...
dir "%~dp0" >nul 2>&1
echo   dir����ERRORLEVEL: %ERRORLEVEL%

echo   ִ��copy����(ʧ��)...
copy "%~dp0nonexistent" "%~dp0copy_test" >nul 2>&1
echo   copy����ERRORLEVEL: %ERRORLEVEL%

echo   ִ��mkdir����(�ɹ�)...
mkdir "%~dp0temp_test_dir" >nul 2>&1
echo   mkdir����ERRORLEVEL: %ERRORLEVEL%

REM ������ʱĿ¼
rmdir "%~dp0temp_test_dir" >nul 2>&1

REM ERRORLEVEL�ļ̳���
echo.
echo 8. ERRORLEVEL�ļ̳���:
echo   ������ERRORLEVEL: %ERRORLEVEL%
cmd /c "echo �ӽ���ERRORLEVEL: %ERRORLEVEL%"
echo   �ӽ��̺󸸽���ERRORLEVEL: %ERRORLEVEL%

echo.
echo ERRORLEVEL��ʾ���