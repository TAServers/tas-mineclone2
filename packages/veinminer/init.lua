---@module 'veinminer.vein'
local mineVein = tas.require("vein")
tas.require("commands")

--- Table containing all allowed tools to be used for vein-mining.
local allowedTools = {
	"mcl_tools:.",
}

local function on_ore_digged(old_on_dig, pos, oreNode, digger)
	if not digger then
		return
	end

	if old_on_dig then
		local diggerMeta = digger:get_meta()
		if not diggerMeta then
			-- Implictly means that Veinminer is disabled since this user has never toggled it.
			return old_on_dig(pos, oreNode, digger)
		end

		local veinminer_enabled = digger:get_meta():get_int("veinminer_enabled")
			== 1

		if not veinminer_enabled then
			return old_on_dig(pos, oreNode, digger)
		end
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

	tas.array.forEach(itemDrops, function(itemDrop)
		minetest.add_item(pos, itemDrop)
	end)

	tool:set_wear(newToolWear)
	playerInventory:set_stack("main", toolIndex, tool)
end

minetest.register_on_mods_loaded(function()
	for nodeName, nodeDefinition in pairs(minetest.registered_nodes) do
		mc2patch.patchDefinitionCallback(
			nodeDefinition,
			"on_dig",
			on_ore_digged
		)
	end
end)
