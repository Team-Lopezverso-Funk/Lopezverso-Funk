@echo off
title Compiler
setlocal enabledelayedexpansion

:: Enable ANSI escape codes (Windows 10+)
for /f "delims=" %%i in ('echo prompt $E ^| cmd') do set "ESC=%%i"

set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "RESET=%ESC%[0m"

echo %YELLOW%========================================%RESET%
echo              %YELLOW%COMPILER%RESET%
echo %YELLOW%========================================%RESET%
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
    echo %YELLOW%Compiling for Windows...%RESET%
    lime test windows > compilation_log.txt 2>&1
) else if "%option%"=="2" (
    echo %YELLOW%Compiling for Mac...%RESET%
    lime test mac > compilation_log.txt 2>&1
) else if "%option%"=="3" (
    echo %YELLOW%Compiling for Linux...%RESET%
    lime test linux > compilation_log.txt 2>&1
) else if "%option%"=="4" (
    echo %YELLOW%Compiling for Android...%RESET%
    lime test android > compilation_log.txt 2>&1
) else (
    echo %RED%Invalid option.%RESET%
    pause
    exit /b
)

:: Check if errors exist in the log
findstr /i /c:"Error" compilation_log.txt >nul
if %errorlevel%==0 (
    echo.
    echo %RED%========================================%RESET%
    echo          COMPILATION FAILED
    echo   Check compilation_log.txt for details
    echo %RED%========================================%RESET%
) else (
    echo.
    echo %GREEN%========================================%RESET%
    echo          COMPILATION SUCCESSFUL
    echo   Check compilation_log.txt for details
    echo %GREEN%========================================%RESET%
)

pause
