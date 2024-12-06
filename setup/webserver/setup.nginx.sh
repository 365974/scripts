#!/bin/bash

# Подключаем переменные из файла конфигурации
source config.sh

apt update

# Создание пользователя
echo -e "$password\n$password\n$username\n\n\n\ny\n" | adduser $username
usermod -aG sudo $username
usermod -aG $username www-data
mkdir -p /home/$username/$domain_name/www
mkdir -p /home/$username/www/$domain_name
mkdir -p /home/$username/tmp
chmod 755 -R /home/$username/
chown -R $username:$username /home/$username/www/
chown -R $username:$username /home/$username/tmp/

#Установка nginx
apt install -y nginx php-fpm php-mysql
systemctl enable nginx
service nginx start
echo "<?php phpinfo(); ?>" > /home/$username/www/$domain_name/index.php

php_version=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

tee /etc/php/$php_version/fpm/pool.d/$domain_name.conf > /dev/null <<EOF

[$domain_name]
listen = /var/run/php/$domain_name.sock
listen.mode = 0666
user = $username
group = $username
chdir = /home/$username/www/$domain_name

php_admin_value[upload_tmp_dir] = /home/$username/tmp
php_admin_value[soap.wsdl_cache_dir] = /home/$username/tmp
php_admin_value[date.timezone] = Europe/Moscow
php_admin_value[upload_max_filesize] = 100M
php_admin_value[post_max_size] = 100M
php_admin_value[open_basedir] = /home/$username/www/$domain_name/
php_admin_value[session.save_path] = /home/$username/tmp
php_admin_value[disable_functions] = exec,passthru,shell_exec,system,proc_open,popen,curl_multi_exec,parse_ini_file,show_source
php_admin_value[cgi.fix_pathinfo] = 0
php_admin_value[apc.cache_by_default] = 0

pm = dynamic
pm.max_children = 7
pm.start_servers = 3
pm.min_spare_servers = 2
pm.max_spare_servers = 4

EOF

tee /etc/nginx/sites-available/$domain_name.conf > /dev/null <<EOF

server {
        listen 80;
        server_name $domain_name www.$domain_name;
        charset utf-8;
        root /home/$username/www/$domain_name;
        index index.php index.html index.htm;

        # Static content
        location ~* ^.+.(jpg|jpeg|gif|png|css|zip|tgz|gz|rar|bz2|doc|xls|exe|pdf|ppt|txt|tar|mid|midi|wav|mp3|bmp|flv|rtf|js|swf|iso)$ {
            root /home/$username/www/$domain_name;
                }

        location ~ \.php$
        {
            include fastcgi.conf;
            fastcgi_intercept_errors on;
            try_files \$uri =404;
            fastcgi_pass unix://var/run/php/$domain_name.sock;
        }

        location / {
        try_files \$uri \$uri/ /index.php?q=\$uri\$args;
        }
        }
EOF

ln -s /etc/nginx/sites-available/$domain_name.conf /etc/nginx/sites-enabled/

service php$php_version-fpm restart
service nginx restart

apt install -y certbot python3-certbot-nginx

echo -e "y\n" | certbot certonly --agree-tos -m $email --webroot --force-interactive -w /home/$username/www/$domain_name/ -d $domain_name

tee /etc/nginx/sites-available/$domain_name.conf > /dev/null <<EOF

server {
        listen 80;
        server_name $domain_name www.$domain_name;
        root /home/$username/www/$domain_name;
        return 301 https://$domain_name\$request_uri;
        }
server
        {
        listen 443 ssl;
        server_name $domain_name www.$domain_name;
        # SSL support
        ssl_certificate /etc/letsencrypt/live/$domain_name/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$domain_name/privkey.pem;
        charset utf-8;
        root /home/$username/www/$domain_name;
        index index.php index.html index.htm;

        # Static content
        location ~* ^.+.(jpg|jpeg|gif|png|css|zip|tgz|gz|rar|bz2|doc|xls|exe|pdf|ppt|txt|tar|mid|midi|wav|mp3|bmp|flv|rtf|js|swf|iso)$ {
                        root /home/$username/www/$domain_name;
                        }

        location ~ \.php$
        {
                include fastcgi.conf;
                fastcgi_intercept_errors on;
                try_files \$uri =404;
                fastcgi_pass unix://var/run/php/$domain_name.sock;
        }

        location / {
                try_files \$uri \$uri/ /index.php?q=\$uri\$args;
        }
        }

EOF
service nginx restart