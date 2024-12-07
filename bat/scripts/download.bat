:: download.bat
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

::download data
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "apt install -y zip"
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "zip -r dir.zip dir"
.\software\putty\pscp -pw "%password%" %username%@%remote_computer%:/root/dir.zip .\dir.zip
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "rm dir.zip"

::unpack and del archive
.\software\7z\7za x dir.zip dir
del dir.zip