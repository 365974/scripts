:: upload.bat
color 0A

::старт машины
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "debian" --type headless

:: Указываем параметры подключения
echo setup password and server
timeout /t 2
@echo off

:: Очищаем переменные
set "remote_computer="
set "username="
set "password="

:: Устанавливаем переменные из файла config.txt
for /f "tokens=1,* delims==" %%a in (scripts\config.txt) do (
    set "%%a=%%b"
)

:: pack and upload data
.\software\7z\7za a -tzip dir.zip dir
.\software\putty\pscp -pw "%password%" dir.zip %username%@%remote_computer%:/root/dir.zip
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "apt update && apt upgrade -y"
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "apt install -y unzip"
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "unzip -o dir.zip"
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "rm dir.zip"
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "apt update && apt upgrade -y"
del dir.zip
pause
