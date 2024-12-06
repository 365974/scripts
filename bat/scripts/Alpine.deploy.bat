:: Alpine.deploy.bat

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

::Запуск системы
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "debian"
timeout /t 40 /nobreak

:: Введите команду root
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "root"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Введите команду apk update
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "apk update"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Введите команду apk add openssh
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "apk add openssh"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 5 /nobreak

:: Введите команду rc-service sshd start
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "rc-service sshd start"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 5 /nobreak

:: Введите команду ip link set eth0 up
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "ip link set eth0 up"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Введите команду udhcpc -i eth0
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "udhcpc -i eth0"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Введите команду passwd root
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "passwd root"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Введите новый пароль password_put_here
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "password_put_here"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Подтвердите пароль password_put_here
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "password_put_here"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Введите команду echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "echo "PermitRootLogin yes" >> /etc/ssh/sshd_config"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Введите команду echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Введите команду rc-service sshd reload
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "rc-service sshd reload"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Подключение репозитория
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "sed -i '$ a https://dl-cdn.alpinelinux.org/alpine/v3.21/main' /etc/apk/repositories"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 5 /nobreak

:: Обновление репозиториев
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "apk update"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 2 /nobreak

:: Подготовка системы
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "apk add e2fsprogs bash unzip"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 5 /nobreak

:: Создание папки
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "mkdir -p /root/dir"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 5 /nobreak

:: Форматирование диска
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "mkfs.ext4 /dev/sda"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 5 /nobreak
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 15 95
timeout /t 5 /nobreak
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 5 /nobreak

:: Монтирование диска
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "mount -t ext4 /dev/sda /root/dir"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 5 /nobreak

:: загрузка и подготовка данных
.\software\7z\7za a -tzip dir.zip dir
.\software\putty\pscp -pw "%password%" dir.zip %username%@%remote_computer%:/root/dir.zip
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "unzip -o dir.zip"
.\software\putty\plink.exe -ssh -l %username% -pw %password% %remote_computer% "rm dir.zip"
del dir.zip

:: cd dir
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "cd dir"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 5 /nobreak

:: bash setup.image.alpine.sh
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputstring "bash setup.image.alpine.sh"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" keyboardputscancode 1C 9C
timeout /t 120 /nobreak

:: Получить образ
.\software\putty\pscp -pw "%password%" %username%@%remote_computer%:/root/dir/preseed-debian-12.8.0-amd64-netinst.iso .\readyimage\preseed-debian-12.8.0-amd64-netinst.iso
pause
:: Остановка машины
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" poweroff

:: Замена диска
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach "debian" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ".\readyimage\preseed-debian-12.8.0-amd64-netinst.iso"

@REM :: фоновый запуск
@REM "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "debian" --type headless

@REM :: остановка и сохранение
@REM "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "debian" savestate
@REM timeout /t 5 /nobreak

pause
