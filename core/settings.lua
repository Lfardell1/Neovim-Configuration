
-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.termguicolors = true

-- Sync Clipboard
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.inccommand = 'split'


