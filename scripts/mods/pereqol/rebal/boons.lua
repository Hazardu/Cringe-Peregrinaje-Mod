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

BuffTemplates.power_up_attack_speed_per_coins_rare.buffs[1].value = 0.000025
BuffTemplates.power_up_attack_speed_per_coins_rare.buffs[1].update_frequency = 3

DeusPowerUpTemplates.boon_dot_burning_01.buff_template.buffs[1].area_radius = 0.4
DeusPowerUpTemplates.boon_careerskill_01.buff_template.buffs[1].area_radius = 3
DeusPowerUpTemplates.boon_careerskill_02.buff_template.buffs[1].area_radius = 3
DeusPowerUpTemplates.boon_careerskill_03.buff_template.buffs[1].area_radius = 3
DeusPowerUpTemplates.boon_careerskill_04.buff_template.buffs[1].area_radius = 3
DeusPowerUpBuffTemplates.boon_career_ability_burning_aoe.buffs[1].time_between_dot_damages = 1
DeusPowerUpBuffTemplates.boon_career_ability_poison_aoe.buffs[1].time_between_dot_damages = 1
DeusPowerUpBuffTemplates.boon_career_ability_bleed_aoe.buffs[1].time_between_dot_damages = 1
DeusPowerUpBuffTemplates.boon_career_ability_burning_aoe.buffs[1].update_start_delay = 1
DeusPowerUpBuffTemplates.boon_career_ability_poison_aoe.buffs[1].update_start_delay = 1
DeusPowerUpBuffTemplates.boon_career_ability_bleed_aoe.buffs[1].update_start_delay = 1

-- DeusPowerUpSettings.cursed_chest_choice_amount = 6
-- DeusPowerUpSettings.cursed_chest_max_picks = 1
-- DeusPowerUpSettings.weapon_chest_choice_amount = 3
