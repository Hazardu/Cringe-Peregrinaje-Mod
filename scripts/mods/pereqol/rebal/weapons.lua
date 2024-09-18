NewDamageProfileTemplates = NewDamageProfileTemplates or {}
function apply_weapon_changes()
    for key, _ in pairs(NewDamageProfileTemplates) do
		i = #NetworkLookup.damage_profiles + 1
		NetworkLookup.damage_profiles[i] = key
		NetworkLookup.damage_profiles[key] = i
	end
	--Merge the tables together
	table.merge_recursive(DamageProfileTemplates, NewDamageProfileTemplates)
	--Do FS things
	for name, damage_profile in pairs(DamageProfileTemplates) do
		if not damage_profile.targets then
			damage_profile.targets = {}
		end

		fassert(damage_profile.default_target, "damage profile [\"%s\"] missing default_target", name)

		if type(damage_profile.critical_strike) == "string" then
			local template = PowerLevelTemplates[damage_profile.critical_strike]

			fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.critical_strike)

			damage_profile.critical_strike = template
		end

		if type(damage_profile.cleave_distribution) == "string" then
			local template = PowerLevelTemplates[damage_profile.cleave_distribution]

			fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.cleave_distribution)

			damage_profile.cleave_distribution = template
		end

		if type(damage_profile.armor_modifier) == "string" then
			local template = PowerLevelTemplates[damage_profile.armor_modifier]

			fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.armor_modifier)

			damage_profile.armor_modifier = template
		end

		if type(damage_profile.default_target) == "string" then
			local template = PowerLevelTemplates[damage_profile.default_target]

			fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.default_target)

			damage_profile.default_target = template
		end

		if type(damage_profile.targets) == "string" then
			local template = PowerLevelTemplates[damage_profile.targets]

			fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.targets)

			damage_profile.targets = template
		end
	end

	local no_damage_templates = {}

	for name, damage_profile in pairs(DamageProfileTemplates) do
		local no_damage_name = name .. "_no_damage"

		if not DamageProfileTemplates[no_damage_name] then
			local no_damage_template = table.clone(damage_profile)

			if no_damage_template.targets then
				for _, target in ipairs(no_damage_template.targets) do
					if target.power_distribution then
						target.power_distribution.attack = 0
					end
				end
			end

			if no_damage_template.default_target.power_distribution then
				no_damage_template.default_target.power_distribution.attack = 0
			end

			no_damage_templates[no_damage_name] = no_damage_template
		end
	end

	DamageProfileTemplates = table.merge(DamageProfileTemplates, no_damage_templates)

	local MeleeBuffTypes = MeleeBuffTypes or {
		MELEE_1H = true,
		MELEE_2H = true
	}
	local RangedBuffTypes = RangedBuffTypes or {
		RANGED_ABILITY = true,
		RANGED = true
	}
	local WEAPON_DAMAGE_UNIT_LENGTH_EXTENT = 1.919366
	local TAP_ATTACK_BASE_RANGE_OFFSET = 0.6
	local HOLD_ATTACK_BASE_RANGE_OFFSET = 0.65

	for item_template_name, item_template in pairs(Weapons) do
		item_template.name = item_template_name
		item_template.crosshair_style = item_template.crosshair_style or "dot"
		local attack_meta_data = item_template.attack_meta_data
		local tap_attack_meta_data = attack_meta_data and attack_meta_data.tap_attack
		local hold_attack_meta_data = attack_meta_data and attack_meta_data.hold_attack
		local set_default_tap_attack_range = tap_attack_meta_data and tap_attack_meta_data.max_range == nil
		local set_default_hold_attack_range = hold_attack_meta_data and hold_attack_meta_data.max_range == nil

		if RangedBuffTypes[item_template.buff_type] and attack_meta_data then
			attack_meta_data.effective_against = attack_meta_data.effective_against or 0
			attack_meta_data.effective_against_charged = attack_meta_data.effective_against_charged or 0
			attack_meta_data.effective_against_combined = bit.bor(attack_meta_data.effective_against, attack_meta_data.effective_against_charged)
		end

		if MeleeBuffTypes[item_template.buff_type] then
			fassert(attack_meta_data, "Missing attack metadata for weapon %s", item_template_name)
			fassert(tap_attack_meta_data, "Missing tap_attack metadata for weapon %s", item_template_name)
			fassert(hold_attack_meta_data, "Missing hold_attack metadata for weapon %s", item_template_name)
			fassert(tap_attack_meta_data.arc, "Missing arc parameter in tap_attack metadata for weapon %s", item_template_name)
			fassert(hold_attack_meta_data.arc, "Missing arc parameter in hold_attack metadata for weapon %s", item_template_name)
		end

		local actions = item_template.actions

		for action_name, sub_actions in pairs(actions) do
			for sub_action_name, sub_action_data in pairs(sub_actions) do
				local lookup_data = {
					item_template_name = item_template_name,
					action_name = action_name,
					sub_action_name = sub_action_name
				}
				sub_action_data.lookup_data = lookup_data
				local action_kind = sub_action_data.kind
				local action_assert_func = ActionAssertFuncs[action_kind]

				if action_assert_func then
					action_assert_func(item_template_name, action_name, sub_action_name, sub_action_data)
				end

				if action_name == "action_one" then
					local range_mod = sub_action_data.range_mod or 1

					if set_default_tap_attack_range and string.find(sub_action_name, "light_attack") then
						local current_attack_range = tap_attack_meta_data.max_range or math.huge
						local tap_attack_range = TAP_ATTACK_BASE_RANGE_OFFSET + WEAPON_DAMAGE_UNIT_LENGTH_EXTENT * range_mod
						tap_attack_meta_data.max_range = math.min(current_attack_range, tap_attack_range)
					elseif set_default_hold_attack_range and string.find(sub_action_name, "heavy_attack") then
						local current_attack_range = hold_attack_meta_data.max_range or math.huge
						local hold_attack_range = HOLD_ATTACK_BASE_RANGE_OFFSET + WEAPON_DAMAGE_UNIT_LENGTH_EXTENT * range_mod
						hold_attack_meta_data.max_range = math.min(current_attack_range, hold_attack_range)
					end
				end

				local impact_data = sub_action_data.impact_data

				if impact_data then
					local pickup_settings = impact_data.pickup_settings

					if pickup_settings then
						local link_hit_zones = pickup_settings.link_hit_zones

						if link_hit_zones then
							for i = 1, #link_hit_zones, 1 do
								local hit_zone_name = link_hit_zones[i]
								link_hit_zones[hit_zone_name] = true
							end
						end
					end
				end
			end
		end
	end
