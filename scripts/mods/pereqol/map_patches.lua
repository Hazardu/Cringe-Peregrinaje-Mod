local mod = get_mod("pereqol")

local function string_starts_with(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end
local PREFIXLEN = string.len("levels/honduras_dlcs/morris/pat__")
local function is_chw_map(lvlname, identifier)
    return string_starts_with(lvlname,"levels/honduras_dlcs/morris/") and string.sub(lvlname,PREFIXLEN,string.len(identifier)+PREFIXLEN-1)==identifier
end

mod.spawn_cubes_at_positions = function(t)
    local qb = QuaternionBox(0,0,1,1)
    local world = Managers.world:world("level_world")
    for index, value in pairs(t) do
        local pos = value.position
        local rot = value.rotation
        qb:store(rot[1],rot[2],rot[3],rot[4]) -- no constructor that takes 4 arguments lol
        local unit = World.spawn_unit(world, value.shape, Vector3(pos[1],pos[2],pos[3]), qb:unbox())
    end
end


local spawn_cubes_for_levels = function()
    
    local player = Managers.player:local_player()
    local world = Managers.world:world("level_world")
    local level_name = LevelHelper:current_level_settings(world).level_name
    if is_chw_map(level_name, "gorge") then
        mod:dofile("scripts/mods/pereqol/maps/foetid_gorge")
    elseif is_chw_map(level_name, "town") then
        mod:dofile("scripts/mods/pereqol/maps/grimblood_fortress")
    elseif is_chw_map(level_name, "mountain") then
        mod:dofile("scripts/mods/pereqol/maps/pinnacle_of_nightmares")
    elseif is_chw_map(level_name, "mordrek") then
        mod:dofile("scripts/mods/pereqol/maps/count_mordrek_fort")
    elseif is_chw_map(level_name, "mines") then
        mod:dofile("scripts/mods/pereqol/maps/belshazir_mines")
    elseif is_chw_map(level_name, "bay") then
        mod:dofile("scripts/mods/pereqol/maps/bay")
    elseif is_chw_map(level_name, "volcano") then
        mod:dofile("scripts/mods/pereqol/maps/cinder_peak")
    elseif is_chw_map(level_name, "forest") then
        mod:dofile("scripts/mods/pereqol/maps/forbidden_trail")
    elseif is_chw_map(level_name, "crag") then
        mod:dofile("scripts/mods/pereqol/maps/lost_city")
    elseif is_chw_map(level_name, "snare") then
        mod:dofile("scripts/mods/pereqol/maps/pit_of_reflections")
    elseif is_chw_map(level_name, "tower") then
        mod:dofile("scripts/mods/pereqol/maps/holseher_tower")
    elseif string_starts_with(level_name, "levels/honduras_dlcs/morris/arena_citadel") then
        mod:dofile("scripts/mods/pereqol/maps/citadel_arena")
    end
end


mod.on_game_state_changed = function(status, state)
    if status == "enter" and state == "StateIngame" then
        spawn_cubes_for_levels()
    end

end



