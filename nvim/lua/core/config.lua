-- Nvim-Tree Configuration
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  auto_reload_on_write = true,
  hijack_cursor       = false,
  update_cwd          = false,
  diagnostics         = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  view = {
    width = 30,
    side = 'left',
  }
}


-- Lualine Configuration
require('lualine').setup {
  options = {
    theme = 'ayu_dark', -- Choose your preferred theme
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

-- Which-Key Configuration
require("which-key").setup {
  -- Your configuration comes here
  -- or leave it empty to use the default settings
}


-- Telescope Configuration
require('telescope').setup{
  defaults = {
    prompt_prefix = "> ",
    selection_caret = "> ",
    path_display = {"smart"},
  },
  extensions = {
    -- Your extensions configuration goes here
  }
}

-- Harpoon Configuration
require("harpoon").setup({
  -- Your configuration comes here
  -- or leave it empty to use the default settings
})
-- Conform.nvim Configuration
require('conform').setup({
  -- Your configuration comes here
  -- or leave it empty to use the default settings
})
-- LSP Configuration
local lspconfig = require'lspconfig'

-- Setup nvim-cmp capabilities
local cmp = require'cmp'
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Define on_attach function for LSP
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  keymap(bufnr, 'n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  -- Autoformat on save (optional)
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd [[
      augroup LspAutocommands
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format { async = true }
      augroup END
    ]]
  end
end

-- Setup language servers
local servers = { 'pyright','gopls', 'clangd' }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = (lsp == 'gopls') and {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
      },
    } or nil,
    init_options = (lsp == 'gopls') and {
      usePlaceholders = true,
    } or nil,
  }
end

-- Enhanced gopls configuration
lspconfig['gopls'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      usePlaceholders = true,
      codelenses = {
        generate = true, -- Enable "go generate" lens
        gc_details = true, -- Show garbage collection optimization details
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  init_options = {
    usePlaceholders = true,
  },
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
  },
  cmd = { "gopls", "serve" }, -- Start gopls server
}

-- Optional: Setup for debugging Go programs with Delve
require('dap-go').setup()

-- DAP UI setup
require("dapui").setup()