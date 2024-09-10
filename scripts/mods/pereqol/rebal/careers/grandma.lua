local mod = get_mod("pereqol")
local pmod = get_mod("Peregrinaje")

mod.init_sienna = function(self)

BuffTemplates.sienna_necromancer_5_2_buff.buffs[1].multiplier = -0.35
mod:modify_talent("bw_necromancer", 5, 2, {
	description_values = {
        {
            value_type = "percent",
            value = BuffTemplates.sienna_necromancer_5_2_buff.buffs[1].multiplier
        },
        {
            value = 3
        }
    },
})

-- 6-2 give it 25 % cooldown
mod:add_talent_buff_template("bright_wizard", "sienna_necromancer_6_2_cdr", {
    multiplier = -0.25,
    stat_buff = "activated_cooldown",
})
mod:modify_talent("bw_necromancer", 6, 2, {
    buffs = {
        "sienna_necromancer_6_2_cdr",
    },
})


mod:add_talent_buff_template("bright_wizard", "cringe_necromancer_power_level_decreased", {
    stat_buff = "power_level",
    multiplier = -0.25
    })
table.insert(PassiveAbilitySettings.bw_necromancer.buffs, "cringe_necromancer_power_level_decreased")
mod:add_talent_buff_template("bright_wizard", "cringe_necromancer_attack_speed_decreased", {
    stat_buff = "attack_speed",
    multiplier = -0.1
    })
table.insert(PassiveAbilitySettings.bw_necromancer.buffs, "cringe_necromancer_attack_speed_decreased")

PassiveAbilitySettings.bw_necromancer.perks[1] = {
    display_name = "cringe_career_passive_name_necro",
    description = "cringe_career_passive_desc_necro"
}

end