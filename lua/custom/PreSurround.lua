-------------------------------------------------------------------------------
--  PreSurround Plugin                                                       --
-------------------------------------------------------------------------------
require('custom.utils.MakeSurround')

local surround = vim.api.nvim_create_namespace('surround_ops')
vim.api.nvim_set_hl(surround, 'NormalFloat', { ctermbg = 'none', })
vim.api.nvim_set_hl(surround, 'FloatBorder', { ctermbg = 'none', })

function PreSurround(n_buf_id, win_id, n_win_id)
	local ns_mrk_pos = vim.api.nvim_buf_get_extmark_by_id(n_buf_id, surround, 1, {})
	local ne_mrk_pos = vim.api.nvim_buf_get_extmark_by_id(n_buf_id, surround, 2, {})
	local text
	local pos
	local col

	col = vim.fn.charcol('$', win_id) - vim.fn.charcol('.', win_id)
	if col > 1 then
		text = vim.api.nvim_buf_get_text(n_buf_id, ns_mrk_pos[1], ns_mrk_pos[2] - 1, ne_mrk_pos[1], ne_mrk_pos[2], {})
	else
		text = vim.api.nvim_buf_get_text(n_buf_id, ns_mrk_pos[1], ns_mrk_pos[2], ne_mrk_pos[1], ne_mrk_pos[2] + 1, {})
	end

	vim.api.nvim_win_close(n_win_id, false)
	vim.api.nvim_set_current_win(win_id)

	pos = vim.api.nvim_win_get_cursor(win_id)
	local indent = vim.fn.indent(pos[1] - 1)

	if col == 0 then
		text[1] = vim.text.indent(indent, text[1])
	end

	for i = 2, #text, 1 do
		text[i] = vim.text.indent(indent, text[i])
	end
	vim.api.nvim_put(text, 'c', true, true)

	if col > 1 then
		vim.api.nvim_feedkeys('h', 'n', true)
	end

	vim.api.nvim_feedkeys('a', 'n', true)

end

local function win_resize()
	local win_relative = vim.api.nvim_win_get_config(0).relative
	local buf_height = vim.api.nvim_win_get_height(0)
	local lines = vim.fn.getpos('$')[2]
	local win_width = vim.api.nvim_win_get_width(0)
	local lines_str = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	local extra_lines = 0
	local n_lines
	local str_width
	for i = 1, #lines_str, 1 do
		str_width = vim.fn.strdisplaywidth(lines_str[i])
		n_lines = math.floor(str_width / win_width)
		extra_lines = extra_lines + n_lines
	end

	if win_relative == 'win' and buf_height ~= lines + extra_lines then
		vim.api.nvim_win_set_height(0, lines + extra_lines)
	end
end

vim.api.nvim_create_user_command('PreSurround',
function (opts)
	local s_chars = MakeSurround(opts.args)
	local put_chars = s_chars[1]..s_chars[2]
	local filetype = vim.bo.filetype
	local buf_id = vim.fn.bufnr()
	local n_buf_id = vim.api.nvim_create_buf(false, true)
	local win_id = vim.fn.win_getid()
	local n_win_id

	local au_opts = {
		group = 'presurround',
		buffer = n_buf_id,
		callback = function () win_resize() end,
	}

	local width_mult = 0.5
	local height_mult = 0.8
	local win_opts = {
		relative = 'win',
		height = 1,
		width = math.floor(width_mult * vim.api.nvim_win_get_width(win_id)),
		row = math.floor(height_mult * vim.api.nvim_win_get_height(win_id)),
		col = math.floor(0.5 * (1 - width_mult) * vim.api.nvim_win_get_width(win_id)),
		style = 'minimal',
		border = 'rounded',
	}

	local win_relative = vim.api.nvim_win_get_config(win_id).relative
	local pos = vim.api.nvim_win_get_cursor(win_id)
	local line = vim.api.nvim_buf_get_lines(buf_id, pos[1] - 1, pos[1], true)

	local confirm_cmd
	local quit_cmd
	local ext_pos
	local ns_mrk_pos
	local col

	if win_relative == 'win' then
		win_opts.width = vim.api.nvim_win_get_width(win_id)
		win_opts.row = vim.api.nvim_win_get_height(win_id) + 1
		win_opts.col = -1
	end

	vim.api.nvim_open_win(n_buf_id, true, win_opts)
	n_win_id = vim.fn.win_getid()
	vim.api.nvim_win_set_hl_ns(n_win_id, surround)

	vim.api.nvim_put(line, 'c', true, true)
	vim.api.nvim_win_set_cursor(n_win_id, {1, pos[2]})

	col = vim.fn.charcol('$') - vim.fn.charcol('.')
	if col > 1 then
		vim.api.nvim_feedkeys('h', 'n', true)
	end

	vim.api.nvim_put({put_chars}, 'c', true, true)

	ext_pos = vim.api.nvim_win_get_cursor(n_win_id)
	vim.api.nvim_buf_set_extmark(n_buf_id, surround, ext_pos[1] - 1, ext_pos[2] - #put_chars + 1, { id = 1, right_gravity = false })
	vim.api.nvim_buf_set_extmark(n_buf_id, surround, ext_pos[1] - 1, ext_pos[2], { id = 2 })

	vim.cmd('normal! ==')

	ns_mrk_pos = vim.api.nvim_buf_get_extmark_by_id(n_buf_id, surround, 1, {})
	vim.api.nvim_win_set_cursor(n_win_id, {ns_mrk_pos[1] + 1, ns_mrk_pos[2] + #s_chars[1]})

	vim.api.nvim_feedkeys('i', 'n', true)

	vim.bo.filetype = filetype

	confirm_cmd = string.format(':lua PreSurround(%d, %d, %d)<CR>', n_buf_id, win_id, n_win_id)
	quit_cmd = string.format(':q | lua vim.api.nvim_set_current_win(%d)<CR>', win_id)
	vim.api.nvim_create_augroup('presurround', {})
	vim.api.nvim_create_autocmd('TextChanged', au_opts)
	vim.api.nvim_create_autocmd('TextChangedI', au_opts)
	vim.api.nvim_buf_set_keymap(n_buf_id, 'n', '<Esc>', quit_cmd, {})
	vim.api.nvim_buf_set_keymap(n_buf_id, 'n', '<CR>', confirm_cmd, {})
end,
{ nargs = 1 })
