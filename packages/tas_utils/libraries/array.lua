return {
	--- Append all the values from array b to array a.
	---@param a table
	---@param b table
	append = function(a, b)
		for _, value in ipairs(b) do
			table.insert(a, value)
		end
	end,

	--- Calls the given callback on each value in the array.
	---@param array table
	---@param callback fun(value:any, index:integer, array:table)
	forEach = function(array, callback)
		for index, value in ipairs(array) do
			callback(value, index, array)
		end
	end,
}
