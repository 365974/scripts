#!/bin/bash

# Чтение значения из внешнего файла
source pass.txt

apt update -y
apt install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb
echo -e "y\n$password\n$password\ny\ny\ny\ny" | mysql_secure_installation