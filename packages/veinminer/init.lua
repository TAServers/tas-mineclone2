--- Table containing all possible offsets for neighboring nodes.
local neighborPositions = {}
do
	local axisValues = { -1, 0, 1 }

	for _, x in ipairs(axisValues) do
		for _, y in ipairs(axisValues) do
			for _, z in ipairs(axisValues) do
				if x ~= 0 or y ~= 0 or z ~= 0 then
					table.insert(neighborPositions, vector.new(x, y, z))
				end
			end
		end
	end
end

--- Table containing all allowed nodes to be vein-mined.
local allowedNodes = {
	"mcl_core:stone_with_.",
	"mcl_core:deepslate_with_.",
	"mcl_core:stone",
}

local veinLimit = 5
local function mineVein(pos, oreType)
	local totalMinedBlocks = 0
	local visitedPositions = {}
	local queue = tas.Queue.new()

	local function addPosition(newPosition)
		if visitedPositions[newPosition] then
			return
		end

		queue:Enqueue(newPosition)
		visitedPositions[newPosition] = true
	end

	addPosition(pos)

	while queue:size() > 0 and totalMinedBlocks < veinLimit do
		local currentPosition = queue:Dequeue()

		for _, neighborPosition in ipairs(neighborPositions) do
			local neighborNode =
				minetest.get_node(vector.add(currentPosition, neighborPosition))

			if neighborNode.name == oreType then
				addPosition(vector.add(currentPosition, neighborPosition))
			end
		end

		minetest.remove_node(currentPosition)
		totalMinedBlocks = totalMinedBlocks + 1
	end

	return totalMinedBlocks
end

local function on_ore_digged(pos, oreNode, digger)
	if not digger then
		return
	end

	local totalMinedBlocks = mineVein(pos, oreNode.name)
	local playerInventory = digger:get_inventory()

	if not playerInventory then
		return
	end

	local totalItemStack = ItemStack(oreNode.name)
	totalItemStack:set_count(totalMinedBlocks)

	playerInventory:add_item("main", totalItemStack)
end

minetest.register_on_mods_loaded(function()
	for nodeName, nodeDefinition in pairs(minetest.registered_nodes) do
		local validNode = false
		for _, typePattern in ipairs(allowedNodes) do
			if nodeName:find(typePattern) then
				validNode = true
				break
			end
		end

		if validNode then
			mc2patch.patchDefinitionCallback(
				nodeDefinition,
				"after_dig_node",
				function(pos, node, _, digger)
					on_ore_digged(pos, node, digger)
				end
			)
		end
	end
end)
