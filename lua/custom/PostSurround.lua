-------------------------------------------------------------------------------
-- PostSurround Plugin                                                       --
-------------------------------------------------------------------------------
require('custom.utils.MakeSurround')
require('custom.utils.GetInput')

function PostSurround(chars)
	local col_start = vim.api.nvim_buf_get_mark(0, "[")[2]
	local col_end = vim.api.nvim_buf_get_mark(0, "]")[2] + 1
	local row_start = vim.api.nvim_buf_get_mark(0, "[")[1] - 1
	local row_end = vim.api.nvim_buf_get_mark(0, "]")[1] - 1
	local s_chars = MakeSurround(chars)
	local cur_pos = {row_end + 1, col_end + #s_chars[1] + #s_chars[2] - 1}

	vim.api.nvim_buf_set_text(0, row_end, col_end,
														row_end, col_end, {s_chars[2]})
	vim.api.nvim_buf_set_text(0, row_start, col_start,
														row_start, col_start, {s_chars[1]})

	vim.api.nvim_win_set_cursor(0, cur_pos)

end

local function setOpFunc(mode)
	local input = GetInput('Surround with')
	local keys = {
		['n'] = 'g@',
		['v'] = '`<v`>g@',
	}
	vim.g.post_surround_input = input
	vim.o.operatorfunc = '{ -> v:lua.PostSurround(g:post_surround_input) }'
	vim.fn.feedkeys(keys[mode])

end

vim.api.nvim_create_user_command('PostSurround',
	function ()
		setOpFunc('n')
	end,
	{ nargs = 0 })

vim.api.nvim_create_user_command('VPostSurround',
	function ()
		setOpFunc('v')
	end,
	{ nargs = 0, range = true })
