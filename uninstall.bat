@echo off
REM Pray CLI Tool - Windows Uninstallation Script

setlocal enabledelayedexpansion

for /F %%a in ('copy /Z "%~f0" nul') do set "ESC=%%a"

set "GREEN=%ESC%[32m"
set "BLUE=%ESC%[34m"
set "RED=%ESC%[31m"
set "NC=%ESC%[0m"

set "INSTALL_DIR=%cd%"
set "BINARY_NAME=pray.exe"
set "QUOTES_FILE=quotes.json"
set "UNINSTALL_GLOBAL=false"

echo %BLUE%Pray CLI Tool - Uninstallation%NC%
echo.

:parse_args
if "%~1"=="" goto begin
if /i "%~1"=="-d" (
    set "INSTALL_DIR=%~2"
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--dir" (
    set "INSTALL_DIR=%~2"
    shift
    shift
    goto parse_args
)
if /i "%~1"=="-g" (
    set "UNINSTALL_GLOBAL=true"
    shift
    goto parse_args
)
if /i "%~1"=="--global" (
    set "UNINSTALL_GLOBAL=true"
    shift
    goto parse_args
)
if /i "%~1"=="-h" goto show_help
if /i "%~1"=="--help" goto show_help

:begin
if "%UNINSTALL_GLOBAL%"=="true" (
    set "INSTALL_DIR=%ProgramFiles%\Pray"
    echo Uninstalling from: !INSTALL_DIR! (requires admin)

    net session >nul 2>&1
    if !errorlevel! neq 0 (
        echo %RED%Error: This requires administrator privileges%NC%
        echo Please run as Administrator
        exit /b 1
    )
) else (
    echo Uninstalling from: !INSTALL_DIR!
)

if not exist "!INSTALL_DIR!\%BINARY_NAME%" (
    echo %RED%Binary not found at !INSTALL_DIR!\%BINARY_NAME%%NC%
    echo Use -d to specify the directory or --global for a system-wide install.
    exit /b 1
)

echo.
echo %BLUE%Removing files...%NC%

if exist "!INSTALL_DIR!\%BINARY_NAME%" (
    del /f /q "!INSTALL_DIR!\%BINARY_NAME%"
)
if exist "!INSTALL_DIR!\%QUOTES_FILE%" (
    del /f /q "!INSTALL_DIR!\%QUOTES_FILE%"
)

if "%UNINSTALL_GLOBAL%"=="true" (
    if not exist "!INSTALL_DIR!\*" (
        rmdir "!INSTALL_DIR!" >nul 2>&1
    )
)

if not exist "!INSTALL_DIR!\%BINARY_NAME%" (
    echo %GREEN%Uninstallation successful!%NC%
    echo Removed: !INSTALL_DIR!\%BINARY_NAME%
) else (
    echo %RED%Uninstallation failed%NC%
    exit /b 1
)

goto end

:show_help
echo Pray CLI Tool - Uninstallation Script
echo.
echo Usage: uninstall.bat [OPTIONS]
echo.
echo Options:
echo   -d, --dir DIR       Directory to uninstall from (default: current directory)
echo   -g, --global        Uninstall from Program Files (requires admin)
echo   -h, --help          Show this help message
echo.
echo Examples:
echo   uninstall.bat                    # Uninstall from current directory
echo   uninstall.bat -d C:\Tools        # Uninstall from C:\Tools
echo   uninstall.bat --global           # Uninstall system-wide install (needs admin)
echo.
exit /b 0

:end
endlocal
