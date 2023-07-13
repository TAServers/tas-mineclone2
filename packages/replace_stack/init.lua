local replace_itemstack = tas.require("replace_itemstack")

minetest.register_on_mods_loaded(function()
	mc2patch.patchAllNodeCallbacks(
		"after_place_node",
		function(_, placer, itemStack)
			replace_itemstack(placer, itemStack)
		end
	)

	mc2patch.patchAllItemCallbacks("on_use", function(itemStack, user)
		replace_itemstack(user, itemStack)
	end)
end)
