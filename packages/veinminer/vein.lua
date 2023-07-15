---@module 'veinminer.repositories.settings'
local veinminerSettings = tas.require("repositories/settings")

local deltaX = { 1, 0, 0, -1, 0, 0, 1, 1, 0, -1, -1, 0, 1, 1, 0, -1, -1, 0, 1, -1, 1, 1, -1, -1, 1, -1 }
local deltaY = { 0, 1, 0, 0, -1, 0, 1, 0, 1, 1, 0, -1, -1, 0, 1, -1, 0, -1, 1, 1, -1, 1, -1, 1, -1, -1 }
local deltaZ = { 0, 0, 1, 0, 0, -1, 0, 1, 1, 0, 1, 1, 0, -1, -1, 0, -1, -1, 1, 1, 1, -1, 1, -1, -1, -1 }

local neighbourOffsets = {}
for i = 1, #deltaX do
	neighbourOffsets[i] = vector.new(deltaX[i], deltaY[i], deltaZ[i])
end

--- Iterates local vectors around the origin of a 3 dimensional array
---@param startPos unknown
---@param nodeName string
---@param maxNodes integer
---@param predicate fun(vector: unknown)
---@return function
local function iterateVein(startPos, nodeName, maxNodes, predicate)
	local queue = tas.Queue.new()
	local visitedPositions = {}
	local totalVisitedBlocks = 0

	local function visit(pos)
		local hashedPosition = minetest.hash_node_position(pos)
		if visitedPositions[hashedPosition] then
			return
		end

		visitedPositions[hashedPosition] = true

		totalVisitedBlocks = totalVisitedBlocks + 1
		queue:Enqueue(pos)
		predicate(pos)
	end

	visit(startPos)

	while queue:Size() > 0 do
		local pos = queue:Dequeue()

		for _, offset in ipairs(neighbourOffsets) do
			if totalVisitedBlocks >= maxNodes then
				return
			end

			local neighbourPos = vector.add(pos, offset)
			local neighbourNode = minetest.get_node(neighbourPos)

			if neighbourNode.name == nodeName then
				visit(neighbourPos)
			end
		end
	end
end

local function mineVein(pos, nodeType, tool)
	local itemDrops = {}
	local totalBlocks = 0
	local digSimulation = minetest.get_dig_params(
		minetest.registered_nodes[nodeType].groups or {},
		tool:get_tool_capabilities(),
		0 -- Zero reference wear as we need to multiply for the number of blocks below
	)

	iterateVein(pos, nodeType, veinminerSettings:getMaxNodes(), function(foundNodePos)
		minetest.remove_node(foundNodePos)

		local droppedItems = minetest.get_node_drops(nodeType, tool:get_name() or "")
		tas.array.append(itemDrops, droppedItems)

		totalBlocks = totalBlocks + 1
	end)

	return itemDrops, tool:get_wear() + digSimulation.wear * totalBlocks
end

return mineVein
