dbgChars = dbgChars or {}

local allowedModels = {
	['models/humans/octo/female_01.mdl'] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21,22,23,24,25,26,27,28,29},
	['models/humans/octo/female_02.mdl'] = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
	['models/humans/octo/female_03.mdl'] = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
	['models/humans/octo/female_04.mdl'] = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
	['models/humans/octo/female_06.mdl'] = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
	['models/humans/octo/female_07.mdl'] = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
	['models/humans/octo/male_01_01.mdl'] = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
	['models/humans/octo/male_02_01.mdl'] = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
	['models/humans/octo/male_03_01.mdl'] = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
	['models/humans/octo/male_04_01.mdl'] = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
	['models/humans/octo/male_05_01.mdl'] = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
	['models/humans/octo/male_06_01.mdl'] = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
	['models/humans/octo/male_07_01.mdl'] = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
	['models/humans/octo/male_08_01.mdl'] = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
	['models/humans/octo/male_09_01.mdl'] = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
}

function dbgChars.sanitizeName(name)
	return string.Trim(octolib.string.camel(octolib.string.stripNonCyrillic(utf8.sub(name, 1, 35))))
end

function dbgChars.sanitizeDescription(desc)
	return string.Trim(octolib.string.stripNonWord(utf8.sub(desc, 1, 350), ',:%.0-9-;%(%)%/%"%\'a-zA-Z'))
end

local function savePresetsToData(ply, presets)
	if not IsValid(ply) or not octolib.db then return end

	local steamID = ply:SteamID()
	if not steamID then return end

	octolib.db:PrepareQuery('REPLACE INTO `dbg_characters_presets` (`steamid`, `presets`) VALUES (?, ?)', {steamID, pon.encode(presets or {})}, function(q, st, res)
		if not st then print('DBG Error saving presets: ', res) end
	end)
end

local function loadPresetsFromData(ply, callback)
	callback = callback or octolib.func.zero
	if not IsValid(ply) or not octolib.db then return callback({}) end

	local steamID = ply:SteamID()
	if not steamID then return callback({}) end

	octolib.db:PrepareQuery('SELECT `presets` FROM `dbg_characters_presets` WHERE `steamid` = ?', {steamID}, function(q, st, data)
		if st and data[1] then
			callback(pon.decode(data[1].presets) or {})
		else
			callback({})
		end
	end)
end

hook.Add('octolib.db.init', 'dbg-characters.dbInit', function(db)
	db:RunQuery([[
		CREATE TABLE IF NOT EXISTS `dbg_characters_presets` (
			`steamid` VARCHAR(32) NOT NULL PRIMARY KEY,
			`presets` TEXT NOT NULL
		) CHARSET=utf8 COLLATE=utf8_unicode_ci
	]], function(q, st, err) if not st then print('DBG Characters DB init error:', err) end end)
end)

netstream.Hook('dbg-characters.savePresets', function(ply, presets)
	if not presets then return end

	local maxPresets = ply:IsPremium() and 10 or 3
	if #presets > maxPresets then
		ply:Notify('warning', 'Превышен лимит сохраненных персонажей')
		return
	end

	for _, preset in ipairs(presets) do
		if not allowedModels[preset.model] then
			ply:Notify('warning', 'Недопустимая модель в пресете: ' .. tostring(preset.model))
			return
		end

		local skinData = allowedModels[preset.model]
		if preset.skin and skinData ~= true and not table.HasValue(skinData, preset.skin) then
			ply:Notify('warning', 'Недопустимый скин в пресете')
			return
		end
	end

	savePresetsToData(ply, presets)
	ply.presets = presets
end)

netstream.Hook('dbg-characters.getPresets', function(ply)
	loadPresetsFromData(ply, function(presets)
		ply.presets = presets
		netstream.Start(ply, 'dbg-characters.getPresets', presets)
	end)
end)

