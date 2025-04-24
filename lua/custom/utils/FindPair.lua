-------------------------------------------------------------------------------
-- Find Pair Utility                                                         --
-------------------------------------------------------------------------------
require('custom.utils.MakeSurround')


function FindPair(chars)
	local curPos = vim.api.nvim_win_get_cursor(0)
	local cRow = curPos[1] - 1
	local cCol = curPos[2]
	local curChar = vim.api.nvim_buf_get_text(0, cRow, cCol, cRow, cCol + 1, {})
	local sPos
	local ePos
	local surChars = MakeSurround(chars)
	local sLen = #surChars[1]
	local eLen = #surChars[2]
	local fPairFlags = 'Wn'
	local bPairFlags = fPairFlags..'b'
	local containsPair = false
	local pairs = {
		['('] = 0,
		[')'] = 0,
		['{'] = 0,
		['}'] = 0,
		['['] = 0,
		[']'] = 0,
		['<'] = 0,
		['>'] = 0,
	}

	local escChars = {
		['('] = '%(',
		[')'] = '%)',
		['.'] = '%.',
		['%'] = '%%',
		['+'] = '%+',
		['-'] = '%-',
		['*'] = '%*',
		['?'] = '%?',
		['['] = '%[',
		[']'] = '%]',
		['^'] = '%^',
		['$'] = '%$',
	}

	if escChars[curChar[1]] then
		curChar[1] = escChars[curChar[1]]
	end

	for i = 1, #surChars[1], 1 do
		if pairs[chars:sub(i,i)] then
			containsPair = true
		end
	end

	surChars[1] = surChars[1]:gsub('%[', '\\[')
	surChars[2] = surChars[2]:gsub('%[', '\\[')
	surChars[1] = surChars[1]:gsub('%]', '\\]')
	surChars[2] = surChars[2]:gsub('%]', '\\]')
	surChars[1] = surChars[1]:gsub('%$', '\\$')
	surChars[2] = surChars[2]:gsub('%$', '\\$')
	surChars[1] = surChars[1]:gsub('%^', '\\^')
	surChars[2] = surChars[2]:gsub('%^', '\\^')
	surChars[1] = surChars[1]:gsub('~', '\\~')
	surChars[2] = surChars[2]:gsub('~', '\\~')

	local function makeRet()
		ePos[1] = ePos[1] - 1
		ePos[2] = ePos[2] - 1
		sPos[1] = sPos[1] - 1
		sPos[2] = sPos[2] - 1

		if ePos[1] < sPos[1] or ePos[2] < sPos[2] then
			return {ePos, sPos, eLen, sLen}
		end

		return {sPos, ePos, sLen, eLen}
	end

	if containsPair == false then
		if surChars[1]:find(curChar[1]) then
			vim.cmd.redraw()
			return print("Error: cursor must be inside surrounding character")
		end

		ePos = vim.fn.searchpos(surChars[1], fPairFlags)
		vim.api.nvim_win_set_cursor(0, {ePos[1], ePos[2] - 1})
		sPos = vim.fn.searchpos(surChars[2], bPairFlags)
		return makeRet()
	end

	ePos = vim.fn.searchpairpos(surChars[1], '', surChars[2], fPairFlags)

	if ePos[1] == 0 and ePos[2] == 0 then
		bPairFlags = fPairFlags
		fPairFlags = fPairFlags..'b'
	end

	ePos = vim.fn.searchpairpos(surChars[1], '', surChars[2], fPairFlags)

	if ePos[1] == 0 and ePos[2] == 0 then
		vim.cmd.redraw()
		return print("No matching character found")
	end

	vim.api.nvim_win_set_cursor(0, {ePos[1], ePos[2] - 1})

	sPos = vim.fn.searchpairpos(surChars[1], '', surChars[2], bPairFlags)

	if sPos[1] == 0 and sPos[2] == 0 then
		vim.cmd.redraw()
		return print("No matching character found")
	end

	return makeRet()
end
