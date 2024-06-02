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

mod:dofile("scripts/mods/pereqol/rebal/careers/dwarf")
mod:dofile("scripts/mods/pereqol/rebal/careers/elf")
mod:dofile("scripts/mods/pereqol/rebal/careers/racist")
mod:dofile("scripts/mods/pereqol/rebal/careers/grandma")
mod:dofile("scripts/mods/pereqol/rebal/careers/kruber")

mod.rebal_changes = function(self)
    local pmod = get_mod("Peregrinaje")
    local buff_perks = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

    BuffTemplates.weave_agile.buffs = {} -- disable cat as its used just for getting out of bounds 90% of the time
    pmod:add_text("weave_agile_desc", "Does fuck all, no more meowing you furry.")

    -- local function add_buff_template(buff_name, buff_data)   
    --     local new_talent_buff = {
    --         buffs = {
    --             merge({ name = buff_name }, buff_data),
    --         },
    --     }
    --     BuffTemplates[buff_name] = new_talent_buff
    --     local index = #NetworkLookup.buff_templates + 1
    --     NetworkLookup.buff_templates[index] = buff_name
    --     NetworkLookup.buff_templates[buff_name] = index
    -- end
    -- local function add_proc_function(name, func)
    --     ProcFunctions[name] = func
    -- end
    -- local function add_buff_function(name, func)
    --     BuffFunctionTemplates.functions[name] = func
    -- end
    
    -- local function add_buff(owner_unit, buff_name)
    --     if Managers.state.network ~= nil then
    --         local network_manager = Managers.state.network
    --         local network_transmit = network_manager.network_transmit

    --         local unit_object_id = network_manager:unit_game_object_id(owner_unit)
    --         local buff_template_name_id = NetworkLookup.buff_templates[buff_name]
    --         local is_server = Managers.player.is_server

    --         if is_server then
    --             local buff_extension = ScriptUnit.extension(owner_unit, "buff_system")

    --             buff_extension:add_buff(buff_name)
    --             network_transmit:send_rpc_clients("rpc_add_buff", unit_object_id, buff_template_name_id, unit_object_id, 0, false)
    --         else
    --             network_transmit:send_rpc_server("rpc_add_buff", unit_object_id, buff_template_name_id, unit_object_id, 0, true)
    --         end
    --     end
    -- end
    -- local function add_talent(career_name, tier, index, new_talent_name, new_talent_data)
    --     local career_settings = CareerSettings[career_name]
    --     local hero_name = career_settings.profile_name
    --     local talent_tree_index = career_settings.talent_tree_index

    --     local new_talent_index = #Talents[hero_name] + 1

    --     Talents[hero_name][new_talent_index] = merge({
    --         name = new_talent_name,
    --         description = new_talent_name .. "_desc",
    --         icon = "icons_placeholder",
    --         num_ranks = 1,
    --         buffer = "both",
    --         requirements = {},
    --         description_values = {},
    --         buffs = {},
    --         buff_data = {},
    --     }, new_talent_data)

    --     TalentTrees[hero_name][talent_tree_index][tier][index] = new_talent_name
    --     TalentIDLookup[new_talent_name] = {
    --         talent_id = new_talent_index,
    --         hero_name = hero_name
    --     }
    -- end

    -- THP changes 

    pmod:add_proc_function("cringemod_heal_crit_headshot_on_melee", function (owner_unit, buff, params)
        if not Managers.state.network.is_server then
            return
        end

        local heal_amount_crit = 2.5
        local heal_amount_hs = 2
        local has_procced = buff.has_procced
        local hit_unit = params[1]
        local hit_zone_name = params[3]
        local target_number = params[4]
        local attack_type = params[2]
        local critical_hit = params[6]
        local breed = AiUtils.unit_breed(hit_unit)

        if target_number == 1 then
            buff.has_procced = false
            has_procced = false
        end

        if ALIVE[owner_unit] and breed and (attack_type == "light_attack" or attack_type == "heavy_attack") and not has_procced then
            if hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" then
                buff.has_procced = true

                DamageUtils.heal_network(owner_unit, owner_unit, heal_amount_hs, "heal_from_proc")
            end

            if critical_hit then
                DamageUtils.heal_network(owner_unit, owner_unit, heal_amount_crit, "heal_from_proc")

                buff.has_procced = true
            end
        end
    end)

    pmod:add_text("cringemod_regrowth_name", "Crit/HS Thp")

    pmod:add_buff_template("cringemod_regrowth", {
        name = "regrowth",
        event_buff = true,
        buff_func = "cringemod_heal_crit_headshot_on_melee",
        event = "on_hit",
        perks = { buff_perks.ninja_healing },
    })

    pmod:add_proc_function("cringemod_heal_damage_targets_on_melee", function (owner_unit, buff, params, world, param_order)
        if not Managers.state.network.is_server then
            return
        end

        if not ALIVE[owner_unit] then
            return
        end

        local attack_type = params[param_order.buff_attack_type]

        if not attack_type or attack_type ~= "light_attack" and attack_type ~= "heavy_attack" then
            return
        end

        local hit_unit = params[param_order.attacked_unit]
        local breed = AiUtils.unit_breed(hit_unit)

        if not breed then
            return
        end

        local damage_amount = params[param_order.damage_amount]

        if damage_amount > 0 then
            local buff_template = buff.template
            local max_targets = buff_template.max_targets
            local target_number = params[param_order.target_index]

            if target_number and target_number <= max_targets then
                local heal_amount = 1

                DamageUtils.heal_network(owner_unit, owner_unit, heal_amount, "heal_from_proc")
            end
        end
    end)
    pmod:add_text("cringemod_cleave_thp_name", "Multi Hit Thp")
    pmod:add_text("cringemod_cleave_thp_desc", "You gain 1 temp health when hitting an enemy, up to 5 enemies per attack.")

    pmod:add_buff_template("cringemod_cleave_thp", {
        bonus = 0.25,
        buff_func = "heal_damage_targets_on_melee",
        event = "on_player_damage_dealt",
        max_targets = 5,
        multiplier = -0.05,
        name = "reaper",
        perks = {
            buff_perks.linesman_healing,
        }
    })  

    local hit_thp_talents = {
        es_mercenary = 1,
        es_huntsman = 3,
        dr_ranger = 2,
        dr_slayer = 1,
        we_waywatcher = 2,
        we_shade = 3,
        we_thornsister = 2,
        wh_captain = 2,
        wh_bountyhunter = 3,
        wh_zealot = 1,
        bw_scholar = 1,
        es_knight = 2,
        es_questingknight = 3,
        dr_ironbreaker = 3,
        dr_engineer = 2,
        we_maidenguard = 1,
        bw_adept = 3,
        bw_unchained = 2,
        bw_necromancer = 1,
        wh_priest = 2,
    }
    for career, column in pairs(hit_thp_talents) do
        local success, err = pcall(function()  
            mod:modify_talent(career, 1, column, {
                name = "cringemod_cleave_thp_name",
                description = "cringemod_cleave_thp_desc",
                buffs = {
                    "cringemod_cleave_thp"
                }
            })
        end)
        if not success then
            mod:echo("modifying thp talent failed %s powerup failed %s", career, err)
        end
    end

    mod:dofile("scripts/mods/pereqol/rebal/weapons")
    mod:dofile("scripts/mods/pereqol/rebal/boons")
    mod:init_dwarf()
    mod:init_elf()
    mod:init_kruber()
    mod:init_sienna()
    mod:init_victor()
  


end