#!/bin/bash

source config.sh 

apt install -y nginx
apt install -y certbot python3-certbot-nginx
certbot certonly --nginx -d $domain_name -d www.$domain_name

tee /etc/nginx/sites-available/$domain_name.conf > /dev/null <<EOF
server {
    listen 443 ssl;
    server_name $domain_name;

    ssl_certificate /etc/letsencrypt/live/$domain_name/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain_name/privkey.pem;

    # Дополнительные настройки SSL
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';

    # Настройки логирования, корень сайта и другие параметры
    access_log /var/log/nginx/$domain_name.access.log;
    error_log /var/log/nginx/$domain_name.error.log;
}
EOF

ln -s /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/

certbot certonly --nginx -d $domain_name -d www.$domain_name
nginx -t
systemctl restart nginx
