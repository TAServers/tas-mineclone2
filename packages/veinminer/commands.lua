---@module 'veinminer.hud'
local huds = tas.require("hud")

local function on_veinminer_enabled_changed(player)
	local hud = huds[player:get_player_name()]
	if not hud then
		return
	end

	hud:UpdateText()
end

minetest.register_chatcommand("veinminer", {
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
