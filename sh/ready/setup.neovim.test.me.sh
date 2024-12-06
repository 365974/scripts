#!/bin/bash

# Обновление и установка необходимых пакетов
apt update
apt install -y neovim curl git ripgrep fd-find

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

" Плагин для отображения горячих клавиш
Plug 'folke/which-key.nvim'

" Плагин для поиска и навигации
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Плагин для улучшенной подсветки синтаксиса
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

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

" Настройки which-key.nvim
lua << EOF
require("which-key").setup {
    plugins = {
        marks = true,           -- Показывать метки
        registers = true,       -- Показывать регистры
        spelling = {
            enabled = true,     -- Включить проверку орфографии
            suggestions = 20,   -- Количество предложений
        },
        presets = {
            operators = false,  -- Добавить записи для операторов
            motions = false,    -- Добавить записи для движений
            text_objects = false, -- Добавить записи для текстовых объектов
            windows = true,     -- Добавить записи для окон
            nav = true,         -- Добавить записи для навигации
            z = true,           -- Добавить записи для префикса z
            g = true,           -- Добавить записи для префикса g
        },
    },
    operators = { gc = "Комментарии" },
    key_labels = {
        ["<leader>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- символы для "хлебных крошек"
        separator = "➜", -- символы для разделителей
        group = "+",      -- символы для групп
    },
    window = {
        border = "none",          -- граница окна
        position = "bottom",      -- позиция окна
        margin = { 1, 0, 1, 0 },  -- отступы окна
        padding = { 1, 1, 1, 1 }, -- внутренние отступы окна
    },
    layout = {
        height = { min = 4, max = 25 }, -- высота
        width = { min = 20, max = 50 }, -- ширина
        spacing = 3,                    -- расстояние
        align = "left",                 -- выравнивание
    },
    ignore_missing = false, -- игнорировать отсутствующие ключи
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- скрытые ключи
    show_help = true, -- показывать помощь
}
EOF

" Настройки telescope.nvim
lua << EOF
require('telescope').setup {
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = false,
            },
        },
        file_sorter = require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
        path_display = {"absolute"},
        winblend = 0,
        border = {},
        borderchars = {
            '─', '│', '─', '│', '┌', '┐', '┘', '└'
        },
        color_devicons = true,
        use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    }
}
EOF

" Настройки nvim-treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
    },
}
EOF
EOF

# Запуск Neovim и установка плагинов
nvim +PlugInstall +qall

echo "Установка завершена. Neovim и необходимые плагины установлены."
