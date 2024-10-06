local mod = get_mod("pereqol")

--before peregrinaje initializes
mod:dofile("scripts/mods/pereqol/rpcs")
mod:dofile("scripts/mods/pereqol/stagger")
mod:dofile("scripts/mods/pereqol/map_patch_utils")
mod:dofile("scripts/mods/pereqol/map_patches")
mod:dofile("scripts/mods/pereqol/rebal/more_talents")



--after peregrinaje updates
mod.loaded = false
local updateFrames = 0
mod.update = function(dt)
	if mod.loaded == false then
		local pmod = get_mod("Peregrinaje")
		if pmod then
			if pmod["player_stats"] then 
				local ps = pmod["player_stats"]
				if next(ps) ~= nil then
					updateFrames = updateFrames + dt
					if updateFrames > 1 then
						mod.loaded = true
                        pmod:ToggleStats()
                        mod:dump(pmod,"Peregrinaje mod object", 0)
                        mod:dofile("scripts/mods/pereqol/post_peregrinaje_init")
					end
				end
			end
		end
	end
    mod.update_cubes(dt)
end