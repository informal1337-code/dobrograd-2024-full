-- "addons\\feature-phone\\lua\\phone\\modules\\blacklist\\cl_init.lua"

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