local mod = get_mod("pereqol")
local pmod = get_mod("Peregrinaje")

BuffTemplates.multishoot_active_reload.buffs[1].bonus = 2
BuffTemplates.multishoot_active_reload.buffs[2].multiplier = 0.15
BuffTemplates.multishoot_active_reload.buffs[3].multiplier = -0.15
pmod:add_text("multishoot_description", "Your ranged attacks fire 2 additional projectiles, but your power, attack speed, and reload speed with ranged weapons is reduced by 15%.")

BuffTemplates.power_up_slower_common.buffs[1].multiplier = -0.15
BuffTemplates.power_up_slower_common.buffs[2].multiplier = 0.45
BuffTemplates.power_up_slower_common.buffs[3].multiplier = 0.15
pmod:add_text("slower_description", "Power increased by 45%. Attack and reload speed decreased by 15%.")

BuffTemplates.power_up_attack_speed_per_coins_rare.buffs[1].value = 0.000025
BuffTemplates.power_up_attack_speed_per_coins_rare.buffs[1].update_frequency = 3
pmod:add_text("description_attack_speed_per_coins", "Attack speed increases by 1% for every 400 coins that you have, up to 127%.")