@echo off
rem Rewrites slides.js after you add or remove hero pictures in this folder.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update-slides.ps1"
pause
