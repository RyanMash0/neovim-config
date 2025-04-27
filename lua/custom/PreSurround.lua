-------------------------------------------------------------------------------
-- PreSurround Plugin                                                        --
-------------------------------------------------------------------------------
require('custom.utils.MakeSurround')

local surround = vim.api.nvim_create_namespace('surround_ops')
vim.api.nvim_set_hl(surround, 'NormalFloat', { ctermbg = 'none', })
vim.api.nvim_set_hl(surround, 'FloatBorder', { ctermbg = 'none', })

vim.api.nvim_create_augroup('presurround', { clear = true })

table.unpack = table.unpack or unpack

function PreSurround()
	local winId = vim.w.presurround_win_id
	local bufId = vim.fn.bufnr()
	local nwinId = vim.fn.win_getid()

	local mrkId = vim.w.presurround_end_mark_id
	local mrkArgs = {bufId, surround, mrkId, {}}
	local mrkPos = vim.api.nvim_buf_get_extmark_by_id(table.unpack(mrkArgs))

	local quitMap = vim.w.presurround_quit_map
	local confirmMap = vim.w.presurround_confirm_map

	vim.api.nvim_win_close(nwinId, false)
	vim.api.nvim_set_current_win(winId)

	vim.api.nvim_win_set_cursor(winId, {mrkPos[1] + 1, mrkPos[2] - 1})

	vim.api.nvim_feedkeys('a', 'n', true)

	if quitMap == '' and confirmMap == '' then
		vim.api.nvim_buf_del_keymap(bufId, 'n', '<Esc>')
		vim.api.nvim_buf_del_keymap(bufId, 'n', '<CR>')
		vim.api.nvim_clear_autocmds({ group = surround })
	end

	vim.api.nvim_buf_del_extmark(bufId, surround, mrkId)

end

local function win_resize()
	local winHeight = vim.api.nvim_win_get_height(0)
	local winWidth = vim.api.nvim_win_get_width(0)

	local lineNr = vim.api.nvim_win_get_cursor(0)[1]
	local linesStr = vim.api.nvim_buf_get_lines(0, lineNr - 1, lineNr, true)

	local strWidth = vim.fn.strdisplaywidth(linesStr[1])
	local extraLines = math.floor(strWidth / winWidth)

	if winHeight ~= 1 + extraLines then
		vim.api.nvim_win_set_height(0, 1 + extraLines)
	end
end

vim.api.nvim_create_user_command('PreSurround',
function (opts)
	local sChars = MakeSurround(opts.args)
	local putChars = sChars[1]..sChars[2]

	local bufId = vim.fn.bufnr()
	local winId = vim.fn.win_getid()
	local winRel = vim.api.nvim_win_get_config(winId).relative
	local pos = vim.api.nvim_win_get_cursor(winId)

	local widthMult = 0.5
	local heightMult = 0.8
	local winHeight = vim.api.nvim_win_get_height(winId)
	local winWidth = vim.api.nvim_win_get_width(winId)
	local winOpts = {
		relative = 'win',
		height = 1,
		width = math.floor(widthMult * winWidth),
		row = math.floor(heightMult * winHeight),
		col = math.floor(0.5 * (1 - widthMult) * winWidth),
		style = 'minimal',
		border = 'rounded',
	}

	if winRel == 'win' then
		winOpts.width = winWidth
		winOpts.row = -1
		winOpts.col = -1
	end

	local nwinId = vim.api.nvim_open_win(bufId, true, winOpts)

	local lineDiff
	local line
	local col

	local mrkArgs
	local mrkId
	local exitStr

	local auOpts = {
		group = 'presurround',
		buffer = bufId,
		callback = function ()
			if vim.api.nvim_win_get_config(0).relative == 'win' then
				win_resize()
			end
		end,
	}

	vim.api.nvim_win_set_cursor(nwinId, pos)
	vim.api.nvim_win_set_hl_ns(nwinId, surround)
	vim.wo.signcolumn = 'no'

	col = vim.fn.charcol('$', winId) - vim.fn.charcol('.', winId)

	vim.api.nvim_put({putChars}, 'c', true, true)
	pos = vim.api.nvim_win_get_cursor(nwinId)

	if col > 1 then
		vim.api.nvim_win_set_cursor(nwinId, {pos[1], pos[2] - 1})
	else
		pos = vim.api.nvim_win_get_cursor(nwinId)
		line = vim.fn.col('$')
		lineDiff = line

		vim.cmd('normal! ==')

		line = vim.fn.col('$')
		lineDiff = line - lineDiff
		lineDiff = lineDiff * vim.o.shiftwidth

		vim.api.nvim_win_set_cursor(nwinId, {pos[1], pos[2] + lineDiff})
		pos = vim.api.nvim_win_get_cursor(nwinId)

		pos[2] = pos[2] + 1
	end

	mrkArgs = {
		bufId,
		surround,
		pos[1] - 1,
		pos[2],
		{},
	}

	mrkId = vim.api.nvim_buf_set_extmark(table.unpack(mrkArgs))

	pos[2] = pos[2] - #sChars[2]
	vim.api.nvim_win_set_cursor(nwinId, pos)

	vim.api.nvim_command('startinsert')

	vim.w.presurround_quit_map = vim.fn.maparg('<Esc>', 'n')
	vim.w.presurround_confirm_map = vim.fn.maparg('<CR>', 'n')
	vim.w.presurround_end_mark_id = mrkId
	vim.w.presurround_win_id = winId

	exitStr = ':lua PreSurround()<CR>'

	vim.api.nvim_create_autocmd('TextChanged', auOpts)
	vim.api.nvim_create_autocmd('TextChangedI', auOpts)
	vim.api.nvim_buf_set_keymap(bufId, 'n', '<Esc>', exitStr, {})
	vim.api.nvim_buf_set_keymap(bufId, 'n', '<CR>', exitStr, {})
end,
{ nargs = 1 })
