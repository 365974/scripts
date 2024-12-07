#!/bin/bash

# Обновление и установка необходимых пакетов
apt update
apt install -y neovim curl git

# Установка Vim-Plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Создание директории конфигурации Neovim
mkdir -p ~/.config/nvim

# Создание файла конфигурации Neovim и добавление плагинов
cat <<EOF > ~/.config/nvim/init.vim
" Инициализация Vim-Plug
call plug#begin('~/.local/share/nvim/plugged')

" Плагины для базовой настройки и удобства работы
Plug 'preservim/nerdtree'          " Файловый менеджер
Plug 'vim-airline/vim-airline'     " Строка состояния
Plug 'sheerun/vim-polyglot'        " Поддержка синтаксиса для множества языков
Plug 'tpope/vim-fugitive'          " Интеграция с Git
Plug 'dense-analysis/ale'          " Линтер и фиксер для кода
Plug 'tpope/vim-surround'          " Удобные операции с окружением текста
Plug 'majutsushi/tagbar'           " Навигация по структуре кода
Plug 'tpope/vim-dadbod'            " Работа с базами данных
Plug 'kristijanhusak/vim-dadbod-ui' " Графический интерфейс для vim-dadbod

" Плагины для работы с конкретными базами данных
Plug 'tpope/vim-mysql'             " Поддержка MySQL
Plug 'lifepillar/vim-sqlite'       " Поддержка SQLite
Plug 'lifepillar/vim-postgres'     " Поддержка PostgreSQL

" Завершение установки плагинов
call plug#end()

" Базовые настройки Neovim
syntax on
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set cursorline
set background=dark

" Настройки для NERDTree
map <C-n> :NERDTreeToggle<CR>

" Настройки для Tagbar
nmap <F8> :TagbarToggle<CR>
EOF

# Запуск Neovim и установка плагинов
nvim +PlugInstall +qall

echo "Установка завершена. Neovim и необходимые плагины установлены."
