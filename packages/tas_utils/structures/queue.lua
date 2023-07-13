---@class tas.Queue
---@field private _data table
local Queue = {}
Queue.__index = Queue

function Queue.new()
	local queue = {
		_data = {},
	}

	return setmetatable(queue, Queue)
end

--- Returns the number of elements in the queue.
---@return integer
function Queue:size()
	return #self._data
end

function Queue:Enqueue(value)
	table.insert(self._data, value)
end

function Queue:Dequeue()
	return table.remove(self._data, 1)
end

return Queue
