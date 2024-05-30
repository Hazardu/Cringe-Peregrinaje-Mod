local mod = get_mod("pereqol")

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local function randomize(event)
	if type(event) == "table" then
		return event[Math.random(1, #event)]
	else
		return event
	end
end
local CLIMB_HEIGHT_OFFSET_THRESHOLD = 2.1
local CLIMB_HEIGHT_OFFSET = 0.125
local climb_run_original = function (self, unit, blackboard, t, dt)
	local navigation_extension = blackboard.navigation_extension
	local locomotion_extension = blackboard.locomotion_extension
	local unit_position = POSITION_LOOKUP[unit]
	local is_on_edge = blackboard.smart_object_data.is_on_edge

	if blackboard.smart_object_data ~= blackboard.next_smart_object_data.smart_object_data then
		return "failed"
	end

	if blackboard.climb_state == "moving_to_within_smartobject_range" then
		local target_dir = Vector3.normalize(navigation_extension:desired_velocity())

		if Vector3.length(Vector3.flat(target_dir)) < 0.05 and Vector3.dot(target_dir, Vector3.normalize(blackboard.climb_exit_pos:unbox() - unit_position)) > 0.99 then
			blackboard.climb_moving_to_enter_entrance_timeout = blackboard.climb_moving_to_enter_entrance_timeout or t + 0.3
		else
			blackboard.climb_moving_to_enter_entrance_timeout = nil
		end

		if blackboard.is_in_smartobject_range or blackboard.climb_moving_to_enter_entrance_timeout and t > blackboard.climb_moving_to_enter_entrance_timeout then
			locomotion_extension:set_wanted_velocity(Vector3.zero())
			locomotion_extension:set_movement_type("script_driven")
			navigation_extension:set_enabled(false)

			if navigation_extension:use_smart_object(true) then
				blackboard.is_smart_objecting = true
				blackboard.is_climbing = true
				blackboard.stagger_prohibited = true
				blackboard.climb_state = "moving_to_to_entrance"
			else
				print("BTClimbAction - failing to use smart object")

				return "failed"
			end
		elseif script_data.ai_debug_smartobject then
			local dist = Vector3.distance_squared(blackboard.climb_entrance_pos:unbox(), unit_position)

			QuickDrawer:circle(blackboard.climb_entrance_pos:unbox(), math.max(dist - 1, 0.5), Vector3.up())
		end
	end

	if blackboard.climb_state == "moving_to_to_entrance" then
		local entrance_pos = blackboard.climb_entrance_pos:unbox()
		local vector_to_target = entrance_pos - unit_position
		local distance_to_target = Vector3.length(vector_to_target)
		local look_direction_wanted = blackboard.climb_ledge_lookat_direction:unbox()
		local look_rotation_wanted = Quaternion.look(look_direction_wanted)

		if distance_to_target > 0.1 then
			local speed = blackboard.breed.run_speed

			if distance_to_target < speed * dt then
				speed = distance_to_target / dt
			end

			local direction_to_target = Vector3.normalize(vector_to_target)

			locomotion_extension:set_wanted_velocity(direction_to_target * speed)
			locomotion_extension:set_wanted_rotation(look_rotation_wanted)

			if script_data.ai_debug_smartobject then
				QuickDrawer:vector(unit_position + Vector3.up() * 0.3, vector_to_target)
			end
		else
			locomotion_extension:teleport_to(entrance_pos, look_rotation_wanted)

			unit_position = entrance_pos

			locomotion_extension:set_wanted_velocity(Vector3.zero())

			local exit_pos = blackboard.climb_exit_pos:unbox()
			local ledge_position = blackboard.ledge_position:unbox() + Vector3.up()

			LocomotionUtils.constrain_on_clients(unit, true, Vector3.min(entrance_pos, exit_pos), Vector3.max(ledge_position, Vector3.max(entrance_pos, exit_pos)))
			LocomotionUtils.set_animation_driven_movement(unit, true, false, false)

			local hit_reaction_extension = ScriptUnit.extension(unit, "hit_reaction_system")

			hit_reaction_extension.force_ragdoll_on_death = true

			local smart_object_settings = SmartObjectSettings.templates[blackboard.breed.smart_object_template]

			if blackboard.climb_upwards or not is_on_edge then
				local ai_extension = ScriptUnit.extension(unit, "ai_system")
				local animation_translation_scale = 1 / ai_extension:size_variation()
				local jump_anim_thresholds = smart_object_settings.jump_up_anim_thresholds
				local climb_jump_height = blackboard.climb_jump_height

				for i = 1, #jump_anim_thresholds do
					local jump_anim_threshold = jump_anim_thresholds[i]

					if climb_jump_height < jump_anim_threshold.height_threshold then
						local jump_anim_name = is_on_edge and jump_anim_threshold.animation_edge or jump_anim_threshold.animation_fence

						Managers.state.network:anim_event(unit, randomize(jump_anim_name))

						local fence_vertical_length = jump_anim_threshold.fence_vertical_length or jump_anim_threshold.vertical_length
						local edge_vertical_length = jump_anim_threshold.vertical_length
						local anim_distance = is_on_edge and edge_vertical_length or fence_vertical_length

						animation_translation_scale = animation_translation_scale * climb_jump_height / anim_distance

						break
					end
				end

				LocomotionUtils.set_animation_translation_scale(unit, Vector3(1, 1, animation_translation_scale))
				locomotion_extension:set_wanted_velocity(Vector3.zero())

				blackboard.climb_state = "waiting_for_finished_climb_anim"
			else
				local jump_anim_thresholds = smart_object_settings.jump_down_anim_thresholds
				local climb_jump_height = math.abs(blackboard.climb_jump_height)

				for i = 1, #jump_anim_thresholds do
					local jump_anim_threshold = jump_anim_thresholds[i]

					if climb_jump_height < jump_anim_threshold.height_threshold then
						local jump_anim_name = is_on_edge and jump_anim_threshold.animation_edge or jump_anim_threshold.animation_fence

						Managers.state.network:anim_event(unit, randomize(jump_anim_name))

						local land_animations = jump_anim_threshold.animation_land or "jump_down_land"

						blackboard.jump_down_land_animation = randomize(land_animations)

						break
					end
				end

				blackboard.climb_state = "waiting_to_reach_ground"
			end
		end
	end

	if blackboard.climb_state == "waiting_for_finished_climb_anim" then
		local action_data = blackboard.action
		local catapult_players = action_data and action_data.catapult_players

		if catapult_players then
			self:_catapult_players(unit, blackboard, catapult_players)
		end

		if blackboard.jump_climb_finished then
			blackboard.jump_climb_finished = nil

			local exit_pos = blackboard.climb_exit_pos:unbox()
			local move_target = is_on_edge and exit_pos or blackboard.ledge_position:unbox()

			if is_on_edge then
				Managers.state.network:anim_event(unit, "move_fwd")

				blackboard.spawn_to_running = true

				locomotion_extension:teleport_to(move_target)

				local entrance_pos = blackboard.climb_entrance_pos:unbox()
				local climb_jump_height = move_target.z - entrance_pos.z

				if climb_jump_height < CLIMB_HEIGHT_OFFSET_THRESHOLD then
					navigation_extension:set_navbot_position(move_target + Vector3.up() * CLIMB_HEIGHT_OFFSET)
				else
					navigation_extension:set_navbot_position(move_target)
				end

				locomotion_extension:set_wanted_velocity(Vector3.zero())
				LocomotionUtils.set_animation_driven_movement(unit, false)

				blackboard.climb_state = "done"
			else
				local jump_anim_thresholds = SmartObjectSettings.templates[blackboard.breed.smart_object_template].jump_down_anim_thresholds
				local climb_jump_height = move_target.z - exit_pos.z

				for i = 1, #jump_anim_thresholds do
					local jump_anim_threshold = jump_anim_thresholds[i]

					if climb_jump_height < jump_anim_threshold.height_threshold then
						local ai_extension = ScriptUnit.extension(unit, "ai_system")
						local ai_size_variation = ai_extension:size_variation()
						local animation_length = jump_anim_threshold.fence_horizontal_length
						local flat_distance_to_jump = Vector3.length(Vector3.flat(unit_position - exit_pos))

						flat_distance_to_jump = flat_distance_to_jump - jump_anim_threshold.fence_land_length

						local animation_translation_scale = math.clamp(flat_distance_to_jump / (animation_length * ai_size_variation), -10, 10)

						LocomotionUtils.set_animation_translation_scale(unit, Vector3(animation_translation_scale, animation_translation_scale, 1))

						local jump_anim_name = jump_anim_threshold.animation_fence

						Managers.state.network:anim_event(unit, randomize(jump_anim_name))

						local land_animations = jump_anim_threshold.animation_land or "jump_down_land"

						blackboard.jump_down_land_animation = randomize(land_animations)

						break
					end
				end

				blackboard.climb_state = "waiting_to_reach_ground"
			end
		end
	end

	if blackboard.climb_state == "waiting_to_reach_ground" then
		local action_data = blackboard.action
		local catapult_players = action_data and action_data.catapult_players

		if catapult_players then
			self:_catapult_players(unit, blackboard, catapult_players)
		end

		local move_target = blackboard.climb_exit_pos:unbox()
		local velocity = locomotion_extension:current_velocity()

		if unit_position.z + velocity.z * dt * 2 <= move_target.z then
			LocomotionUtils.set_animation_driven_movement(unit, true, false, false)
			LocomotionUtils.set_animation_translation_scale(unit, Vector3(1, 1, 1))

			local land_animation = blackboard.jump_down_land_animation

			Managers.state.network:anim_event(unit, land_animation)

			local hit_reaction_extension = ScriptUnit.extension(unit, "hit_reaction_system")

			hit_reaction_extension.force_ragdoll_on_death = nil
			blackboard.climb_state = "waiting_for_finished_land_anim"
		end
	elseif blackboard.climb_state == "waiting_for_finished_land_anim" then
		local move_target = blackboard.climb_exit_pos:unbox()
		local ground_target = Vector3(unit_position.x, unit_position.y, move_target.z)

		locomotion_extension:teleport_to(ground_target)

		if blackboard.jump_climb_finished then
			local move_target = blackboard.climb_exit_pos:unbox()

			LocomotionUtils.set_animation_driven_movement(unit, false)
			Managers.state.network:anim_event(unit, "move_fwd")

			blackboard.spawn_to_running = true

			local distance = Vector3.distance(unit_position, move_target)

			if distance < 0.01 then
				local position_on_navmesh, altitude = GwNavQueries.triangle_from_position(blackboard.nav_world, move_target, 0.4, 0.4)

				if altitude then
					move_target.z = altitude
				end

				local entrance_pos = blackboard.climb_entrance_pos:unbox()
				local climb_jump_height = math.abs(move_target.z - entrance_pos.z)

				if climb_jump_height < CLIMB_HEIGHT_OFFSET_THRESHOLD then
					navigation_extension:set_navbot_position(move_target + Vector3.up() * CLIMB_HEIGHT_OFFSET)
				else
					navigation_extension:set_navbot_position(move_target)
				end

				locomotion_extension:teleport_to(move_target)
				locomotion_extension:set_wanted_velocity(Vector3.zero())

				blackboard.climb_state = "done"
			else
				local speed = blackboard.breed.run_speed
				local time_to_travel = distance / speed

				blackboard.climb_align_end_time = t + time_to_travel
				blackboard.climb_state = "aligning_to_navmesh"
			end
		end
	end

	if blackboard.climb_state == "aligning_to_navmesh" then
		local move_target = blackboard.climb_exit_pos:unbox()

		if t > blackboard.climb_align_end_time then
			local position_on_navmesh, altitude = GwNavQueries.triangle_from_position(blackboard.nav_world, move_target, 0.4, 0.4)

			if not position_on_navmesh then
				position_on_navmesh, altitude = GwNavQueries.triangle_from_position(blackboard.nav_world, move_target, 1.5, 1.5)

				if position_on_navmesh then
					printf("WTF navmesh pos @ move_target %s, actual altitude=%f", tostring(move_target), altitude)
				end
			end

			navigation_extension:set_navbot_position(move_target)
			locomotion_extension:teleport_to(move_target)
			locomotion_extension:set_wanted_velocity(Vector3.zero())

			blackboard.climb_state = "done"
		else
			local speed = blackboard.breed.run_speed
			local direction_to_target = Vector3.normalize(move_target - unit_position)
			local wanted_velocity = direction_to_target * speed

			locomotion_extension:set_wanted_velocity(wanted_velocity)
		end
	end

	if blackboard.climb_state == "done" then
		blackboard.climb_state = "done_for_reals"
	elseif blackboard.climb_state == "done_for_reals" then
		blackboard.climb_state = "done_for_reals2"
	elseif blackboard.climb_state == "done_for_reals2" then
		return "done"
	end

	return "running"
end

mod:hook(BTClimbAction, "run" ,function (func, ...)
	return climb_run_original(...)
end)
