#!/bin/bash

# Переменные
SCRIPT_PATH="/usr/local/bin/bt_reconnect.sh"
SERVICE_PATH="/etc/systemd/system/bt_reconnect.service"
TIMER_PATH="/etc/systemd/system/bt_reconnect.timer"
LOGFILE="/var/log/bt_reconnect.log"

# MAC-адреса ваших устройств (замените на реальные значения)
KEYBOARD_MAC="DD:77:54:60:CB:A5"
MOUSE_MAC="YY:YY:YY:YY:YY:YY"
HEADSET_MAC="ZZ:ZZ:ZZ:ZZ:ZZ:ZZ"

# Опции командной строки
USE_KEYBOARD=false
USE_MOUSE=false
USE_HEADSET=false

for arg in "$@"
do
    case $arg in
        --keyboard)
        USE_KEYBOARD=true
        shift
        ;;
        --mouse)
        USE_MOUSE=true
        shift
        ;;
        --headset)
        USE_HEADSET=true
        shift
        ;;
        *)
        ;;
    esac
done

if ! $USE_KEYBOARD && ! $USE_MOUSE && ! $USE_HEADSET; then
    echo "Usage: $0 [--keyboard] [--mouse] [--headset]"
    exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $1" | tee -a "$LOGFILE" >&2
}

check_command_status() {
    if [ $? -ne 0 ]; then
        log_error "$1"
        exit 1
    fi
}

# Создание или обновление скрипта bt_reconnect.sh
log "Creating or updating $SCRIPT_PATH..."
cat > $SCRIPT_PATH <<EOF
#!/bin/bash

LOGFILE="$LOGFILE"
exec &>> "\$LOGFILE"

# MAC-адреса ваших устройств
KEYBOARD_MAC="$KEYBOARD_MAC"
MOUSE_MAC="$MOUSE_MAC"
HEADSET_MAC="$HEADSET_MAC"

log() {
    echo "\$(date '+%Y-%m-%d %H:%M:%S') - \$1"
}

handle_error() {
    local DEVICE_NAME=\$1
    local ERROR_MESSAGE=\$2
    log "Error with \$DEVICE_NAME: \$ERROR_MESSAGE"
}

connect_device() {
    local MAC_ADDRESS=\$1
    local DEVICE_NAME=\$2

    CONNECTED=\$(bluetoothctl info \$MAC_ADDRESS | grep 'Connected: yes')

    if [ -z "\$CONNECTED" ]; then
        log "Attempting to connect to \$DEVICE_NAME (\$MAC_ADDRESS)..."
        bluetoothctl <<EOF2
power on
agent on
default-agent
connect \$MAC_ADDRESS
EOF2
        if [ \$? -eq 0 ]; then
            log "Successfully connected to \$DEVICE_NAME (\$MAC_ADDRESS)."
        else
            handle_error "\$DEVICE_NAME" "Failed to connect"
        fi
    else
        log "\$DEVICE_NAME (\$MAC_ADDRESS) is already connected."
    fi
}

# Проверка и подключение каждого устройства
EOF

# Добавление подключений для выбранных устройств
if $USE_KEYBOARD; then
    echo 'connect_device $KEYBOARD_MAC "Keyboard"' >> $SCRIPT_PATH
fi

if $USE_MOUSE; then
    echo 'connect_device $MOUSE_MAC "Mouse"' >> $SCRIPT_PATH
fi

if $USE_HEADSET; then
    echo 'connect_device $HEADSET_MAC "Headset"' >> $SCRIPT_PATH
fi

chmod +x $SCRIPT_PATH
check_command_status "Failed to set execute permissions for $SCRIPT_PATH"

# Создание файла журнала и установка прав, если они не существуют
if [ ! -f $LOGFILE ]; then
    log "Creating log file $LOGFILE..."
    touch $LOGFILE
    check_command_status "Failed to create log file $LOGFILE"
    chmod 664 $LOGFILE
    check_command_status "Failed to set permissions for log file $LOGFILE"
    chown root:adm $LOGFILE
    check_command_status "Failed to change owner for log file $LOGFILE"
else
    log "Log file $LOGFILE already exists."
fi

# Создание или обновление службы bt_reconnect.service
log "Creating or updating $SERVICE_PATH..."
cat > $SERVICE_PATH <<EOF
[Unit]
Description=Bluetooth Reconnect Service
After=bluetooth.service

[Service]
ExecStart=$SCRIPT_PATH
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=bt_reconnect

[Install]
WantedBy=multi-user.target
EOF
check_command_status "Failed to create or update $SERVICE_PATH"

# Создание или обновление таймера bt_reconnect.timer
log "Creating or updating $TIMER_PATH..."
cat > $TIMER_PATH <<EOF
[Unit]
Description=Run Bluetooth Reconnect Script every minute

[Timer]
# Запустить через минуту после загрузки системы
OnBootSec=1min
# Повторять каждые 60 секунд
OnUnitActiveSec=1min

[Install]
WantedBy=timers.target
EOF
check_command_status "Failed to create or update $TIMER_PATH"

# Перезагрузка конфигурации systemd
log "Reloading systemd configuration..."
systemctl daemon-reload
check_command_status "Failed to reload systemd configuration"

# Активация и запуск таймера
log "Enabling and starting bt_reconnect.timer..."
systemctl enable bt_reconnect.timer
check_command_status "Failed to enable bt_reconnect.timer"
systemctl start bt_reconnect.timer
check_command_status "Failed to start bt_reconnect.timer"

# Активация службы
log "Enabling bt_reconnect.service..."
systemctl enable bt_reconnect.service
check_command_status "Failed to enable bt_reconnect.service"

log "Setup completed."
