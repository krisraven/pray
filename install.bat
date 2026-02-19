@echo off
REM Pray CLI Tool - Windows Installation Script

setlocal enabledelayedexpansion

REM Colors using for /F with ANSI escape codes
for /F %%a in ('copy /Z "%~f0" nul') do set "ESC=%%a"

set "GREEN=%ESC%[32m"
set "BLUE=%ESC%[34m"
set "RED=%ESC%[31m"
set "NC=%ESC%[0m"

REM Configuration
set "INSTALL_DIR=%cd%"
set "BINARY_NAME=pray.exe"
set "QUOTES_FILE=quotes.json"
set "INSTALL_GLOBAL=false"

echo %BLUE%Pray CLI Tool - Installation%NC%
echo.

REM Parse arguments
:parse_args
if "%~1"=="" goto check_arch
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
    set "INSTALL_GLOBAL=true"
    shift
    goto parse_args
)
if /i "%~1"=="--global" (
    set "INSTALL_GLOBAL=true"
    shift
    goto parse_args
)
if /i "%~1"=="-h" goto show_help
if /i "%~1"=="--help" goto show_help

:check_arch
REM Detect Windows architecture
set "ARCH=amd64"
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" set "ARCH=386"
if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "ARCH=arm64"

REM Handle 32-bit Python on 64-bit Windows
if defined PROCESSOR_ARCHITEW6432 (
    if /i "%PROCESSOR_ARCHITEW6432%"=="x86" set "ARCH=386"
)

echo %BLUE%Detected architecture: %ARCH%%NC%
echo.

REM Determine installation directory
if "%INSTALL_GLOBAL%"=="true" (
    set "INSTALL_DIR=%ProgramFiles%\Pray"
    echo Installing to: !INSTALL_DIR! (requires admin)
) else (
    if "%INSTALL_DIR%"=="" set "INSTALL_DIR=%cd%"
    echo Installing to: !INSTALL_DIR!
)

REM Create directory if needed
if not exist "!INSTALL_DIR!" (
    mkdir "!INSTALL_DIR!"
    if !errorlevel! neq 0 (
        echo %RED%Failed to create directory%NC%
        exit /b 1
    )
)

REM Check if running as admin for global install
if "%INSTALL_GLOBAL%"=="true" (
    net session >nul 2>&1
    if !errorlevel! neq 0 (
        echo %RED%Error: This installation requires administrator privileges%NC%
        echo Please run as Administrator
        exit /b 1
    )
)

REM Download binary
echo.
echo %BLUE%Downloading binary...%NC%
set "BINARY_URL=https://github.com/krisraven/pray/releases/download/latest/pray-windows-%ARCH%.exe"

powershell -NoProfile -Command "& {
    $url = '%BINARY_URL%'
    $output = '!INSTALL_DIR!\%BINARY_NAME%'
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocol]::Tls12
        Invoke-WebRequest -Uri $url -OutFile $output
        Write-Host 'Downloaded successfully'
    } catch {
        Write-Host 'Failed to download: ' $_
        exit 1
    }
}"

if !errorlevel! neq 0 (
    echo %RED%Failed to download binary%NC%
    exit /b 1
)

REM Download quotes.json
echo %BLUE%Downloading quotes...%NC%
set "QUOTES_URL=https://raw.githubusercontent.com/krisraven/pray/main/quotes.json"

powershell -NoProfile -Command "& {
    $url = '%QUOTES_URL%'
    $output = '!INSTALL_DIR!\%QUOTES_FILE%'
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocol]::Tls12
        Invoke-WebRequest -Uri $url -OutFile $output
        Write-Host 'Downloaded successfully'
    } catch {
        Write-Host 'Failed to download: ' $_
        exit 1
    }
}"

if !errorlevel! neq 0 (
    echo %RED%Failed to download quotes%NC%
    exit /b 1
)

REM Verify installation
echo.
echo %BLUE%Verifying installation...%NC%

if exist "!INSTALL_DIR!\%BINARY_NAME%" (
    echo %GREEN%Installation successful!%NC%
    echo.
    echo Binary: !INSTALL_DIR!\%BINARY_NAME%
    echo Quotes: !INSTALL_DIR!\%QUOTES_FILE%
    echo.

    if "%INSTALL_GLOBAL%"=="true" (
        echo %GREEN%You can now run: pray%NC%
    ) else (
        echo %GREEN%Run the tool with: !INSTALL_DIR!\%BINARY_NAME%%NC%
        echo.
        echo %BLUE%To add to PATH:%NC%
        echo Open Environment Variables and add: !INSTALL_DIR!
    )
    echo.
    echo %BLUE%Testing installation...%NC%
    "!INSTALL_DIR!\%BINARY_NAME%"
) else (
    echo %RED%Installation failed%NC%
    exit /b 1
)

goto end

:show_help
echo Pray CLI Tool - Installation Script
echo.
echo Usage: install.bat [OPTIONS]
echo.
echo Options:
echo   -d, --dir DIR       Installation directory (default: current directory)
echo   -g, --global        Install to Program Files (requires admin)
echo   -h, --help          Show this help message
echo.
echo Examples:
echo   install.bat                    # Install to current directory
echo   install.bat -d C:\Tools        # Install to C:\Tools
echo   install.bat --global           # Install system-wide (needs admin)
echo.
exit /b 0

:end
endlocal
