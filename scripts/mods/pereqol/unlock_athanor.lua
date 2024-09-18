local mod = get_mod("pereqol")

mod.set_unlock_levels = function()
    local progression_properties = WeaveWeaponProgression.properties

    if progression_properties then
        for _, slot_unlock in ipairs(progression_properties) do
            slot_unlock.unlock_level = 1
        end
    end

    local progression_traits = WeaveWeaponProgression.traits

    if progression_traits then
        for _, slot_unlock in ipairs(progression_traits) do
            slot_unlock.unlock_level = 1
        end
    end
    local career_progression_properties = WeaveCareerProgression.properties

    if career_progression_properties then
        for _, slot_unlock in ipairs(career_progression_properties) do
            slot_unlock.unlock_level = 1
        end
    end
    local career_progression_traits = WeaveCareerProgression.traits

    if career_progression_traits then
        for _, slot_unlock in ipairs(career_progression_traits) do
            slot_unlock.unlock_level = 1
        end
    end
end

mod.set_unlock_levels()

mod:hook(HeroWindowWeaveProperties, "_create_slot_grid", function (func, self, slot_layout, slots_progression) 
    mod:echo("printing slots progression on _create_slot_grid")
    mod:dump(slots_progression, "slots_progression123", 10)
    if slots_progression.properties then
        for _, slot_unlock in ipairs(slots_progression.properties) do
            slot_unlock.unlock_level = 1
        end
    end

    if slots_progression.traits then
        for _, slot_unlock in ipairs(slots_progression.traits) do
            slot_unlock.unlock_level = 1
        end
    end

    return func(self,slot_layout, slots_progression)
end) 


mod:hook(HeroWindowWeaveProperties, "_setup_menu_options", function (func, self, career_name, slots_progression) 
    if slots_progression.properties then
        for _, slot_unlock in ipairs(slots_progression.properties) do
            slot_unlock.unlock_level = 1
        end
    end

    if slots_progression.traits then
        for _, slot_unlock in ipairs(slots_progression.traits) do
            slot_unlock.unlock_level = 1
        end
    end
    func(self, career_name, slots_progression)
end)


mod:hook(HeroWindowWeaveProperties, "on_enter", function (func, self, params, offset) 
    mod.set_unlock_levels()
    func(self,params,offset) 

end)
