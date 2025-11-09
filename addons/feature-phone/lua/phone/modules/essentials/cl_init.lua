-- "addons\\feature-phone\\lua\\phone\\modules\\essentials\\cl_init.lua"

local function req(title, desc, func)
	return function()
		Derma_StringRequest(title, desc, '', func, nil, L.ok, L.cancel)
	end
end

local function doCommand(start)
	return function(queryInput)
		local chatInput = start
		if queryInput then
			chatInput = chatInput .. ' ' .. queryInput
		end

		octochat.say(chatInput)
	end
end

local function hasSomething(tbl)
	for _, v in pairs(tbl) do
		if v then return true end
	end

	return false
end

local services = {
	{
		icon = octolib.icons.silk16('asterisk_yellow'),
		title = L.ems_hint,
		command = {
			title = L.call_ems,
			desc = 'На вызов могут отреагировать полицейские, медики и спасатели.\n' .. L.desc_sit_and_place,
			cmd = function(s)
				netstream.Start('dbg-phone.cr', s)
			end,
		},
	},
	{
		icon = octolib.icons.silk16('user_medical'),
		title = L.medic,
		check = DarkRP.isMedic,
		command = {
			title = L.call_medic,
			desc = 'На вызов могут отреагировать медики и фармацевты.\n' .. L.desc_sit_and_place,
			cmd = '/callmed',
		},
	},
	{
		icon = octolib.icons.silk16('user_firefighter'),
		title = 'Спасателей',
		check = DarkRP.isFirefighter,
		command = {
			title = 'Вызов спасателей',
			desc = L.desc_sit_and_place,
			cmd = '/callfire',
		},
	},
	{
		icon = octolib.icons.silk16('car'),
		title = L.mechanic2,
		check = DarkRP.isMech,
		command = {
			title = L.call_mech,
			desc = L.desc_sit_and_place,
			cmd = '/callmech',
		},
	},
	{
		icon = octolib.icons.silk16('wrench'),
		title = 'Городского рабочего',
		check = DarkRP.isWorker,
		command = {
			title = 'Вызов городского рабочего',
			desc = L.desc_sit_and_place,
			cmd = '/callworker',
		},
	},
	{
		icon = octolib.icons.silk16('add_package'),
		title = 'Грузчиков',
		check = function(ply)
			return ply:Team() == TEAM_RA
		end,
		command = {
			title = 'Вызов грузчиков',
			desc = L.desc_sit_and_place,
			cmd = '/callra',
		},
	},
	{
		icon = octolib.icons.silk16('car_taxi'),
		title = 'Такси',
		check = DarkRP.isTaxist,
		command = {
			title = 'Вызов такси',
			desc = 'Опиши местоположение и место назначения',
			cmd = '/calltaxi',
		},
	},
}

for _, v in ipairs(services) do
	local command = v.command

	local cmd = command.cmd
	v.callback = req(command.title, command.desc, isfunction(cmd) and cmd or doCommand(cmd))

	v.players = {}
end

local function updatePlayerInServices(ply)
	if not IsValid(ply) or not ply:IsPlayer() then
		return
	end

	for _, v in ipairs(services) do
		local check = v.check
		if not check then continue end

		v.players[ply] = check(ply) and true or nil
	end
end

hook.Add('PlayerChangedTeam', 'dbgPhones.updateEssentialServices', function(ply)
	updatePlayerInServices(ply)
end)

hook.Add('OnEntityCreated', 'dbgPhones.updateEssentialServices', function(ent, fullUpdate)
	if fullUpdate or not ent:IsPlayer() or ent == LocalPlayer() then return end

	updatePlayerInServices(ent)
end)

hook.Add('EntityRemoved', 'dbgPhones.updateEssentialServices', function(ent, fullUpdate)
	if fullUpdate or not ent:IsPlayer() then return end

	for _, v in ipairs(services) do
		v.players[ent] = nil
	end
end)

dbgPhone.registerAction('call_services', {
	title = L.call_hint,
	priority = 1,
	icon = octolib.icons.silk16('phone_handset'),
	submenu = function()
		local submenu, i = {}, 0

		for _, v in ipairs(services) do
			local check = v.check
			if check and not hasSomething(v.players) then continue end

			i = i + 1
			submenu[i] = v
		end

		return submenu
	end,
})

dbgPhone.registerAction('check_balance', {
	title = 'Проверить баланс',
	priority = 1,
	icon = octolib.icons.silk16('money'),
	callback = function()
		netstream.Start('chat', '/getbank')
	end,
})

dbgPhone.registerAction('advert', {
	title = L.advert,
	priority = 3,
	icon = octolib.icons.silk16('advertising'),
	submenu = {
		{
			title = L.create_text_newsletter,
			icon = octolib.icons.silk16('email_add'),
			callback = req(L.create_text_newsletter, L.text_advert, function(s)
				netstream.Start('chat', '/ad ' .. s)
			end),
		},
		{
			title = L.make_map_advert,
			icon = octolib.icons.silk16('map_add'),
			callback = function()
				netstream.Start('chat', '/mapadvert')
			end,
		},
	},
})

dbgPhone.registerAction('make_order', {
	title = L.make_order,
	priority = 3,
	icon = octolib.icons.silk16('cart_add'),
	callback = function()
		octogui.f4.openWindow('shop')
	end,
})