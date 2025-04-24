-------------------------------------------------------------------------------
-- Get Input Utility                                                         --
-------------------------------------------------------------------------------
function GetInput(prompt)
	local ret
	local function makeRet(input)
		 ret = input
	end

	vim.ui.input({ prompt = prompt..': ' }, function(input)
		if input == nil then return end
		makeRet(input)
	end)

	return ret
end
