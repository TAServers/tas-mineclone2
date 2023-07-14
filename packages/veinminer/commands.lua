---@module 'veinminer.hud'
local huds = tas.require("hud")
---@module 'veinminer.repositories.settings'
local veinminerSettings = tas.require("repositories/settings")

local function on_veinminer_enabled_changed(player)
	local hud = huds.getHUD(player)
	if not hud then
		return
	end

	hud:UpdateText()
end

minetest.register_chatcommand("veinminer", {
	params = "",
	description = "Toggles vein-mining mode.",
	privs = {},
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end

		local meta = player:get_meta()
		local veinminerEnabled = meta:get_int("veinminer_enabled") == 1
		meta:set_int("veinminer_enabled", veinminerEnabled and 0 or 1)
		on_veinminer_enabled_changed(player)
	end,
})

minetest.register_chatcommand("veinminer_maxnodes", {
	params = "<max_nodes>",
	description = "Sets the maximum amount of nodes to be vein-mined. Must have server privs.",
	privs = {
		server = true,
	},
	func = function(name, param)
		local maxNodes = tonumber(param)
		if not maxNodes then
			return
		end

		veinminerSettings:setMaxNodes(maxNodes)
	end,
})
