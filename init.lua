
--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- ------------------------------- PLUGINS BEGIN -------------------------------
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      'hrsh7th/cmp-path',
    },
  },

  -- {
  --   'hrsh7th/cmp-path', opts = {},
  --   config = function()
  --     require('cmp').setup({
  --       sources = {
  --         { name = 'path'}
  --       }
  --     })
  --   end
  -- },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',
    opts = {
      window = {
        border = "double",
      },
    }
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        -- add = { text = '+' },
        -- change = { text = '~' },
        -- delete = { text = '_' },
        -- topdelete = { text = '‾' },
        -- changedelete = { text = '~' },
        add = { text = '│'},
        change = { text = '│'},
        delete = { text = '_'},
        topdelete = { text = '‾'},
        changedelete = { text = '~'},
        untracked    = { text = '┆' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        vim.keymap.set('n', '<leader>gb', require('gitsigns').toggle_current_line_blame, { silent = true, desc = 'Toggle blame' })
        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({'n', 'v'}, ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
        vim.keymap.set({'n', 'v'}, '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1002,
    config = function()
     vim.cmd.colorscheme 'onedark'
    end,
   },
  {
    'lunarvim/lunar.nvim',
    priority = 1003,
    config = function()
      vim.cmd.colorscheme 'lunar'
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    priority = 1001,
    config  = function()
      vim.cmd.colorscheme 'vscode'
    end,
  },

-- ------------------- NAVIC ---------------------------------------------------
-- Winbar code breadcrumbs
  {
    'SmiteshP/nvim-navic',
    opts = {},
    config = function()
      local navic = require('nvim-navic').setup({
        icons_enabled = true,
        icons = {
          File          = "󰈙 ",
          Folder        = "󰉋 ",
          Module        = " ",
          Namespace     = "▤ ",
          Package       = " ",
          Class         = "󰌗 ",
          Method        = "󰆧 ",
          Property      = " ",
          Field         = " ",
          Constructor   = " ",
          Enum          = "󰕘 ",
          Interface     = "󰕘 ",
          Function      = "󰊕 ",
          Variable      = "󰆧 ",
          Constant      = "󰏿 ",
          String        = "󰀬 ",
          Number        = "󰎠 ",
          Boolean       = "◩ ",
          Array         = "󰅪 ",
          Object        = "󰅩 ",
          Key           = "󰌋 ",
          Null          = "󰟢 ",
          EnumMember    = " ",
          Struct        = "󰌗 ",
          Event         = " ",
          Operator      = "󰆕 ",
          TypeParameter = "󰊄 ",
        },
        lsp = {
          auto_attach = true,
          preference = nil,
        },
        highlight = false,
        separator = " → ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true,
        lazy_update_context = false,
        click = false,
      })
    end
  },

-- -------------- Lualine ------------------------------------------------------
-- Bottom status line and top winbar line
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim', opts = {},
  },

-- ------------------------ Indent Blankline -----------------------------------
-- Highlight indents including blank lines 
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      -- char = '▏',
      -- char = '│',
      show_trailing_blankline_indent = false,
      space_char_blankline = " ",
      show_current_context = true,
      show_current_context_start = true,
    },
    config = function()
      require('indent_blankline').setup({
        show_trailing_blankline_indent = false,
        -- char = '┊',
        char = '▏',
        context_char = "▏",
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true
      })
    end
  },

-- ------------------------- Comment -------------------------------------------
-- Comment by line or block
  { 'numToStr/Comment.nvim', opts = {} },

-- ------------------------- Harpoon -------------------------------------------
--
  {
    'ThePrimeagen/harpoon', opts = {},
  },

-- ------------------------- Telescope -----------------------------------------
-- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    -- config = function()
    --   require('telescope').setup({
    --     local project_actions = require('telescope._extensions.project.actions')
    --     extensions = {
    --       project = {
    --         base_dirs = {
    --           {'~/code', max_depth = 4}
    --         },
    --       },
    --       order_by = 'asc',
    --       search_by = "title",
    --       sync_with_nvim_tree = true,
    --       on_project_selected = function(prompt_bufnr)
    --         project_actions.change_working_directory(prompt_bufnr, false)
    --       end
    --     }
    --   })
    -- end
  },

