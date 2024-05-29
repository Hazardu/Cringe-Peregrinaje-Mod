

function add_chain_actions(action_no, action_from, new_data)
    local value = "allowed_chain_actions"
    local row = #action_no[action_from][value] + 1
    action_no[action_from][value][row] = new_data
end

for _, weapon in ipairs{
    "longbow_empire_template",
} do
    local weapon_template = Weapons[weapon]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    add_chain_actions(action_one, "shoot_charged_heavy", {
        sub_action = "default",
        start_time = 0, -- 0.3
        action = "action_wield",
        input = "action_wield",
        end_time = math.huge
    })
end

--Kruber Bow
function add_chain_actions(action_no, action_from, new_data)
    local value = "allowed_chain_actions"
    local row = #action_no[action_from][value] + 1
    action_no[action_from][value][row] = new_data
end

for _, weapon in ipairs{
    "longbow_empire_template",
} do
    local weapon_template = Weapons[weapon]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    add_chain_actions(action_one, "shoot_charged_heavy", {
        sub_action = "default",
        start_time = 0, -- 0.3
        action = "action_wield",
        input = "action_wield",
        end_time = math.huge
    })
end

Weapons.longbow_empire_template.actions.action_one.shoot_charged_heavy.allowed_chain_actions[4].start_time = 0.25
Weapons.longbow_empire_template.actions.action_one.shoot_charged_heavy.allowed_chain_actions[4].sub_action = "default"
Weapons.longbow_empire_template.actions.action_one.shoot_charged_heavy.allowed_chain_actions[4].action = "action_one"
Weapons.longbow_empire_template.actions.action_one.shoot_charged_heavy.allowed_chain_actions[4].release_required = "action_two_hold"
Weapons.longbow_empire_template.actions.action_one.shoot_charged_heavy.allowed_chain_actions[4].input = "action_one"

Weapons.longbow_empire_template.actions.action_one.shoot_charged_heavy.reload_event_delay_time = 0.1
Weapons.longbow_empire_template.actions.action_one.shoot_charged_heavy.override_reload_time = nil
Weapons.longbow_empire_template.actions.action_one.shoot_charged_heavy.allowed_chain_actions[2].start_time = 0.68

Weapons.longbow_empire_template.actions.action_one.default.allowed_chain_actions[2].start_time = 0.4
Weapons.longbow_empire_template.actions.action_one.default.override_reload_time = 0.15
Weapons.longbow_empire_template.actions.action_two.default.heavy_aim_flow_delay = nil
Weapons.longbow_empire_template.actions.action_two.default.heavy_aim_flow_event = nil
Weapons.longbow_empire_template.actions.action_two.default.aim_zoom_delay = 100
Weapons.longbow_empire_template.ammo_data.reload_time = 0
Weapons.longbow_empire_template.ammo_data.reload_on_ammo_pickup = true

SpreadTemplates.empire_longbow.continuous.still = {max_yaw = 0.25, max_pitch = 0.25 }
SpreadTemplates.empire_longbow.continuous.moving = {max_yaw = 0.4, max_pitch = 0.4 }
SpreadTemplates.empire_longbow.continuous.crouch_still = {max_yaw = 0.75, max_pitch = 0.75 }
SpreadTemplates.empire_longbow.continuous.crouch_moving = {max_yaw = 2, max_pitch = 2 }
SpreadTemplates.empire_longbow.continuous.zoomed_still = {max_yaw = 0, max_pitch = 0}
SpreadTemplates.empire_longbow.continuous.zoomed_moving = {max_yaw = 0.4, max_pitch = 0.4 }
SpreadTemplates.empire_longbow.continuous.zoomed_crouch_still = {max_yaw = 0, max_pitch = 0 }
SpreadTemplates.empire_longbow.continuous.zoomed_crouch_moving = {max_yaw = 0.4, max_pitch = 0.4 }

function add_chain_actions(action_no, action_from, new_data)
    local value = "allowed_chain_actions"
    local row = #action_no[action_from][value] + 1
    action_no[action_from][value][row] = new_data
end

for _, weapon in ipairs{
    "longbow_empire_template",
} do
    local weapon_template = Weapons[weapon]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    add_chain_actions(action_one, "shoot_charged", {
        sub_action = "default",
        start_time = 0, -- 0.3
        action = "action_wield",
        input = "action_wield",
        end_time = math.huge
    })
end

Weapons.longbow_empire_template.actions.action_one.shoot_charged.allowed_chain_actions[4].start_time = 0.4
Weapons.longbow_empire_template.actions.action_one.shoot_charged.allowed_chain_actions[4].sub_action = "default"
Weapons.longbow_empire_template.actions.action_one.shoot_charged.allowed_chain_actions[4].action = "action_one"
Weapons.longbow_empire_template.actions.action_one.shoot_charged.allowed_chain_actions[4].release_required = "action_two_hold"
Weapons.longbow_empire_template.actions.action_one.shoot_charged.allowed_chain_actions[4].input = "action_one"

Weapons.longbow_empire_template.actions.action_one.shoot_charged.allowed_chain_actions[2].start_time = 0.7
Weapons.longbow_empire_template.actions.action_one.shoot_charged.reload_event_delay_time = 0.15
Weapons.longbow_empire_template.actions.action_one.shoot_charged.override_reload_time = nil
Weapons.longbow_empire_template.actions.action_one.shoot_charged.speed = 11000

Weapons.longbow_empire_template.actions.action_two.default.aim_zoom_delay = 0.01
Weapons.longbow_empire_template.actions.action_two.default.heavy_aim_flow_event = nil
Weapons.longbow_empire_template.actions.action_two.default.default_zoom = "zoom_in_trueflight"
Weapons.longbow_empire_template.actions.action_two.default.buffed_zoom_thresholds = { "zoom_in_trueflight", "zoom_in" }
DamageProfileTemplates.arrow_sniper_kruber.armor_modifier_near.attack = { 1, 1.25, 1.5, 1, 0.75, 0.25 }


