local mod = get_mod("pereqol")
mod.on_setting_changed = function()
    if Managers.player.is_server then
        mod:network_send("rpc_cringe_sync", "all", mod:get("disable_ulgu_modifier"), mod:get("disable_darkness_modifier"), mod:get("disable_no_respawn_modifier"))
    else 
        mod:network_send("rpc_cringe_sync_request", "others")
    end

end

mod.on_user_joined = function(player)
	if Managers.player.is_server then
		mod:network_send("rpc_cringe_sync", "all", mod:get("disable_ulgu_modifier"), mod:get("disable_darkness_modifier"), mod:get("disable_no_respawn_modifier"))
	else
		mod:network_send("rpc_cringe_sync_request", "others")
	end
end

mod:network_register("rpc_cringe_sync", function (sender, skipUlgu, skipDarkness, skipAbduction)
    if not Managers.player.is_server then
        mod:set("disable_ulgu_modifier", skipUlgu)
        mod:set("disable_darkness_modifier", skipDarkness)
        mod:set("disable_no_respawn_modifier", skipAbduction)
    end
end)

mod:network_register("rpc_cringe_sync_request", function (sender)
    if Managers.player.is_server then
        mod:network_send("rpc_cringe_sync", "all", mod:get("disable_ulgu_modifier"), mod:get("disable_darkness_modifier"), mod:get("disable_no_respawn_modifier"))
    end
end)
