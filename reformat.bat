@echo off
VERIFY OTHER 2>NUL
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions
SET me=%~n0
SET parent=%~dp0

IF NOT DEFINED SQLDEVELOPER_HOME (ECHO SQLDEVELOPER_HOME is NOT defined. please set it such that %%SQLDEVELOPER_HOME%%\sqldeveloper\bin\sdcli is valid )
IF NOT DEFINED SQLDEVELOPER_HOME (exit /B 1 )

set SDCLI=%SQLDEVELOPER_HOME%\sqldeveloper\bin\sdcli
IF NOT EXIST %SDCLI% (echo executable not found:%SDCLI% && exit /B 2 )


for /R source %%i in (*.pks *.pkb *.tps *.tpb) do (echo %%i && %SDCLI% format input=%%i output=%%i )


endlocal