-- -------------------------- Treesitter ---------------------------------------
-- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

-- -------------------------- Alpha --------------------------------------------
-- Splash screen/startup window
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require'alpha'.setup(require'alpha.themes.home'.config)
    end
  },

-- ---------------------- Telescope Project ------------------------------------
-- 
  {
    'nvim-telescope/telescope-project.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  {
    'ahmedkhalf/project.nvim',
    config = function()
      require("project_nvim").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true
        },
        active = true,
        manual_mode = false,
        detection_methods = {'pattern'},
        patterns = {'.git', '.Makefile'},
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "global",
        datapath = vim.fn.stdpath("data"),
      })
    end
  },

-- ------------------------- Nvim Tree -----------------------------------------
-- File browser on the side 

  { 'nvim-tree/nvim-tree.lua', opts = {},
    config = function()
      require("nvim-tree").setup({
        git = { ignore = false},
        update_focused_file = { enable = true, update_root = true},
        renderer = {root_folder_label = ':t'},
        -- update_focused_file.update_root = true,
      })
    end
  },

-- --------------------- Telescope: File Browser -------------------------------
-- Fast floating file browser
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim'}
  },

-- -------------------- Nvim Autopairs -----------------------------------------
-- Create brackets and quotes in pairs
  { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {}},

-- -------------------- Vim Cursorword -----------------------------------------
-- Underline the current word and other instances of it 
  {
    'itchyny/vim-cursorword',
    event = {'BufEnter', 'BufNewFile'},
    config = function()
      vim.api.nvim_command('augroup user_plugin_cursorword')
      vim.api.nvim_command("augroup user_plugin_cursorword")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
      vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
      vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
      vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
      vim.api.nvim_command("augroup END")
    end
  },

-- ------------------------ Bufferline ---------------------------------------
-- Bufferline tabs and jumping between buffers
  {
    'akinsho/bufferline.nvim', dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {},
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = 'nvim_lsp',
          -- indicator = {
          --   style = "underline",
          -- },
          -- custom_filter = function(buf_number)
          --   -- if vim.bo[buf_number].filetype ~= "zsh;#toggleterm#1" then
          --   if vim.fn.bufname(buf_number) ~= "toggleterm" then
          --     return true
          --   end
          -- end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true
            }
          },
          mode = "buffer",
          separator_style = 'slant',
          numbers = function(opts)
            -- return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
            return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
          end,
        }
      })
    end,
  },

-- ---------------------- Treesitter: Context ----------------------------------
-- Keep function/class signatures at the top of the buffer
  {
    'nvim-treesitter/nvim-treesitter-context', opts = {},
  },

-- ---------------------- Cmake Tools ------------------------------------------
-- Run cmake commands from within neovim
  -- {
  --   'Civitasv/cmake-tools.nvim', opt = {},
  --   config = function()
  --     require('cmake-tools').setup({
  --       -- cmake_build_directory = 'build/${variant:buildType}',
  --     })
  --   end
  -- },
  -- {
  --   'Shatur/neovim-tasks'
  -- },
-- ----------------------- ToggleTerm ------------------------------------------
-- Easily open terminals in neovim
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true
  },

-- {
--   'mfussenegger/nvim-dap',
--   config = function()
--     require('dap').setup({
--       dap.adapters.codelldb = {
--         type = 'server',
--         host = '127.0.0.1',
--         port = 13000
--       }
--     })
--   end
-- },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap'
    },
    opts = {}
  },

}, {})
-- ------------------------------- PLUGINS END ---------------------------------

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },

-- -----------------------------------------------------------------------------
-- Let lualine winbar interface with navic
local navic = require("nvim-navic")

require("lualine").setup({
  -- disabled_filetypes {
  --   statusline = { 'NvimTree'},
  --   winbar = { 'NvimTree' },
  -- },
  options = {
    theme = "auto",
    globalstatus = true,
    disabled_filetypes = {'alpha', 'NvimTree', 'toggleterm'},
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'diff' },
    lualine_x = {
      'diagnostics',
      'filetype'
    },
    lualine_y = { 'location', 'progress' },
    lualine_z = { 'datetime'},
  },
  ignore_focus = {'NvimTree'},
  winbar = {
    lualine_b = { {"filename"}},
    lualine_c = {
      {
        "navic"
      }
    }
  },
  inactive_winbar = {
    lualine_b = { 'filename' },
  },
})

