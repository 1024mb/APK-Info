@ECHO OFF

ECHO APK-Info shell integration...
ECHO.
SET "ERROR=0"

REG ADD "HKCU\SOFTWARE\Classes\.apk" /ve /t REG_SZ /d "APK-Info.apk" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul
REG ADD "HKCU\SOFTWARE\Classes\APK-Info.apk\DefaultIcon" /ve /t REG_SZ /d "\"%cd%\APK-Info.exe\"" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul
REG ADD "HKCU\SOFTWARE\Classes\APK-Info.apk\shell\open" /ve /t REG_SZ /d "APK-Info" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul
REG ADD "HKCU\SOFTWARE\Classes\APK-Info.apk\shell\open\command" /ve /t REG_SZ /d "\"%cd%\APK-Info.exe\" \"%%1\"" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul

REG ADD "HKCU\SOFTWARE\Classes\SystemFileAssociations\.apk\Shell\APK-Info\Command" /ve /t REG_SZ /d "\"%cd%\APK-Info.exe\" \"%%1\"" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul

REG ADD "HKCU\SOFTWARE\Classes\.apks" /ve /t REG_SZ /d "APK-Info.apks" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul
REG ADD "HKCU\SOFTWARE\Classes\APK-Info.apks\DefaultIcon" /ve /t REG_SZ /d "\"%cd%\icons\APK-Info-APKS.ico\"" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul
REG ADD "HKCU\SOFTWARE\Classes\APK-Info.apks\shell\open" /ve /t REG_SZ /d "APK-Info" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul
REG ADD "HKCU\SOFTWARE\Classes\APK-Info.apks\shell\open\command" /ve /t REG_SZ /d "\"%cd%\APK-Info.exe\" \"%%1\"" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul

REG ADD "HKCU\SOFTWARE\Classes\SystemFileAssociations\.apks\Shell\APK-Info\Command" /ve /t REG_SZ /d "\"%cd%\APK-Info.exe\" \"%%1\"" /f >nul 2>nul || SET "ERROR=1" >nul 2>nul

IF %ERROR% EQU 0 (
ECHO APK-Info shell integration completed!
ECHO.
ECHO.
ECHO     **** Press any key to exit ****
) ELSE (
ECHO APK-Info shell integration failed!
ECHO There was an error creating at least one of the keys.
ECHO.
ECHO.
ECHO     **** Press any key to exit ****
)
pause > NUL
