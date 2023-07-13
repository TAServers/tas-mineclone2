local mineVein = tas.require("vein")

--- Table containing all allowed nodes to be vein-mined.
local allowedNodes = {
	".",
}

--- Table containing all allowed tools to be used for vein-mining.
local allowedTools = {
	"mcl_tools:.",
}

local function on_ore_digged(pos, oreNode, digger)
	if not digger then
		return
	end

	local tool = digger:get_wielded_item()
	local toolIndex = digger:get_wield_index()
	if not tool or not tas.validateNodeType(tool:get_name(), allowedTools) then
		return
	end

	local itemDrops, newToolWear = mineVein(pos, oreNode.name, tool)
	local playerInventory = digger:get_inventory()

	if not playerInventory then
		return
	end

	for _, dropStack in ipairs(itemDrops) do
		playerInventory:add_item("main", dropStack)
	end

	tool:set_wear(newToolWear)
	playerInventory:set_stack("main", toolIndex, tool)
end

minetest.register_on_mods_loaded(function()
	for nodeName, nodeDefinition in pairs(minetest.registered_nodes) do
		if tas.validateNodeType(nodeName, allowedNodes) then
			mc2patch.patchDefinitionCallback(
				nodeDefinition,
				"on_dig",
				function(pos, node, digger)
					on_ore_digged(pos, node, digger)
				end
			)
		end
	end
end)