end


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
Weapons.two_handed_spears_elf_template_1.actions.action_one.heavy_attack_stab.additional_critical_strike_chance = 0.30


--Flail 
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_left.anim_time_scale = 1 * 1.25	-- 1.0
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_right.anim_time_scale = 1 * 1.35	-- 1.0
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_bopp.anim_time_scale = 1 * 1.3	-- 1.1

--Light 1, 2, 3, 4 Movement Speed--
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_left.buff_data.external_multiplier = 0.9	-- 0.75
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_right.buff_data.external_multiplier = 0.9	--0.75
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_down.buff_data.external_multiplier = 0.9	--0.75
Weapons.one_handed_flail_template_1.actions.action_one.light_attack_last.buff_data.external_multiplier = 1.0	--0.75

Weapons.dual_wield_axes_template_1.actions.action_one.heavy_attack_3.additional_critical_strike_chance = 0.15 --0

--Weapon Swap Fixes (moonfire, Coru, MWP, Jav)
Weapons.we_deus_01_template_1.actions.action_one.default.total_time = 0.7
Weapons.we_deus_01_template_1.actions.action_one.default.allowed_chain_actions[1].start_time =  0.4
Weapons.we_deus_01_template_1.actions.action_one.shoot_charged.total_time = 0.55
Weapons.we_deus_01_template_1.actions.action_one.shoot_charged.allowed_chain_actions[1].start_time = 0.45
Weapons.we_deus_01_template_1.actions.action_one.shoot_special_charged.total_time = 0.5 Weapons.we_deus_01_template_1.actions.action_one.shoot_special_charged.allowed_chain_actions[1].start_time = 0.4
Weapons.bw_deus_01_template_1.actions.action_two.default.allowed_chain_actions[1].start_time = 0

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

Weapons.fencing_sword_template_1.max_fatigue_points = 4

Weapons.two_handed_swords_template_1.actions.action_one.light_attack_bopp.anim_time_scale = 1.3
Weapons.two_handed_swords_template_1.actions.action_one.push.fatigue_cost = "action_stun_push"

Weapons.two_handed_axes_template_2.actions.action_one.light_attack_left_upward.anim_time_scale = 1.1		
Weapons.two_handed_axes_template_2.actions.action_one.light_attack_left.anim_time_scale = 1.3
Weapons.two_handed_axes_template_2.actions.action_one.light_attack_bopp.anim_time_scale = 1.2

