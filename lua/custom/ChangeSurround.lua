-------------------------------------------------------------------------------
-- ChangeSurround Plugin                                                     --
-------------------------------------------------------------------------------
require('custom.utils.FindPair')
require('custom.utils.MakeSurround')
require('custom.utils.GetInput')

function ChangeSurround()
	local chars = GetInput('Change')
	local pos = FindPair(chars)
	if pos == nil then return end
	local sRow = pos[1][1]
	local sCol = pos[1][2]
	local eRow = pos[2][1]
	local eCol = pos[2][2]
	local cChars = GetInput('Replace with')
	local sChars = MakeSurround(cChars)

	vim.api.nvim_buf_set_text(0, eRow, eCol, eRow, eCol + pos[4], {sChars[2]})
	vim.api.nvim_buf_set_text(0, sRow, sCol, sRow, sCol + pos[3], {sChars[1]})

end


vim.api.nvim_create_user_command('ChangeSurround',
	function ()
		ChangeSurround()
	end,
	{ nargs = 0 })
