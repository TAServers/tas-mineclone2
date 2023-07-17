---@module 'veinminer.repositories.veinminer'
local veinminer = tas.require("repositories/veinminer")

---@class VeinminerHUD
--- Per-player instance which handles the player's HUD for Veinminer
local VeinminerHUD = {}
VeinminerHUD.__index = VeinminerHUD

local ICON_SCALE = 0.47

function VeinminerHUD.new(player)
	local hud = {
		_player = player,
		_hudIndex = nil,
	}

	hud._hudIndex = player:hud_add({
		hud_elem_type = "image",
		scale = { x = ICON_SCALE, y = ICON_SCALE },
		-- MineClone2 uses constant pixel offsets instead of screen-relative positions.
		position = {
			x = 0.5,
			y = 0,
		},
		offset = {
			x = 500,
			y = 300,
		},
		alignment = {
			x = 0.5,
			y = 0.5,
		},
		text = "veinminer_on.png",
	})

	hud = setmetatable(hud, VeinminerHUD)
	hud:Update()

	return hud
end

function VeinminerHUD:Update(active)
	if active then
		self._player:hud_change(self._hudIndex, "scale", { x = ICON_SCALE, y = ICON_SCALE })
	else
		self._player:hud_change(self._hudIndex, "scale", { x = 0, y = 0 })
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

veinminer.registerOnActiveChanged(function(player, active)
	local hud = huds[player:get_player_name()]
	if hud then
		hud:Update(active)
	end
end)
