@echo off
setlocal
cd /d "%~dp0"
echo === Init git repo for 3D viewer site ===

where git >nul 2>nul
if errorlevel 1 (
  echo [ERROR] git not found in PATH. Install Git for Windows first.
  pause
  exit /b 1
)

if exist ".git" (
  echo [SKIP] .git already exists - skipping git init.
) else (
  git init
  if errorlevel 1 goto :fail
)

echo [1/4] install pre-commit hook
if not exist ".git\hooks" mkdir ".git\hooks"
copy /y "tools\pre-commit" ".git\hooks\pre-commit" >nul
if errorlevel 1 goto :fail

echo [2/4] stage files
git add -A
if errorlevel 1 goto :fail

echo [3/4] commit (hook will regenerate models.json)
git commit -m "Initial commit: 3D viewer index + models"
if errorlevel 1 (
  echo [WARN] nothing to commit, or commit failed. Continuing...
)
git branch -M main

echo [4/4] set remote origin
git remote remove origin >nul 2>nul
git remote add origin https://github.com/ianyuchuang/3d.git
if errorlevel 1 goto :fail

echo.
echo Done. Next step - push it yourself:
echo     git push -u origin main
echo.
echo Then on GitHub: Settings ^> Pages ^> Source = main / (root)
echo Site URL: https://ianyuchuang.github.io/3d/
echo.
pause
exit /b 0

:fail
echo.
echo [ERROR] failed at the step above.
pause
exit /b 1
