#!/bin/bash

# Переменные для логина и пароля Яндекс.Диска
YANDEX_USERNAME="your_username"  # Укажите ваш логин
YANDEX_PASSWORD="your_password"  # Укажите ваш пароль

# Установка davfs2
echo "Устанавливаем davfs2..."
apt update
apt install -y davfs2

# Создание точки монтирования
MOUNT_POINT="/mnt/yandex.disk"
echo "Создаем директорию $MOUNT_POINT..."
mkdir -p $MOUNT_POINT

# Настройка файла secrets
SECRETS_FILE="/etc/davfs2/secrets"
echo "Настраиваем файл $SECRETS_FILE..."
echo "https://webdav.yandex.ru $YANDEX_USERNAME $YANDEX_PASSWORD" >> $SECRETS_FILE
chmod 600 $SECRETS_FILE

# Настройка fstab
FSTAB_ENTRY="https://webdav.yandex.ru   $MOUNT_POINT   davfs   rw,users,_netdev    0   0"
echo "Добавляем запись в /etc/fstab..."
echo "$FSTAB_ENTRY" >> /etc/fstab

# Монтирование директории
echo "Монтируем Яндекс.Диск..."
mount -t davfs https://webdav.yandex.ru $MOUNT_POINT

# Проверка доступности
echo "Проверяем содержимое $MOUNT_POINT..."
ls -l $MOUNT_POINT

echo "Проверяем объем $MOUNT_POINT..."
df -h $MOUNT_POINT

echo "Настройка завершена. Перезагрузите систему для применения изменений."
