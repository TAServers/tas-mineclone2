local settingsRepository = {
	_modStorage = minetest.get_mod_storage(),
}

local DEFAULT_MAX_NODES = 5

function settingsRepository:setMaxNodes(limit)
	self._modStorage:set_int("max_nodes", limit)
end

function settingsRepository:getMaxNodes()
	local max_nodes = self._modStorage:get_int("max_nodes")
	if max_nodes == 0 then
		return DEFAULT_MAX_NODES
	end

	return max_nodes
end

return settingsRepository
