return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`pereqol` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("pereqol", {
			mod_script       = "scripts/mods/pereqol/pereqol",
			mod_data         = "scripts/mods/pereqol/pereqol_data",
			mod_localization = "scripts/mods/pereqol/pereqol_localization",
		})
	end,
	packages = {
		"resource_packages/pereqol/pereqol",
	},
}
