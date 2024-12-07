#!/bin/bash

# Обновляем пакеты и устанавливаем необходимые зависимости
apt-get update
apt-get install -y neovim git curl php-cli php-pear php-codesniffer phpmd universal-ctags

# Устанавливаем vim-plug - менеджер плагинов для Neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Создаем конфигурационный файл для Neovim
mkdir -p ~/.config/nvim
cat << EOF > ~/.config/nvim/init.vim
" Используем vim-plug для управления плагинами
call plug#begin('~/.local/share/nvim/plugged')

" Плагины для PHP разработки
Plug 'StanAngeloff/php.vim'

" Линтеры
Plug 'dense-analysis/ale'

" Строка состояния
Plug 'itchyny/lightline.vim'

" Вкладки и буферы
Plug 'akinsho/bufferline.nvim'
Plug 'mhinz/vim-startify'

" Git интеграция
Plug 'tpope/vim-fugitive'

" Навигация по коду
Plug 'majutsushi/tagbar'

" Завершаем установку плагинов
call plug#end()

" Настройки для плагинов
" ALE - Асинхронный линтер
let g:ale_php_phpcs_executable = 'phpcs'
let g:ale_php_phpmd_executable = 'phpmd'
let g:ale_linters = {
\   'php': ['phpcs', 'phpmd'],
\}
let g:ale_fixers = {
\   'php': ['php_cs_fixer'],
\}
let g:ale_fix_on_save = 1

" Tagbar - для навигации по коду
nmap <F8> :TagbarToggle<CR>

" Lightline - строка состояния
set laststatus=2
set noshowmode
let g:lightline = {
\   'colorscheme': 'wombat',
\   'active': {
\     'left': [ ['mode', 'paste'], ['readonly', 'filename', 'modified'] ]
\   },
\   'component_function': {
\     'filename': 'LightlineFilename'
\   },
\ }

" Bufferline - управление буферами
let g:bufferline = {
\ 'animation': v:false,
\ 'auto_hide': v:false,
\ 'tabpages': v:true,
\ 'closable': v:true,
\ 'clickable': v:true,
\ }

" Общие настройки
set number
set relativenumber
syntax on
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
EOF

# Устанавливаем плагины Neovim
nvim +PlugInstall +qall

echo "Установка завершена. Neovim и необходимые плагины установлены."
