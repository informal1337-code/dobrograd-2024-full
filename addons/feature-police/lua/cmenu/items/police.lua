-- "addons\\feature-police\\lua\\cmenu\\items\\police.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function nameAsc(a, b)
	return a:GetName() < b:GetName()
end

local function getSortedPlayers()
	local plys = player.GetAll()
	table.sort(plys, nameAsc)
	return plys
end

local function canGov(ply)
	return ply:GetActiveRank('gov') ~= 'worker'
end

octogui.cmenu.registerItem('departments', 'police', {
	text = L.police,
	check = DarkRP.isCop,
	icon = octolib.icons.silk16('set_security_question'),
	options = {
		{
			text = 'Розыск',
			icon = octolib.icons.silk16('flag_flyaway_blue'),
			check = function(ply)
				if ply:GetActiveRank('gov') then return canGov(ply) end
				return DarkRP.isCop(ply) and not DarkRP.isMayor(ply)
			end,
			options = {
				{
					text = L.c_language_wanted,
					icon = octolib.icons.silk16('flag_flyaway_red'),
					build = function(sm)
						local me = LocalPlayer()
						for _, v in ipairs(getSortedPlayers()) do
							if v == me or v:isWanted() then continue end

							sm:AddOption(v:Name(), octolib.fStringRequest(L.make_wanted, L.reason_wanted, '', function(s)
								octochat.say('/wanted', v:UserID(), s)
							end, nil, L.ok, L.cancel)):SetColor(v:getJobTable().color)
						end
					end,
				}, {
					text = L.c_language_unwanted,
					icon = octolib.icons.silk16('flag_flyaway_green'),
					build = function(sm)
						for _, v in ipairs(getSortedPlayers()) do
							if not v:isWanted() then continue end

							sm:AddOption(v:Name(), octolib.fStringRequest(L.c_language_unwanted, L.c_language_unwanted_description, '', function(a)
								octochat.say('/unwanted', v:UserID(), a)
							end, nil, L.ok, L.cancel)):SetColor(v:getJobTable().color)
						end
					end,
				}
			},
		},
		{
			text = 'Штрафы',
			icon = octolib.icons.silk16('money'),
			check = function(ply)
				if ply:GetActiveRank('gov') then return canGov(ply) end
				return DarkRP.isCop(ply) and not DarkRP.isMayor(ply)
			end,
			build = function(sm)
				local me = LocalPlayer()
				for _, v in ipairs(getSortedPlayers()) do

					sm:AddOption(v:Name(), function(s)
						netstream.Start('dbg-police.fines.menu', v)
					end)
				end
			end,
		},
		{
			text = L.broadcast,
			icon = octolib.icons.silk16('email_go'),
			check = function(ply)
				return ply:isChief()
			end,
			action = octolib.fStringRequest(L.pbroadcast_hint, L.broadcast_write_text, '', function(s)
				octochat.say('/pbroadcast', s)
			end, nil, L.ok, L.cancel),
		},
		{
			text = 'Лицензия',
			icon = octolib.icons.silk16('page'),
			check = function(ply)
				local mayor, chief, serg, cop
				for _,v in ipairs(player.GetAll()) do
					if v:isMayor() or v:GetActiveRank('gov') == 'worker' then
						mayor = true
						break
					elseif v:isChief() then
						chief = true
					elseif v:getJobTable().command == 'cop2' then
						serg = true
					elseif v:isCP() then cop = true end
				end
				if mayor then
					return ply:isMayor() or ply:GetActiveRank('gov') == 'worker'
				elseif chief then
					return ply:isChief()
				elseif serg then
					return ply:getJobTable().command == 'cop2'
				elseif cop then
					return ply:isCP()
				else return ply:IsAdmin() end
			end,
			options = {
				{
					text = 'Выдать',
					icon = octolib.icons.silk16('page_add'),
					action = function()
						local value = ''
						local target = octolib.use.getTrace(LocalPlayer()).Entity
						if IsValid(target) then
							value = target:GetNetVar('HasGunlicense', '')
						end

						octolib.request.open({
							{
								name = 'Лицензия',
								desc = 'Напиши сюда, на что выдается лицензия. Лицензия на...',
								type = 'strLong',
								maxLen = 64,
								ph = 'Лицензия на...',
								value = value
							}
						}, function(data)
							if not data then return end
							octochat.say('/givelicense', data[1])
						end)
					end,
				}, {
					text = 'Изъять',
					icon = octolib.icons.silk16('page_delete'),
					action = function()
						local lply = LocalPlayer()
						octolib.request.open({
							{
								name = 'Забрать лицензию',
								type = 'comboBox',
								required = true,
								opts = octolib.table.mapSequential(player.GetAll(), function(ply, i)
									if not ply:GetNetVar('HasGunlicense') or ply == lply then return end
									if ply:getJobTable().police or ply:GetActiveRank('gov') then return end
									local name = ply:Name()
									return {name, name, i == 1}
								end)
							}
						}, function(data)
							if not data then return end
							octolib.request.open({
								{
									name = 'Лицензия',
									desc = 'Напиши сюда причину изъятия лицензии.',
									type = 'strShort',
									maxLen = 64,
								}
							}, function(data2)
								if not data2 then return end
								octochat.say('/takelicense', ('"%s"'):format(data[1]), ('"%s"'):format(data2[1]))
							end)
						end)
					end,
				}
			}
		}, {
			text = 'Проверить лицензии',
			icon = octolib.icons.silk16('page_white_magnify'),
			check = function(ply)
				if ply:GetActiveRank('gov') then return canGov(ply) end
				return DarkRP.isCop(ply)
			end,
			build = function(sm)
				for _, ply in ipairs(getSortedPlayers()) do
					sm:AddOption(ply:Name(), function(s)
						netstream.Start('dbg-police.checkLicense', ply)
					end)
				end
			end,
		},
		{
			text = 'Проверить автомобиль',
			icon = octolib.icons.silk16('car_add'),
			say = '/carcheck',
		},
		{
			text = 'Сменить подставное имя',
			icon = octolib.icons.silk16('group'),
			check = function(ply)
				return dbgPolice.checkCitizenForm(ply) and (ply:Team() == TEAM_DETECTIVE or ply:GetActiveRank('dpd') == 'dec') and ply:GetNetVar('dbg-police.fakeName') == nil
			end,
			action = octolib.fStringRequest('Сменить подставное имя', 'Введи подставное имя', '', function(arg)
				octochat.say('/fake', arg)
			end, nil, L.ok, L.cancel),
		},
		{
			text = 'Сбросить подставное имя',
			icon = octolib.icons.silk16('group_delete'),
			check = function(ply)
				return dbgPolice.checkCitizenForm(ply) and (ply:Team() == TEAM_DETECTIVE or ply:GetActiveRank('dpd') == 'dec') and ply:GetNetVar('dbg-police.fakeName') ~= nil
			end,
			action = function()
				octochat.say('/clearfake')
			end,
		},
		{
			text = L.request_backup,
			icon = octolib.icons.silk16('shield_add'),
			check = function(ply)
				local can = hook.Run('canCallHelp', ply)
				if can ~= nil then
					return can
				end

				return DarkRP.isCop(ply)
			end,
			action = octolib.fStringRequest(L.request_backup, L.request_backup_query, '', function(s)
				octochat.say('/callhelp', s)
			end, nil, L.ok, L.cancel),
		},
		{
			text = L.show_codes,
			icon = octolib.icons.silk16('document_inspector'),
			action = function()
				octogui.cmenu.window(L.codes_hint, L.codes_help)
			end,
		},
		{
			text = 'Уволить сотрудника',
			icon = octolib.icons.silk16('user_delete'),
			action = function()
				local ply = LocalPlayer()
				octolib.request.open({
					{
						order = 1,
						name = 'Уволить сотрудника',
					},
					target = {
						order = 2,
						required = true,
						desc = 'Выбери сотрудника',
						type = 'comboBox',
						opts = octolib.table.mapSequential(player.GetAll(), function(target, i)
							local policeJob = target:GetNetVar('dbg-police.job', '')
							if target ~= ply and policeJob ~= '' and target:Team() ~= TEAM_DPD then
								local job = DarkRP.getJobByCommand(policeJob)
								return {target:Name('gui') .. ' (' .. (job and job.name or L.unknown) .. ')', target, i == 1}
							end
						end),
					},
					reason = {
						order = 3,
						required = true,
						desc = 'Укажи причину увольнения',
						type = 'strShort',
						maxLen = 64,
					}
				}, function(data)
					if not data or not IsValid(data.target) then
						return
					end

					netstream.Start('dbg-police.fire', data.target, data.reason)
				end)
			end,
			check = function(ply)
				return DarkRP.isChief(ply)
			end
		},
	},
})
octogui.cmenu.registerItem('departments', 'gr', {
	text = L.speaker,
	check = function(ply)
		return DarkRP.isGov(ply) or hook.Run('canUseLoudSpeaker', ply) or false
	end,
	icon = octolib.icons.silk16('events'),
	action = octolib.fStringRequest(L.speaker_say, L.write_text, '', function(s)
		octochat.say('/gr', s)
	end, nil, L.ok, L.cancel),
})

