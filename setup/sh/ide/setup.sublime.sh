#!/bin/bash
# Добавление ключа GPG
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor -o /usr/share/keyrings/sublimehq-archive-keyring.gpg

# Добавление репозитория Sublime Text
echo "deb [signed-by=/usr/share/keyrings/sublimehq-archive-keyring.gpg] https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list > /dev/null

# Обновление списка пакетов и установка Sublime Text
apt update
apt install sublime-text
