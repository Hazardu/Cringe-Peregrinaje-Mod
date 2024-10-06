local mod = get_mod("pereqol")

local includeBuffIntoTraits = function(name, category1, category2, category3)
    local buff = WeaveTraits.traits[name]
    if buff == nil then
        mod:echo(name .. " is null")
        return 
    end
    local categoryTable = WeaveTraits.categories[category1]
    categoryTable[#categoryTable + 1] = name
    if category2 ~= nil then
        categoryTable = WeaveTraits.categories[category2]
        categoryTable[#categoryTable + 1] = name
    end
    if category3 ~= nil then
        categoryTable = WeaveTraits.categories[category3]
        categoryTable[#categoryTable + 1] = name
    end
    for career_name, career_table in pairs(WeaveTraitsByCareer) do
        career_table[name] = buff -- append buff to all careers
    end
end

includeBuffIntoTraits("weave_melee_attack_speed_on_crit", "melee")
includeBuffIntoTraits("weave_melee_timed_block_cost", "melee")
includeBuffIntoTraits("weave_melee_counter_push_power", "melee")
includeBuffIntoTraits("weave_necklace_no_healing_health_regen", "defence_accessory")
includeBuffIntoTraits("weave_necklace_damage_taken_reduction_on_heal", "defence_accessory")
includeBuffIntoTraits("weave_trinket_grenade_damage_taken", "offence_accessory")
includeBuffIntoTraits("weave_trinket_not_consume_grenade", "offence_accessory")
includeBuffIntoTraits("weave_ranged_increase_power_level_vs_armour_crit", "ranged_ammo", "ranged_heat", "ranged_energy")
