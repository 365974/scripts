:: putty.bat
color 0A

:: Указываем параметры подключения
echo setup password and server
timeout /t 1
@echo off

:: Очищаем переменные
set "remote_computer="
set "username="
set "password="

:: Устанавливаем переменные из файла config.txt
for /f "tokens=1,* delims==" %%a in (scripts\config.txt) do (
    set "%%a=%%b"
)

:: Запуск Plink через PowerShell и отправка Enter
powershell -Command "Start-Process '.\software\putty\plink.exe' -ArgumentList ('-pw %password% -ssh %username%@%remote_computer% -D 8080 -N'); Start-Sleep -Seconds 5; $wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('plink'); $wshell.SendKeys('{ENTER}')"
timeout /t 5 /nobreak
curl --socks5 localhost:8080 http://ifconfig.me
pause