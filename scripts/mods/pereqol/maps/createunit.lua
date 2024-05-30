local mod = get_mod("pereqol")

local unit_path = "units/Cube"
local unit_path_wide = "units/CubeWide"

local function spawn_package_to_player (package_name)
  local player = Managers.player:local_player()
  local world = Managers.world:world("level_world")

  if world and player and player.player_unit then
    local player_unit = player.player_unit

    local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
    local rotation = Unit.local_rotation(player_unit, 0)
    mod:echo(position)
    mod:echo(rotation)
    mod.position = position
    mod.rotation = rotation
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
  mod.cubetype = "normal"
end)

mod:command("widecube", "", function() 
  if mod.testcube then
    local world = Managers.world:world("level_world")
    World.destroy_unit(world, mod.testcube)
    mod.testcube = false
  end
  mod.testcube = spawn_package_to_player(unit_path_wide)
  mod.cubetype = "wide"
end)

mod:command("save", "", function()
  if mod.testcube then
    mod.objlist[#mod.objlist + 1] = {
      position = mod.position,
      rotation = mod.rotation,
      type = mod.cubetype
    }
    mod:echo("saved to list")
  end
end)

mod:command("listdump", "", function()
  mod:echo("dumping list of obj")
  mod:dump(mod.objlist , "Cubes", 4)
end)

mod:command("listclear", "", function()
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

