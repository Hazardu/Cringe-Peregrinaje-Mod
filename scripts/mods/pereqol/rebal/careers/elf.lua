local mod = get_mod("pereqol")
local pmod = get_mod("Peregrinaje")

mod.init_elf = function(self)

    -- more ammo
    BuffTemplates.kerillian_waywatcher_passive_increased_ammunition.buffs[1].multiplier = 2.0

    BuffTemplates.kerillian_waywatcher_attack_speed_on_ranged_headshot_buff.buffs[1].duration = 6
    BuffTemplates.kerillian_waywatcher_attack_speed_on_ranged_headshot_buff.buffs[1].multiplier  = 0.2
    mod:modify_talent("we_waywatcher", 2, 3, {
        description_values = {
            {
                value_type = "percent",
                value = BuffTemplates.kerillian_waywatcher_attack_speed_on_ranged_headshot_buff.buffs[1].multiplier
            },
            {
                value = BuffTemplates.kerillian_waywatcher_attack_speed_on_ranged_headshot_buff.buffs[1].duration
            }
        },
    })
    BuffTemplates.kerillian_shade_ult_invis_combo_window_peregrinaje.buffs[1].extend_time = 2

    BuffTemplates.kerillian_waywatcher_extra_arrow_melee_kill_buff.buffs[1].bonus = 3
    pmod:add_text("cringemod_kerillian_waywatcher_extra_arrow_melee_kill_desc", "After killing an enemy with a melee attack, your next ranged attack within 10 seconds fires 3 additional arrows.")
    mod:modify_talent("we_waywatcher", 2, 1, {
        description = "cringemod_kerillian_waywatcher_extra_arrow_melee_kill_desc",
    })

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

end