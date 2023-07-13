--- Table containing all possible offsets for neighboring nodes.
local neighborPositions = {
	vector.new(1, 0, 0), -- 	+x
	vector.new(-1, 0, 0), -- 	-x
	vector.new(0, 1, 0), -- 	+y
	vector.new(0, -1, 0), -- 	-y
	vector.new(0, 0, 1), -- 	+z
	vector.new(0, 0, -1), -- 	-z
}

--- Table containing all allowed ores to be mined.
local allowedOres = {
	"iron",
	"diamond",
	"coal",
}

local blockMineLimit = 5

--- Recursively search for and mine any neighboring nodes of the same given node.
---@param pos any
---@param node any
---@param visitedPositions? table
---@return integer minedBlocks The number of blocks mined.
local function recursive_mine(pos, node, visitedPositions)
	local minedBlocks = 0
	visitedPositions = visitedPositions or {}

	for _, neighborPos in ipairs(neighborPositions) do
		local minePosition = pos + neighborPos
		if not visitedPositions[minePosition] then
			local neighborNode = minetest.get_node(minePosition)
			if neighborNode.name == node.name then
				visitedPositions[minePosition] = true

				local mined = minetest.dig_node(pos + neighborPos)
				if mined then
					minedBlocks = minedBlocks + 1
					if minedBlocks >= blockMineLimit then
						return minedBlocks
					end
					minetest.debug(minedBlocks)
					minedBlocks = minedBlocks
						+ recursive_mine(
							pos + neighborPos,
							neighborNode,
							visitedPositions
						)
				end
			end
		end
	end

	return minedBlocks
end

local function on_ore_digged(pos, oreNode, digger)
	if not digger then
		return
	end

	local totalMinedBlocks = recursive_mine(pos, oreNode)
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
		local validOre = false
		for _, oreName in ipairs(allowedOres) do
			if nodeName:find(("%s$"):format(oreName)) then
				validOre = true
				break
			end
		end

		if nodeName:find("_with_.") and validOre then
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
