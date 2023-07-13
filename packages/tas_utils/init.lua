tas = {}
tas._includeCache = {}

--- Simulates Lua's `require` given a file path separated by forward slashes. All paths are relative to the mod directory.
---
--- **This function cannot be used after loading, which is usually in registration functions or callbacks. It's recommended that you only use this function at the top-level scope.**
---
--- Example:
--- ```lua
--- local array = tas.require("array")
--- local someModule = tas.require("modules/someModule")
---
--- ...
--- ```
---@param name string
---@return unknown
function tas.require(name)
	local rootDirectory = minetest.get_modpath(minetest.get_current_modname())
	local path = rootDirectory .. "/" .. name .. ".lua"

	if tas._includeCache[path] then
		return tas._includeCache[path]
	end

	local result = dofile(path)
	tas._includeCache[path] = result

	return result
end

---@module 'structures.queue'
tas.Queue = tas.require("structures/queue")
