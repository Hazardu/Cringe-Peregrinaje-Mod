local mod = get_mod("pereqol")
local pmod = get_mod("Peregrinaje")

mod.init_kruber = function(self)
    -- more ammo
    BuffTemplates.markus_huntsman_passive_increased_ammunition.buffs[1].multiplier = 1.5
    
    BuffTemplates.markus_knight_cooldown_buff.buffs[1].duration = 0.175
    BuffTemplates.markus_knight_cooldown_buff.buffs[1].multiplier = 4.5
    BuffTemplates.markus_knight_cooldown_buff.buffs[1].max_stacks = 2
    BuffTemplates.markus_knight_cooldown_buff.buffs[1].refresh_durations = false
    mod:modify_talent("es_knight", 5, 3, {
        description_values = {
            {
                value_type = "baked_percent",
                value = BuffTemplates.markus_knight_cooldown_buff.buffs[1].multiplier
            },
            {
                value = BuffTemplates.markus_knight_cooldown_buff.buffs[1].duration
            }
        }
    })

    BuffTemplates.markus_knight_power_level_impact.buffs[1].multiplier = 0.3
    mod:modify_talent("es_knight", 2, 1, {
        description_values = {
            {
                value_type = "percent",
                value = 0.3
            }
        }
    })


    mod:add_talent_buff_template("empire_soldier", "gs_sniper_buff_1", {
		multiplier = -1,
		stat_buff = "reduced_spread",
	})
	mod:add_talent_buff_template("empire_soldier", "gs_sniper_buff_2", {
		multiplier = -1,
		stat_buff = "reduced_spread_hit",
	})
	mod:add_talent_buff_template("empire_soldier", "gs_sniper_buff_3", {
		multiplier = -3,
		stat_buff = "reduced_spread_moving",
	})
	mod:add_talent_buff_template("empire_soldier", "gs_sniper_buff_4", {
		multiplier = -3,
		stat_buff = "reduced_spread_shot",
	})
	mod:modify_talent("es_huntsman", 5, 4, {
		buffs = {
			"gs_sniper_buff_1",
			"gs_sniper_buff_2",
			"gs_sniper_buff_3",
			"gs_sniper_buff_4"
		},
	})

end