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
	SET "CURL_BIT=win64"
	SET "MAGICK_BIT=x64"
	SET "SEVENZIP_BIT=x64\"
) ELSE (
    SET "CURL_BIT=win32"
	SET "MAGICK_BIT=x86"
	SET "SEVENZIP_BIT= "
)

ECHO.
ECHO Getting latest 7-zip version
ECHO.
powershell -Command "Invoke-WebRequest https://api.github.com/repos/ip7z/7zip/tags -OutFile .\tools\tmp\7zip-tags.json" 
powershell -Command "$json=Get-Content -Raw -Path '.\tools\tmp\7zip-tags.json' | Out-String | ConvertFrom-Json; foreach ($line in $json) { $line.name > .\tools\tmp\7zip-latest.txt; return }"

powershell -Command "$content = (gc .\tools\tmp\7zip-latest.txt).Trim(); [System.IO.File]::WriteAllText('.\tools\tmp\7zip-latest.txt', $content)"

FOR /F "delims=" %%G IN (.\tools\tmp\7zip-latest.txt) DO SET "SEVENZIP_VERSION=%%G"

powershell -Command "(gc .\tools\tmp\7zip-latest.txt) -replace '\.', '' | Out-File -encoding ASCII .\tools\tmp\7zip-latest.txt"
powershell -Command "$content = (gc .\tools\tmp\7zip-latest.txt).Trim(); [System.IO.File]::WriteAllText('.\tools\tmp\7zip-latest.txt', $content)"

FOR /F "delims=" %%G IN (.\tools\tmp\7zip-latest.txt) DO SET "SEVENZIP_VERSION_PLAIN=%%G"

DEL /F /Q .\tools\tmp\7zip-tags.json
DEL /F /Q .\tools\tmp\7zip-latest.txt

ECHO.
ECHO Downloading 7-zip
ECHO.
powershell -Command "Invoke-WebRequest https://github.com/ip7z/7zip/releases/download/%SEVENZIP_VERSION%/7zr.exe -OutFile .\tools\tmp\7zr.exe"
powershell -Command "Invoke-WebRequest https://github.com/ip7z/7zip/releases/download/%SEVENZIP_VERSION%/7z%SEVENZIP_VERSION_PLAIN%-extra.7z -OutFile .\tools\tmp\7z-extra.7z"

ECHO.
ECHO Unpacking 7-zip...
ECHO.
.\tools\tmp\7zr.exe e .\tools\tmp\7z-extra.7z -o.\tools %SEVENZIP_BIT%7za.exe -aoa -y
REN .\tools\7za.exe 7z.exe
DEL /F /Q .\tools\tmp\7zr.exe
DEL /F /Q .\tools\tmp\7z-extra.7z

ECHO Downloading curl...
ECHO.
powershell -Command "Invoke-WebRequest https://curl.se/windows/latest.cgi?p=%CURL_BIT%-mingw.zip -OutFile .\tools\tmp\curl-%CURL_BIT%-mingw.zip"

ECHO.
ECHO Extracting curl...
ECHO.
.\tools\7z.exe e .\tools\tmp\curl-%CURL_BIT%-mingw.zip -o.\tools curl.exe curl-ca-bundle.crt -r -aoa -y
DEL /F /Q .\tools\tmp\curl-%CURL_BIT%-mingw.zip

ECHO.
ECHO Getting latest magick version
ECHO.
powershell -Command "Invoke-WebRequest https://api.github.com/repos/ImageMagick/ImageMagick/tags -OutFile .\tools\tmp\magick-tags.json" 
powershell -Command "$json=Get-Content -Raw -Path '.\tools\tmp\magick-tags.json' | Out-String | ConvertFrom-Json; foreach ($line in $json) { $line.name > .\tools\tmp\magick-latest.txt; return }"

powershell -Command "$content = (gc .\tools\tmp\magick-latest.txt).Trim(); [System.IO.File]::WriteAllText('.\tools\tmp\magick-latest.txt', $content)"

FOR /F "delims=" %%G IN (.\tools\tmp\magick-latest.txt) DO SET "MAGICK_VERSION=%%G"
DEL /F /Q .\tools\tmp\magick-tags.json
DEL /F /Q .\tools\tmp\magick-latest.txt

ECHO.
ECHO Downloading magick
ECHO.
.\tools\curl.exe -L -o .\tools\tmp\ImageMagick-%MAGICK_VERSION%-portable-Q16-%MAGICK_BIT%.zip https://imagemagick.org/archive/binaries/ImageMagick-%MAGICK_VERSION%-portable-Q16-%MAGICK_BIT%.zip

ECHO.
ECHO Extracting magick...
ECHO.
.\tools\7z.exe e .\tools\tmp\ImageMagick-%MAGICK_VERSION%-portable-Q16-%MAGICK_BIT%.zip -o.\tools convert.exe colors.xml -r -aoa -y
DEL /F /Q .\tools\tmp\ImageMagick-%MAGICK_VERSION%-portable-Q16-%MAGICK_BIT%.zip


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

.\tools\7z.exe e .\tools\tmp\build-tools_r34-windows.zip -o.\tools android-14\aapt.exe android-14\aapt2.exe android-14\lib\apksigner.jar android-14\libwinpthread-1.dll -aoa -y
DEL /F /Q .\tools\tmp\build-tools_r34-windows.zip

ECHO.
ECHO Downloading ADB compatible with WinXP
ECHO.
IF NOT EXIST .\tools\xp MKDIR .\tools\xp
.\tools\curl.exe -L -o .\tools\xp\adb.exe https://raw.githubusercontent.com/1024mb/adb-win/master/SDK_Platform-Tools_for_Windows/platform-tools_r23.1.0-windows/adb.exe
.\tools\curl.exe -L -o .\tools\xp\AdbWinApi.dll https://raw.githubusercontent.com/1024mb/adb-win/master/SDK_Platform-Tools_for_Windows/platform-tools_r23.1.0-windows/AdbWinApi.dll
.\tools\curl.exe -L -o .\tools\xp\AdbWinUsbApi.dll https://raw.githubusercontent.com/1024mb/adb-win/master/SDK_Platform-Tools_for_Windows/platform-tools_r23.1.0-windows/AdbWinUsbApi.dll

RMDIR /S /Q .\tools\tmp
ECHO.
ECHO.
ECHO All tools downloaded.
ECHO Press any button to close this window.
PAUSE > NUL 2>&1
