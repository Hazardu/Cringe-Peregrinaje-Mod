local mod = get_mod("pereqol")
local pmod = get_mod("Peregrinaje")

mod.init_dwarf = function(self)
        
    -- more ammo
    BuffTemplates.bardin_ranger_passive_increased_ammunition.buffs[1].multiplier = 1.5



    BuffTemplates.bardin_ironbreaker_party_power_on_blocked_attacks_buff.buffs[1].duration = 15
    mod:modify_talent("dr_ironbreaker", 2, 3, {
        description_values = {
            {
                value_type = "percent",
                value = 0.02
            },
            {
                value = BuffTemplates.bardin_ironbreaker_stacking_buff_gromril.buffs[1].update_frequency
            },
            {
                value = 5
            },
        },
    })


    BuffTemplates.bardin_ironbreaker_stacking_buff_gromril.buffs[1].update_frequency = 6
    mod:modify_talent("dr_ironbreaker", 4, 1, {
        description_values = {
            {
                value = BuffTemplates.bardin_ironbreaker_stacking_buff_gromril.buffs[1].update_frequency
            },
            {
                value_type = "percent",
                value = 0.08
            },
        },
    })




    mod:add_talent_buff_template("dwarf_ranger", "gs_bardin_slayer_increased_defence", {
        stat_buff = "damage_taken",
        multiplier = -0.10
    })

    table.insert(PassiveAbilitySettings.dr_2.buffs, "gs_bardin_slayer_increased_defence")
    PassiveAbilitySettings.dr_2.perks[1] = {
        display_name = "rebaltourn_career_passive_name_dr_2d",
        description = "rebaltourn_career_passive_desc_dr_2d_2"
    }


    pmod:add_buff_template("engi_2_1_cdr", {
        stat_buff = "cooldown_regen",
        name = "engi_2_1_cdr",
        multiplier = 0.4
    })
    mod:modify_talent("dr_engineer", 2, 1, {
        name = "engi_2_1_cdr_name",
        description = "engi_2_1_cdr_desc",
        buffs = {
            "engi_2_1_cdr"
        }
    })

    --minigun special kills give 6 seconds of free firing
    BuffTemplates.bardin_engineer_increased_ability_bar_buff.buffs[1].duration = 6
    mod:modify_talent("dr_engineer", 6, 3, {
        description_values = {
            {
                value_type = "percent",
                value = 0.5
            },
            {
                value = BuffTemplates.bardin_engineer_increased_ability_bar_buff.buffs[1].duration
            },
        },
    })
end