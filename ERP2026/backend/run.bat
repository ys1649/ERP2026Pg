@echo off
cd /d %~dp0
set PORT=8000

for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":%PORT% " ^| findstr "LISTENING"') do (
    echo Port %PORT% is already in use by PID %%p, killing it...
    taskkill /F /T /PID %%p >nul 2>&1
)

python -m uvicorn main:app --reload --port %PORT%
