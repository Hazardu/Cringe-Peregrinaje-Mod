local mod = get_mod("pereqol")


-- disable being catapulted when enemies drop at you
-- stopped working since 5.5.0 update dropped
-- mod:hook(BTClimbAction, "_catapult_players", function(func, self, unit, blackboard, data)
--     return
-- end)

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

mod:hook(DeusRunController, "setup_run", function(func, self, run_seed, difficulty, journey_name, dominant_god, initial_own_soft_currency, telemetry_id, with_belakor, mutators, boons)
    local skipUlgu = mod:get("disable_ulgu_modifier")
    local skipDarkness = mod:get("disable_darkness_modifier")
    local skipAbduction = mod:get("disable_no_respawn_modifier")

    local populate_config = DEUS_MAP_POPULATE_SETTINGS[journey_name] or DEUS_MAP_POPULATE_SETTINGS.default
    local modifiers = populate_config.AVAILABLE_MINOR_MODIFIERS
    local toSet = {}
    for mod_id, modifierList in pairs(modifiers) do
        -- oscuridad - darkness 
        -- curse_belakors_shadows - ulgus deception
        -- no_respawn - abduction
        if skipDarkness and has_value(modifierList, "oscuridad") then -- skip
        elseif skipAbduction and has_value(modifierList, "no_respawn") then -- skip
        elseif skipUlgu and has_value(modifierList, "curse_belakors_shadows") then -- skip
        else
            toSet[#toSet+1] = modifierList
        end
    end

    DEUS_MAP_POPULATE_SETTINGS[journey_name].AVAILABLE_MINOR_MODIFIERS = toSet
    
    func(self, run_seed, difficulty, journey_name, dominant_god, initial_own_soft_currency, telemetry_id, with_belakor, mutators, boons)
end)

mod.reserve_space_for_talent = function (talent_name, career_name, row, _icon, _buffer)
    _icon = _icon or "icons_placeholder"
    _buffer = _buffer or "server"
    
    local career_settings = CareerSettings[career_name]
    local character_name = career_settings.profile_name
    local talent_tree_index = career_settings.talent_tree_index
    
    --reserve in TalentIDLookup
    local talent_id = #Talents[character_name] + 101
    TalentIDLookup[talent_name] = {
        talent_id = talent_id,
        hero_name = character_name
    }
    --talent row
    local chartalentTree = TalentTrees[character_name]
    local tidx = chartalentTree[talent_tree_index]
    local column = #tidx[row] + 1
    
    --reserve in TalentTrees
    TalentTrees[character_name][talent_tree_index][row][column] = talent_name
    
    --add to Talents
    Talents[character_name][talent_id] = {
        icon = _icon,
        buffer = _buffer,
        description_values = {},
        buffs = {},
        row = row,
        talent_id = talent_id,
        tree = talent_tree_index,
        coulumn = column,
        num_ranks = 1,
        name = talent_name,
        description = talent_name.."_desc"
    }
    return column
end

mod:dofile("scripts/mods/pereqol/map_patch_utils")
mod:dofile("scripts/mods/pereqol/map_patches")

mod.reserve_space_for_talent("kerillian_waywatcher_passive_restore_ammo", "we_waywatcher", 4, "kerillian_waywatcher_movement_speed_on_special_kill")

mod.on_all_mods_loaded = function()

    local Peregrinaje = get_mod("Peregrinaje")
    if Peregrinaje then
        Peregrinaje.register_callback(function()
            
            -- disable stats by defaut
            Peregrinaje:ToggleStats()
            
            for expedition_name, expedition in pairs(DEUS_MAP_POPULATE_SETTINGS) do
                local modifiers = expedition.AVAILABLE_MINOR_MODIFIERS
                local toSet = {}

                for mod_id, modifierList in pairs(modifiers) do
                    -- oscuridad - darkness 
                    -- curse_belakors_shadows - ulgus deceptions
                    if has_value(modifierList, "oscuridad") or has_value(modifierList, "curse_belakors_shadows") then
                        -- skip
                    else
                        toSet[#toSet+1] = modifierList
                    end
                end
                DEUS_MAP_POPULATE_SETTINGS[expedition_name].AVAILABLE_MINOR_MODIFIERS = toSet
            end

            
            mod:dofile("scripts/mods/pereqol/rebal/talents")
            mod:dofile("scripts/mods/pereqol/climbing_enemies")
            
            mod:rebal_changes()
            -- add to TalentTrees
               --  [dwarf_ranger][subclass][row][last element] = string of talent name
            -- add to TalentIDLookup
                -- [bardin_slayer_push_on_dodge] = table
                --     [talent_id] = 30 (number)
                --     [hero_name] = dwarf_ranger (string)
            -- add to Talents.dwarf_ranger
                -- {
                --     buffer = "server",
                --     description = "vanguard_desc",
                --     icon = "bardin_ironbreaker_regrowth",
                --     name = "bardin_ironbreaker_vanguard",
                --     num_ranks = 1,
                --     description_values = {},
                --     buffs = {
                --         "bardin_ironbreaker_vanguard",
                --     },
                -- },
            -- add to TalentBuffTemplates.dwarf_ranger
                -- bardin_ironbreaker_ability_cooldown_on_hit = {
                    -- buffs = {
                    --     {
                    --         buff_func = "reduce_activated_ability_cooldown",
                    --         event = "on_hit",
                    --     },
                    -- },

            -- BuffUtils.copy_talent_buff_names(TalentBuffTemplates.dwarf_ranger)
            -- BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.dwarf_ranger, buff_tweak_data)
        end)
    end

end
