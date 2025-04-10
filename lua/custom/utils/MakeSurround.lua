-------------------------------------------------------------------------------
--  Make Surround Utility                                                    --
-------------------------------------------------------------------------------
function MakeSurround(chars)
	local chars_r = ""
	local side = ""
	local brackets_l = {
		["("] = ")",
		["["] = "]",
		["{"] = "}",
		["<"] = ">"
	}

	local brackets_r = {
		[")"] = "(",
		["]"] = "[",
		["}"] = "{",
		[">"] = "<"
	}

	local html = {0, 0}
	for i = #chars, 1, -1 do
		if brackets_l[chars:sub(i,i)] then
			chars_r = chars_r..brackets_l[chars:sub(i,i)]
			side = "left"
		elseif brackets_r[chars:sub(i,i)] then
			chars_r = chars_r..brackets_r[chars:sub(i,i)]
			side = "right"
		else
			chars_r = chars_r..chars:sub(i,i)
		end
		if chars:sub(i,i) == ">" and html[1] == 0 then
			html[2] = i
		elseif chars:sub(i,i) == "<" and html[2] ~= 0 then
			side = "html"
			html[1] = i
		end
	end

	if side == "html" then
		chars_r = chars_r:sub(1, #chars_r - html[2] + 1)
									 .."/"
									 ..chars:sub(html[1] + 1, html[2] - 1)
									 ..chars_r:sub(#chars_r - html[1] + 1)
		return {chars, chars_r}

	elseif side == "right" then
		return {chars_r, chars}

	else
		return {chars, chars_r}

	end
end
