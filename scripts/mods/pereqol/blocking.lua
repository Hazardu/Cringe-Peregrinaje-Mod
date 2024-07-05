local mod = get_mod("pereqol")

mod:hook(GenericStatusExtension, "can_block", function (func, self, attacking_unit, attack_direction)
	local unit = self.unit
	local player = self.player
	local inventory_extension = self.inventory_extension
	local equipment = inventory_extension:equipment()
	local network_manager = Managers.state.network
	local weapon_template_name = equipment.wielded.template or equipment.wielded.temporary_template
	local weapon_template = Weapons[weapon_template_name]

	if not weapon_template_name then
		return false
	end

	local game = network_manager:game()
	local unit_id = network_manager:unit_game_object_id(unit)

	if not game or not unit_id then
		return false
	end

	if player then
		local aim_direction = GameSession.game_object_field(game, unit_id, "aim_direction")
		local player_direction_flat = Vector3.flat(aim_direction)
		local player_position = POSITION_LOOKUP[unit]
		local attacker_position = POSITION_LOOKUP[attacking_unit] or Unit.world_position(attacking_unit, 0)
		local block_direction = Vector3.normalize(attacker_position - player_position)
		local block_direction_flat = Vector3.flat(block_direction)
		local buff_extension = self.buff_extension
		local block_angle = buff_extension:apply_buffs_to_value(weapon_template.block_angle or 90, "block_angle")
		local outer_block_angle = 360

		block_angle = math.clamp(block_angle, 0, 360)
		outer_block_angle = math.clamp(outer_block_angle, 0, 360)

		local block_half_angle = math.rad(block_angle * 0.5)
		local outer_block_half_angle = math.rad(outer_block_angle * 0.5)
		local dot = Vector3.dot(block_direction_flat, player_direction_flat)
		local angle_to_attacker = math.acos(dot)
		local block = angle_to_attacker <= block_half_angle
		local outer_block = block_half_angle < angle_to_attacker and angle_to_attacker <= outer_block_half_angle

		if not block and not outer_block then
			return false
		end

		if script_data.debug_draw_block_arcs then
			if block and not outer_block then
				self._debug_draw_color = Colors.get_table("lime")
			elseif not block and outer_block then
				self._debug_draw_color = Colors.get_table("dark_orange")
			else
				self._debug_draw_color = Colors.get_table("red")
			end
		end

		local fatigue_point_costs_multiplier = outer_block and (weapon_template.outer_block_fatigue_point_multiplier or 2) or weapon_template.block_fatigue_point_multiplier or 1
		local improved_block = block and not outer_block

		if not attack_direction then
			local cross = Vector3.cross(block_direction_flat, player_direction_flat)

			attack_direction = cross.z < 0 and "left" or "right"
		end

		return true, fatigue_point_costs_multiplier, improved_block, attack_direction
	end

	return false
end)