-- 1h axe
Weapons.one_hand_axe_template_1.actions.action_one.light_attack_last.anim_time_scale = 1.25 --1.035
Weapons.one_hand_axe_template_2.actions.action_one.light_attack_last.anim_time_scale = 1.25 --1.035
Weapons.one_hand_axe_template_1.actions.action_one.heavy_attack_left.range_mod = 1.2 --1
Weapons.one_hand_axe_template_1.actions.action_one.heavy_attack_right.range_mod = 1.15 --1
Weapons.one_hand_axe_template_2.actions.action_one.heavy_attack_left.range_mod = 1.15 --1
Weapons.one_hand_axe_template_2.actions.action_one.heavy_attack_right.range_mod = 1.2 --1
Weapons.one_hand_axe_template_1.actions.action_one.light_attack_last.damage_profile = "light_1h_axe_cringe"
Weapons.one_hand_axe_template_2.actions.action_one.light_attack_last.damage_profile = "light_1h_axe_cringe"
Weapons.one_hand_axe_template_1.actions.action_one.light_attack_left.damage_profile = "light_1h_axe_cringe"
Weapons.one_hand_axe_template_2.actions.action_one.light_attack_left.damage_profile = "light_1h_axe_cringe"
Weapons.one_hand_axe_template_1.actions.action_one.light_attack_right.damage_profile = "light_1h_axe_cringe"
Weapons.one_hand_axe_template_2.actions.action_one.light_attack_right.damage_profile = "light_1h_axe_cringe"
Weapons.one_hand_axe_template_1.actions.action_one.light_attack_bopp.damage_profile = "light_1h_axe_cringe"
Weapons.one_hand_axe_template_2.actions.action_one.light_attack_bopp.damage_profile = "light_1h_axe_cringe"
Weapons.we_one_hand_axe_template.actions.action_one.light_attack_left.damage_profile = "light_1h_axe_cringe"
Weapons.we_one_hand_axe_template.actions.action_one.light_attack_right.damage_profile = "light_1h_axe_cringe"
Weapons.we_one_hand_axe_template.actions.action_one.light_attack_right_last.damage_profile = "light_1h_axe_cringe"
Weapons.we_one_hand_axe_template.actions.action_one.light_attack_last.damage_profile = "light_1h_axe_cringe"
Weapons.we_one_hand_axe_template.actions.action_one.light_attack_bopp.damage_profile = "light_1h_axe_cringe"

--Heavy
NewDamageProfileTemplates.light_1h_axe_cringe = {
    armor_modifier = {
        attack = {
            1.35,
            0.5,
            2.15,
            1.5,
            1.4,
            0.6
        },
        impact = {
            1,
            0.5,
            1,
            1,
            0.75,
            0.25
        }
    },
    critical_strike = {
        attack_armor_power_modifer = {
            1.25,
            0.45,
            2.75,
            1,
            1
        },
        impact_armor_power_modifer = {
            1,
            1,
            1,
            1,
            1
        }
    },
    charge_value = "light_attack",
    cleave_distribution = {
        attack = 0.1,
        impact = 0.05
    },
    default_target = {
        boost_curve_type = "smiter_curve",
        attack_template = "slashing_smiter",
        boost_curve_coefficient_headshot = 2,
        power_distribution = {
            attack = 0.3,
            impact = 0.15
        }
    },
    ignore_stagger_reduction = true,
    targets =  {
        [2] = {
            boost_curve_type = "smiter_curve",
            attack_template = "slashing_smiter",
            armor_modifier = {
                attack = {
                    1,
                    0.25,
                    1,
                    1,
                    0.75
                },
                impact = {
                    0.75,
                    0.25,
                    1,
                    1,
                    0.75
                }
            },
            power_distribution = {
                attack = 0.1,
                impact = 0.05
            }
        }
    },
}

Weapons.two_handed_hammers_template_1.actions.action_one.heavy_attack_right.anim_time_scale = 1.15
Weapons.two_handed_hammers_template_1.actions.action_one.heavy_attack_left.anim_time_scale = 1.15
DamageProfileTemplates.priest_hammer_heavy_blunt_tank_upper.targets[2].power_distribution.attack = 0.1
DamageProfileTemplates.priest_hammer_blunt_smiter.armor_modifier.attack[2] = 2.025
DamageProfileTemplates.priest_hammer_blunt_smiter.armor_modifier.attack[6] = 1.2
DamageProfileTemplates.priest_hammer_blunt_smiter.critical_strike.attack_armor_power_modifer[2] = 1.8

DamageProfileTemplates.light_slashing_smiter_finesse.shield_break = true


apply_weapon_changes()