octogui.cmenu.registerItem('departments', 'panicbtn', {
	text = L.panic_button_press,
	check = function(ply)
		local canUsePanic = hook.Run('canUsePanicButton', ply)
		if canUsePanic ~= nil then return canUsePanic == true end

		return DarkRP.isGov(ply)
	end,
	icon = octolib.icons.silk16('alarm_bell'),
	say = '/panicbutton',
})

local function canUse(ply)
	return DarkRP.isTaxist(ply) or ply:Team() == TEAM_ALPHA
end

octogui.cmenu.registerItem('departments', 'alphabtn', {
	text = L.panic_button_press,
	check = canUse,
	icon = octolib.icons.silk16('alarm_bell'),
	say = '/alphabutton',
})

octogui.cmenu.registerItem('clothes', 'police_clothes', {
	text = 'Форма',
	icon = octolib.icons.silk16('user_policeman_white'),
	check = function(ply)
		if not dbgPolice or not dbgPolice.clothes then return false end
		for _, v in pairs(dbgPolice.clothes) do
			if v.check and v.check(ply) then
				return true
			end
		end
		return false
	end,
	build = function(sm)
		local ply = LocalPlayer()
		if not dbgPolice or not dbgPolice.clothes then return end
		
		for id, clothes in pairs(dbgPolice.clothes) do
			if clothes.check and not clothes.check(ply) then
				continue
			end

			for bgId, bgInfo in pairs(clothes.bgs) do
				local icon, menuName, emote, value
				if ply:GetBodygroup(bgId) ~= bgInfo.values[1] then
					icon = octolib.icons.silk16(bgInfo.icons[2])
					value = bgInfo.values[1]
					menuName = bgInfo.menuNames[2]
					emote = bgInfo.emotes[2]
				else
					icon = octolib.icons.silk16(bgInfo.icons[1])
					value = bgInfo.values[2]
					menuName = bgInfo.menuNames[1]
					emote = bgInfo.emotes[1]
				end

				sm:AddOption(menuName, function()
					if bgInfo.slot and ply:GetMask(bgInfo.slot) then
						octolib.notify.show('warning', 'На тебе надет конфликтующий аксессуар, его необходимо сначала снять.')
						return
					end

					netstream.Start('dbg-police.clothes', id, bgId, value)
					octochat.say(emote)
				end):SetIcon(icon)
			end
		end
	end,
})