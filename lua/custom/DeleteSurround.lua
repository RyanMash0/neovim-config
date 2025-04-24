-------------------------------------------------------------------------------
--  DeleteSurround Plugin                                                    --
-------------------------------------------------------------------------------
require('custom.utils.FindPair')

function DeleteSurround(chars)
	local pos = FindPair(chars)
	if pos == nil then return end
	local sRow = pos[1][1]
	local sCol = pos[1][2]
	local eRow = pos[2][1]
	local eCol = pos[2][2]

	vim.api.nvim_buf_set_text(0, eRow, eCol, eRow, eCol + pos[4], {''})
	vim.api.nvim_buf_set_text(0, sRow, sCol, sRow, sCol + pos[3], {''})

end

local function get_input()
	vim.ui.input({ prompt = 'Delete surrounding: ' }, function(input)
		if input == nil then return end
		DeleteSurround(input)
	end)

end

vim.api.nvim_create_user_command('DeleteSurround',
	function ()
		get_input()
	end,
	{ nargs = 0 })
