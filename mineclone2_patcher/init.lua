mc2patch = {}

--- Patch a node callback.
---@param definition table
---@param callbackName string
---@param callback function
function mc2patch.patchNodeCallback(definition, callbackName, callback)
	local oldCallback = definition[callbackName]
	local delegate = function(...)
		if oldCallback then
			oldCallback(...)
		end

		return callback(...)
	end

	rawset(definition, callbackName, delegate)
end

--- Patches a specific node callback for all registered nodes.
---@param callbackName string
---@param callback function
function mc2patch.patchAllNodeCallbacks(callbackName, callback)
	for _, nodeDefinition in pairs(minetest.registered_nodes) do
		mc2patch.patchNodeCallback(nodeDefinition, callbackName, callback)
	end
end
