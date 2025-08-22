@echo off
setlocal enabledelayedexpansion

:: Enable ANSI escape codes (Windows 10+)
for /f "delims=" %%i in ('echo prompt $E ^| cmd') do set "ESC=%%i"

set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "RESET=%ESC%[0m"

echo %YELLOW%================ COMPILER ================%RESET%
echo.
echo Select the platform to compile:
echo [1] Windows
echo [2] Mac
echo [3] Linux
echo [4] Android
echo.

set /p option=Enter option number: 

:: Clear previous log
if exist compilation_log.txt del compilation_log.txt

if "%option%"=="1" (
    lime test windows > compilation_log.txt 2>&1
) else if "%option%"=="2" (
    lime test mac > compilation_log.txt 2>&1
) else if "%option%"=="3" (
    lime test linux > compilation_log.txt 2>&1
) else if "%option%"=="4" (
    lime test android > compilation_log.txt 2>&1
    if exist "export/android/bin" start "" "export/android/bin"
) else (
    echo Invalid option.
    pause
    exit /b
)

:: Check if errors exist in the log
findstr /i /c:"Error" compilation_log.txt >nul
if %errorlevel%==0 (
    echo %RED%Compilation failed%RESET%
    echo Check compilation_log.txt for details
) else (
    echo %GREEN%Compilation successful%RESET%
)

pause