local replace_itemstack = tas.require("replace_itemstack")
local consumeableItemTypes = {
	"mcl_throwing:.",
	"mcl_mobitems:.",
}

minetest.register_on_mods_loaded(function()
	mc2patch.patchAllNodeCallbacks(
		"after_place_node",
		function(_, placer, itemStack)
			replace_itemstack(placer, itemStack)
		end
	)

	for nodeName, nodeDefinition in pairs(minetest.registered_items) do
		if tas.validateNodeType(nodeName, consumeableItemTypes) then
			mc2patch.patchDefinitionCallback(
				nodeDefinition,
				"on_use",
				function(itemStack, user)
					replace_itemstack(user, itemStack)
				end
			)
		end
	end
end)
