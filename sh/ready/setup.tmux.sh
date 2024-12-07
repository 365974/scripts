#!/bin/bash

# Обновление и установка необходимых пакетов
apt update
apt install -y tmux git curl

# Установка Tmux Plugin Manager (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Создание файла конфигурации tmux и добавление плагинов
cat <<EOF > ~/.tmux.conf
# Установка префиксной клавиши
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Переключение между окнами
bind -n C-left previous-window
bind -n C-right next-window

# Установка времени обновления статуса
set -g status-interval 1

# Настройка строки статуса
set -g status-bg black
set -g status-fg white
set -g status-left '#[bg=green,fg=black] #(whoami)@#H #[bg=yellow,fg=black] #S '
set -g status-right '#[bg=green,fg=black] %Y-%m-%d %H:%M:%S #[default]'

# Установка плагинов
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Настройки для tmux-resurrect и tmux-continuum
set -g @continuum-restore 'on'
set -g @resurrect-capture-pane-contents 'on'

# Инструкции TPM
run '~/.tmux/plugins/tpm/tpm'
EOF

# Запуск tmux и установка плагинов
tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server

# Добавление строки в .bashrc для автоматического запуска tmux при подключении по SSH
echo 'if [ -z "$TMUX" ]; then' >> ~/.bashrc
echo '  tmux attach-session -t main || tmux new-session -s main' >> ~/.bashrc
echo 'fi' >> ~/.bashrc

echo "Установка завершена. tmux и необходимые плагины установлены."
