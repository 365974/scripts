#!/bin/bash

# Переменные
IP_ADDRESS="8.8.8.8"
VNC_PASSWORD="password"
SSL_DIR="/etc/nginx/ssl"
NOVNC_DIR="/root/novnc"

# Обновление и установка базовых пакетов
apt-get update -y
apt-get upgrade -y
apt-get install -y xorg xterm openbox feh tint2 wget mousepad pcmanfm xrdp fail2ban tigervnc-standalone-server tigervnc-common novnc websockify nginx unzip

# Установка и настройка VNC
echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Создание скрипта запуска VNC
cat <<EOL > /root/start-vnc.sh
#!/bin/bash
vncserver :1 -geometry 1280x1024 -depth 24
EOL
chmod +x /root/start-vnc.sh

# Создание и запуск VNC-сервиса
cat <<EOL > /etc/systemd/system/vncserver@.service
[Unit]
Description=Start VNC server at startup
After=syslog.target network.target

[Service]
Type=forking
PIDFile=/root/.vnc/%H:%i.pid
ExecStart=/root/start-vnc.sh
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOL
systemctl daemon-reload
systemctl enable vncserver@1.service
systemctl start vncserver@1.service

# Создание и настройка самоподписанного сертификата
mkdir -p $SSL_DIR
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $SSL_DIR/selfsigned.key -out $SSL_DIR/selfsigned.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=$IP_ADDRESS"

# Настройка Nginx
cat <<EOL > /etc/nginx/sites-available/novnc
server {
    listen 80;
    server_name $IP_ADDRESS;

    # Перенаправление на HTTPS
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name $IP_ADDRESS;

    ssl_certificate $SSL_DIR/selfsigned.crt;
    ssl_certificate_key $SSL_DIR/selfsigned.key;

    # Настройка безопасности SSL
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://localhost:6080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

# Активация конфигурации Nginx
ln -s /etc/nginx/sites-available/novnc /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx

# Настройка noVNC
mkdir -p $NOVNC_DIR
cd $NOVNC_DIR
wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip
unzip master.zip
cd noVNC-master
ln -s vnc.html index.html

# Создание скрипта запуска noVNC
cat <<EOL > /root/start-novnc.sh
#!/bin/bash
websockify --web $NOVNC_DIR/noVNC-master 6080 localhost:5901
EOL
chmod +x /root/start-novnc.sh

# Создание и настройка сервиса noVNC
cat <<EOL > /etc/systemd/system/novnc.service
[Unit]
Description=noVNC web server
After=network.target

[Service]
Type=simple
ExecStart=/root/start-novnc.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL
systemctl daemon-reload
systemctl enable novnc.service
systemctl start novnc.service
