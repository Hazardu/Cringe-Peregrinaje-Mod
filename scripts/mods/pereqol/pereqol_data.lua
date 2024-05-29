local mod = get_mod("pereqol")

return {
	name = "Cringe Peregrinaje Mod",
	description = mod:localize("mod_description"),
	is_togglable = false,
	options ={
		collapsed_widgets = {},
		widgets = {
			{
				setting_id    = "disable_darkness_modifier",
				type          = "checkbox",
				default_value = true,
				title 		  = "disable_darkness_modifier_name",
				tooltip 	  = "disable_darkness_modifier_tooltip",
			},
			{
				setting_id    = "disable_no_respawn_modifier",
				type          = "checkbox",
				default_value = true,
				title 		  = "disable_no_respawn_modifier_name",
				tooltip 	  = "disable_no_respawn_modifier_tooltip",
			},
			{
				setting_id    = "disable_ulgu_modifier",
				type          = "checkbox",
				default_value = true,
				title 		  = "disable_ulgu_modifier_name",
				tooltip 	  = "disable_ulgu_modifier_tooltip",
			}
		}
	}
}
