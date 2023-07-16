tas = tas or {}
local oldPlayerControls = {}
---@type table<tas.CONTROLS, Set<tas.ControlListenerCallback>>
local controlListeners = {}

---@alias tas.ControlListenerCallback fun(player: unknown, pressed: boolean):void
---@alias Set<T> table<T, boolean>

---@enum tas.CONTROLS
tas.CONTROLS = {
	UP = 0,
	DOWN = 1,
	LEFT = 2,
	RIGHT = 3,
	JUMP = 4,
	AUX1 = 5,
	SNEAK = 6,
	--- Equivalent to mouse button 1 (left click)
	DIG = 7,
	--- Equivalent to mouse button 2 (right click)
	PLACE = 8,
	ZOOM = 9,
}

for _, control in pairs(tas.CONTROLS) do
	controlListeners[control] = {}
end

local function getControlChanges(playerName, newControls)
	local oldControls = oldPlayerControls[playerName] or 0
	oldPlayerControls[playerName] = newControls

	return bit.bxor(newControls, oldControls)
end

local function callControlListeners(player)
	local newControls = player:get_player_control_bits()
	local changedControls = getControlChanges(player:get_player_name(), newControls)

	for controlName, controlBitIndex in pairs(tas.CONTROLS) do
		local controlBitmask = bit.lshift(1, controlBitIndex)
		local changed = bit.band(changedControls, controlBitmask) ~= 0
		local pressed = bit.band(newControls, controlBitmask) ~= 0

		if changed then
			local listeners = controlListeners[controlBitIndex]
			for callback in pairs(listeners) do
				callback(player, pressed)
			end
		end
	end
end

minetest.register_globalstep(function()
	tas.array.forEach(minetest.get_connected_players(), callControlListeners)
end)

minetest.register_on_leaveplayer(function(player)
	oldPlayerControls[player:get_player_name()] = nil
end)

--- Registers a control listener
---@param control tas.CONTROLS
---@param callback tas.ControlListenerCallback
function tas.addControlListener(control, callback)
	controlListeners[control][callback] = true
end

--- Unregisters a control listener.
---@param control tas.CONTROLS
---@param callback tas.ControlListenerCallback
function tas.removeControlListener(control, callback)
	controlListeners[control][callback] = nil
end
