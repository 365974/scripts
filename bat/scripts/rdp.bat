::rdp.bat
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

:: Добавление учетных данных для удаленного компьютера
cmdkey /generic:%remote_computer% /user:%username% /pass:%password%
@echo on

:: Запуск удаленного рабочего стола
mstsc /v:%remote_computer%

:: Удаление учетных данных для удаленного компьютера
echo forget password and server
@echo off
timeout /t 2
cmdkey /delete:%remote_computer%
reg delete "HKCU\Software\Microsoft\Terminal Server Client\Default" /f /va
attrib -s -h %userprofile%\documents\Default.rdp
del %userprofile%\documents\Default.rdp
del /f /s /q /a %AppData%\Microsoft\Windows\Recent\AutomaticDestinations