netstream.Hook('dbg-characters.selectPreset', function(ply, presetIndex)
	if not ply.presets or not ply.presets[presetIndex] then
		ply:Notify('warning', 'Пресет не найден')
		return
	end

	local preset = ply.presets[presetIndex]

	local ok = allowedModels[preset.model]
	if not ok or not util.IsValidModel(preset.model) then
		ply:Notify('warning', 'Модель персонажа недоступна')
		return
	end

	ply:SetNetVar('SelectedPreset', preset)

	if ply:Alive() then
		ply:KillSilent()
	end
end)

netstream.Hook('dbg-characters.newPreset', function(ply, presetData)
	if not ply.presets then
		ply.presets = {}
	end

	local maxPresets = ply:IsPremium() and 10 or 3
	if #ply.presets >= maxPresets then
		ply:Notify('warning', 'Достигнут лимит персонажей')
		return
	end

	presetData.id = #ply.presets + 1
	presetData.created = os.time()

	table.insert(ply.presets, presetData)

	savePresetsToData(ply, ply.presets)

	netstream.Start(ply, 'dbg-characters.newPreset', presetData)
end)

netstream.Hook('dbg-characters.editPreset', function(ply, presetIndex, presetData)
	if not ply.presets or not ply.presets[presetIndex] then
		ply:Notify('warning', 'Пресет не найден')
		return
	end

	presetData.updated = os.time()
	ply.presets[presetIndex] = presetData

	savePresetsToData(ply, ply.presets)

	netstream.Start(ply, 'dbg-characters.editPreset', presetIndex, presetData)
end)

netstream.Hook('dbg-characters.removePreset', function(ply, presetIndex)
	if not ply.presets or not ply.presets[presetIndex] then
		ply:Notify('warning', 'Пресет не найден')
		return
	end

	table.remove(ply.presets, presetIndex)

	for i, preset in ipairs(ply.presets) do
		preset.id = i
	end

	savePresetsToData(ply, ply.presets)

	netstream.Start(ply, 'dbg-characters.removePreset', presetIndex)
end)

hook.Add('PlayerInitialSpawn', 'dbg-char.loadPresets', function(ply)
	loadPresetsFromData(ply, function(presets)
		ply.presets = presets
	end)
end)

