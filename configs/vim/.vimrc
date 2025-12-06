set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8
set mouse=a
set updatetime=250
set clipboard^=unnamed,unnamedplus
set noswapfile nobackup

set number relativenumber
set cursorline signcolumn=no
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab smartindent

set ignorecase smartcase
set hlsearch incsearch


augroup restore_cursor
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>nh :nohlsearch<CR>
nnoremap <Esc> :nohlsearch<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
