local mod = get_mod("pereqol")
local pmod = get_mod("Peregrinaje")

mod.init_victor = function(self)

    BuffTemplates.bounty_clip_size.buffs[1].multiplier = 1
    BuffTemplates.victor_bountyhunter_stacking_damage_reduction_on_elite_or_special_kill_buff.buffs[1].max_stacks = 20
    mod:modify_talent("wh_bountyhunter", 5, 3, {
        description_values = {
            {
                value_type = "percent",
                value = -0.01
            },
            {
                value = BuffTemplates.victor_bountyhunter_stacking_damage_reduction_on_elite_or_special_kill_buff.buffs[1].max_stacks
            },
        },
    })

    BuffTemplates.victor_bountyhunter_restore_ammo_on_elite_kill.buffs[1].ammo_bonus_fraction = 0.5
    mod:modify_talent("wh_bountyhunter", 5, 2, {
        description_values = {
            {
                value_type = "percent",
                value = BuffTemplates.victor_bountyhunter_restore_ammo_on_elite_kill.buffs[1].ammo_bonus_fraction
            }
        },
    })

    -- 6-3 has been removed by isaakk
    mod:add_talent_buff_template("witch_hunter", "victor_bountyhunter_activated_ability_blast_shotgun_cdr", {
        multiplier = -0.3,
        stat_buff = "activated_cooldown",
    })
    pmod:add_text("victor_bountyhunter_activated_ability_blast_shotgun_desc", "Modifies Victor's sidearm to fire two blasts of shield-penetrating pellets in a devastating cone. Reduces cooldown of Locked and Loaded by 30%%.")
    mod:modify_talent("wh_bountyhunter", 6, 3, {
        buffs = {
            "victor_bountyhunter_activated_ability_blast_shotgun",
            "victor_bountyhunter_activated_ability_blast_shotgun_cdr",
        },
    })
    -- BuffTemplates.victor_bountyhunter_activated_ability_blast_shotgun.buffs[1].multiplier = -0.3
    BuffTemplates.victor_bountyhunter_activated_ability_railgun_delayed_add.buffs[1].multiplier = 0.75
    mod:modify_talent("wh_bountyhunter", 6, 2, {
        description_values = {
            {
                value_type = "percent",
                value = BuffTemplates.victor_bountyhunter_activated_ability_railgun_delayed_add.buffs[1].multiplier
            }
        },
    })

    -- crit chance for 6-1, does not work
    -- BuffTemplates.victor_bountyhunter_activated_ability_passive_cooldown_reduction.buffs[2].multiplier = 0.075
    -- pmod:add_text("cringemod_victor_bountyhunter_activated_ability_reset_cooldown_on_stacks_2_desc", "Ranged critical hits reduce the cooldown of your career skill by 20%%. This effect can occur every 4 seconds. Increases crit chance by 7.5%%.")
    -- mod:modify_talent("wh_bountyhunter", 6, 1, {
    --     description = "cringemod_victor_bountyhunter_activated_ability_reset_cooldown_on_stacks_2_desc",
    -- })


    pmod:add_text("cringemod_victor_bountyhunter_power_burst_on_no_ammo_scrounger_desc", "When you fire your last shot, gain 15%% power and attack speed for 15 seconds. Additionally you gain 5%% ammo on ranged critical hit. Stacks with 'Scrounger'.")
    mod:modify_talent("wh_bountyhunter", 2, 2, {
        description = "cringemod_victor_bountyhunter_power_burst_on_no_ammo_scrounger_desc",
        buffs = {
            "victor_bountyhunter_increased_melee_damage_on_no_ammo_add",
            "traits_ranged_replenish_ammo_on_crit"
        },
    })

end