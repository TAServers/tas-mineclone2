--- Filters an array given a predicate function
---@param array table
---@param predicate fun(value: unknown, index: number):boolean
---@return table<number, unknown>
local function filter(array, predicate)
	local result = {}

	for index, value in ipairs(array) do
		if predicate(value, index) then
			table.insert(result, value)
		end
	end

	return result
end

return {
	filter = filter,
}
