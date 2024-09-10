local mod = get_mod("pereqol")
local pmod = get_mod("Peregrinaje")

mod.init_victor = function(self)
    mod:dump(get_mod("Peregrinaje"), "pere", 0)
    -- BuffTemplates.bounty_clip_size.buffs[1].multiplier = 1
    BuffTemplates.victor_bountyhunter_power_level_on_clip_size_buff.buffs[1].multiplier = 0.01
    -- BuffTemplates.victor_bountyhunter_stacking_damage_reduction_on_elite_or_special_kill_buff.buffs[1].max_stacks = 20
    -- mod:modify_talent("wh_bountyhunter", 5, 3, {
    --     description_values = {
    --         {
    --             value_type = "percent",
    --             value = -0.01
    --         },
    --         {
    --             value = BuffTemplates.victor_bountyhunter_stacking_damage_reduction_on_elite_or_special_kill_buff.buffs[1].max_stacks
    --         },
    --     },
    -- })

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
        multiplier = -0.10,
        stat_buff = "activated_cooldown",
    })
    mod:modify_talent("wh_bountyhunter", 6, 3, {
        buffs = {
            "victor_bountyhunter_activated_ability_blast_shotgun",
            "victor_bountyhunter_activated_ability_blast_shotgun_cdr",
            "traits_ranged_replenish_ammo_on_crit",
        },
    })
    BuffTemplates.victor_bountyhunter_activated_ability_railgun_delayed_add.buffs[1].multiplier = 0.75
    mod:modify_talent("wh_bountyhunter", 6, 2, {
        description_values = {
            {
                value_type = "percent",
                value = BuffTemplates.victor_bountyhunter_activated_ability_railgun_delayed_add.buffs[1].multiplier
            }
        },
    })
end