#!/bin/bash

# Чтение значения из внешнего файла

password_file="$PWD/dir/pass.txt"
password=$(<"$password_file")

#Создать настроичный файл подключения
echo "[client]\nuser=root\npassword=$password" > .my.cnf
chmod 600 .my.cnf

# Формируем SQL-запрос
query="ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('$password');"

# Выполняем запрос к MySQL
mariadb -u root -e "$query"
mariadb < dir/start.sql
exit;
