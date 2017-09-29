@taskkill /f /im "MoveToMain.exe"
@echo ----------------------------------------------------------
cd "%~dp0"
copy "MoveToMain.exe" "C:\Program Files\"
copy "*.ico" "C:\Program Files\"
copy "*.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\"
@echo ----------------------------------------------------------
@echo You can close this windows.
@"C:\Program Files\MoveToMain.exe"
@exit