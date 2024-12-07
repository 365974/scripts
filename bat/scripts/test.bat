:: test.bat

:: настройка цвета
color 0A
chcp 65001

:: Очищаем переменные
set "remote_computer="
set "username="
set "password="

:: Устанавливаем переменные из файла config.txt
for /f "tokens=1,* delims==" %%a in (scripts\config.txt) do (
    set "%%a=%%b"
)


:: Введите команду root
.\software\putty\puttygen.exe -t rsa -b 4096 
pause
