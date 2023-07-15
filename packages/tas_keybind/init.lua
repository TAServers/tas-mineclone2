tas = tas or {}
tas._oldControls = {}

---@alias tas.KeyListenerCallback fun(player: unknown, pressed: boolean):void
---@alias Set<T> table<T, boolean>

---@type table<tas.CONTROLS, Set<tas.KeyListenerCallback>>
tas.keyListeners = {}
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

local function saveControlsForPlayer(player)
	local playerControls = player:get_player_control_bits()
	local oldControls = tas._oldControls[player:get_player_name()] or 0

	tas._oldControls[player:get_player_name()] = playerControls

	return oldControls, playerControls
end

local function callKeyListeners(player, oldControls, newControls)
	local changedKeys = bit.bxor(newControls, oldControls)

	for controlName, controlBitIndex in pairs(tas.CONTROLS) do
		local controlBitmask = bit.rshift(1, controlBitIndex)
		local changed = bit.band(changedKeys, controlBitmask) ~= 0
		local pressed = bit.band(newControls, controlBitmask) ~= 0

		if changed then
			local listeners = tas.keyListeners[controlBitIndex]
			if listeners then
				for callback in pairs(listeners) do
					callback(player, pressed)
				end
			end
		end
	end
end

minetest.register_globalstep(function()
	for _, player in ipairs(minetest.get_connected_players()) do
		local oldControls, newControls = saveControlsForPlayer(player)
		callKeyListeners(player, oldControls, newControls)
	end
end)

--- Registers a key listener for a control.
---@param control tas.CONTROLS
---@param callback tas.KeyListenerCallback
function tas.registerKeyListener(keyName, callback)
	local listeners = tas.keyListeners[keyName]
	if not listeners then
		listeners = {}
		tas.keyListeners[keyName] = listeners
	end

	listeners[callback] = true
end

--- Unregisters a key listener for a control.
---@param control tas.CONTROLS
---@param callback tas.KeyListenerCallback
function tas.unregisterKeyListener(keyName, callback)
	local listeners = tas.keyListeners[keyName]
	if listeners then
		listeners[callback] = nil
	end
end
