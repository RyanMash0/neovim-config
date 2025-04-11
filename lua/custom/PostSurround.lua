-------------------------------------------------------------------------------
--  PostSurround Plugin                                                      --
-------------------------------------------------------------------------------
require('custom.utils.MakeSurround')

function PostSurround(chars)
	local col_start = vim.api.nvim_buf_get_mark(0, "[")[2]
	local col_end = vim.api.nvim_buf_get_mark(0, "]")[2] + 1
	local row_start = vim.api.nvim_buf_get_mark(0, "[")[1] - 1
	local row_end = vim.api.nvim_buf_get_mark(0, "]")[1] - 1
	local s_chars = MakeSurround(chars)

	vim.api.nvim_buf_set_text(0, row_end, col_end,
														row_end, col_end, {s_chars[2]})
	vim.api.nvim_buf_set_text(0, row_start, col_start,
														row_start, col_start, {s_chars[1]})

end

local function get_input(mode)

	vim.ui.input({ prompt = 'Surround with: ' }, function(input)
		local keys = {
			['n'] = 'g@',
			['v'] = '`<v`>g@',
		}
		if input == nil then return end
		vim.cmd.let('&operatorfunc = { -> v:lua.PostSurround("'..input..'")}')
		vim.fn.feedkeys(keys[mode])
	end)

end

vim.api.nvim_create_user_command('PostSurround',
	function ()
		get_input('n')
	end,
	{ nargs = 0 })

vim.api.nvim_create_user_command('VPostSurround',
	function ()
		get_input('v')
	end,
	{ nargs = 0, range = true })
