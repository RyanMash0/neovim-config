-------------------------------------------------------------------------------
-- PreSurround Plugin                                                        --
-------------------------------------------------------------------------------
require('custom.utils.MakeSurround')

local surround = vim.api.nvim_create_namespace('surround_ops')
vim.api.nvim_set_hl(surround, 'NormalFloat', { ctermbg = 'none', })
vim.api.nvim_set_hl(surround, 'FloatBorder', { ctermbg = 'none', })

vim.api.nvim_create_augroup('presurround', { clear = true })

table.unpack = table.unpack or unpack

function PreSurround(nBufId, winId, nwinId)
	local nsMrkPos = vim.api.nvim_buf_get_extmark_by_id(nBufId, surround, 1, {})
	local neMrkPos = vim.api.nvim_buf_get_extmark_by_id(nBufId, surround, 2, {})
	local col = vim.fn.charcol('$', winId) - vim.fn.charcol('.', winId)
	local pos
	local textArgs
	local text

	if col > 1 then
		textArgs = {
			nBufId,
			nsMrkPos[1],
			nsMrkPos[2] - 1,
			neMrkPos[1],
			neMrkPos[2],
			{},
		}
	else
		textArgs = {
			nBufId,
			nsMrkPos[1],
			nsMrkPos[2],
			neMrkPos[1],
			neMrkPos[2] + 1,
			{},
		}
	end
	text = vim.api.nvim_buf_get_text(table.unpack(textArgs))

	vim.api.nvim_win_close(nwinId, false)
	vim.api.nvim_set_current_win(winId)

	pos = vim.api.nvim_win_get_cursor(winId)
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
	local winRel = vim.api.nvim_win_get_config(0).relative
	local bufHeight = vim.api.nvim_win_get_height(0)
	local lines = vim.fn.getpos('$')[2]
	local winWidth = vim.api.nvim_win_get_width(0)
	local linesStr = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	local extraLines = 0
	local nLines
	local strWidth

	for i = 1, #linesStr, 1 do
		strWidth = vim.fn.strdisplaywidth(linesStr[i])
		nLines = math.floor(strWidth / winWidth)
		extraLines = extraLines + nLines
	end

	if winRel == 'win' and bufHeight ~= lines + extraLines then
		vim.api.nvim_win_set_height(0, lines + extraLines)
	end
end

vim.api.nvim_create_user_command('PreSurround',
function (opts)
	local sChars = MakeSurround(opts.args)
	local putChars = sChars[1]..sChars[2]
	local filetype = vim.bo.filetype
	local bufId = vim.fn.bufnr()
	local nBufId = vim.api.nvim_create_buf(false, true)
	local winId = vim.fn.win_getid()
	local nwinId

	local auOpts = {
		group = 'presurround',
		buffer = nBufId,
		callback = function () win_resize() end,
	}

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

	local winRel = vim.api.nvim_win_get_config(winId).relative
	local pos = vim.api.nvim_win_get_cursor(winId)
	local line = vim.api.nvim_buf_get_lines(bufId, pos[1] - 1, pos[1], true)

	local confirmStr
	local confirmCmd
	local quitStr
	local quitCmd
	local extPos
	local cursorArgs
	local nsMrkPos
	local nsMrkArgs
	local neMrkArgs
	local col

	if winRel == 'win' then
		winOpts.width = winWidth
		winOpts.row = winHeight + 1
		winOpts.col = -1
	end

	vim.api.nvim_open_win(nBufId, true, winOpts)
	nwinId = vim.fn.win_getid()
	vim.api.nvim_win_set_hl_ns(nwinId, surround)
	vim.bo.filetype = filetype

	vim.api.nvim_put(line, 'c', true, true)
	vim.api.nvim_win_set_cursor(nwinId, {1, pos[2]})

	col = vim.fn.charcol('$') - vim.fn.charcol('.')
	if col > 1 then
		vim.api.nvim_feedkeys('h', 'n', true)
	end

	vim.api.nvim_put({putChars}, 'c', true, true)

	extPos = vim.api.nvim_win_get_cursor(nwinId)
	nsMrkArgs = {
		nBufId,
		surround,
		extPos[1] - 1,
		extPos[2] - #putChars + 1,
		{ id = 1, right_gravity = false },
	}
	neMrkArgs = {
		nBufId,
		surround,
		extPos[1] - 1,
		extPos[2],
		{ id = 2 }
	}
	vim.api.nvim_buf_set_extmark(table.unpack(nsMrkArgs))
	vim.api.nvim_buf_set_extmark(table.unpack(neMrkArgs))

	vim.cmd('normal! ==')

	nsMrkPos = vim.api.nvim_buf_get_extmark_by_id(nBufId, surround, 1, {})
	cursorArgs = {nwinId, {nsMrkPos[1] + 1, nsMrkPos[2] + #sChars[1]}}
	vim.api.nvim_win_set_cursor(table.unpack(cursorArgs))

	vim.api.nvim_feedkeys('i', 'n', true)

	confirmStr = ':lua PreSurround(%d, %d, %d)<CR>'
	confirmCmd = string.format(confirmStr, nBufId, winId, nwinId)
	quitStr = ':q | lua vim.api.nvim_set_current_win(%d)<CR>'
	quitCmd = string.format(quitStr, winId)
	vim.api.nvim_create_autocmd('TextChanged', auOpts)
	vim.api.nvim_create_autocmd('TextChangedI', auOpts)
	vim.api.nvim_buf_set_keymap(nBufId, 'n', '<Esc>', quitCmd, {})
	vim.api.nvim_buf_set_keymap(nBufId, 'n', '<CR>', confirmCmd, {})
end,
{ nargs = 1 })
