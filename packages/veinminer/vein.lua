--- Table containing all possible offsets for neighboring nodes.
local neighborOffsets = {}
do
	local axisValues = { -1, 0, 1 }

	for _, x in ipairs(axisValues) do
		for _, y in ipairs(axisValues) do
			for _, z in ipairs(axisValues) do
				if x ~= 0 or y ~= 0 or z ~= 0 then
					table.insert(neighborOffsets, vector.new(x, y, z))
				end
			end
		end
	end
end

local function iterateVein(startPos, oreType, maxNodes)
	local queue = tas.Queue.new()
	local visitedPositions = {}
	local totalVisitedBlocks = 0

	local function addPosition(newPosition)
		if visitedPositions[newPosition] then
			return
		end

		queue:Enqueue(newPosition)
		visitedPositions[newPosition] = true
	end

	addPosition(startPos)

	return function()
		if queue:Size() <= 0 or totalVisitedBlocks >= maxNodes then
			return nil
		end

		local currentPosition = queue:Dequeue()

		for _, offset in ipairs(neighborOffsets) do
			local neighborPosition = vector.add(currentPosition, offset)
			local neighborNode = minetest.get_node(neighborPosition)

			if neighborNode.name == oreType then
				addPosition(neighborPosition)
			end
		end

		totalVisitedBlocks = totalVisitedBlocks + 1
		return currentPosition
	end
end

local function mineVein(pos, oreType, toolUsed)
	local itemDrops = {}
	for currentPosition in iterateVein(pos, oreType, 5) do
		minetest.remove_node(currentPosition)

		local droppedItems = minetest.get_node_drops(oreType, toolUsed or "")
		for _, droppedItem in ipairs(droppedItems) do
			table.insert(itemDrops, ItemStack(droppedItem))
		end
	end

	return itemDrops
end

return mineVein
