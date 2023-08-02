" load vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'bronson/vim-trailing-whitespace'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'fatih/vim-go'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
call plug#end()

"========== settings ==========
set nocompatible
filetype plugin indent on

set ttyfast

set formatoptions+=r
set encoding=utf-8
set wildmenu
set autoindent
set incsearch
set hlsearch
set backspace=indent,eol,start
set autoread
set autowrite
set noerrorbells
set showcmd
set hidden
set fileformats=unix,dos,mac
set completeopt=menuone,noselect
set pumheight=10
set shortmess+=c

set viminfo='1000
set conceallevel=2

" file types
augroup filetypedetect
  autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4
  autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType vim setlocal expandtab shiftwidth=2 softtabstop=2
  autocmd FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0
augroup END

"========== mappings ==========
" buffer navigation
map bt :bnext<CR>
map bT :bprevious<CR>

" Format json
map =j :%!jq<CR>

"========== plugins ==========
" fzf
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'down': '~20%' }
let g:fzf_preview_window = ''

nmap <C-p> :FzfFiles<cr>

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
let g:go_gopls_enabled = 0
let g:go_echo_go_info = 0
let g:go_def_mapping_enabled = 0
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0

" delimitmate
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_smart_quotes = 1
let g:delimitMate_expand_inside_quotes = 0
let g:delimitMate_smart_matchpairs = '^\%(\w\|\$\)'

" vim-json
let g:vim_json_syntax_conceal = 0

" lua plugins configurations
lua << EOF
local opt = vim.opt
local fn = vim.fn
local g = vim.g
local keymap = vim.keymap
local cmd = vim.cmd


---- core

-- options
opt.laststatus = 3
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.cursorline = true

-- indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = ""

-- numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = true

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true
opt.undodir = fn.expand('~/.config/nvim/undo')
opt.undolevels = 1000
opt.undoreload = 10000

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- mappings
g.mapleader = ","

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  g["loaded_" .. provider .. "_provider"] = 0
end

-- colors
cmd.colorscheme "catppuccin-latte"

-- disable arrows
keymap.set('n', '<Up>', '')
keymap.set('n', '<Down>', '')
keymap.set('n', '<Left>', '')
keymap.set('n', '<Right>', '')


---- Plugins

-- lualine
require('lualine').setup({
  options = {
    theme = "catppuccin-latte",
  },
})

-- netrw - disable
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- nvim-tree
require("nvim-tree").setup({
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
  },
  view = {
    adaptive_size = false,
    preserve_window_proportions = true,
  },
  git = {
    enable = false,
    ignore = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  renderer = {
    root_folder_label = false,
    icons = {
      show = {
        git = false,
      },

      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
})

keymap.set('n', '<leader>n', '<cmd> NvimTreeToggle <CR>')
keymap.set('n', '<leader>e', '<cmd> NvimTreeFocus <CR>')

-- bufferline
require("bufferline").setup{
  options = {
    numbers = "none",
    diagnostics = false,
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "thin",
  }
}

-- lspconfig
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end

nvim_lsp.gopls.setup{
  cmd = {'gopls'},
  capabilities = capabilities,
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
  on_attach = on_attach,
}

nvim_lsp.pylsp.setup{
  cmd = {'pylsp'},
  filetypes = {'python'},
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        flake8 = {
          enabled = true,
          maxLineLength = 120,
        },
      },
    },
  },
  on_attach = on_attach,
}

nvim_lsp.solargraph.setup{
  cmd = {'solargraph', 'stdio'},
  filetypes = {'ruby'},
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    solargraph = {
      solargraph = {
        diagnostics = false,
      },
    },
  },
  on_attach = on_attach,
}

local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<cr>"] = cmp.mapping.confirm({select = true}),
    ["<s-tab>"] = cmp.mapping.select_prev_item(),
    ["<tab>"] = cmp.mapping.select_next_item(),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
  },
}

-- null-ls
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.goimports,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})
EOF
