:: Настройка цвета
color 0A
chcp 65001

:: Удаление старой папки
rd /s /q "%~dp0..\repo_temp" >nul 2>&1

:: Создание новой папки
mkdir "%~dp0..\repo_temp"

:: Проверка подключения к GitHub
"%~dp0..\software/PortableGit/usr/bin/ssh.exe" -i "%~dp0..\ssh_keys/id_rsa" -T git@github.com

:: Клонирование репозитория
"%~dp0..\software/PortableGit/bin/git.exe" -c core.sshCommand="\"%~dp0..\software/PortableGit/usr/bin/ssh.exe\" -i \"%~dp0..\ssh_keys/id_rsa\"" clone git@github.com:365974/scripts.git "%~dp0..\repo_temp"

:: Завершение
echo Данные успешно загружены в папку "%~dp0..\repo_temp"
pause
exit