-- -----------------------------------------------------------------------------
-- require'telescope'.extensions.project.project{}

-- local Path = require('plenary.path')
-- require('tasks').setup({
--   defualt_params = {
--     cmake = {
--       cmd = 'cmake',
--       build_dir = tostring(Path:new('{cwd}', 'build', '{os}--{build_type}')),
--       build_type = 'Debug',
--       dap_name = 'lldb',
--       args = {
--         configure = {'-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1', '-G', 'make'},
--       } })

-- local dap = require('dap')
-- dap.adapters.codelldb = {
--  type = 'server',
--  host = '127.0.0.1',
--  port = 13000
-- 
-- dap.configurations.cpp = {
--  {
--    type = 'codelldb',
--    request = 'launch',
--    program = function()
--      return vim.fn.input('Path to executable: ', vim.fn.getcwd()..'/', 'file')
--    end,
--    --program = '${fileDirname}/${fileBasenameNoExtension}',
--    cwd = '${workspaceFolder}',
--    terminal = 'integrated'
--  }
-- 
-- dap.adapters.codelldb = {
--   type = 'server',
--   host = '${port}',
--   executable = {
--     command = '~/.local/share/nvim/mason/packages/codelldb/codelldb',
--     args = {'--port', '${port}'},
--   }
-- }
-- dap.setup()

-- -------------------------- vim settings -------------------------------------
-- General settings
vim.o.foldmethod = "expr"
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false
vim.o.cursorline = true
vim.o.colorcolumn = '80'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true -- MMM

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- ------------------------- End Vim Settings ----------------------------------

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local project_actions = require('telescope._extensions.project.actions')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    project = {
      base_dirs = {
        {'~/code', max_depth = 4}
      },
    },
    theme = "dropdown",
    order_by = 'asc',
    search_by = "title",
    sync_with_nvim_tree = true,
    on_project_selected = function(prompt_bufnr)
      project_actions.change_working_directory(prompt_bufnr, false)
    end
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
require'telescope'.load_extension('project')
require'telescope'.load_extension('harpoon')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Fuzzy search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })

-- ----------------------------- My Keymaps ------------------------------------
-- General mappings ------------------------------------------------------------
vim.keymap.set('n', '<leader>q', ':q<cr>',                { silent = true, desc = 'Quit' })
vim.keymap.set('n', '<C-s>', ':w<cr>',                    { silent = true, desc = 'Save' })
vim.keymap.set('n', '<leader>w', ':w<cr>',                { silent = true, desc = 'Save' })
vim.keymap.set('n', '<leader>;', ':Alpha<cr>',            { silent = true, desc = 'Dashboard'})
vim.keymap.set('n', '<leader>h', ':noh<cr>',              { silent = true, desc = 'No Highlight'})

-- Split windows ---------------------------------------------------------------
vim.keymap.set('n', '-', ':split<cr>',                    { silent = true, desc = 'Horizontal Split' })
vim.keymap.set('n', '|', ':vsplit<cr>',                   { silent = true, desc = 'Vertical Split' })

-- File browsers ---------------------------------------------------------------
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>',   { silent = true, desc = 'Open File Explorer' })
require('telescope').load_extension('file_browser')
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope file_browser<cr>', { noremap = true, silent = true, desc = 'Open File Browser'})
-- vim.api.nvim_set_keymap('n', '<leader>fp', require('telescope').extensions.project.projects, { noremap = true, silent = true, desc = 'Open Project Browser'})

-- require'telescope'.extensions.projects.projects{}
-- Moving buffers --------------------------------------------------------------
vim.keymap.set('n', '<leader>bn', ':bnext<cr>',           { silent = true, desc = 'Next'})
vim.keymap.set('n', '<leader>bb', ':bprevious<cr>',       { silent = true, desc = 'Back'})
vim.keymap.set('n', '<leader>c',  ':bd<cr>',              { silent = true, desc = 'Close buffer'})
vim.keymap.set('n', '<leader>bj', ':BufferLinePick<cr>',  { silent = true, desc = 'Jump to'})

-- Moving windows --------------------------------------------------------------
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>',             { silent = true, desc = 'Move window down'})
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>',             { silent = true, desc = 'Move window left'})
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>',             { silent = true, desc = 'Move window up'})
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>',             { silent = true, desc = 'Move window right'})

-- ToggleTerm keymaps ----------------------------------------------------------
vim.keymap.set('n', '<M-1>', ':ToggleTerm size=10 direction=horizontal<cr>',  { silent = true, desc = 'Open horizontal terminal'})
vim.keymap.set('n', '<M-2>', ':ToggleTerm size=80 direction=vertical<cr>',    { silent = true, desc = 'Open vertical terminal'})
vim.keymap.set('n', '<M-3>', ':ToggleTerm size=30 direction=float<cr>',       { silent = true, desc = 'Open floating terminal'})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]],            { silent = true, desc = 'Exit terminal'})
  vim.keymap.set('t', 'jk',    [[<C-\><C-n>]],            { silent = true, desc = 'Exit terminal'})
  vim.keymap.set('t', '<C-j>', [[<cmd>wincmd j<CR>]],     { silent = true, desc = 'Move window down'})
  vim.keymap.set('t', '<C-h>', [[<cmd>wincmd h<CR>]],     { silent = true, desc = 'Move window left'})
  vim.keymap.set('t', '<C-k>', [[<cmd>wincmd k<CR>]],     { silent = true, desc = 'Move window up'})
  vim.keymap.set('t', '<C-l>', [[<cmd>wincmd l<CR>]],     { silent = true, desc = 'Move window right'})
  vim.keymap.set('t', '<M-1>', [[<cmd>ToggleTerm<cr>]],   { silent = true, desc = 'Open horizontal terminal'})
  vim.keymap.set('t', '<M-2>', [[<cmd>ToggleTerm<cr>]],   { silent = true, desc = 'Open vertical terminal'})
  vim.keymap.set('t', '<M-3>', [[<cmd>ToggleTerm<cr>]],   { silent = true, desc = 'Open floating terminal'})
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Resize windows --------------------------------------------------------------
vim.keymap.set('n', '<C-Down>',   '<C-w>-',               { silent = true, desc = 'Decrease window height'})
vim.keymap.set('n', '<C-Up>',     '<C-w>+',               { silent = true, desc = 'Increase window height'})
vim.keymap.set('n', '<C-Left>',   '<C-w><',               { silent = true, desc = 'Decrease window width'})
vim.keymap.set('n', '<C-Right>',  '<C-w>>',               { silent = true, desc = 'Increase window width'})

