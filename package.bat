SETLOCAL

FOR /F "tokens=* USEBACKQ" %%F IN (`powershell -Command "(gc .\Application-source\APK-Info.au3 -Raw) -replace '(?ms).+Res_Fileversion=(.+?$).+', '$1'"`) DO (
SET "APP_VERSION=%%F"
)

7z a -tzip -xr!nppBackup "APK-Info_win_v%APP_VERSION%.zip" Documents icons APK-Info.exe APK-Info_x64.exe APK-Info-Shell-Integration.cmd APK-Info-Shell-Integration_Remove.cmd APK-Info-Shell-Integration-x64.cmd app_config.ini localization.ini README.md Setup_Additional_Tools.cmd user_config.ini

ENDLOCAL
EXIT