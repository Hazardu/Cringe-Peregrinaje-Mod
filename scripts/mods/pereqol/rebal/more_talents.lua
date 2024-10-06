local mod = get_mod("pereqol")

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



mod.reserve_space_for_talent("huntsman_pinpoint_accuracy", "es_huntsman", 5, "kerillian_waywatcher_movement_speed_on_special_kill")

local elf_talent_len = #Talents.wood_elf
mod.reserve_space_for_talent("kerillian_waywatcher_passive_restore_ammo", "we_waywatcher", 4, "kerillian_waywatcher_movement_speed_on_special_kill", elf_talent_len + 1)
