@ECHO OFF

REM make sure we don't stomp variables in calling script
SETLOCAL

REM the location of this batch file
SET SOURCE="%~DP0"

REM target location
SET TARGET=%1

IF [%TARGET%]==[] GOTO FAIL

GOTO OK

:FAIL

ECHO Must supply target folder parameter, e.g.:
ECHO.`
ECHO   deploy.bat ../deploy/lib/g11n
ECHO.
GOTO :EOF

:OK

REM copy all files
xcopy %SOURCE%\source %TARGET%\source\ /q /e

REM recursively go through target directories & remove non-data directories
pushd %TARGET%
for /d /r %%d in (*) do (
 set "TRUE="
 if "%%~nd"=="javascript" set TRUE=1 
 if "%%~nd"=="loc" set TRUE=1
 if "%%~nd"=="css" set TRUE=1
 if defined TRUE (
  rd "%%d" /s /q
 )

 REM remove package files
 if exist "%%d\package.js" del "%%d\package.js"
)
popd

ENDLOCAL