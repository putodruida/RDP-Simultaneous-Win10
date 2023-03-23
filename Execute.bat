@echo off

REM .bat con permisos de administrador
REM .bat with administrator permissions
:-------------------------------------
REM --> Analizando los permisos
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If there is an error, it means that there are no administrator permissions.
if '%errorlevel%' NEQ '0' (

REM not shown --> echo Solicitando permisos de administrador... 

REM not shown --> echo Requesting administrative privileges... 

REM not shown --> echo Anfordern Administratorrechte ...

goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"
:--------------------------------------
cls

echo ******************************************************************************************
echo .
echo . If you edited the "termsrv.dll" file, choose this option --------- 1
echo .
echo . If you did not edit the "termsrv.dll" file, choose this option --- 2
echo .
echo . To exit ---------------------------------------------------------- 0
echo .
echo ******************************************************************************************
echo .
echo .
set /p respuesta= Enter the number: 
IF %respuesta%==1 goto edited
IF %respuesta%==2 goto noEdited
IF %respuesta%==0 goto exit

:edited
cls
REM Detiene el servico de Escritorio Remoto
REM Stop the Remote Desktop service
Net stop TermService 
cls
echo [ESP]
echo Si esta el servicio aun iniciado, fallara, por lo que no se podra continuar.
echo Si falla, hay que reiniciar el equipo.
echo .
echo [ENG]
echo If the service is still started, it will fail, so it will not be possible to continue.
echo If it fails, you have to restart the computer.
echo .
PAUSE
REM Elimina el archivo. SI ESTA EN USO, fallara.
REM Delete the file. IF IN USE, it will fail.
del /s /q "c:\Windows\System32\termsrv.dll"

REM Copia el editado
REM Copy the edited
COPY /Y "C:\DISCOS\RDP Simultaneos Win10\EDITED\termsrv.dll" "c:\Windows\System32"

REM Inicia el servico de Escritorio Remoto
REM Start the Remote Desktop service
Net start TermService

echo EL EQUIPO SE REINICIARA...
echo.
echo THE EQUIPMENT WILL RESTART...
PAUSE
shutdown -r -t 0
EXIT

:noEdited
cls
md "C:\DISCOS"
md "C:\DISCOS\RDP Simultaneos Win10"
md "C:\DISCOS\RDP Simultaneos Win10\BACKUP"
md "C:\DISCOS\RDP Simultaneos Win10\EDITED"

copy "%~dp0\Execute.bat" "C:\DISCOS\RDP Simultaneos Win10"
copy "%~dp0\Line to edit.png" "C:\DISCOS\RDP Simultaneos Win10"
copy c:\Windows\System32\termsrv.dll "C:\DISCOS\RDP Simultaneos Win10\BACKUP\termsrv.dll_backup"
copy c:\Windows\System32\termsrv.dll "C:\DISCOS\RDP Simultaneos Win10"


REM Cambia el propietario del archivo al grupo "Administradores"
REM Change the owner of the file to the "Administrators" group
takeown /F c:\Windows\System32\termsrv.dll /A

REM Concede todos los permisos, incluido el control total al grupo "Administradores"
REM Grant all permissions including full control to the "Administrators" group
icacls c:\Windows\System32\termsrv.dll /grant Administradores:(D,WDAC,F,M,RX)
cls
echo [ESP]
echo .
echo Edite con un editor HEX el "termsrv.dll" (Ejemplo con HxD)
echo .
echo Reemplace la linea "39 81 3C 06 00 00 0F 84 XX XX XX XX"
echo .
echo con "B8 00 01 00 00 89 81 38 06 00 00 90"
echo .
echo Una vez editado...
echo .
echo Ver imagen "Line for edit.png"
echo .
echo.
echo [ENG]
echo .
echo Edit with a HEX editor the "termsrv.dll" (Example with HxD)
echo .
echo Replace the line "39 81 3C 06 00 00 0F 84 XX XX XX XX"
echo .
echo with "B8 00 01 00 00 89 81 38 06 00 00 90"
echo .
echo Once edited...
echo.
echo See image "Line for edit.png"
echo.
explorer.exe "C:\DISCOS\RDP Simultaneos Win10"
PAUSE

cls
REM Mueve el editado a la nueva ruta
REM Move the edited to the new path
move "C:\DISCOS\RDP Simultaneos Win10\termsrv.dll" "C:\DISCOS\RDP Simultaneos Win10\EDITED"

REM Detiene el servico de Escritorio Remoto
REM Stop the Remote Desktop service
Net stop TermService 
cls
echo [ESP]
echo Si esta el servicio aun iniciado, fallara, por lo que no se podra continuar.
echo Si falla, hay que reiniciar el equipo.
echo .
echo [ENG]
echo If the service is still started, it will fail, so it will not be possible to continue.
echo If it fails, you have to restart the computer.
echo .
PAUSE
REM Elimina el archivo. SI ESTA EN USO, fallara.
REM Delete the file. IF IN USE, it will fail.
del /s /q "c:\Windows\System32\termsrv.dll"

REM Copia el editado
REM Copy the edited
COPY /Y "C:\DISCOS\RDP Simultaneos Win10\EDITED\termsrv.dll" "c:\Windows\System32"

REM Inicia el servico de Escritorio Remoto
REM Start the Remote Desktop service
Net start TermService

cls
echo EL EQUIPO SE REINICIARA...
echo.
echo THE EQUIPMENT WILL RESTART...
PAUSE
shutdown -r -t 0
EXIT

:exit
cls
EXIT
