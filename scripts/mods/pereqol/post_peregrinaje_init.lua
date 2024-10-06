local mod = get_mod("pereqol")


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
    local skipMiasma = mod:get("disable_nurgle_miasma")
    local skipTzeentchSizes = mod:get("disable_tzeentch_sizes")

    local reward_modifiers = {
        DoubleChest = 1,
        Dinero = 1,
        DineroPlus = 2,
        increased_grenades = 1,
        MoreBadges = 1,
        increased_healing = 1,
    }
    local hard_modifiers = {
        "deus_more_hordes",
        "deus_more_specials",
        "deus_more_elites", 
        "deus_more_roamers",
        "deus_more_monsters",
        "powerful_elites", 
        "no_respawn",
        "curse_belakors_shadows"
    }
    local easy_modifiers = {
        "deus_less_hordes",
        "deus_less_specials",
        "deus_less_elites",
        "deus_less_roamers",
        "MutatorNoRoaming",
        "deus_less_monsters",
    }
    local populate_config = DEUS_MAP_POPULATE_SETTINGS[journey_name] or DEUS_MAP_POPULATE_SETTINGS.default
    local modifiers = populate_config.AVAILABLE_MINOR_MODIFIERS
    local toSet = {}
    for mod_id, modifierList in pairs(modifiers) do
        -- oscuridad - darkness 
        -- curse_belakors_shadows - ulgus deception
        -- no_respawn - abduction
        local replacement = {
            "deus_more_hordes",
            "deus_more_specials",
            "deus_more_elites", 
            "deus_more_roamers",
            "deus_more_monsters",
            "DoubleChest",
            "MoreBadges",
            "DineroPlus",
            "Dinero",
            "increased_deus_soft_currency"
        }
        if skipDarkness and has_value(modifierList, "oscuridad") then  toSet[#toSet+1] = replacement -- skip
        elseif skipAbduction and has_value(modifierList, "no_respawn") then  toSet[#toSet+1] = replacement -- skip
        elseif skipUlgu and has_value(modifierList, "curse_belakors_shadows") then  toSet[#toSet+1] = replacement -- skip
        else
            if difficulty == "cataclysm_3" then
                local newModList = {}
                local hardMods = 0;
                for rewMod, price in pairs(reward_modifiers) do
                    if has_value(modifierList, rewMod) then
                        hardMods = hardMods + price
                    end 
                end
                for x, mod in pairs(modifierList) do
                    if has_value(easy_modifiers, mod) and hardMods > 0 then
                        hardMods = hardMods - 1
                    else    
                        if has_value(hard_modifiers, mod) then
                            hardMods = hardMods - 1
                        end
                        newModList[#newModList + 1] = mod
                    end
                end
                for x, hardmod in pairs(hard_modifiers) do
                    if hardMods > 0 and not has_value(newModList, hardmod) then
                        newModList[#newModList + 1] = hardmod
                        hardMods = hardMods - 1
                    end
                end
                toSet[#toSet+1] = newModList
            else
                toSet[#toSet+1] = modifierList
            end
        end
    end
    DEUS_MAP_POPULATE_SETTINGS[journey_name].AVAILABLE_MINOR_MODIFIERS = toSet

    local toSetCurses = {}
    local curses = populate_config.AVAILABLE_CURSES
    for map_type, godtable in pairs(curses) do
        toSetCurses[map_type] = {}
        for godname, curseList in pairs(godtable) do
            toSetCurses[map_type][godname] = {}
            for curseIdx, curseName in pairs(curseList) do
                if skipMiasma and curseName == "curse_rotten_miasma" then --skip
                elseif skipTzeentchSizes and curseName == "VariableSize" then --skip
                else
                    toSetCurses[map_type][godname][#toSetCurses[map_type][godname] + 1] = curseName
                end
            end
        end
    end
    DEUS_MAP_POPULATE_SETTINGS[journey_name].AVAILABLE_CURSES = toSetCurses
    func(self, run_seed, difficulty, journey_name, dominant_god, initial_own_soft_currency, telemetry_id, with_belakor, mutators, boons)
end)

--mod:hook_disable(DeusRunController, "setup_run")
mod:dofile("scripts/mods/pereqol/rebal/talents")
mod:dofile("scripts/mods/pereqol/climbing_enemies")
mod:dofile("scripts/mods/pereqol/rebal/localization")
mod:dofile("scripts/mods/pereqol/blocking")
mod:dofile("scripts/mods/pereqol/unlock_athanor")
mod:dofile("scripts/mods/pereqol/athanor_traits")
mod:rebal_changes()

mod:hook(BTConditions, "ungor_archer_enter_melee_combat", function (func, blackboard)
    return func(blackboard) or blackboard.fired_first_shot
end)

mod:echo("Added cringe to your pere")
