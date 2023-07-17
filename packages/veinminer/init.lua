---@module 'veinminer.repositories.veinminer'
local veinminer = tas.require("repositories/veinminer")

---@module 'veinminer.vein'
local mineVein = tas.require("vein")
tas.require("commands")

local allowedTools = {
	"mcl_tools:.",
}

local function onDig(oldOnDig, pos, oreNode, digger)
	if not digger then
		return
	end

	if oldOnDig and not veinminer.isActive(digger) then
		return oldOnDig(pos, oreNode, digger)
	end

	local tool = digger:get_wielded_item()
	local toolIndex = digger:get_wield_index()
	if not tool or not tas.validateNodeType(tool:get_name(), allowedTools) then
		return
	end

	local playerInventory = digger:get_inventory()
	if not playerInventory then
		return
	end

	local itemDrops, newToolWear = mineVein(pos, oreNode.name, tool)

	if not minetest.is_creative_enabled(digger:get_player_name()) then
		tas.array.forEach(itemDrops, function(itemDrop)
			minetest.add_item(pos, itemDrop)
		end)

		tool:set_wear(newToolWear)
		playerInventory:set_stack("main", toolIndex, tool)
	end
end

minetest.register_on_mods_loaded(function()
	for nodeName, nodeDefinition in pairs(minetest.registered_nodes) do
		mc2patch.patchDefinitionCallback(nodeDefinition, "on_dig", onDig)
	end
end)
