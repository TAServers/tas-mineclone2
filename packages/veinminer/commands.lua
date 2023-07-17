---@module 'veinminer.repositories.settings'
local veinminerSettings = tas.require("repositories/settings")

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
