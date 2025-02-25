-- Initialize plugin manager (vim-plug)
local Plug = vim.fn['plug#']

vim.call('plug#begin', './plugins/')

-- Core plugins
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'tpope/vim-surround'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

-- LaTeX and HTML utilities
Plug 'lervag/vimtex'
Plug 'mattn/emmet-vim'

-- Go development
Plug 'fatih/vim-go'
Plug 'leoluz/nvim-dap-go'


-- Visual enhancements
Plug 'gko/vim-coloresque'
Plug 'flazz/vim-colorschemes'
Plug 'rose-pine/neovim' -- Updated repository
Plug 'ayu-theme/ayu-vim'
Plug 'nvim-lualine/lualine.nvim'

-- Python development
Plug 'davidhalter/jedi-vim' -- Consider removing if using LSP

-- Productivity tools
Plug 'folke/which-key.nvim'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'nvim-telescope/telescope.nvim'
Plug 'numToStr/Comment.nvim'

-- Language Server Protocol (LSP) and completio
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

-- Modern tools
Plug 'github/copilot.vim'
Plug 'ThePrimeagen/harpoon'
Plug 'stevearc/conform.nvim'
Plug 'octol/vim-cpp-enhanced-highlight'

-- Dependency for Telescope
Plug 'nvim-lua/plenary.nvim'

-- Debug Adaptor 
Plug 'mfussenegger/nvim-dap'

-- DAP UI  
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'


vim.call('plug#end')
