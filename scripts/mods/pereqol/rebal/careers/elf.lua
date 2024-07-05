local mod = get_mod("pereqol")
local pmod = get_mod("Peregrinaje")

mod.init_elf = function(self)

    -- more ammo
    BuffTemplates.kerillian_waywatcher_passive_increased_ammunition.buffs[1].multiplier = 2.0

    -- BuffTemplates.kerillian_waywatcher_attack_speed_on_ranged_headshot_buff.buffs[1].duration = 6
    -- BuffTemplates.kerillian_waywatcher_attack_speed_on_ranged_headshot_buff.buffs[1].multiplier  = 0.2
    -- mod:modify_talent("we_waywatcher", 2, 3, {
    --     description_values = {
    --         {
    --             value_type = "percent",
    --             value = BuffTemplates.kerillian_waywatcher_attack_speed_on_ranged_headshot_buff.buffs[1].multiplier
    --         },
    --         {
    --             value = BuffTemplates.kerillian_waywatcher_attack_speed_on_ranged_headshot_buff.buffs[1].duration
    --         }
    --     },
    -- })
    BuffTemplates.kerillian_shade_ult_invis_combo_window_peregrinaje.buffs[1].extend_time = 2


    BuffTemplates.kerillian_maidenguard_activated_ability_crit_buff.buffs[1].duration = 15
    BuffTemplates.kerillian_maidenguard_power_level_on_unharmed_cooldown.buffs[1].duration = 6
    mod:modify_talent("we_maidenguard", 2, 1, {
        description_values = {
            {
                value = BuffTemplates.kerillian_maidenguard_power_level_on_unharmed_cooldown.buffs[1].duration
            },
            {
                value_type = "percent",
                value = 0.35
            },
        },
    })

    BuffTemplates.kerillian_maidenguard_activated_ability_invis_duration.buffs[1].duration = 2
    mod:modify_talent("we_maidenguard", 6, 1, {
        description_values = {
            {
                value = BuffTemplates.kerillian_maidenguard_activated_ability_invis_duration.buffs[1].duration
            }
        },
    })

    BuffTemplates.kerillian_shade_charged_backstabs_buff.buffs[1].bonus = 0.1
    BuffTemplates.kerillian_shade_charged_backstabs_buff.buffs[1].max_stacks = 50
    mod:modify_talent("we_shade", 4, 1, {
        description_values = {
            {
                value_type = "percent",
                value = BuffTemplates.kerillian_shade_charged_backstabs_buff.buffs[1].bonus
            },
            {
                value = 5
            },
            {
                value = BuffTemplates.kerillian_shade_charged_backstabs_buff.buffs[1].max_stacks
            }
        },
    })

    BuffTemplates.kerillian_shade_backstabs_replenishes_ammunition_cooldown.buffs[1].duration = 0.1
    mod:modify_talent_buff_template("wood_elf", "kerillian_thorn_sister_passive_temp_health_funnel_aura_buff", {
        multiplier = 0.20
    })

    -- people wont even notice its increased by +30 seconds so i wont update description >:D
    -- i'm not a big fan of making a escape career a durable tank as well
    BuffTemplates.hp_stacks.update_frequency = 60

    local original_regen_func = BuffFunctionTemplates.functions.update_kerillian_waywatcher_regen
    BuffFunctionTemplates.functions.update_kerillian_waywatcher_regen = function(unit, buff, params, world)
        --regen ammo
        local t = params.t
		local buff_template = buff.template
		local next_heal_tick = buff.next_heal_tick or 0
        if next_heal_tick < t and Unit.alive(unit) then
            local talent_extension = ScriptUnit.extension(unit, "talent_system")
			local ammo_restore_talent = talent_extension:has_talent("kerillian_waywatcher_passive_restore_ammo", "wood_elf", true)
            if ammo_restore_talent then

				local inventory_extension = ScriptUnit.extension(unit, "inventory_system")
				local slot_data = inventory_extension:get_slot_data("slot_ranged")

				if slot_data then
					local right_unit_1p = slot_data.right_unit_1p
					local left_unit_1p = slot_data.left_unit_1p
					local right_hand_ammo_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
					local left_hand_ammo_extension = ScriptUnit.has_extension(left_unit_1p, "ammo_system")
					local ammo_extension = right_hand_ammo_extension or left_hand_ammo_extension

					if ammo_extension then
						local ammo_bonus_fraction = 0.05
						local ammo_amount = math.max(math.round(ammo_extension:max_ammo() * ammo_bonus_fraction), 1)

						ammo_extension:add_ammo_to_reserve(ammo_amount)
					end
				end
			end
        end
        original_regen_func(unit, buff, params, world)
    end
    
    ProcFunctions.cringe_kerillian_waywatcher_add_extra_shot_buff_on_melee_kill = function (owner_unit, buff, params)
        if not ALIVE[owner_unit] then
            return
        end
    
        local killing_blow_data = params[1]
    
        if not killing_blow_data then
            return
        end
    
        local attack_type = killing_blow_data[DamageDataIndex.ATTACK_TYPE]
        mod:dump(killing_blow_data, "killing_blow_data", 10)
        if not attack_type or attack_type ~= "light_attack" and attack_type ~= "heavy_attack" then
            return
        end
    
        local buff_template = buff.template
        local buff_name = buff_template.buff_to_add
        local buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
    
        buff_extension:add_buff(buff_name, {
            attacker_unit = owner_unit,
        })
    end
    mod:add_talent_buff_template("wood_elf", "cringe_kerillian_waywatcher_extra_arrow_melee_kill", {
        buff_func = "cringe_kerillian_waywatcher_add_extra_shot_buff_on_melee_kill",
        buff_to_add = "cringe_kerillian_waywatcher_extra_arrow_melee_kill_buff",
        event = "on_kill",
    })
    mod:add_talent_buff_template("wood_elf", "cringe_kerillian_waywatcher_extra_arrow_melee_kill_buff", {
        buff_func = "kerillian_waywatcher_consume_extra_shot_buff",
        event = "on_ranged_hit",
        icon = "kerillian_waywatcher_extra_arrow_melee_kill",
        max_stacks = 1,
        refresh_durations = true,
        remove_on_proc = true,
        stat_buff = "extra_shot",
        duration = 10,
        bonus = 3
    })
    
    BuffTemplates.kerillian_waywatcher_extra_arrow_melee_kill_buff.buffs[1].bonus = 3
    mod:modify_talent("we_waywatcher", 2, 4, {
        description = "cringemod_kerillian_waywatcher_extra_arrow_melee_kill_desc",
		icon = "kerillian_waywatcher_extra_arrow_melee_kill",
		name = "kerillian_waywatcher_extra_arrow_melee_kill",
		num_ranks = 1,
		description_values = {
			{
				value = BuffTemplates.kerillian_waywatcher_extra_arrow_melee_kill_buff.buffs[1].duration,
			},
		},
        buffs = {
			"cringe_kerillian_waywatcher_extra_arrow_melee_kill",
		},
        buffer = nil
    })
end