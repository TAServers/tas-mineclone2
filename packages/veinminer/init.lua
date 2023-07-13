local mineVein = tas.require("vein")

--- Table containing all allowed nodes to be vein-mined.
local allowedNodes = {
	"mcl_core:stone_with_.",
	"mcl_core:deepslate_with_.",
	"mcl_core:stone",
}

local function on_ore_digged(pos, oreNode, digger)
	if not digger then
		return
	end

	local itemDrops = mineVein(pos, oreNode.name)
	local playerInventory = digger:get_inventory()

	if not playerInventory then
		return
	end

	for _, dropStack in ipairs(itemDrops) do
		playerInventory:add_item("main", dropStack)
	end
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
