-------------------------------------------------------------------------------
--  Text Object Motion Plugin                                                --
-------------------------------------------------------------------------------
function TextObjMotion(opts)
	local usage = 'usage: :TextObjMotion <colection_type><character>'
	if #opts.args ~= 2 then
		print("argument must consist of two characters\n"..usage)
		return
	end

	local l_shift
	local r_shift
	if opts.args:sub(1,1) == 'i' then
		l_shift = 0
		r_shift = 2
	elseif opts.args:sub(1,1) == 'a' then
		l_shift = 1
		r_shift = 1
	else
		print("first character must be either 'a' or 'i'\n"..usage)
		return
	end
	local pos = vim.fn.getpos('.')
	local line = vim.api.nvim_buf_get_lines(0, pos[2] - 1, pos[2], true)[1]

	if line:sub(pos[3], pos[3]) == opts.args:sub(2,2) then
		print("error: cursor must be inside surrounding character")
		return
	end

	local function check_left ()
		local i = pos[2]
		local j = pos[3]
		while i > 0 do
			while j >= 0 do
				if line:sub(j,j) == opts.args:sub(2,2) then
					vim.api.nvim_buf_set_mark(0, "[", i, j - l_shift, {})
					return true
				end
				j = j - 1
			end
			if i - 1 < 0 then
				print("error: no surrounding character found to the left")
				return false
			end
			i = i - 1
			line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
			j = #line
		end
	end

	if check_left() == false then
		return
	end

	local last_line = vim.fn.getpos('$')[2]
	line = vim.api.nvim_buf_get_lines(0, pos[2] - 1, pos[2], true)[1]

	local function check_right ()
		local i = pos[2]
		local j = pos[3]
		while i <= last_line do
			while j <= #line do
				if line:sub(j,j) == opts.args:sub(2,2) then
					vim.api.nvim_buf_set_mark(0, "]", i, j - r_shift, {})
					return true
				end
				j = j + 1
			end
			if i + 1 > last_line then
				print("error: no surrounding character found to the right")
				return false
			end
			i = i + 1
			line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
			j = 0
		end
	end

	if check_right() == false then
		return
	end

	vim.cmd.normal('`[v`]')
end

vim.api.nvim_create_user_command('TextObjMotion',
	function (opts)
		TextObjMotion(opts)
	end,
	{ nargs = 1 })
