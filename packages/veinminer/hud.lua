---@class VeinminerHUD
--- Per-player instance which handles the player's HUD for Veinminer
local VeinminerHUD = {}
VeinminerHUD.__index = VeinminerHUD

function VeinminerHUD.new(player)
	local hud = {
		_player = player,
		_hudIndex = nil,
	}

	hud._hudIndex = player:hud_add({
		hud_elem_type = "text",
		position = {
			x = 0.5,
			y = 0.5,
		},
		offset = {
			x = 0,
			y = 0,
		},
		alignment = {
			x = 1,
			y = 1,
		},
		scale = {
			x = 100,
			y = 100,
		},
		text = "",
	})

	hud = setmetatable(hud, VeinminerHUD)
	hud:UpdateText()

	return hud
end

function VeinminerHUD:UpdateText()
	local meta = self._player:get_meta()
	local veinminerEnabled = meta:get_int("veinminer_enabled") == 1

	if veinminerEnabled then
		self._player:hud_change(self._hudIndex, "text", "Veinminer: Enabled")
	else
		self._player:hud_change(self._hudIndex, "text", "Veinminer: Disabled")
	end
end

---@type table<string, VeinminerHUD>
local huds = {}

minetest.register_on_joinplayer(function(player)
	huds[player:get_player_name()] = VeinminerHUD.new(player)
end)

minetest.register_on_leaveplayer(function(player)
	huds[player:get_player_name()] = nil
end)

--- Retrieves the HUD for the given player.
---@param player any
---@return VeinminerHUD
local function getHUD(player)
	return huds[player:get_player_name()]
end

return {
	getHUD = getHUD,
}
