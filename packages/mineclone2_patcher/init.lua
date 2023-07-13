mc2patch = {}

--- Patch a definition callback.
---@param definition table
---@param callbackName string
---@param callback function
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
end

--- Patches a specific node callback for all registered nodes.
---@param callbackName string
---@param callback function
function mc2patch.patchAllNodeCallbacks(callbackName, callback)
	for _, nodeDefinition in pairs(minetest.registered_nodes) do
		mc2patch.patchDefinitionCallback(nodeDefinition, callbackName, callback)
	end
end

--- Patches a specific item callback for all registered items.
---@param callbackName string
---@param callback function
function mc2patch.patchAllItemCallbacks(callbackName, callback)
	for _, itemDefinition in pairs(minetest.registered_items) do
		mc2patch.patchDefinitionCallback(itemDefinition, callbackName, callback)
	end

	for _, itemDefinition in pairs(minetest.registered_tools) do
		mc2patch.patchDefinitionCallback(itemDefinition, callbackName, callback)
	end
end
