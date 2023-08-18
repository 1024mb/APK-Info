@ECHO OFF

ECHO Removing APK-Info shell integration...
ECHO.
SET "ERROR=0"

REG DELETE "HKCU\SOFTWARE\Classes\.apk" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul
REG DELETE "HKCU\SOFTWARE\Classes\APK-Info" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul

REG DELETE "HKCU\SOFTWARE\Classes\SystemFileAssociations\.apk\Shell\APK-Info\Command" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul

IF %ERROR% EQU 0 (
ECHO APK-Info shell integration removed!
ECHO.
ECHO.
ECHO     **** Press any key to exit ****
) ELSE (
ECHO APK-Info shell integration removing failed!
ECHO At least one of the keys failed to be removed.
ECHO.
ECHO.
ECHO     **** Press any key to exit ****
)
pause > NUL
