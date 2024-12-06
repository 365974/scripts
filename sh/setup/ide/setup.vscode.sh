#!/bin/bash

# Путь к .desktop файлу для VSCode
vscode_desktop_file="/usr/share/applications/vscoderoot.desktop"

# Путь к конфигурационному файлу Tint2 для пользователя root
tint2_config_file="/root/.config/tint2/tint2rc"

# Проверка наличия установленных пакетов
packages_installed=1
dpkg -s wget gpg tint2 >/dev/null 2>&1 || packages_installed=0

if [ $packages_installed -eq 0 ]; then
    # Установка необходимых пакетов
    apt-get update
    apt-get install wget gpg tint2 -y
fi

# Установка ключа для пакетов Microsoft VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Установка apt-transport-https и обновление списка пакетов
apt-get update
apt-get install apt-transport-https -y

# Установка Visual Studio Code
apt-get install code -y

# Проверка наличия .desktop файла для VSCode
if [ ! -f "$vscode_desktop_file" ]; then
    # Создание .desktop файла
    cat <<EOF > "$vscode_desktop_file"
[Desktop Entry]
Version=1.0
Name=VSCode
Comment=Visual Studio Code
Exec=code --no-sandbox --user-data-dir=/root/vscode-data
Icon=vscode
Terminal=false
Type=Application
Categories=Development;IDE;
EOF

    # Назначение прав доступа для файла (только для root)
    chown root:root "$vscode_desktop_file"
    chmod 644 "$vscode_desktop_file"
fi

# Проверка наличия конфигурационного файла Tint2 и его доступа для записи
if [ -f "$tint2_config_file" ] && [ -w "$tint2_config_file" ]; then
    # Проверка наличия блока Launcher в конфигурации Tint2
    if grep -q '# Launcher' "$tint2_config_file"; then
        # Добавление ссылки на .desktop файл в блок Launcher, если её нет
        if ! grep -q "launcher_item_app = $vscode_desktop_file" "$tint2_config_file"; then
            sed -i '/# Launcher/{:a;n;/launcher_item_app/!ba;i\launcher_item_app = '"$vscode_desktop_file"'' "$tint2_config_file"
        fi
    else
        # Создание нового блока Launcher с ссылкой на .desktop файл, если блока нет
        cat <<EOF >> "$tint2_config_file"

# Launcher
launcher_padding = 0 0 2
launcher_background_id = 0
launcher_icon_background_id = 0
launcher_icon_size = 22
launcher_icon_asb = 100 0 0
launcher_icon_theme_override = 0
startup_notifications = 1
launcher_tooltip = 1
launcher_item_app = "$vscode_desktop_file"
EOF
    fi
else
    echo "Ошибка: конфигурационный файл Tint2 не найден или нет доступа для записи." >&2
    exit 1
fi

echo "Скрипт успешно выполнен."
