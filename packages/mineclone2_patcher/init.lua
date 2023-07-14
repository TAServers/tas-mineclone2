mc2patch = {}

--- Patch a definition callback.
---@param definition table
---@param callbackName string
---@param callback function
---@return function|nil oldCallback The replaced callback, or nil if there was no previous callback.
function mc2patch.patchDefinitionCallback(definition, callbackName, callback)
	local oldCallback = definition[callbackName]
	local delegate = function(...)
		local newReturnValue = callback(...)
		if newReturnValue ~= nil then
			return newReturnValue
		end

		if oldCallback then
			return oldCallback(...)
		end
	end

	rawset(definition, callbackName, delegate)
	return oldCallback
end

--- Patches a specific node callback for all registered nodes.
---@param callbackName string
---@param callback function
function mc2patch.patchAllNodeCallbacks(callbackName, callback)
	for _, nodeDefinition in pairs(minetest.registered_nodes) do
		mc2patch.patchDefinitionCallback(nodeDefinition, callbackName, callback)
	end
end
