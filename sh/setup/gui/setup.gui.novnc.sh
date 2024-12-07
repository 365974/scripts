#!/bin/bash

# Обновление и установка базовых пакетов
apt-get update -y
apt-get upgrade -y
apt-get install -y xorg xterm openbox feh tint2 wget mousepad pcmanfm xrdp fail2ban

# Установка необходимых пакетов для VNC и noVNC
apt-get install -y tigervnc-standalone-server tigervnc-common novnc websockify

# Скачивание и настройка фонового изображения
wget https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Clouds_over_the_Atlantic_Ocean.jpg/1280px-Clouds_over_the_Atlantic_Ocean.jpg -O /root/Ocean.jpg

# Настройка Openbox
mkdir -p /root/.config/openbox
touch /root/.config/openbox/autostart.sh
echo "setxkbmap -layout us,ru -variant -option grp:ctrl_shift_toggle,grp_led:scroll" >> /root/.config/openbox/autostart.sh
echo "tint2 &" >> /root/.config/openbox/autostart.sh
echo "feh --bg-scale /root/Ocean.jpg &" >> /root/.config/openbox/autostart.sh

# Настройка VNC-сервера
# Замените <password> на ваш пароль для VNC
echo "<password>" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Создание скрипта запуска VNC-сервера
cat <<EOL > /root/start-vnc.sh
#!/bin/bash
vncserver :1 -geometry 1280x1024 -depth 24
EOL
chmod +x /root/start-vnc.sh

# Запуск VNC-сервера
/root/start-vnc.sh

# Настройка noVNC
mkdir -p /root/novnc
cd /root/novnc
wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip
unzip master.zip
cd noVNC-master
ln -s vnc.html index.html

# Создание скрипта запуска noVNC
cat <<EOL > /root/start-novnc.sh
#!/bin/bash
websockify --web /root/novnc 6080 localhost:5901
EOL
chmod +x /root/start-novnc.sh

# Запуск noVNC
/root/start-novnc.sh


