-------------------------------------------------------------------------------
--  Keymaps                                                                  --
-------------------------------------------------------------------------------
require('config.texmaps')

-- Leader
local L = '<Leader>'
vim.keymap.set('n', '-', ',')
vim.keymap.set('n', ',', '<Nop>')
vim.g.mapleader = ","

-- Completion
vim.keymap.set('i', '<Tab>', '<C-n>')
vim.keymap.set('i', '<S-Tab>', '<C-p>')
vim.cmd("inoremap <expr> <cr> pumvisible() ? '<C-y>' : '<CR>'")

-- Explore
vim.keymap.set('n', L..'e', '<Cmd>Ex<CR>')

-- Windows
vim.keymap.set('n', L..'w', '<C-w>')

-- Buffers
vim.keymap.set('n', L..'n', '<Cmd>bn<CR>')
vim.keymap.set('n', L..'b', '<Cmd>bp<CR>')
vim.keymap.set('n', L..'d<CR>', '<Cmd>bp | bd #<CR>')

-- Surround
vim.keymap.set('n', L..'s', ':PostSurround<CR>')
vim.keymap.set('v', L..'s', ':VPostSurround<CR>')

-- DeleteSurround
vim.keymap.set('n', L..'ds', ':DeleteSurround<CR>')

-- ChangeSurround
vim.keymap.set('n', L..'cs', ':ChangeSurround<CR>')

-- Surround Insert
-- vim.keymap.set('i', '()<CR>', '<Esc>:PreSurround (<CR>')
-- vim.keymap.set('i', '[]<CR>', '<Esc>:PreSurround [<CR>')
-- vim.keymap.set('i', '{}<CR>', '<Esc>:PreSurround {<CR>')
-- vim.keymap.set('i', '{} <CR>', '<Esc>:PreSurround { <CR>')
-- vim.keymap.set('i', '<><CR>', '<Esc>:PreSurround <<CR>')
-- vim.keymap.set('i', '\"\"<CR>', '<Esc>:PreSurround \"<CR>')
-- vim.keymap.set('i', '\'\'<CR>', '<Esc>:PreSurround \'<CR>')

-- Color Column
vim.keymap.set('n', L..'c+', ':set colorcolumn=80<CR>')
vim.keymap.set('n', L..'c-', ':set colorcolumn=0<CR>')

-- Telescope
local r = 'cwd=/'
vim.keymap.set('n', L..'f', '<Cmd>Telescope find_files<CR>')
vim.keymap.set('n', L..'g', '<Cmd>Telescope git_files<CR>')
vim.keymap.set('n', L..'com', '<Cmd>Telescope git_commits<CR>')
vim.keymap.set('n', L..'h', '<Cmd>Telescope help_tags<CR>')
vim.keymap.set('n', L..'lg', '<Cmd>Telescope live_grep <CR>')
vim.keymap.set('n', L..'rf', '<Cmd>Telescope find_files '..r..'<CR>')
vim.keymap.set('n', L..'rlg', '<Cmd>Telescope live_grep '..r..'<CR>')
