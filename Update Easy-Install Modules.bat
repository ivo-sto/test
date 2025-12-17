@Echo off&&cd /D %~dp0&&chcp 65001 >nul
Title 'Update Easy-Install Modules' v0.1.0 by ivo
:: Pixaroma Community Edition ::

:: Set colors ::
call :set_colors

:: Check for the main folder ::
if not exist "python_embeded" (
    echo %green%::::::::::::::: Run this file from the %yellow%'ComfyUI-Easy-Install main folder'%green% folder%reset%
    echo %green%::::::::::::::: Press any key to exit...%reset%&Pause>nul
	exit
)

echo %green%::::: Updating %yellow%ComfyUI-Easy-Install\Add-Ons%green% folder :::::%reset%
echo.

:: Renaming files ::
call :rename_files ".\run_nvidia_gpu.bat" 				"Start ComfyUI.bat"
call :rename_files ".\run_nvidia_gpu_SageAttention.bat"	"Start ComfyUI SageAttention.bat"
call :rename_files ".\Update All and RUN.bat" 			"Update ComfyUI and Nodes.bat"
call :rename_files ".\Update Comfy and RUN.bat" 		"Update ComfyUI.bat"
call :rename_files ".\Add-Ons\Easy-Models-Linker.bat" 	"1. Easy-Models-Linker.bat"
call :rename_files ".\Add-Ons\Insightface-NEXT.bat" 	"Insightface.bat"
call :rename_files ".\Add-Ons\Nunchaku-NEXT.bat" 		"Nunchaku.bat"
call :rename_files ".\Add-Ons\SageAttention-NEXT.bat" 	"SageAttention.bat"
echo.

:: Add a path just in case ::
if exist "%windir%\System32" set "path=%PATH%;%windir%\System32"
if exist "%windir%\System32\WindowsPowerShell\v1.0" set "path=%PATH%;%windir%\System32\WindowsPowerShell\v1.0"


if not exist "Add-Ons" mkdir "Add-Ons"
set "HLPR-NAME=Helper-CEI.zip"

:: Disable only CRL/OCSP checks for SSL ::
powershell -Command "[System.Net.ServicePointManager]::CheckCertificateRevocationList = $false"

:: Ignore SSL certificate errors ::
REM powershell -Command "Add-Type @'using System.Net;using System.Security.Cryptography.X509Certificates;public class TrustAllCertsPolicy : ICertificatePolicy {public bool CheckValidationResult(ServicePoint srvPoint,X509Certificate certificate,WebRequest request,int certificateProblem){return true;}}'@;[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy"

:: ------------------------------------------------------------------------------

REM powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip' -OutFile 'ComfyUI-Easy-Install.zip' -UseBasicParsing"

powershell -Command "Invoke-WebRequest -Uri 'https://github.com/ivo-sto/test/releases/latest/download/ComfyUI-Easy-Install.zip' -OutFile 'ComfyUI-Easy-Install.zip' -UseBasicParsing"

:: ------------------------------------------------------------------------------

if not exist "ComfyUI-Easy-Install.zip" (
    echo %red%::::::::::::::: Error downloading 'ComfyUI-Easy-Install.zip'%reset%
    echo %green%::::::::::::::: Press any key to exit...%reset%&Pause>nul
	exit
)

tar.exe -xf "ComfyUI-Easy-Install.zip" --strip-components=1 "ComfyUI-Easy-Install/%HLPR-NAME%"
tar.exe -xf "%HLPR-NAME%" -C "Add-Ons" --strip-components=2 "ComfyUI-Easy-Install/Add-Ons"

if exist "ComfyUI-Easy-Install.zip" del "ComfyUI-Easy-Install.zip"
if exist "%HLPR-NAME%" del "%HLPR-NAME%"

:: Create a shortcut on the desktop ::
if exist ".\Add-Ons\Tools\ComfyUI-EZi.ico" if exist ".\Start ComfyUI.bat" (
	echo.
	echo %green%::::::::::: Create a shortcut on the desktop :::::::::::%reset%
	powershell -command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\ComfyUI-EZi.lnk'); $s.TargetPath='%cd%\Start ComfyUI.bat'; $s.WorkingDirectory='%cd%\'; $s.IconLocation='%cd%\Add-Ons\Tools\ComfyUI-EZi.ico'; $s.Save();"
)

if exist ".\Add-Ons\Tools\AutoRun.bat" (
	pushd %cd%
	call ".\Add-Ons\Tools\AutoRun.bat"
	popd
	del  ".\Add-Ons\Tools\AutoRun.bat"
)

:: Final Messages ::
echo.
echo %green%::::::::::::::::: Installation Complete ::::::::::::::::%reset%
echo.
echo %green%::::::::::::: You can read what's new here: ::::::::::::%reset%
echo %yellow%https://github.com/Tavris1/ComfyUI-Easy-Install/releases%reset%
echo.
echo %green%::::::::::::::::: Press any key to exit ::::::::::::::::%reset%&Pause>nul
exit

::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::

:set_colors
set warning=[33m
set     red=[91m
set   green=[92m
set  yellow=[93m
set    bold=[1m
set   reset=[0m
goto :eof

:rename_files
::Renaming files ::
if exist "%~1" if not exist "%~2" (
	echo %green%::::::::::::::: Renaming %yellow%%~1%green% to %yellow%%~2 %reset%
	ren "%~1" "%~2"
)
