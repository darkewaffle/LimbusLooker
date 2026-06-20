-- table.move was added in Lua 5.3 and Windower runs on Lua 5.1
-- This 5.1 compatible implementation was copied from https://github.com/lunarmodules/lua-compat-5.3/blob/master/compat53/module.lua#L294
-- Some modifications were made to reduce dependencies (but also error checking so buyer beware of what you provide as arguments)

-- TableMove(SourceTable, RangeStart, RangeEnd, NewRangeStart, ResultTable)
function TableMove(a1, f, e, t, a2)
	a2 = a2 or a1

	if e >= f then
		local m, n, d = 0, e-f, 1

		if t > f then
			m, n, d = n, m, -1
		end

		for i = m, n, d do
			a2[t+i] = a1[f+i]
		end
	
	end

	return a2
end