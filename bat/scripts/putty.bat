:: putty.bat
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

:: clear start
.\software\putty\putty -cleanup
start .\software\putty\putty.exe -ssh %username%@%remote_computer% -pw "%password%"