--Deepwood Staff
VortexTemplates.spirit_storm.time_of_life = { 5,5 }
VortexTemplates.spirit_storm.reduce_duration_per_breed = { chaos_warrior = 0.5 }

--Corruscation
ExplosionTemplates.magma.aoe.duration = 10
ExplosionTemplates.magma.aoe.damage_interval = 0.55
BuffTemplates['burning_magma_dot'].buffs[1].ticks = 2
BuffTemplates['burning_magma_dot'].buffs[1].max_stacks = 15


--Conflag
DamageProfileTemplates.geiser.targets[1].power_distribution.attack = 0.75
ExplosionTemplates.conflag.aoe.duration = 10
ExplosionTemplates.conflag.aoe.damage_interval = 2


Weapons.dual_wield_daggers_template_1.actions.action_one.heavy_attack.allowed_chain_actions[5].start_time = 0.35
Weapons.dual_wield_daggers_template_1.actions.action_one.heavy_attack_stab.allowed_chain_actions[5].start_time = 0.35

Weapons.two_handed_spears_elf_template_1.actions.action_one.light_attack_left.damage_window_start = 0.27
Weapons.two_handed_spears_elf_template_1.actions.action_one.light_attack_left.damage_window_end = 0.38
Weapons.two_handed_spears_elf_template_1.actions.action_one.light_attack_stab_1.damage_window_start = 0.17
Weapons.two_handed_spears_elf_template_1.actions.action_one.light_attack_stab_1.damage_window_end = 0.34
Weapons.two_handed_spears_elf_template_1.actions.action_one.light_attack_stab_2.damage_window_start = 0.19
Weapons.two_handed_spears_elf_template_1.actions.action_one.light_attack_stab_2.damage_window_end = 0.33
Weapons.two_handed_spears_elf_template_1.actions.action_one.heavy_attack_stab.additional_critical_strike_chance = 0.4


--Flail 
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_left.anim_time_scale = 1 * 1.25	-- 1.0
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_right.anim_time_scale = 1 * 1.35	-- 1.0
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_bopp.anim_time_scale = 1 * 1.3	-- 1.1
--Light 1, 2, 3, 4 Movement Speed--
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_left.buff_data.external_multiplier = 0.9	-- 0.75
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_right.buff_data.external_multiplier = 0.9	--0.75
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_down.buff_data.external_multiplier = 0.9	--0.75
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_last.buff_data.external_multiplier = 1.0	--0.75

Weapons.dual_wield_axes_template_1.actions.action_one.heavy_attack_3.additional_critical_strike_chance = 0.2 --0

--Weapon Swap Fixes (moonfire, Coru, MWP, Jav)
Weapons.we_deus_01_template_1.actions.action_one.default.total_time = 0.7
Weapons.we_deus_01_template_1.actions.action_one.default.allowed_chain_actions[1].start_time =  0.4
Weapons.we_deus_01_template_1.actions.action_one.shoot_charged.total_time = 0.55
Weapons.we_deus_01_template_1.actions.action_one.shoot_charged.allowed_chain_actions[1].start_time = 0.45
Weapons.we_deus_01_template_1.actions.action_one.shoot_special_charged.total_time = 0.5 Weapons.we_deus_01_template_1.actions.action_one.shoot_special_charged.allowed_chain_actions[1].start_time = 0.4
Weapons.bw_deus_01_template_1.actions.action_two.default.allowed_chain_actions[1].start_time = 0
Weapons.heavy_steam_pistol_template_1.actions.action_one.shoot.total_time = 0.3
Weapons.heavy_steam_pistol_template_1.actions.action_one.shoot.allowed_chain_actions[1].start_time =  0.3
Weapons.fencing_sword_template_1.max_fatigue_points = 4
Weapons.javelin_template.actions.action_one.throw_charged.allowed_chain_actions[2].start_time = 0.3
Weapons.javelin_template.actions.action_one.default.allowed_chain_actions[2].start_time = 0.4
Weapons.javelin_template.actions.action_one.default_left.allowed_chain_actions[2].start_time = 0.4
Weapons.javelin_template.actions.action_one.default_chain_01.allowed_chain_actions[2].start_time = 0.45
Weapons.javelin_template.actions.action_one.default_chain_02.allowed_chain_actions[2].start_time = 0.45
Weapons.javelin_template.actions.action_one.default_chain_03.allowed_chain_actions[2].start_time = 0.45
Weapons.javelin_template.actions.action_one.stab_01.allowed_chain_actions[2].start_time = 0.4
Weapons.javelin_template.actions.action_one.stab_02.allowed_chain_actions[2].start_time = 0.4
Weapons.javelin_template.actions.action_one.chain_stab_03.allowed_chain_actions[2].start_time = 0.45
Weapons.javelin_template.actions.action_one.heavy_stab.allowed_chain_actions[2].start_time = 0.45

Weapons.repeating_pistol_template_1.dodge_count = 2
Weapons.repeating_pistol_template_1.ammo_data.ammo_per_reload = 16
Weapons.brace_of_pistols_template_1.ammo_data.ammo_per_reload = 3


BuffTemplates.weave_traits_reduce_cooldown_on_crit_internal_cooldown.buffs[1].duration = 3
BuffTemplates.traits_reduce_cooldown_on_crit_internal_cooldown.buffs[1].duration = 3

ExplosionTemplates.hammer_book_charged_impact_explosion_dash.explosion.radius_min = 0.3
ExplosionTemplates.hammer_book_charged_impact_explosion_dash.explosion.radius_max = 0.5
