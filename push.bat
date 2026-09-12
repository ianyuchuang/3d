@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>nul
cd /d "%~dp0"
echo === Push to GitHub ===

where git >nul 2>nul
if errorlevel 1 (
  echo [ERROR] git not found in PATH.
  pause
  exit /b 1
)

if not exist ".git" (
  echo [ERROR] not a git repo yet. Run init-git.bat first.
  pause
  exit /b 1
)

git remote get-url origin >nul 2>nul
if errorlevel 1 (
  echo [ERROR] remote "origin" is not set. Run init-git.bat first.
  pause
  exit /b 1
)

call "tools\check-identity.bat"
if errorlevel 1 goto :fail

rem --- uncommitted changes? offer to commit them ---
set "DIRTY="
for /f "delims=" %%i in ('git status --porcelain') do set "DIRTY=1"
if defined DIRTY (
  echo.
  git status --short
  echo.
  set /p "ANS=Uncommitted changes found. Commit them now? [Y/N] "
  if /i "!ANS!"=="Y" (
    set /p "MSG=Commit message (blank = update 3d models): "
    if "!MSG!"=="" set "MSG=update 3d models"
    git add -A
    git commit -m "!MSG!"
    if errorlevel 1 goto :fail
  ) else (
    echo [INFO] pushing committed work only; local changes stay uncommitted.
  )
)

rem --- current branch ---
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD') do set "BR=%%b"
echo [INFO] branch: !BR!

rem --- upstream set? ---
git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >nul 2>nul
if errorlevel 1 (
  echo [INFO] first push - setting upstream origin/!BR!
  git push -u origin "!BR!"
) else (
  git push
)
if errorlevel 1 goto :fail

echo.
echo Pushed OK.
echo Site: https://ianyuchuang.github.io/3d/
echo ^(GitHub Pages usually takes 1-2 minutes to rebuild^)
echo.
pause
exit /b 0

:fail
echo.
echo [ERROR] failed at the step above.
echo Common causes: no GitHub login, repo not created yet, or remote has newer commits ^(run: git pull --rebase^).
pause
exit /b 1
