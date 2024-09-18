local mod = get_mod("pereqol")

-- Buff and Talent Functions
mod.merge = function(self, dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end


mod.add_talent_buff_template = function(self, hero_name, buff_name, buff_data, extra_data)   
    local new_talent_buff = {
        buffs = {
            mod:merge({ name = buff_name }, buff_data),
        },
    }
    if extra_data then
        new_talent_buff = mod:merge(new_talent_buff, extra_data)
    elseif type(buff_data[1]) == "table" then
        new_talent_buff = {
            buffs = buff_data,
        }
        if new_talent_buff.buffs[1].name == nil then
            new_talent_buff.buffs[1].name = buff_name
        end
    end
    TalentBuffTemplates[hero_name][buff_name] = new_talent_buff
    BuffTemplates[buff_name] = new_talent_buff
    local index = #NetworkLookup.buff_templates + 1
    NetworkLookup.buff_templates[index] = buff_name
    NetworkLookup.buff_templates[buff_name] = index
end

mod.modify_talent_buff_template = function(self, hero_name, buff_name, buff_data, extra_data)   
    local new_talent_buff = {
        buffs = {
            mod:merge({ name = buff_name }, buff_data),
        },
    }
    if extra_data then
        new_talent_buff = mod:merge(new_talent_buff, extra_data)
    elseif type(buff_data[1]) == "table" then
        new_talent_buff = {
            buffs = buff_data,
        }
        if new_talent_buff.buffs[1].name == nil then
            new_talent_buff.buffs[1].name = buff_name
        end
    end

    local original_buff = TalentBuffTemplates[hero_name][buff_name]
    local merged_buff = original_buff
    for i=1, #original_buff.buffs do
        if new_talent_buff.buffs[i] then
            merged_buff.buffs[i] = mod:merge(original_buff.buffs[i], new_talent_buff.buffs[i])
        elseif original_buff[i] then
            merged_buff.buffs[i] = mod:merge(original_buff.buffs[i], new_talent_buff.buffs)
        else
            merged_buff.buffs = mod:merge(original_buff.buffs, new_talent_buff.buffs)
        end
    end

    TalentBuffTemplates[hero_name][buff_name] = merged_buff
    BuffTemplates[buff_name] = merged_buff
end

mod.modify_talent = function(self, career_name, tier, index, new_talent_data)
    local career_settings = CareerSettings[career_name]
    local hero_name = career_settings.profile_name
    local talent_tree_index = career_settings.talent_tree_index
    
    local old_talent_name = TalentTrees[hero_name][talent_tree_index][tier][index]
    local old_talent_id_lookup = TalentIDLookup[old_talent_name]
    local old_talent_id = old_talent_id_lookup.talent_id
    local old_talent_data = Talents[hero_name][old_talent_id]
    Talents[hero_name][old_talent_id] = mod:merge(old_talent_data, new_talent_data)
end

mod.add_buff_function = function(self, name, func)
    BuffFunctionTemplates.functions[name] = func
end

mod:dofile("scripts/mods/pereqol/rebal/careers/dwarf")
mod:dofile("scripts/mods/pereqol/rebal/careers/elf")
mod:dofile("scripts/mods/pereqol/rebal/careers/racist")
mod:dofile("scripts/mods/pereqol/rebal/careers/grandma")
mod:dofile("scripts/mods/pereqol/rebal/careers/kruber")

mod.rebal_changes = function(self)
    local pmod = get_mod("Peregrinaje")
    local buff_perks = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

   
    mod:init_dwarf()
    mod:init_elf()
    mod:init_kruber()
    mod:init_sienna()
    mod:init_victor()
    

end