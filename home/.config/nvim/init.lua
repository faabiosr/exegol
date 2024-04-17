-- # Neovim configuration

-- Set <comma> as the leader key
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Format options
vim.opt.formatoptions:append 'r'

-- Insert mode completion
vim.opt.completeopt = 'menuone,noselect'

-- Make line numbers and ruler as default
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.ruler = true

-- Disable mouse mode
vim.opt.mouse = ''

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Number of items to show in the popup menu
vim.opt.pumheight = 10

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 200
vim.opt.undoreload = 2000

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumns on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time: interval for writing swap file to disk
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep about and below the cursor
vim.opt.scrolloff = 10

-- Characters to fill the statuslines
vim.opt.fillchars = { eob = " " }

-- Disable neovim intro
vim.opt.shortmess:append 'csI'

-- Indenting
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Disable arrows navigation
vim.keymap.set('n', '<Up>', '')
vim.keymap.set('n', '<Down>', '')
vim.keymap.set('n', '<Left>', '')
vim.keymap.set('n', '<Right>', '')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })

-- Buffer navigation
vim.keymap.set('n', '[b', '<Cmd>bprevious<CR>', { desc = 'Go to previous [B]uffer' })
vim.keymap.set('n', ']b', '<Cmd>bnext<CR>', { desc = 'Go to next [B]uffer' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('exegol-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)


-- lazy
require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  { -- Fuzzy finder
    'junegunn/fzf.vim',
    dependencies = {
      {
        'junegunn/fzf',
        build = './install --bin --no-update-rc',
      },
    },
    init = function()
      vim.g.fzf_command_prefix = 'Fzf'
      vim.g.fzf_layout = {
        down = '~20%'
      }

      vim.g.fzf_preview_window = ''
      vim.keymap.set('n', '<C-p>', '<cmd>FzfFiles<CR>')
    end,
  },

  { -- LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('exegol-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          map('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          map('<space>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

          -- Rename the variable under your cursor.
          map('<space>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
            }
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'gopls',
        'gofumpt',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'goimports', 'gofumpt' },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<tab>'] = cmp.mapping.select_next_item(),

          -- Select the [p]revious item
          ['<s-tab>'] = cmp.mapping.select_prev_item(),

          -- Accept ([y]es) the completion.
          ['<cr>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          ['<C-Space>'] = cmp.mapping.complete {},
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  { -- color scheme
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    init = function ()
      vim.cmd.colorscheme 'catppuccin-latte'
    end,
  },

  { -- Autoclose (brackets, parentesis and more)
    'echasnovski/mini.pairs',
    version = '*',
    config = function()
      require('mini.pairs').setup()
    end,
  },

  { -- Tabline (for buffers)
    'echasnovski/mini.tabline',
    version = '*',
    config = function()
      require('mini.tabline').setup({
        show_icons = false,
      })
    end,
  },

  -- Add/delete/replace surroundinds (brackets, quotes, etc.)
  'tpope/vim-surround',

  -- A Git wrapper so awesome, it should be illegal
  'tpope/vim-fugitive',

  { -- File explorer
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup({
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
    end,
    init = function()
      vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeToggle<CR>')
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFocus<CR>')
    end,
  },

  { -- Statusline
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('lualine').setup()
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'go',
        'html',
        'json',
        'lua',
        'luadoc',
        'make',
        'markdown',
        'vim',
        'vimdoc',
        'yaml',
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  { -- Golang tools
    'olexsmir/gopher.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gopher').setup({})
    end,
  },

})

-- vim: ts=2 sts=2 sw=2 et
