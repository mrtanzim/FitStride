@echo off
title FORGE - Flutter Dev Server

echo [FORGE] Killing previous flutter run processes...
taskkill /F /IM dart.exe /T >nul 2>&1
taskkill /F /IM flutter_tools.snapshot >nul 2>&1

:: Kill any chrome launched by flutter on the debug port
for /f "tokens=5" %%a in ('netstat -aon ^| find ":9222"') do (
    taskkill /F /PID %%a >nul 2>&1
)

timeout /t 1 /nobreak >nul

echo [FORGE] Starting Flutter on Chrome...
cd /d "%~dp0"
flutter run -d chrome

pause
