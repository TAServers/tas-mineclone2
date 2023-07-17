---@module 'veinminer.repositories.settings'
local veinminerSettings = tas.require("repositories/settings")
---@module 'veinminer.repositories.veinminer'
local veinminer = tas.require("repositories/veinminer")

minetest.register_chatcommand("veinminer", {
	params = "",
	description = "Toggles vein-mining mode.",
	privs = {},
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end

		minetest.debug(dump(veinminer))
		veinminer.setVeinminerEnabled(player, not veinminer.isEnabled(player))
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
