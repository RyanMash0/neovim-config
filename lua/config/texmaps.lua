-------------------------------------------------------------------------------
-- LaTeX Config                                                              --
-------------------------------------------------------------------------------
local tex_opts = {
	group = 'tex',
	pattern = 'tex',
	command = 'lua TexMaps()',
}
vim.api.nvim_create_augroup('tex', { clear = true })
vim.api.nvim_create_autocmd('FileType', tex_opts)

function TexMaps()

	vim.api.nvim_buf_set_keymap(0, 'o', 'i$', ':TextObjMotion i$<CR>', {})
	vim.api.nvim_buf_set_keymap(0, 'o', 'a$', ':TextObjMotion a$<CR>', {})

	local items = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
	local item_str
	for i = 1 , #items do
		item_str = '\\item[('..items[i]..')] '
		vim.api.nvim_buf_set_keymap(0, 'i', '--item'..items[i], item_str, {})
	end

	local sets = { 'reals', 'nats', 'ints', 'rats', 'irrs' }
	local set_symbs = { 'R', 'N', 'Z', 'Q', 'I' }
	local set_str
	for i = 1, #sets do
		set_str = '\\mathds{'..set_symbs[i]..'}'
		vim.api.nvim_buf_set_keymap(0, '!', '--'..sets[i], set_str, {})
	end

	vim.api.nvim_buf_set_keymap(0, 'i', '$<CR>', '<Esc>:PreSurround $<CR>', {})
	vim.api.nvim_buf_set_keymap(0, 'i', '|<CR>', '<Esc>:PreSurround |<CR>', {})
	vim.api.nvim_buf_set_keymap(0, 'i', '--set', '<Esc>:MakeSet<CR>', {})

end
