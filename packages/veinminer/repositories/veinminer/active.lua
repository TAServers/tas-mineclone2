---@module 'veinminer.repositories.veinminer.enabled'
local veinminerEnabled = tas.require("repositories/veinminer/enabled")
local CONTROL = tas.CONTROLS.SNEAK
local playersUsingControl = {}

---@alias veinminer.OnActiveChanged fun(player: unknown, active: boolean)
---@type Set<veinminer.OnActiveChanged>
local activeChangedListeners = {}

local function invokeActiveChangedListeners(player, active)
	for callback in pairs(activeChangedListeners) do
		callback(player, active)
	end
end

local function isVeinminerActive(player)
	return (playersUsingControl[player:get_player_name()] or false) and veinminerEnabled.isVeinminerEnabled(player)
end

local function onControl(player, pressed)
	playersUsingControl[player:get_player_name()] = pressed
	invokeActiveChangedListeners(player, isVeinminerActive(player))
end

--- Registers a callback that is called if any player activates or deactivates veinmining.
---@param callback veinminer.OnActiveChanged
local function registerOnActiveChanged(callback)
	activeChangedListeners[callback] = true
end

tas.addControlListener(CONTROL, onControl)

return {
	isVeinminerActive = isVeinminerActive,
	registerOnActiveChanged = registerOnActiveChanged,
}
