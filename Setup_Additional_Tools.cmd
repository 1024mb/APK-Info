@ECHO OFF
SETLOCAL
CLS
ECHO.
ECHO Before continuing with the download you have to
ECHO go to each of the following websites and accept
ECHO their licenses.
ECHO.
ECHO https://curl.se
ECHO https://www.7-zip.org
ECHO https://imagemagick.org
ECHO https://developer.android.com/tools
ECHO.
ECHO By continuing you agree with said licenses.
ECHO.
CHOICE /C YN /M "Enter Y to confirm or N to exit."
IF %ERRORLEVEL% NEQ 1 (
	EXIT
)
CLS
ECHO.

IF NOT EXIST .\tools MKDIR tools
IF NOT EXIST .\tools\tmp MKDIR tools\tmp

IF DEFINED ProgramFiles(x86) (
    GOTO 64_Bits
) ELSE (
    GOTO 32_Bits
)

:64_Bits
WHERE /Q powershell.exe
IF %ERRORLEVEL% EQU 0 (

	powershell -Command "Invoke-WebRequest https://curl.se/windows/dl-8.2.1_6/curl-8.2.1_6-win64-mingw.zip -OutFile .\tools\tmp\curl-8.2.1_6-win64-mingw.zip"
	powershell -Command "Invoke-WebRequest https://www.7-zip.org/a/7zr.exe -OutFile .\tools\tmp\7zr.exe"

	powershell -Command "Invoke-WebRequest https://www.7-zip.org/a/7z2301-extra.7z -OutFile .\tools\tmp\7z2301-extra.7z"


) ELSE (
	
	bitsadmin /transfer "Curl" https://curl.se/windows/dl-8.2.1_6/curl-8.2.1_6-win64-mingw.zip .\tools\tmp\curl-8.2.1_6-win64-mingw.zip
	bitsadmin /transfer "7-zip" https://www.7-zip.org/a/7zr.exe .\tools\tmp\7zr.exe
	bitsadmin /transfer "7-zip Extra" https://www.7-zip.org/a/7z2301-extra.7z .\tools\tmp\7z2301-extra.7z
	
)
.\tools\tmp\7zr.exe e .\tools\tmp\7z2301-extra.7z -o.\tools x64\7za.exe -aoa -y
REN .\tools\7za.exe 7z.exe
DEL /F /Q .\tools\tmp\7zr.exe
DEL /F /Q .\tools\tmp\7z2301-extra.7z
.\tools\7z.exe e .\tools\tmp\curl-8.2.1_6-win64-mingw.zip -o.\tools curl.exe curl-ca-bundle.crt -r -aoa -y
DEL /F /Q .\tools\tmp\curl-8.2.1_6-win64-mingw.zip
.\tools\curl.exe -o .\tools\tmp\ImageMagick-7.1.1-15-portable-Q16-x64.zip https://imagemagick.org/archive/binaries/ImageMagick-7.1.1-15-portable-Q16-x64.zip
.\tools\7z.exe e .\tools\tmp\ImageMagick-7.1.1-15-portable-Q16-x64.zip -o.\tools convert.exe colors.xml -r -aoa -y
DEL /F /Q .\tools\tmp\ImageMagick-7.1.1-15-portable-Q16-x64.zip
GOTO Universal_Tools

