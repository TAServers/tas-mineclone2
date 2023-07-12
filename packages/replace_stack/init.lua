local function after_node_placed(_, placer, itemstack)
	-- FYI: Minetest removes the current item *after* this hook, so itemstack:get_count() == 1 when it's the last block.
	if
		not placer
		or not itemstack
		or placer:get_player_name() == ""
		or itemstack:get_count() ~= 1
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

	local equivalentStack, equivalentStackIndex
	local currentStackTable = itemstack:to_table()

	for index, otherStack in ipairs(stackList) do
		local otherStackTable = otherStack:to_table()

		-- We don't want to use a normal equality check because this particular class has overrided it to check equal names and counts, but we want only equal names.
		if
			otherStackTable
			and currentStackTable.name == otherStackTable.name
			and currentStackTable.count ~= otherStackTable.count
		then
			equivalentStack = otherStack
			equivalentStackIndex = index
			break
		end
	end

	local currentStackIndex
	for index, otherStack in ipairs(stackList) do
		if itemstack == otherStack then
			currentStackIndex = index
			break
		end
	end

	if not equivalentStack or not currentStackIndex then
		return
	end

	itemstack:add_item(equivalentStack)
	playerInventory:set_stack("main", equivalentStackIndex, ItemStack(nil))

	-- Returning true overrides the default Minetest behavior of taking away 1 item from the stack.
	return true
end

minetest.register_on_mods_loaded(function()
	mc2patch.patchAllNodeCallbacks("after_place_node", after_node_placed)
end)
