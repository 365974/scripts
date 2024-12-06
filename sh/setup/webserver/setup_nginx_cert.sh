#!/bin/bash

# Переменные
DOMAIN="xetabull.ddns.net"

apt-get update && apt-get upgrade
apt-get install certbot -y
systemctl stop nginx
certbot certonly --standalone -d $DOMAIN
systemctl start nginx