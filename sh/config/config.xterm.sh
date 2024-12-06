#!/bin/bash

# Установка необходимых пакетов
apt-get update
apt-get install -y autocutsel openbox

# Создание или очистка файла ~/.Xresources
cat <<EOL > ~/.Xresources
xterm*scrollBar: true
xterm*boldMode: true
xterm*foreground: green
xterm*background: black
xterm*savelines: 10000
xterm*font: 10x20
EOL

# Обновление файла autostart.sh
AUTOSTART_FILE=~/.config/openbox/autostart.sh

# Создание директории, если она не существует
mkdir -p ~/.config/openbox

# Создание файла autostart.sh, если он не существует
if [ ! -f "$AUTOSTART_FILE" ]; then
    touch "$AUTOSTART_FILE"
fi

# Удаление старых строк, если они существуют
sed -i '/xrdb -merge/d' "$AUTOSTART_FILE"
sed -i '/autocutsel/d' "$AUTOSTART_FILE"

# Добавление новых строк в autostart.sh
echo "xrdb -merge ~/.Xresources &" >> "$AUTOSTART_FILE"
echo "autocutsel -fork &" >> "$AUTOSTART_FILE"
echo "autocutsel -selection PRIMARY &" >> "$AUTOSTART_FILE"
echo "autocutsel -selection CLIPBOARD &" >> "$AUTOSTART_FILE"

# Перезагрузка Openbox для применения изменений
openbox --reconfigure

echo "Настройка завершена. Перезапустите систему или Openbox, чтобы применить изменения."
