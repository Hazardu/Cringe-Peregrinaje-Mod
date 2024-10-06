local mod = get_mod("pereqol")
local unit_path = "units/Cube"
local unit_path_wide = "units/CubeWide"

mod.positionBox = Vector3Box()
local function storepos(position)
  local unit_position_x, unit_position_y, unit_position_z = Vector3.to_elements(position)
  mod.position = { unit_position_x, unit_position_y, unit_position_z }
  mod.positionBox:store(position)
end

mod.rotationBox = QuaternionBox()
local function storerot(rotation)
  local unit_rotation_x, unit_rotation_y, unit_rotation_z, unit_rotation_w = Quaternion.to_elements(rotation)
  mod.rotation = { unit_rotation_x, unit_rotation_y, unit_rotation_z, unit_rotation_w }
  mod.rotationBox:store(rotation)
end


local function spawn_package_to_player (package_name)
  local player = Managers.player:local_player()
  local world = Managers.world:world("level_world")

  if world and player and player.player_unit then
    local player_unit = player.player_unit
    local camera_unit = player.camera_follow_unit
    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(camera_unit, 0)

    storepos(position)
    storerot(rotation)
    mod.cubetype = package_name

    local unit = World.spawn_unit(world, package_name, position, rotation)
    return unit
  end

  return nil
end

mod.objlist = {}

mod:command("cube", "", function() 
  if mod.testcube then
    local world = Managers.world:world("level_world")
    World.destroy_unit(world, mod.testcube)
    mod.testcube = false
  end
  mod.testcube = spawn_package_to_player(unit_path)
end)

mod:command("widecube", "", function() 
  if mod.testcube then
    local world = Managers.world:world("level_world")
    World.destroy_unit(world, mod.testcube)
    mod.testcube = false
  end
  mod.testcube = spawn_package_to_player(unit_path_wide)
end)

mod:command("save", "", function()
  if mod.testcube then
    mod.objlist[#mod.objlist + 1] = {
      position = mod.position,
      rotation = mod.rotation,
      shape = mod.cubetype
    }
    mod:echo("saved to list")
    mod.testcube = false
  end
end)

mod:command("dumplist", "", function()
  mod:echo("dumping list of obj")
  for key, value in pairs(mod.objlist) do
    mod:echo("{\n    shape = \"" .. value.shape .. "\",\n    rotation = {" .. tostring(value.rotation[1]) .. ", " .. tostring(value.rotation[2]) .. ", ".. tostring(value.rotation[3]) .. ", ".. tostring(value.rotation[4]) .. "},\n    position = { " .. tostring(value.position[1]) .. ", " .. tostring(value.position[2]) .. ", " .. tostring(value.position[3]) .. "}\n}," )
  end
  local world = Managers.world:world("level_world")
  local level_name = LevelHelper:current_level_settings(world).level_name
  mod:echo("Level name: " .. level_name)
end)

mod:command("clearlist", "", function()
  mod.objlist = {}
  mod:echo("list of obj cleared")
end)

mod:command("remove", "", function()
  if mod.testcube then
    local world = Managers.world:world("level_world")
    World.destroy_unit(world, mod.testcube)
    mod.testcube = false
  end
end)

local function resetCollision()
  if mod.testcube then
    local world = Managers.world:world("level_world")
    World.destroy_unit(world, mod.testcube)
    mod.testcube = World.spawn_unit(world, mod.cubetype, mod.positionBox:unbox(), mod.rotationBox:unbox())
  end
end

local dragging = false
local dragOffsetBox = Vector3Box(Vector3(0,0,0))

function mod.update_cubes(dt)
  if mod.testcube then
    local player = Managers.player:local_player()
    local world = Managers.world:world("level_world")
    local camera_unit = player.camera_follow_unit
    if world and player and player.player_unit then
      local player_unit = player.player_unit
      if Keyboard.button(Keyboard.button_index("1"))  > 0.5 then
        local playerposition = Unit.local_position(player_unit, 0)
        if dragging then
          local position = playerposition + dragOffsetBox:unbox()
          Unit.set_local_position(mod.testcube, 0, position)
          storepos(position)
        else
          dragOffsetBox:store(mod.positionBox:unbox() - playerposition)
          dragging = true
        end
      else
        dragging = false
        resetCollision()
      end

      if Keyboard.button(Keyboard.button_index("2")) > 0.5 then
        local camera_unit = player.camera_follow_unit
        local rotation = Unit.local_rotation(camera_unit, 0)
        Unit.set_local_rotation(mod.testcube, 0, rotation)
        storerot(rotation)
      end
    end
  end
end


-- save
-- remove
-- reset : resets collisions to current position
-- cube
-- widecube
-- listdump
-- listclear
