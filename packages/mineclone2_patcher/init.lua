mc2patch = {}

---@alias mc2.Enchantment {name: string, max_level: number, primary: Set<string>, secondary: Set<string>, disallow: Set<string>, incompatible: Set<string>, weight: number, description: string, curse: boolean, on_enchant: fun(itemstack: unknown, level: number), requires_tool: boolean, treasure: boolean, power_range_table: table<number, number>[], inv_combat_tab: boolean, inv_tool_tab: boolean}

--- Patch a definition callback.
---@param definition table
---@param callbackName string
---@param callback function
function mc2patch.patchDefinitionCallback(definition, callbackName, callback)
	local oldCallback = definition[callbackName]
	local delegate = function(...)
		local newReturnValue = callback(oldCallback, ...)
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

--- Adds an enchantment to the game.
---@param enchantmentDefinition mc2.Enchantment
function mc2patch.addEnchantment(name, enchantmentDefinition)
	mcl_enchanting.enchantments[name] = enchantmentDefinition
end
