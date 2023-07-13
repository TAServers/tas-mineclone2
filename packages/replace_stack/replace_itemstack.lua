local array = tas.require("array")

--- Finds an equivalent ItemStack given an ItemStack and a list of ItemStacks. Returns nil if no equivalent ItemStack is found.
---@param wieldStack any
---@param stackList table<number, any>
---@return any
local function findEquivalentItemStack(wieldStack, wieldIndex, stackList)
	local equivalentStacks = array.filter(stackList, function(stack, idx)
		return stack:get_name() == wieldStack:get_name() and idx ~= wieldIndex
	end)

	local maxCount = -1
	local maximumStack = nil

	for _, equivalentStack in ipairs(equivalentStacks) do
		local count = equivalentStack:get_count()
		if count > maxCount then
			maxCount = count
			maximumStack = equivalentStack
		end
	end

	return maximumStack
end

return function(placer, wieldStack)
	-- FYI: Minetest removes the current item *after* this hook, so wieldStack:get_count() == 1 when it's the last block.
	if
		not placer
		or not wieldStack
		or placer:get_player_name() == ""
		or wieldStack:get_count() ~= 1
	then
		return
	end

	local playerInventory = minetest.get_inventory({
		type = "player",
		name = placer:get_player_name(),
	})

	if not playerInventory then
		return
	end

	local stackList = playerInventory:get_list("main")
	if not stackList then
		return
	end

	local wieldIndex = placer:get_wield_index()
	local equivalentStack =
		findEquivalentItemStack(wieldStack, wieldIndex, stackList)
	if not equivalentStack then
		return
	end

	local newItems = equivalentStack:take_item(equivalentStack:get_count())
	wieldStack:add_item(newItems)

	playerInventory:set_list("main", stackList)

	-- Returning true overrides the default Minetest behavior of taking away 1 item from the stack.
	return true
end
