tas = tas or {}
local oldPlayerControls = {}
---@type table<tas.CONTROLS, Set<tas.ControlListenerCallback>>
local controlListeners = {}

---@alias tas.ControlListenerCallback fun(player: unknown, pressed: boolean):void
---@alias Set<T> table<T, boolean>

---@enum tas.CONTROLS
tas.CONTROLS = {
	up = 0,
	down = 1,
	left = 2,
	right = 3,
	jump = 4,
	aux1 = 5,
	sneak = 6,
	dig = 7,
	place = 8,
	zoom = 9,
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
		local controlBitmask = bit.rshift(1, controlBitIndex)
		local changed = bit.band(changedControls, controlBitmask) ~= 0
		local pressed = bit.band(newControls, controlBitmask) ~= 0

		if changed then
			local listeners = controlListeners[controlBitIndex]
			if listeners then
				for callback in pairs(listeners) do
					callback(player, pressed)
				end
			end
		end
	end
end

minetest.register_globalstep(function()
	tas.array.forEach(minetest.get_connected_players(), callControlListeners)
end)

--- Registers a control listener
---@param control tas.CONTROLS
---@param callback tas.ControlListenerCallback
function tas.addControlListener(control, callback)
	local listeners = controlListeners[keyName]
	listeners[callback] = true
end

--- Unregisters a control listener.
---@param control tas.CONTROLS
---@param callback tas.ControlListenerCallback
function tas.removeControlListener(control, callback)
	local listeners = controlListeners[keyName]
	listeners[callback] = nil
end
