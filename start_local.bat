@echo off
REM ═══════════════════════════════════════════════════════════════════
REM  Palei Solutions — Local Backend Startup Script
REM  Starts Redis (if installed) then FastAPI backend
REM ═══════════════════════════════════════════════════════════════════

echo [Palei] Starting local backend...
cd /d "%~dp0"

REM ── 1. Try to start Redis ──────────────────────────────────────────
echo [Palei] Checking Redis...

REM Check common Redis install locations on Windows
SET REDIS_PATHS=C:\Program Files\Redis\redis-server.exe;C:\Redis\redis-server.exe;C:\tools\Redis\redis-server.exe

FOR %%P IN (%REDIS_PATHS%) DO (
    IF EXIST "%%P" (
        echo [Palei] Found Redis at %%P — starting...
        START "Redis Server" "%%P" --port 6379
        timeout /t 2 /nobreak > nul
        GOTO :redis_done
    )
)

REM Try redis-server from PATH
WHERE redis-server >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo [Palei] Found Redis in PATH — starting...
    START "Redis Server" redis-server --port 6379
    timeout /t 2 /nobreak > nul
    GOTO :redis_done
)

echo [Palei] Redis not found. WebSocket will use direct broadcast (single-worker mode OK).
echo [Palei] To install Redis: https://github.com/tporadowski/redis/releases

:redis_done

REM ── 2. Activate venv and start FastAPI ────────────────────────────
echo [Palei] Starting FastAPI backend on port 8000...
CALL venv\Scripts\activate.bat
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
