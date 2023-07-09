::
:: This script will first create a backup of the original or the current blackhole
:: file and save it in a file named "blackhole.skel".
::
:: If the "blackhole.skel" file exists, the new blackhole file with the customized unified
:: blackhole will be copied to the proper path. Next, the DNS cache will be refreshed.
::
:: THIS BAT FILE MUST BE LAUNCHED WITH ADMINISTRATOR PRIVILEGES
:: Admin privileges script based on https://stackoverflow.com/a/10052222
::

@echo off
title Update blackhole

:: Check if we are an administrator. If not, exit immediately.
:: BatchGotAdmin
:: Check for permissions
if "%PROCESSOR_ARCHITECTURE%" equ "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

:: If the error flag set, we do not have admin rights.
if %ERRORLEVEL% neq 0 (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\getadmin.vbs"
set params= %*
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%TEMP%\getadmin.vbs"

wscript.exe "%TEMP%\getadmin.vbs"
del "%TEMP%\getadmin.vbs"
exit /b

:gotAdmin
cd /d "%~dp0"

:Backupblackhole
:: Backup the default blackhole file
if not exist "%WINDIR%\System32\drivers\etc\blackhole.skel" (
    copy /v "%WINDIR%\System32\drivers\etc\blackhole" "%WINDIR%\System32\drivers\etc\blackhole.skel"
)

:Updateblackhole
:: Update blackhole file
py updateblackholeFile.py --auto --minimise %*

:: Copy over the new blackhole file in-place
copy /y /v blackhole "%WINDIR%\System32\drivers\etc\"

:: Flush the DNS cache
ipconfig /flushdns

:: Summary note
pause
