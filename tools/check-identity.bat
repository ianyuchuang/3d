@echo off
rem Ensure git user.name / user.email are set. Called by init-git.bat and push.bat.
setlocal enabledelayedexpansion
chcp 65001 >nul 2>nul

git config user.email >nul 2>nul
if errorlevel 1 goto :ask
git config user.name >nul 2>nul
if errorlevel 1 goto :ask
exit /b 0

:ask
echo.
echo === Git identity is not set ===
echo This name/email is stamped on every commit and is PUBLIC in a public repo.
echo.
set "GN="
set /p "GN=Name  [ianyuchuang]: "
if "!GN!"=="" set "GN=ianyuchuang"

echo.
echo Email:
echo   1^) ian861016@gmail.com  - your real address, visible in public commits
echo   2^) ianyuchuang@users.noreply.github.com  - GitHub private alias
echo   or type a full address
set "GE="
set /p "GE=Email [1]: "
if "!GE!"=="" set "GE=1"
if "!GE!"=="1" set "GE=ian861016@gmail.com"
if "!GE!"=="2" set "GE=ianyuchuang@users.noreply.github.com"

git config --global user.name "!GN!"
if errorlevel 1 goto :fail
git config --global user.email "!GE!"
if errorlevel 1 goto :fail

echo [OK] git identity set: !GN! ^<!GE!^>
echo      change it later with: git config --global user.email "..."
echo.
exit /b 0

:fail
echo [ERROR] failed to write git config.
exit /b 1
