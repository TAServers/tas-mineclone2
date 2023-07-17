local allowedTools = {
	"mcl_tools:.",
}

local function isVeinminerActive(player)
	local tool = player:get_wielded_item()
	if not tool then
		return false
	end

	if not tas.validateNodeType(tool:get_name(), allowedTools) then
		return false
	end

	if not mcl_enchanting.get_enchantments(tool).veinmining then
		return false
	end

	return true
end

return {
	isActive = isVeinminerActive,
}
