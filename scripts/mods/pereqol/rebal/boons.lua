local mod = get_mod("pereqol")
local pmod = get_mod("Peregrinaje")

BuffTemplates.multishoot_active_speed.buffs[1].bonus = 2
BuffTemplates.multishoot_active_speed.buffs[2].multiplier = 0.15
BuffTemplates.multishoot_active_speed.buffs[3].multiplier = -0.15

BuffTemplates.multishoot_active_reload.buffs[1].bonus = 2
BuffTemplates.multishoot_active_reload.buffs[2].multiplier = 0.15
BuffTemplates.multishoot_active_reload.buffs[3].multiplier = -0.15

BuffTemplates.power_up_slower_common.buffs[1].multiplier = -0.15
BuffTemplates.power_up_slower_common.buffs[2].multiplier = 0.45
BuffTemplates.power_up_slower_common.buffs[3].multiplier = 0.15

BuffTemplates.power_up_attack_speed_per_coins_rare.buffs[1].value = 0.00005
BuffTemplates.power_up_attack_speed_per_coins_rare.buffs[1].update_frequency = 3

DeusPowerUpBuffTemplates.boon_career_ability_burning_aoe.buffs[1].time_between_dot_damages = 1
DeusPowerUpBuffTemplates.boon_career_ability_poison_aoe.buffs[1].time_between_dot_damages = 1
DeusPowerUpBuffTemplates.boon_career_ability_bleed_aoe.buffs[1].time_between_dot_damages = 1
DeusPowerUpBuffTemplates.boon_career_ability_burning_aoe.buffs[1].update_start_delay = 1
DeusPowerUpBuffTemplates.boon_career_ability_poison_aoe.buffs[1].update_start_delay = 1
DeusPowerUpBuffTemplates.boon_career_ability_bleed_aoe.buffs[1].update_start_delay = 1

-- powerful obliterate weapon trait 5%->2%
BuffTemplates.weave_no_crit_power_buff.buffs[1].multiplier = 0.02
