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

end