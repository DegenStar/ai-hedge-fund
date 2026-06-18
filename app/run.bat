@echo off
REM AI Hedge Fund Web Application Setup and Runner (Windows)
REM This script makes it easy for non-technical users to run the full web application

set "INFO=[INFO]"
set "SUCCESS=[SUCCESS]"
set "WARNING=[WARNING]"
set "ERROR=[ERROR]"

REM Check Node.js
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo %ERROR% Node.js is not installed. Please install from https://nodejs.org/
    pause
    exit /b 1
)

REM Check npm
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo %ERROR% npm is not installed. Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

REM Check Python
where python >nul 2>&1
if %errorlevel% neq 0 (
    where python3 >nul 2>&1
    if %errorlevel% neq 0 (
        echo %ERROR% Python is not installed. Please install from https://python.org/
        pause
        exit /b 1
    )
)

REM Check uv
where uv >nul 2>&1
if %errorlevel% neq 0 (
    REM Try common install locations
    if exist "%USERPROFILE%\.local\bin\uv.exe" (
        echo %INFO% uv found in user directory. Adding to PATH temporarily...
        set "PATH=%USERPROFILE%\.local\bin;%PATH%"
        goto :uv_found
    )
    if exist "%USERPROFILE%\.cargo\bin\uv.exe" (
        echo %INFO% uv found in cargo bin. Adding to PATH temporarily...
        set "PATH=%USERPROFILE%\.cargo\bin;%PATH%"
        goto :uv_found
    )
    echo %WARNING% uv is not installed.
    echo %INFO% uv is required to manage Python dependencies for this project.
    echo.
    set /p install_uv="Would you like to install uv automatically? (y/N): "
    if /i "%install_uv%"=="y" (
        echo %INFO% Installing uv...
        powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
        if %errorlevel% neq 0 (
            echo %ERROR% Failed to install uv automatically.
            echo %INFO% Please install uv manually from https://docs.astral.sh/uv/
            pause
            exit /b 1
        )
        echo %SUCCESS% uv installed successfully!
        set "PATH=%USERPROFILE%\.local\bin;%PATH%"
        where uv >nul 2>&1
        if %errorlevel% neq 0 (
            echo %WARNING% uv was installed but is not yet available in PATH.
            echo %INFO% Please restart your terminal and run this script again.
            pause
            exit /b 1
        )
        echo %SUCCESS% uv is now available!
    ) else (
        echo %ERROR% uv is required to run this application.
        echo %INFO% Install from: https://docs.astral.sh/uv/
        pause
        exit /b 1
    )
)

:uv_found
echo %SUCCESS% uv is available!

REM Ensure correct working directory
if not exist "frontend" (
    echo %ERROR% This script must be run from the app\ directory
    pause
    exit /b 1
)
if not exist "backend" (
    echo %ERROR% This script must be run from the app\ directory
    pause
    exit /b 1
)

echo.
echo %INFO% AI Hedge Fund Web Application Setup
echo %INFO% This script will install dependencies and start both frontend and backend services
echo.

REM Check for .env
if not exist "..\.env" (
    if exist "..\.env.example" (
        echo %WARNING% No .env file found. Creating from .env.example...
        copy "..\.env.example" "..\.env"
        echo %WARNING% Please edit ..\.env to add your API keys.
        echo.
    ) else (
        echo %ERROR% No .env or .env.example file found in the root directory.
        pause
        exit /b 1
    )
) else (
    echo %SUCCESS% Environment file (.env) found
)

REM Setup database
echo %INFO% Setting up database...
if exist "..\hedge_fund.db" (
    echo %SUCCESS% Database file already exists
) else (
    echo %INFO% Database will be created when backend starts for the first time
)

REM Install backend dependencies
echo %INFO% Installing backend dependencies...
uv run python -c "import uvicorn; import fastapi" >nul 2>&1
if %errorlevel% equ 0 (
    echo %SUCCESS% Backend dependencies already installed
) else (
    echo %INFO% Installing Python dependencies with uv...
    cd ..
    uv sync --no-dev
    cd app
    if %errorlevel% neq 0 (
        echo %ERROR% Failed to install backend dependencies
        pause
        exit /b 1
    )
    echo %SUCCESS% Backend dependencies installed successfully
)

REM Install frontend dependencies
echo %INFO% Installing frontend dependencies...
cd frontend
if exist "node_modules" (
    echo %SUCCESS% Frontend dependencies already installed
) else (
    echo %INFO% Installing Node.js dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo %ERROR% Failed to install frontend dependencies
        pause
        exit /b 1
    )
    echo %SUCCESS% Frontend dependencies installed
)
cd ..

REM Start services
echo %INFO% Starting the AI Hedge Fund web application...
echo %INFO% Press Ctrl+C to stop all services
echo.

echo %INFO% Launching backend server...
cd ..
start /b uv run uvicorn app.backend.main:app --reload --host 127.0.0.1 --port 8000
cd app

timeout /t 5 /nobreak >nul

echo %INFO% Launching frontend development server...
cd frontend
start /b npm run dev
cd ..

timeout /t 5 /nobreak >nul

echo %INFO% Opening browser...
start http://localhost:5173

echo.
echo %SUCCESS% AI Hedge Fund web application is now running
echo %INFO% Frontend: http://localhost:5173
echo %INFO% Backend:  http://localhost:8000
echo %INFO% Docs:     http://localhost:8000/docs
echo.
echo %INFO% Press any key to stop both services...
pause >nul

taskkill /f /im "uvicorn.exe" >nul 2>&1
taskkill /f /im "node.exe" >nul 2>&1

echo %SUCCESS% Services stopped. Goodbye
pause
