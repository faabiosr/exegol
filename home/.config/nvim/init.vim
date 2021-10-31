" load vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'bronson/vim-trailing-whitespace'
Plug 'neovim/nvim-lspconfig'
call plug#end()

"========== settings ==========
set nocompatible
filetype plugin indent on

set ttyfast

set formatoptions+=r
set encoding=utf-8
set noshowmode
set wildmenu
set number
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set ruler
set cursorline
set laststatus=2
set incsearch
set hlsearch
set ignorecase
set smartcase
set shell=/bin/bash
set backspace=indent,eol,start
set autoread
set autowrite
set noerrorbells
set showcmd
set splitbelow
set splitright
set hidden
set fileformats=unix,dos,mac
set completeopt=menu,menuone
set updatetime=3000
set pumheight=10
set shortmess+=c

"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus

set signcolumn=yes

if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

set viminfo='1000
set conceallevel=2

" color
syntax enable
set t_Co=256
set background=dark
set termguicolors
colorscheme onehalfdark

" file types
augroup filetypedetect
  autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4
  autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType vim setlocal expandtab shiftwidth=2 softtabstop=2
  autocmd FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0
augroup END

"========== mappings ==========
let mapleader=","

" disable arrows
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>

" buffer navigation
map bt :bnext<CR>
map bT :bprevious<CR>

" Format json
map =j :%!jq<CR>

"========== plugins ==========
" lightline
let g:lightline = { 'colorscheme': 'onehalfdark' }

" fzf
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'down': '~20%' }
let g:fzf_preview_window = ''

nmap <C-p> :FzfFiles<cr>

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25

map <leader>n :Explore<CR>

" vim-go
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_addtags_transform = "snakecase"
let g:go_fmt_command = "goimports"
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

nmap <C-g> :GoDecls<cr>
imap <C-g> <esc>:<C-u>GoDecls<cr>

augroup go
  autocmd!

  autocmd FileType go nmap <silent> <Leader>v <Plug>(go-def-vertical)
  autocmd FileType go nmap <silent> <Leader>s <Plug>(go-def-split)
  autocmd FileType go nmap <silent> <Leader>x <Plug>(go-doc-vertical)
  autocmd FileType go nmap <silent> <leader>t <Plug>(go-test)
  autocmd FileType go nmap <silent> <Leader>c <Plug>(go-coverage-toggle)
augroup END

" lspconfig
lua << EOF
require('lspconfig').gopls.setup{}
EOF
