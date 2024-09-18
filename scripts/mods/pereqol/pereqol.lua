local mod = get_mod("pereqol")

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end


-- -- Text Localization
-- local _language_id = Application.user_setting("language_id")
-- local _localization_database = {}
-- mod._quick_localize = function (self, text_id)
--     local mod_localization_table = _localization_database
--     if mod_localization_table then
--         local text_translations = mod_localization_table[text_id]
--         if text_translations then
--             return text_translations[_language_id] or text_translations["en"]
--         end
--     end
-- end
-- function mod.add_text(self, text_id, text)
--     if type(text) == "table" then
--         _localization_database[text_id] = text
--     else
--         _localization_database[text_id] = {
--             en = text
--         }
--     end
-- end
-- mod:hook("Localize", function(func, text_id)
--     local str = mod:_quick_localize(text_id)
--     if str then return str end
--     return func(text_id)
-- end)

mod.reserve_space_for_talent = function (talent_name, career_name, row, _icon, _talentid)
    _icon = _icon or "icons_placeholder"
    local career_settings = CareerSettings[career_name]
    local character_name = career_settings.profile_name
    local talent_tree_index = career_settings.talent_tree_index
    --reserve in TalentIDLookup
    local talent_id = _talentid or #Talents[character_name] + 1
    TalentIDLookup[talent_name] = {
        talent_id = talent_id,
        hero_name = character_name
    }
    --talent row
    local chartalentTree = TalentTrees[character_name]
    local tidx = chartalentTree[talent_tree_index]
    local column = #tidx[row] + 1
    
    --add to Talents
    Talents[character_name][talent_id] = {
        icon = _icon,
        buffer = "server",
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
    --reserve in TalentTrees
    TalentTrees[character_name][talent_tree_index][row][column] = talent_name
    
    return column
end

mod:dofile("scripts/mods/pereqol/unlock_athanor")
mod:dofile("scripts/mods/pereqol/map_patch_utils")
mod:dofile("scripts/mods/pereqol/map_patches")
mod:dofile("scripts/mods/pereqol/rebal/more_talents")

mod:hook(DeusRunController, "setup_run", function(func, self, run_seed, difficulty, journey_name, dominant_god, initial_own_soft_currency, telemetry_id, with_belakor, mutators, boons)
    local skipUlgu = mod:get("disable_ulgu_modifier")
    local skipDarkness = mod:get("disable_darkness_modifier")
    local skipAbduction = mod:get("disable_no_respawn_modifier")
    local skipMiasma = mod:get("disable_nurgle_miasma")
    local skipTzeentchSizes = mod:get("disable_tzeentch_sizes")

    local reward_modifiers = {
        DoubleChest = 3,
        Dinero = 1,
        DineroPlus = 2
    }
    local hard_modifiers = {
        "deus_more_hordes",
        "deus_more_specials",
        "deus_more_elites", 
        "deus_more_roamers",
        "powerful_elites", 
        "deus_more_monsters",
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
        if skipDarkness and has_value(modifierList, "oscuridad") then -- skip
        elseif skipAbduction and has_value(modifierList, "no_respawn") then -- skip
        elseif skipUlgu and has_value(modifierList, "curse_belakors_shadows") then -- skip
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

mod.loaded = false
local updateFrames = 0


mod.update = function(dt)
	if mod.loaded == false then
		local pmod = get_mod("Peregrinaje")
        mod.set_unlock_levels() -- just spam this function until it works lmao
		if pmod then
			if pmod["player_stats"] then 
				local ps = pmod["player_stats"]
				if next(ps) ~= nil then
					updateFrames = updateFrames + dt
					if updateFrames > 1 then
						mod.loaded = true
                        pmod:ToggleStats()

                        mod:dofile("scripts/mods/pereqol/rebal/talents")
                        mod:dofile("scripts/mods/pereqol/climbing_enemies")
                        mod:dofile("scripts/mods/pereqol/rebal/localization")
                        mod:dofile("scripts/mods/pereqol/blocking")

                        mod:rebal_changes()
					end
				end
			end
		end
	end
end




-- mod.on_all_mods_loaded = function()

--     local Peregrinaje = get_mod("Peregrinaje")
--     if Peregrinaje then
--         Peregrinaje.register_callback(function()
--             -- disable stats by defaut
            
            
--         end)
--     end

-- end
