-------------------------------------------------------------------------------
-- LaTeX Make Set Plugin                                                    --
-------------------------------------------------------------------------------
require('custom.utils.GetInput')

function MakeSet()
	local args = {GetInput('Element'), GetInput('Condition')}
	if args[1] == nil or args[2] == nil then return end
	local elem = args[1]
	local cond = args[2]
	local set = '\\lbrace '..elem..' : '..cond..' \\rbrace'
	local pos = vim.api.nvim_win_get_cursor(0)
	local row = pos[1] - 1
	local col = pos[2] + 1

	if cond == '' then
		set = '\\lbrace '..elem..' \\rbrace'
	end

	vim.api.nvim_buf_set_text(0, row, col, row, col, {set})
	vim.api.nvim_input(#set..'la')

end

vim.api.nvim_create_user_command('MakeSet',
function ()
	MakeSet()
end,
{ nargs = 0 })
