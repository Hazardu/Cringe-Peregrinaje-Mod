local mod = get_mod("pereqol")

mod.reserve_space_for_talent("huntsman_pinpoint_accuracy", "es_huntsman", 5, "kerillian_waywatcher_movement_speed_on_special_kill")

local elf_talent_len = #Talents.wood_elf
mod.reserve_space_for_talent("kerillian_waywatcher_passive_restore_ammo", "we_waywatcher", 4, "kerillian_waywatcher_movement_speed_on_special_kill", elf_talent_len + 1)
-- mod.reserve_space_for_talent("cringe_kerillian_waywatcher_bloodshot", "we_waywatcher", 2, "kerillian_waywatcher_extra_arrow_melee_kill", elf_talent_len + 2)
