-- "addons\\feature-phone\\lua\\phone\\modules\\blacklist\\cl_init.lua"

netstream.Hook('dbgPhone.openBlacklistMenu', function(data, action)
	local menu = DermaMenu()

	if action == "add" then
		for _, playerData in ipairs(data) do
			menu:AddOption(playerData.name, function()
				netstream.Start('dbgPhone.updateBlacklist', 'add', playerData.steamid)
			end):SetIcon(octolib.icons.silk16('user_add'))
		end
	elseif action == "remove" then
		for _, steamid in ipairs(data) do
			local ply = player.GetBySteamID(steamid)
			local name = IsValid(ply) and ply:Name() or steamid
			menu:AddOption(name, function()
				netstream.Start('dbgPhone.updateBlacklist', 'remove', steamid)
			end):SetIcon(octolib.icons.silk16('user_delete'))
		end
	end

	menu:Open()
	menu:Center()
end)

dbgPhone.registerAction('blacklist', {
	title = L.make_blacklist,
	priority = 2,
	icon = octolib.icons.silk16('lock_go'),
	submenu = {
		{
			title = L.add,
			icon = octolib.icons.silk16('lock_add'),
			callback = function()
				netstream.Start('dbgPhone.requestBlacklist', 'add')
			end,
		},
		{
			title = L.remove,
			icon = octolib.icons.silk16('lock_delete'),
			callback = function()
				netstream.Start('dbgPhone.requestBlacklist', 'remove')
			end,
		},
	},
})