vim.keymap.set('n', '<M-Down>',   '<C-w>-',               { silent = true, desc = 'Decrease window height'})
vim.keymap.set('n', '<M-Up>',     '<C-w>+',               { silent = true, desc = 'Increase window height'})
vim.keymap.set('n', '<M-Left>',   '<C-w><',               { silent = true, desc = 'Decrease window width'})
vim.keymap.set('n', '<M-Right>',  '<C-w>>',               { silent = true, desc = 'Increase window width'})

-- Hmake specific keymaps ------------------------------------------------------
vim.keymap.set('n', '<leader>Ha', ':! hmake all<cr>',            { silent = true, desc = 'hmake all'})
vim.keymap.set('n', '<leader>Hi', ':! hmake install<cr>',        { silent = true, desc = 'hmake install'})
vim.keymap.set('n', '<leader>Hh', ':silent :! hmake all && hmake install<cr>', { silent = true, desc = 'hmake all & install (silent)'})
vim.keymap.set('n', '<leader>Hl', ':! hmake all && hmake install<cr>',         { silent = true, desc = 'hmake all & install'})

-- Cmake specific keymaps ------------------------------------------------------
vim.keymap.set('n', '<leader>Cg', ':CMakeGenerate<cr>',          { silent = true, desc = 'Generate'})
vim.keymap.set('n', '<leader>Cr', ':CMakeGenerate Release<cr>',  { silent = true, desc = 'Generate Release'})
vim.keymap.set('n', '<leader>Cd', ':CMakeGenerate Debug<cr>',    { silent = true, desc = 'Generate Debug'})
vim.keymap.set('n', '<leader>Cb', ':CMakeBuild<cr>',             { silent = true, desc = 'Build'})
vim.keymap.set('n', '<leader>Co', ':CMakeOpen<cr>',              { silent = true, desc = 'Open'})
vim.keymap.set('n', '<leader>Ci', ':CMakeInstall<cr>',           { silent = true, desc = 'Install'})
vim.keymap.set('n', '<leader>Cs', ':CMakeSelectBuildType<cr>',   { silent = true, desc = 'Select build'})

