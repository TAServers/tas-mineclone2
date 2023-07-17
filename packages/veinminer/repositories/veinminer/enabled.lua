-- This repository uses MetaDataRefs, which is a Minetest-specific feature that abstracts away persistence and serialization.
local VEINMINER_ENABLED_KEY = "veinminer_enabled"

local function isVeinminerEnabled(player)
	local meta = player:get_meta()
	if not meta then
		return false
	end

	return meta:get_int(VEINMINER_ENABLED_KEY) == 1
end

local function setVeinminerEnabled(player, enabled)
	local meta = player:get_meta()
	if not meta then
		return
	end

	meta:set_int(VEINMINER_ENABLED_KEY, enabled and 1 or 0)
end

return {
	isVeinminerEnabled = isVeinminerEnabled,
	setVeinminerEnabled = setVeinminerEnabled,
}