:32_Bits
WHERE /Q powershell.exe
IF %ERRORLEVEL% EQU 0 (

	powershell -Command "Invoke-WebRequest https://curl.se/windows/dl-8.2.1_6/curl-8.2.1_6-win32-mingw.zip -OutFile .\tools\tmp\curl-8.2.1_6-win32-mingw.zip"
	powershell -Command "Invoke-WebRequest https://www.7-zip.org/a/7zr.exe -OutFile .\tools\tmp\7zr.exe"

	powershell -Command "Invoke-WebRequest https://www.7-zip.org/a/7z2301-extra.7z -OutFile .\tools\tmp\7z2301-extra.7z"

) ELSE (
	
	bitsadmin /transfer "Curl" https://curl.se/windows/dl-8.2.1_6/curl-8.2.1_6-win32-mingw.zip .\tools\tmp\curl-8.2.1_6-win32-mingw.zip
	bitsadmin /transfer "7-zip" https://www.7-zip.org/a/7zr.exe .\tools\tmp\7zr.exe
	bitsadmin /transfer "7-zip Extra" https://www.7-zip.org/a/7z2301-extra.7z .\tools\tmp\7z2301-extra.7z
	
)
.\tools\tmp\7zr.exe e .\tools\tmp\7z2301-extra.7z -o.\tools 7za.exe -aoa -y
REN .\tools\7za.exe 7z.exe
DEL /F /Q .\tools\tmp\7zr.exe
DEL /F /Q .\tools\tmp\7z2301-extra.7z
.\tools\7z.exe e .\tools\tmp\curl-8.2.1_6-win32-mingw.zip -o.\tools curl.exe curl-ca-bundle.crt -r -aoa -y
DEL /F /Q .\tools\tmp\curl-8.2.1_6-win32-mingw.zip
ECHO.
ECHO Downloading ImageMagick
ECHO.
.\tools\curl.exe -o .\tools\tmp\ImageMagick-7.1.1-15-portable-Q16-x86.zip https://imagemagick.org/archive/binaries/ImageMagick-7.1.1-15-portable-Q16-x86.zip
.\tools\7z.exe e .\tools\tmp\ImageMagick-7.1.1-15-portable-Q16-x86.zip -o.\tools convert.exe colors.xml -r -aoa -y
DEL /F /Q .\tools\tmp\ImageMagick-7.1.1-15-portable-Q16-x86.zip
GOTO Universal_Tools


:Universal_Tools
ECHO.
ECHO Downloading Android platform-tools
ECHO.
.\tools\curl.exe -o .\tools\tmp\platform-tools_r34.0.4-windows.zip https://dl.google.com/android/repository/platform-tools_r34.0.4-windows.zip
ECHO.
ECHO Downloading Android build-tools
ECHO.
.\tools\curl.exe -o .\tools\tmp\build-tools_r34-windows.zip https://dl.google.com/android/repository/build-tools_r34-windows.zip
ECHO.

.\tools\7z.exe e .\tools\tmp\platform-tools_r34.0.4-windows.zip -o.\tools adb.exe AdbWinApi.dll AdbWinUsbApi.dll -r -aoa -y
DEL /F /Q .\tools\tmp\platform-tools_r34.0.4-windows.zip

.\tools\7z.exe e .\tools\tmp\build-tools_r34-windows.zip -o.\tools android-14\aapt.exe android-14\lib\apksigner.jar android-14\libwinpthread-1.dll -aoa -y
DEL /F /Q .\tools\tmp\build-tools_r34-windows.zip

ECHO.
ECHO Downloading ADB compatible with WinXP
ECHO.
IF NOT EXIST .\tools\xp MKDIR .\tools\xp
.\tools\curl.exe -o .\tools\xp\adb.exe https://raw.githubusercontent.com/awake558/adb-win/master/SDK_Platform-Tools_for_Windows/platform-tools_r23.1.0-windows/adb.exe
.\tools\curl.exe -o .\tools\xp\AdbWinApi.dll https://github.com/awake558/adb-win/raw/master/SDK_Platform-Tools_for_Windows/platform-tools_r23.1.0-windows/AdbWinApi.dll
.\tools\curl.exe -o .\tools\xp\AdbWinUsbApi.dll https://github.com/awake558/adb-win/raw/master/SDK_Platform-Tools_for_Windows/platform-tools_r23.1.0-windows/AdbWinUsbApi.dll

RMDIR /S /Q .\tools\tmp
ECHO.
ECHO.
ECHO All tools downloaded.
ECHO Press any button to close this window.
PAUSE > NUL 2>&1
