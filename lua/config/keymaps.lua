-------------------------------------------------------------------------------
--  Keymaps                                                                  --
-------------------------------------------------------------------------------
require('config.texmaps')

-- Leader
local L = '<Leader>'
vim.keymap.set('n', '-', ',')
vim.keymap.set('n', ',', '<Nop>')
vim.g.mapleader = ","

-- Explore
vim.keymap.set('n', L..'e', '<Cmd>Ex<CR>')

-- Windows
vim.keymap.set('n', L..'w', '<C-w>')

-- Buffers
vim.keymap.set('n', L..'n', '<Cmd>bn<CR>')
vim.keymap.set('n', L..'b', '<Cmd>bp<CR>')
vim.keymap.set('n', L..'d', '<Cmd>bp | bd #<CR>')

-- Surround
vim.keymap.set('n', L..'s', ':Surround<CR>')
vim.keymap.set('v', L..'s', ':VSurround<CR>')

-- Surround Insert
vim.keymap.set('i', '()', '<Esc>:SurroundInsert (<CR>')
vim.keymap.set('i', '[]', '<Esc>:SurroundInsert [<CR>')
vim.keymap.set('i', '{}', '<Esc>:SurroundInsert {<CR>')
vim.keymap.set('i', '\"\"', '<Esc>:SurroundInsert \"<CR>')
vim.keymap.set('i', '\'\'', '<Esc>:SurroundInsert \'<CR>')

-- Color Column
vim.keymap.set('n', L..'c+', ':set colorcolumn=80<CR>')
vim.keymap.set('n', L..'c-', ':set colorcolumn=0<CR>')

-- Telescope
local r = 'cwd=/'
vim.keymap.set('n', L..'f', '<Cmd>Telescope find_files<CR>')
vim.keymap.set('n', L..'h', '<Cmd>Telescope help_tags<CR>')
vim.keymap.set('n', L..'g', '<Cmd>Telescope live_grep <CR>')
vim.keymap.set('n', L..'rf', '<Cmd>Telescope find_files '..r..'<CR>')
vim.keymap.set('n', L..'rg', '<Cmd>Telescope live_grep '..r..'<CR>')
vim.keymap.set('n', L..'gf', '<Cmd>Telescope git_files<CR>')
vim.keymap.set('n', L..'gc', '<Cmd>Telescope git_commits<CR>')
