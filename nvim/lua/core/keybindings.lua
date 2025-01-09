local keyset = vim.keymap.set

-- Leader key

vim.g.mapleader = ' '


-- General keybindings

keyset('n', ' ', '<Nop>')  -- Unbind space key to use as leader

-- Nvimtree keybindings
keyset('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = "Toggle NvimTree" })


-- Buffer / Tab Switching

keyset('n', '<S-Tab>', ':bprev<CR>')  -- Switch to previous buffer

keyset('n', '<Tab>', ':bnext<CR>')  -- Switch to next buffer


-- File Navigation

keyset('n', '<leader>f', ':Files<CR>')  -- FZF Files

keyset('n', '<leader>b', ':Buffers<CR>')  -- FZF Buffers


-- Telescope Navigation

keyset('n', '<leader>ff', ':Telescope find_files<CR>')  -- Telescope find files

keyset('n', '<leader>fg', ':Telescope live_grep<CR>')  -- Telescope live grep

keyset('n', '<leader>fb', ':Telescope buffers<CR>')  -- Telescope buffers


-- Commenting

keyset('n', '<leader>c', ':CommentToggle<CR>')  -- Toggle comment

keyset('v', '<leader>c', ':CommentToggle<CR>')  -- Toggle comment in visual mode


-- Code Navigation (Goto)

keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})  -- Go to definition

keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})  -- Go to type definition

keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})  -- Go to implementation

keyset("n", "gr", "<Plug>(coc-references)", {silent = true})  -- Go to references


-- Git integration

keyset('n', '<leader>gs', ':Git<CR>')  -- Open Git status

keyset('n', '<leader>gc', ':Git commit<CR>')  -- Git commit

keyset('n', '<leader>gp', ':Git push<CR>')  -- Git push

keyset('n', '<leader>gl', ':Git pull<CR>')  -- Git pull


-- Window Management

keyset('n', '<leader>wh', ':split<CR>')  -- Horizontal split

keyset('n', '<leader>wv', ':vsplit<CR>')  -- Vertical split

keyset('n', '<leader>wm', ':wincmd w<CR>')  -- Switch to next window

keyset('n', '<leader>wq', ':q<CR>')  -- Close current window


-- Miscellaneous keybindings

keyset('n', '<leader>q', ':close<CR>', { noremap = true, silent = true })  -- Close Cheatsheet
