---@module 'veinminer.repositories.veinminer.active'
local active = tas.require("repositories/veinminer/active")

---@module 'veinminer.repositories.veinminer.enabled'
local enabled = tas.require("repositories/veinminer/enabled")

return {
	isActive = active.isVeinminerActive,
	isEnabled = enabled.isVeinminerEnabled,
	registerOnActiveChanged = active.registerOnActiveChanged,
	setVeinminerEnabled = enabled.setVeinminerEnabled,
}