local function getRandomModel()
	local models = table.GetKeys(allowedModels)
	local model = models[math.random(#models)]
	local skinData = allowedModels[model]
	local skin = skinData[math.random(#skinData)]
	return model, skin
end

local function getRandomName(isMale)
	local namePool = isMale and dbgChars.config.names.male or dbgChars.config.names.female
	local name = namePool[math.random(#namePool)]
	local surname = dbgChars.config.names.surnames[math.random(#dbgChars.config.names.surnames)]

	return ('%s %s'):format(name, surname)
end

local function getJobByCommand(jobCmd)
	for _, v in ipairs(RPExtraTeams) do
		if v.command == jobCmd and (v.customCheck and v.customCheck(LocalPlayer()) or true) and not v.noPreference then
			return v, v.team
		end
	end
end

local function applyCharData(ply, name, jobCmd, desc, model, skin, face, voice)
	local job, jobID = getJobByCommand(jobCmd or 'citizen') or getJobByCommand('citizen')
	jobID = jobID or 1

	if ply:Name() ~= name then ply:SetName(name) end
	if ply:Team() ~= jobID then ply:changeTeam(jobID, true, true) end
	ply:SetModel(model or 'models/humans/octo/male_01_01.mdl')
	ply:SetSkin(skin or 0)
	ply:SetSubMaterial(0, (face and face ~= '') and face or nil)
	ply:SetNetVar('dbgDesc', (desc and desc ~= '') and desc or nil)
	ply:SetSalary(job and job.salary or 0)
	if voice then ply:SetNetVar('Voice', voice) end

	ply:SetNetVar('dbgLook', {
		name = 'playerName',
		nameRender = true,
		desc = 'playerDesc',
		descRender = true,
		checkLoader = 'playerLoader',
		time = 0.75,
		bone = 'ValveBiped.Bip01_Head1',
		posAbs = Vector(0, 0, 10),
		lookOff = Vector(0, -100, 0),
	})
end

local function spawnPlayer(ply)
	if not ply.passedTest then return end

	local selectedPreset = ply:GetNetVar('SelectedPreset')
	if selectedPreset then
		applyCharData(ply, selectedPreset.name, selectedPreset.jobCmd, selectedPreset.desc, selectedPreset.model, selectedPreset.skin, selectedPreset.face, selectedPreset.voice)
	else
		ply:GetClientVar({
			'dbgChars.name', 'dbgChars.model', 'dbgChars.skin', 'dbgChars.face', 'dbgChars.job', 'dbgChars.desc'
		}, function(vars)
			local name, model, skin, face, jobCmd, desc = vars['dbgChars.name'], vars['dbgChars.model'], vars['dbgChars.skin'], vars['dbgChars.face'], vars['dbgChars.job'], vars['dbgChars.desc']

			if not (name and name ~= '' and model and model ~= '' and allowedModels[model]) then
				model, skin = getRandomModel()
				name = getRandomName(octolib.models.isMale(model))
			end

			if not allowedModels[model] or not util.IsValidModel(model) then model, skin = getRandomModel() end
			local skins = allowedModels[model]
			if skin < 0 or skin > 32 or (istable(skins) and not table.HasValue(skins, skin)) then skin = 0 end

			local job = getJobByCommand(jobCmd)
			if not job then jobCmd = 'citizen' end

			name = dbgChars.sanitizeName(name)
			if name == '' then name = getRandomName(octolib.models.isMale(model)) end
			if not string.find(name, ' ') then name = getRandomName(octolib.models.isMale(model)) end

			ply:SetClientVar('dbgChars.name', name)
			ply:SetClientVar('dbgChars.model', model)
			ply:SetClientVar('dbgChars.skin', skin)
			ply:SetClientVar('dbgChars.job', jobCmd)
			ply:SetClientVar('dbgChars.face', face)
			ply:SetClientVar('dbgChars.desc', desc or '')

			applyCharData(ply, name, jobCmd, desc, model, skin, face)
		end)
	end
end

hook.Add('PlayerSpawn', 'dbg-char.spawn', spawnPlayer)
hook.Add('PlayerFinishedLoading', 'dbg-char.spawn', spawnPlayer)

local spawnsConfig = {
	rp_evocity_dbg_251031 = {
		Vector(735, 7135, 71),
		Vector(-4019, -8764, 72),
	},
	rp_truenorth_v1a = {
		Vector(-11076, 15175, -200),
		Vector(-6519, 7204, 136),
		Vector(5060, 9926, 136),
		Vector(10540, 12466, 8),
		Vector(8496, 10592, 8),
		Vector(15810, -990, 4),
		Vector(13648, -12944, 8),
		Vector(-13805, -12976, 16),
		Vector(-16, 1666, 8),
		Vector(5997, 2532, 0),
		Vector(3887, 1592, 8),
	}
}

local respPos = spawnsConfig[game.GetMap()] or spawnsConfig.rp_evocity_dbg_251031

local function getRespawnPos(ply, minDist, maxDist)
	if minDist then
		local okPos = {}
		for _, pos in ipairs(respPos) do
			local dist = ply:GetPos():DistToSqr(pos)
			if dist > minDist * minDist and not maxDist or dist < maxDist * maxDist then
				table.insert(okPos, pos)
			end
		end

		return okPos[math.random(#okPos)]
	else
		return respPos[math.random(#respPos)]
	end
end

local function enableCharRespawn(ply, pos)
	ply.dbgChar_respawnPos = pos

	netstream.Start(ply, 'dbg-characters.updateState', true)

	ply:AddMarker({
		id = 'change-char',
		txt = 'Место для смены персонажа',
		pos = pos,
		col = Color(255,92,38),
		icon = 'octoteam/icons-16/user.png',
	})

	ply:Notify('Идите в указанное место для смены персонажа')
end
local function removeTimer(ply)
	ply:ClearMarkers('change-char')
	ply.dbgChar_respawnPos = nil
	ply.dbgChar_respawnStartTime = nil
	ply.dbgChar_lastNotify = nil

	netstream.Start(ply, 'dbg-characters.updateState', false)
end

local function checkPlayerRespawnPosition(ply)
	if not IsValid(ply) or not ply.dbgChar_respawnPos then return end

	local dist = ply:GetPos():DistToSqr(ply.dbgChar_respawnPos)
	if dist <= 10000 then
		if not ply.dbgChar_respawnStartTime then
			ply.dbgChar_respawnStartTime = CurTime()
		else
			local timeOnSpot = CurTime() - ply.dbgChar_respawnStartTime
			if timeOnSpot >= 3 then
				if ply:Alive() then
					ply:KillSilent()
				end
				ply:SetNetVar('_SpawnTime', CurTime())

				if ply.SpawnForRound then
					ply:SpawnForRound()
					if IsValid(ply.server_ragdoll) then
						ply.server_ragdoll:Remove()
					end
				else
					ply:Spawn()
				end

				removeTimer(ply)
			end
		end
	else
		if ply.dbgChar_respawnStartTime then
			ply.dbgChar_respawnStartTime = nil
		end
	end
end

hook.Add('Think', 'dbg-char.daun', function()
	for _, ply in ipairs(player.GetAll()) do
		if ply.dbgChar_respawnPos then
			checkPlayerRespawnPosition(ply)
		end
	end
end)

hook.Add('PlayerDeath', 'dbg-char', function(ply)
	removeTimer(ply)
	ply:SetNetVar('SelectedPreset', nil)
end)
hook.Add('PlayerSilentDeath', 'dbg-char', removeTimer)
hook.Add('PlayerDisconnected', 'dbg-char', removeTimer)

netstream.Hook('dbg-characters.respawn', function(ply, state)
	if state then
		if ply.dbgChar_nextRequest and CurTime() < ply.dbgChar_nextRequest then
			ply:Notify('warning', 'Подождите перед повторной попыткой')
			return
		end
		ply.dbgChar_nextRequest = CurTime() + 15

		if ply.dbgChar_respawnPos then
			ply:Notify('warning', 'Вы уже меняете персонажа')
			return
		end

		if not ply:Alive() or ply:IsGhost() or ply:GetNetVar('wanted') or ply:isArrested() then
			ply:Notify('warning', 'Сейчас нельзя сменить персонажа')
			return
		end

		ply:GetClientVar('dbgChars.job', function(jobCmd)
			jobCmd = jobCmd or 'citizen'

			local job, jobID
			for _, v in ipairs(RPExtraTeams) do
				if v.command == jobCmd then
					job = v
					jobID = v.team
					break
				end
			end

			if not job then
				jobCmd = 'citizen'
				for _, v in ipairs(RPExtraTeams) do
					if v.command == 'citizen' then
						job = v
						jobID = v.team
						break
					end
				end
			end

			if not job then
				ply:Notify('warning', 'Профессия гражданин не найдена')
				return
			end

			local limit = job.max == 0 or team.NumPlayers(job.team) < math.ceil(player.GetCount() * job.max)
			if not limit then
				ply:Notify('warning', 'Достигнут лимит профессии')
				return
			end

			netstream.Start(ply, 'dbg-characters.updateState', true)

			local pos = getRespawnPos(ply, 1000, 8000)
			if pos then
				enableCharRespawn(ply, pos)
			else
				enableCharRespawn(ply, getRespawnPos(ply))
			end
		end)
	else
		removeTimer(ply)
		ply:Notify('warning', 'Смена персонажа отменена')
	end
end)

local meta = FindMetaTable 'Player'
function meta:SetName(name)
	if not name or string.len(name) < 2 then return end
	hook.Run('onPlayerChangedName', self, self:Name(), name)
	self:SetNetVar('rpname', name)
end
