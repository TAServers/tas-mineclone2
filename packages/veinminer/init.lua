---@module 'veinminer.repositories.veinminer'
local veinminer = tas.require("repositories/veinminer")

---@module 'veinminer.vein'
local mineVein = tas.require("vein")

tas.require("hud")
tas.require("commands")

local function onDig(oldOnDig, pos, oreNode, digger)
	if not digger then
		return
	end

	if oldOnDig and not veinminer.isActive(digger) then
		return oldOnDig(pos, oreNode, digger)
	end

	local tool = digger:get_wielded_item()
	local toolIndex = digger:get_wield_index()
	if not tool then
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

	mc2patch.addEnchantment("veinmining", {
		name = "Veinmining",
		max_level = 3,
		primary = { pickaxe = true, shovel = true, axe = true, hoe = true },
		secondary = { shears = true },
		disallow = {},
		incompatible = { fortune = true },
		weight = 7,
		description = "Blocks are mined repeatedly with the same tool in a single action.",
		curse = false,
		on_enchant = function()
			minetest.debug("Hi!")
		end,
		requires_tool = true,
		treasure = false,
		power_range_table = { { 5, 61 }, { 13, 71 }, { 21, 81 } },
		inv_combat_tab = false,
		inv_tool_tab = true,
	})
end)
