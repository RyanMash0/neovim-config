-------------------------------------------------------------------------------
--  Surround Insert Plugin                                                   --
-------------------------------------------------------------------------------
require('custom.utils.MakeSurround')

function SurroundInsert()
	local text = vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {})
	local col
	vim.api.nvim_win_close(0, false)

	if #text > 1 then
		vim.api.nvim_put(text, 'c', true, true)
		vim.api.nvim_feedkeys('='..(#text - 1)..'k\']', 'n', true)

		if #text[#text] > 1 then
			vim.api.nvim_feedkeys((#text[#text] - 1)..'la', 'n', true)
		else
			vim.api.nvim_feedkeys('a', 'n', true)
		end

	else
		col = vim.fn.col('$') - vim.fn.col('.') - 1
		vim.api.nvim_put(text, 'c', true, true)
		if col == 0 then
			vim.api.nvim_feedkeys('a', 'n', true)
		else
			vim.api.nvim_feedkeys('i', 'n', true)
		end
	end

end

local function win_resize()
	local height = vim.api.nvim_win_get_height(0)
	local lines = vim.fn.getpos('$')[2]
	if height ~= lines then
		vim.api.nvim_win_set_height(0, lines)
	end
end


vim.api.nvim_create_user_command('SurroundInsert',
function (opts)
	local s_chars = MakeSurround(opts.args)
	local filetype = vim.bo.filetype
	local au_opts = {
		buffer = 0,
		callback = function () win_resize() end,
	}
	local buf = vim.api.nvim_create_buf(false, true)
	local width_mult = 0.5
	local height_mult = 0.8
	local win_relative = vim.api.nvim_win_get_config(0).relative
	local win_col = vim.api.nvim_win_get_config(0).col
	local win_opts = {
		relative = 'win',
		height = 1,
		width = math.floor(width_mult * vim.api.nvim_win_get_width(0)),
		row = math.floor(height_mult * vim.api.nvim_win_get_height(0)),
		col = math.floor(0.5 * (1 - width_mult) * vim.api.nvim_win_get_width(0)),
		style = 'minimal',
		border = 'rounded',
	}
	if win_relative == 'win' and win_col == -1 then
		vim.api.nvim_put({s_chars[1]..s_chars[2]}, 'c', true, true)
		vim.api.nvim_feedkeys('i', 'n', true)
		return
	elseif win_relative == 'win' then
		win_opts.width = vim.api.nvim_win_get_width(0)
		win_opts.row = vim.api.nvim_win_get_height(0) + 1
		win_opts.col = -1
	end

	vim.api.nvim_open_win(buf, true, win_opts)
	vim.api.nvim_put({s_chars[1]..s_chars[2]}, 'c', true, true)
	vim.api.nvim_feedkeys('i', 'n', true)

	vim.api.nvim_set_hl(0, 'NormalFloat', { ctermbg = 'none', })
	vim.api.nvim_set_hl(0, 'FloatBorder', { ctermbg = 'none', })
	vim.bo.filetype = filetype

	vim.api.nvim_create_autocmd('TextChanged', au_opts)
	vim.api.nvim_create_autocmd('TextChangedI', au_opts)
	vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':q<CR>', {})
	vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':lua SurroundInsert()<CR>', {})
end,
{ nargs = 1 })
