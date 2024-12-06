#!/bin/bash

# Функция для проверки наличия и установки пакетов
install_packages() {
    echo "Установка пакетов: $@"
    apt-get update
    apt-get install -y "$@"
}

# Функция для установки нужных локалей
setup_locale() {
    echo "Установка и настройка локали ru_RU.UTF-8"

    # Устанавливаем локаль
    sed -i '/ru_RU.UTF-8/s/^#//g' /etc/locale.gen
    locale-gen
    update-locale LANG=ru_RU.UTF-8

    # Устанавливаем кодовую страницу в терминале
    sed -i 's/^CODESET=.*/CODESET="Uni2"/' /etc/default/console-setup
    setupcon
}

# Функция для настройки размера шрифта в терминале
setup_fontsize() {
    echo "Настройка размера шрифта в терминале"

    # Измените значение FONTSIZE на нужный вам размер, например, 16x32
    sed -i 's/^FONTSIZE=.*/FONTSIZE="8x16"/' /etc/default/console-setup
    setupcon
}

# Основная часть скрипта
echo "Начало настройки системы..."

# Установка необходимых пакетов
install_packages fonts-dejavu-core

# Установка и настройка локали и кодовой страницы
setup_locale

# Настройка размера шрифта в терминале
setup_fontsize

echo "Настройка завершена."