-- Harpoon keymaps -------------------------------------------------------------
vim.keymap.set('n', 'hx', require('harpoon.mark').add_file, { desc = "Harpoon mark"})
vim.keymap.set('n', 'hn', require('harpoon.ui').nav_next,   { desc = "Harpoon next"})
vim.keymap.set('n', 'hp', require('harpoon.ui').nav_prev,   { desc = "Harpoon prev"})
vim.keymap.set('n', 'hd', require('harpoon.mark').rm_file,  { desc = "Harpoon remove"})
vim.keymap.set('n', 'hm', ':Telescope harpoon marks<CR>',   { silent = true, desc = "Harpoon marks"})


-- Helpful keymaps -------------------------------------------------------------
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').colorscheme, { silent = true, desc = '[S]earch [C]olor'})

-- Set group names for keymaps -------------------------------------------------
local wk = require("which-key")
wk.register({
  ['<leader>'] = {
    l = {
      name = 'LSP',
      w = {
        name = 'Workspace',
        s = {'<cmd>telescope.builtin.lsp_dynamic_workspace_symbols', '[W]orkspace [S]ymbols'},
        a = {'vim.lsp.buf.add_workspace_folder', '[W]orkspace [A]dd Folder'},
        r = {'vim.lsp.buf.remove_workspace_folder', '[W]orkspace [R]emove Folder'},
      },
      d = {
        name = "Document",
        s = {'telescope.builtin.lsp_document_symbols', '[D]ocument [S]ymbols'},
      }
    }
  },
  ['<leader>f'] = { name = 'File' },
  ['<leader>b'] = { name = 'Buffer' },
  ['<leader>s'] = { name = 'Search' },
  ['<leader>g'] = { name = 'Git' },
  ['<leader>H'] = { name = 'hmake'},
  ['<leader>C'] = { name = 'cmake'}
})

-- ------------------------- End My Keymaps -------------------------------------

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'perl'},

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- MMM Added this to change error and warning symbols ⊗⭙‼
  -- local signs = { Error = "⭙", Warn = "⚠", Hint = "⚲", Info = "🕮"}
  local signs2 = {
    BoldError = "",
    Error = "",
    BoldWarn = "",
    Warn = "",
    BoldInformation = "",
    Information = "",
    BoldQuestion = "",
    Question = "",
    BoldHint = "",
    Hint = "󰌶",
    Debug = "",
    Trace = "✎",
  }
  for type, icon in pairs(signs2) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
  end
  -- MMM Added this to change error and warning symbols


  nmap('<leader>ln', vim.lsp.buf.rename, 'Rename')
  nmap('<leader>la', vim.lsp.buf.code_action, 'Code Action')

  nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
  nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
  nmap('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
  nmap('<leader>lD', vim.lsp.buf.type_definition, 'Type Definition')
  nmap('<leader>lds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
  -- nmap('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
  -- nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap('<leader>lwl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
  
  -- if _.server_capabilities.documentsSymbolProvider then
  --   _.attach(_, bufnr)
  -- end
end

-- require('lspconfig').clangd.setup {
--   on_attach = on_attach
-- }
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
-- scrollbar = cmp-config.window.completion.scrollbar()
    -- scrollbar = cmp.window.completion.scrollbar()
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    -- ['<CR>'] = cmp.mapping.confirm {
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = true,
    -- },
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false})
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
