local mod = get_mod("pereqol")

mod:hook(HeroWindowWeaveProperties, "_magic_level", function(func,self) 
    return 30
end)

mod:hook(BackendInterfaceWeavesPlayFab, "get_mastery", function (func, self, career_name, optional_item_backend_id)
	local mastery_settings = WeaveMasterySettings
	local loadout = self._loadouts[career_name]
	local initial_mastery = 3200
    local cost = loadout and self:_get_loadout_mastery_cost(loadout) or 0
    if loadout then
        if loadout.slot_ranged then
            local loadout_weapon_ranged = loadout.item_loadouts[loadout.slot_ranged]
            if loadout_weapon_ranged then
                cost = cost + self:_get_loadout_mastery_cost(loadout_weapon_ranged)
            end
        end
        if loadout.slot_melee then
            local loadout_weapon_melee = loadout.item_loadouts[loadout.slot_melee] 
            if loadout_weapon_melee then
                cost = cost + self:_get_loadout_mastery_cost(loadout_weapon_melee)
            end
        end
    end
	local current_mastery = initial_mastery - cost    
	return initial_mastery, current_mastery
end)

