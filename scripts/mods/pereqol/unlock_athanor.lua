local mod = get_mod("pereqol")

mod:hook(HeroWindowWeaveProperties, "_magic_level", function(func,self) 
    return 30
end)
`


mod:hook(BackendInterfaceWeavesPlayFab, "get_mastery", function (func, self, career_name, optional_item_backend_id)
	local mastery_settings = WeaveMasterySettings
	local loadout = self._loadouts[career_name]
	local initial_mastery = 3000

	if optional_item_backend_id then
		loadout = loadout.item_loadouts[optional_item_backend_id]

		local magic_level = self:get_item_magic_level(optional_item_backend_id)

	else
		local magic_level = self:get_career_magic_level(career_name)

	end

	local total_cost = loadout and self:_get_loadout_mastery_cost(loadout) or 0
	local current_mastery = initial_mastery - total_cost

	return initial_mastery, current_mastery
end)