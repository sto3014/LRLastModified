@echo off
set SCRIPT_DIR=%~dp0
set VERSION=1.1.1.1
::
powershell -command "Expand-Archive -Force '%SCRIPT_DIR%target\LRLastModified%VERSION%_win.zip' '%HOMEDRIVE%%HOMEPATH%'"

