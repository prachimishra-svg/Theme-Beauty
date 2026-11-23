@echo off
rem Rebuilds the high-fidelity Homepage after you add photographs to the images folder.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-hifi.ps1"
pause
