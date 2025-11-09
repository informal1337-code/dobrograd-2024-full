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
    
    ply.presets = presets
end)

hook.Add('PlayerInitialSpawn', 'dbg-char.initialSetup', function(ply)
    timer.Simple(5, function()
        if not IsValid(ply) then return end
        
        local name = ply:GetInfo('dbgChars.name')
        local model = ply:GetInfo('dbgChars.model')
        
        if not name or name == '' or not model or model == '' then
            local randomModel, randomSkin = getRandomModel(models)
            local randomName = getName(randomModel)
            
            ply:ConCommand('dbgChars.name "' .. randomName .. '"')
            ply:ConCommand('dbgChars.model "' .. randomModel .. '"')
            ply:ConCommand('dbgChars.skin "' .. randomSkin .. '"')
            ply:ConCommand('dbgChars.job "citizen"')
            
            print('[CHAR] Created default character for ' .. ply:SteamID() .. ': ' .. randomName)
        end
    end)
end)
local models = table.GetKeys(allowedModels)
PrintTable(models)
netstream.Hook('dbg-characters.getPresets', function(ply)
	netstream.Start(ply, 'dbg-characters.getPresets', ply.presets or {})
end)
local names, models = L.names, table.GetKeys(allowedModels)

local function playerCanChangeTeam(ply, tID, force)
	if not force then return false, L.can_change_job end
end
hook.Add('playerCanChangeTeam', 'dbg-char', playerCanChangeTeam)

local function canChangeJob()
	return false, L.can_change_name_job
end
hook.Add('canChangeJob', 'dbg-char', canChangeJob)

local function playerCanChangeName()
	return false, L.can_change_name
end
hook.Add('CanChangeRPName', 'dbg-char', playerCanChangeName)

local storedHealth, storedHunger = {}, {}

local function getName(mdl)
    local isMale = string.StartWith(mdl, 'models/humans/octo/male')
    local gender = isMale and names.male or names.female
    local name, surname = gender[math.random(#gender)], names.surnames[math.random(#names.surnames)]
    return ('%s %s'):format(name, surname)
end

local function getSkinCount(mdl)
	local modelInfo = util.GetModelInfo(mdl)
	if not modelInfo then
		return 0
	end
	return modelInfo.SkinCount - 1
end

local function getRandomModel()
    local model = models[math.random(#models)]
    local skinData = allowedModels[model]
    local skin
    
    if skinData == true then
        skin = math.random(0, getSkinCount(model))
    else
        skin = skinData[math.random(#skinData)]
    end
    
    return model, skin
end
local function getSkinCount(mdl)
    local modelInfo = util.GetModelInfo(mdl)
    if not modelInfo then
        return 0
    end
    return modelInfo.SkinCount - 1
end

local function getRandomModel(mdls)
    local mdl = mdls[math.random(#mdls)]
    local skin = math.random(0, getSkinCount(mdl))
    return mdl, skin
end

local function getName(mdl)
    local gender = octolib.models.isMale(mdl) and names.male or names.female
    local name, surname = gender[math.random(#gender)], names.surnames[math.random(#names.surnames)]
    return ('%s %s'):format(name, surname)
end
local function spawnPlayer(ply)
    timer.Remove('dbg-char.disconnect' .. ply:SteamID())

    if not ply.passedTest then return end

    local he = not ply.died and storedHealth[ply:SteamID()] or 100
    local hu = not ply.died and storedHunger[ply:SteamID()] or 100
    
    timer.Simple(2, function()
        if not IsValid(ply) then return end

        -- Получаем выбранный пресет
        local selectedPreset = ply:GetNetVar('SelectedPreset')
        
        -- Если выбран пресет, используем его данные
        if selectedPreset then
            applyPresetAppearance(ply, selectedPreset)
            
            local name = selectedPreset.name
            local jobCmd = selectedPreset.jobCmd or 'citizen'
            local desc = selectedPreset.desc

            local job, jobID = DarkRP.getJobByCommand(jobCmd)
            if not job or job.noPreference or (job.customCheck and (not job.customCheck(ply))) then
                job, jobID = DarkRP.getJobByCommand('citizen')
            end

            if ply:Team() ~= jobID then
                ply:changeTeam(jobID, true, true)
            end

            ply:SetName(name)
            ply:SetSalary(job.salary)
            
            if desc and desc ~= '' then
                ply:SetNetVar('dbgDesc', desc)
            end
            
            ply:Notify('hint', 'Персонаж "' .. name .. '" успешно применен')
        else
            -- Иначе используем данные из консольных переменных или создаем случайные
            local name = ply:GetInfo('dbgChars.name')
            local model = ply:GetInfo('dbgChars.model')
            local skin = tonumber(ply:GetInfo('dbgChars.skin') or '0') or 0
            local face = ply:GetInfo('dbgChars.face') or ''
            local jobCmd = ply:GetInfo('dbgChars.job') or 'citizen'
            local desc = ply:GetInfo('dbgChars.desc') or ''
            
            -- Проверяем, есть ли валидные данные
            local hasValidData = name and name ~= '' and model and model ~= '' and allowedModels[model]
            
            if not hasValidData then
                -- Создаем случайного персонажа
                model, skin = getRandomModel(models)
                name = getName(model)
                
                -- Устанавливаем консольные переменные на сервере
                ply:ConCommand('dbgChars.name "' .. name .. '"')
                ply:ConCommand('dbgChars.model "' .. model .. '"')
                ply:ConCommand('dbgChars.skin "' .. skin .. '"')
                ply:ConCommand('dbgChars.job "citizen"')
                ply:ConCommand('dbgChars.desc ""')
                
                ply:Notify('hint', 'Создан новый персонаж: ' .. name)
            end

            -- Валидация модели
            local ok = allowedModels[model]
            if not ok or not util.IsValidModel(model) then
                model, skin = getRandomModel(models)
                ply:ConCommand('dbgChars.model "' .. model .. '"')
                ply:ConCommand('dbgChars.skin "' .. skin .. '"')
            end

            -- Валидация скина
            if skin < 0 or skin > getSkinCount(model) or (istable(ok) and not table.HasValue(ok, skin)) then
                skin = 0
                ply:ConCommand('dbgChars.skin "0"')
            end

            -- Валидация работы
            local job, jobID = DarkRP.getJobByCommand(jobCmd)
            if not job or job.noPreference or (job.customCheck and (not job.customCheck(ply))) then
                job, jobID = DarkRP.getJobByCommand('citizen')
                ply:ConCommand('dbgChars.job citizen')
            end

            -- Валидация имени
            name = string.Trim(octolib.string.camel(octolib.string.stripNonWord(name)))
            if name == '' then
                name = getName(model)
                ply:ConCommand('dbgChars.name "' .. name .. '"')
            end
            
            name = utf8.sub(name, 1, 35)
            if not string.find(name, ' ') then
                ply:Notify('warning', 'Твое имя указано без фамилии. Создан новый персонаж')
                name = getName(model)
                ply:ConCommand('dbgChars.name "' .. name .. '"')
            end

            -- Применяем настройки
            if ply:Name() ~= name then
                ply:SetName(name)
            end

            if ply:Team() ~= jobID then
                ply:changeTeam(jobID, true, true)
            end

            ply:SetCanZoom(false)
            ply:SetModel(model)
            ply:SetSkin(skin)
            
            -- Применяем текстуру лица если указана
            if face and face ~= '' then
                for i, mat in ipairs(ply:GetMaterials()) do
                    if string.match(mat, '.+/sheet_%d+') then
                        ply:SetSubMaterial(i-1, face)
                    end
                end
            else
                -- Иначе сбрасываем все текстуры лица
                for i, mat in ipairs(ply:GetMaterials()) do
                    if string.match(mat, '.+/sheet_%d+') then
                        ply:SetSubMaterial(i-1, nil)
                    end
                end
            end

            if desc == '' then desc = nil end
            ply:SetNetVar('dbgDesc', desc)
            ply:SetSalary(job.salary)
        end

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

        timer.Simple(0, function()
            if IsValid(ply) then ply:SetHealth(he) end
        end)
        ply:SetLocalVar('Energy', hu)

        ply.SaveCharState = ply.SaveCharState or octolib.func.debounceEnd(function(self)
            if not IsValid(self) then return end
            storedHealth[self:SteamID()] = math.floor(self:Health())
            storedHunger[self:SteamID()] = math.floor(self:GetNetVar('Energy'))
        end, 3)

        if not ply.inTown then
            local txt = ply:Name() .. ' (' .. tostring(ply:GetInfo('dbgChars.name')) .. ')' .. L.arrive_in_town
            print('[LOG] ' .. txt)

            ply.inTown = true
            hook.Run('dbg-char.firstSpawn', ply)
        end

        hook.Run('dbg-char.spawn', ply)
    end)
end

local function applyPresetAppearance(ply, preset)
    if not preset then return end
    
    ply:SetModel(preset.model)
    ply:SetSkin(preset.skin or 0)

    -- Сбрасываем все текстуры лица сначала
    for i = 0, ply:GetNumMaterials() - 1 do
        local mat = ply:GetMaterial(i)
        if mat and string.match(mat, 'facemap') then
            ply:SetSubMaterial(i, '')
        end
    end

    if preset.face and preset.face ~= '' then
        for i = 0, ply:GetNumMaterials() - 1 do
            local mat = ply:GetMaterial(i)
            if mat and string.match(mat, 'facemap') then
                ply:SetSubMaterial(i, preset.face)
                break
            end
        end
    end

    if preset.voice then
        ply:SetNetVar('Voice', preset.voice)
    end

    if preset.desc then
        ply:SetNetVar('dbgDesc', preset.desc)
    end
end

hook.Add('PlayerSpawn', 'dbg-char', spawnPlayer)
hook.Add('PlayerFinishedLoading', 'dbg-char', spawnPlayer)

util.AddNetworkString('dbgChars.presets.select')
util.AddNetworkString('dbgChars.presets.new')
util.AddNetworkString('dbgChars.presets.edit')
util.AddNetworkString('dbgChars.presets.remove')

netstream.Hook('dbgChars.presets.select', function(ply, presetIndex)
	if not ply.presets or not ply.presets[presetIndex] then
		return 'Пресет не найден'
	end
	
	local preset = ply.presets[presetIndex]
	
	local ok = allowedModels[preset.model]
	if not ok or not util.IsValidModel(preset.model) then
		return 'Модель персонажа недоступна'
	end
	
	ply:SetNetVar('SelectedPreset', preset)
	
	if ply:Alive() then
		ply:KillSilent()
	end
	
	return true
end)

netstream.Hook('dbgChars.presets.new', function(ply, presetData)
	if not ply.presets then
		ply.presets = {}
	end
	
	local maxPresets = ply:IsPremium() and 7 or 3
	if #ply.presets >= maxPresets then
		return false, 'Достигнут лимит персонажей'
	end

	presetData.id = #ply.presets + 1
	presetData.created = os.time()
	
	table.insert(ply.presets, presetData)
	
	return true, presetData
end)

netstream.Hook('dbgChars.presets.edit', function(ply, presetIndex, presetData)
	if not ply.presets or not ply.presets[presetIndex] then
		return false, 'Пресет не найден'
	end
	
	presetData.updated = os.time()
	ply.presets[presetIndex] = presetData
	
	return true, presetData
end)

netstream.Hook('dbgChars.presets.remove', function(ply, presetIndex)
	if not ply.presets or not ply.presets[presetIndex] then
		return false, 'Пресет не найден'
	end
	
	table.remove(ply.presets, presetIndex)
	
	for i, preset in ipairs(ply.presets) do
		preset.id = i
	end
	
	return true
end)

hook.Add('PlayerFinishedLoading', 'dbgChars.sendPresets', function(ply)
	timer.Simple(1, function()
		if not IsValid(ply) then return end
		
		if not ply.presets then
			ply.presets = {}
		end
		
		netstream.Start(ply, 'dbgChars.presets.load', ply.presets)
	end)
end)

gameevent.Listen('player_disconnect')
hook.Add('player_disconnect', 'dbg-char', function(data)
	local sID
	if octolib.string.isSteamID(data.networkid) then
		sID = data.networkid
	elseif (data.networkid:find('^7656119%d+$')) then
		sID = util.SteamIDFrom64(data.networkid)
	else return end

	timer.Create('dbg-char.disconnect' .. sID, 1200, 1, function()
		storedHealth[sID], storedHunger[sID] = nil
	end)
end)

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
	},
	rp_evocity_dbg_230226 = {
		Vector(1836, 5533, 68),
		Vector(686, 7165, 74),
		Vector(-444, 9561, 119),
		Vector(-7342, 10556, 199),
		Vector(-5544, 406, 97),
		Vector(-4369, 6095, 141),
		Vector(-10350, 8328, 81),
		Vector(-7860, -3286, 72),
		Vector(-10674, -8114, 72),
		Vector(-11347, -14177, 72),
		Vector(-10537, -11856, 72),
		Vector(-3907, -8724, 72),
		Vector(-3516, -4905, 200)
	},
	rp_riverden_dbg_220313 = {
		Vector(-7696, 13552, 0),
		Vector(-1322, 357, -237),
		Vector(-10671, -12390, -242),
		Vector(7298, -120, 786),
		Vector(14602, 9456, 818),
		Vector(3784, 13881, 9),
		Vector(-2092, 4441, -229),
		Vector(-14909, 11048, 0),
		Vector(9301, 5161, 771),
		Vector(8073, 11812, 313),
		Vector(5204, 8973, -260),
		Vector(3262, 4907, -247),
		Vector(-2029, 11198, -36),
		Vector(7249, -10760, 782),
		Vector(4258, -14276, 727),
		Vector(-2141, -12907, 133),
		Vector(-5223, -8888, -264),
		Vector(1570, -8538, -185),
		Vector(-8946, -4543, -239),
		Vector(-14235, 8216, -253),
		Vector(-5782, 14650, 0),
		Vector(-11574, 573, -264),
		Vector(-9136, 11920, 0),
		Vector(-13488, 15016, 0),
	},
}
local respPos = spawnsConfig[game.GetMap()]

util.AddNetworkString 'dbg-char.respawnRequest'
util.AddNetworkString 'dbg-char.respawnCancel'

local function checkPlayer(ply)

	local steamID = ply:SteamID()
	return function()
		if not IsValid(ply) or not ply.dbgChar_respawnPos then
			timer.Remove('dbg-char.respawn' .. steamID)
			return
		end

		if ply:GetPos():DistToSqr(ply.dbgChar_respawnPos) < 900 then
			for _, ent in ipairs(ents.FindInSphere(ply:EyePos(), 500)) do
				if IsValid(ent) and ent:IsPlayer() and ent ~= ply and not ent:IsGhost() and not ent:GetNetVar('Invisible') then
					local tr = util.TraceLine({
						start = ply:EyePos(),
						endpos = ent:EyePos(),
						filter = {ply, ent},
					})
					if not tr.Hit then
						ply:Notify('warning', L.somebody_near)
						return
					end
				end
			end

			if ply:Alive() then ply:KillSilent() end
			ply:SetNetVar( '_SpawnTime', CurTime() )
			ply.dbgChar_respawnPos = nil
		end
	end

end

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

	netstream.Start(ply, 'dbg-char.respawnPos', pos)

	ply:AddMarker({
		id = 'change-char',
		txt = L.discreet_place,
		pos = pos,
		col = Color(255,92,38),
		icon = 'octoteam/icons-16/user.png',
	})
	timer.Create('dbg-char.respawn' .. ply:SteamID(), 3, 0, checkPlayer(ply))

	ply:Notify(L.go_discreet_place)
end

local function respawnRequest(ply)

	if ply.dbgChar_nextRequest and CurTime() < ply.dbgChar_nextRequest then
		ply:Notify('warning', L.wait_boy)
		return
	end
	ply.dbgChar_nextRequest = CurTime() + 15

	if ply.dbgChar_respawnPos then
		ply:Notify('warning', L.you_already_change)
		return
	end

	if not ply:Alive() or ply:IsGhost() or ply:GetNetVar('wanted') or ply:isArrested() then
		ply:Notify('warning', L.cant_change_now)
		return
	end

	local _, info_job = DarkRP.getJobByCommand(ply:GetInfo('dbg_job') or 'citizen')
	local job = RPExtraTeams[info_job]
	local limit = job.max == 0 or team.NumPlayers(job.team) < math.ceil(player.GetCount() * job.max)

	if not limit then
		ply:Notify('warning', L.job_limit)
		return
	end

	netstream.Start(ply, 'dbg-char.updateState', true)
	local pos = getRespawnPos(ply, 1000, 8000)
	if pos then
		enableCharRespawn(ply, pos)
	else
		enableCharRespawn(ply, getRespawnPos(ply))
	end

end

local function removeTimer(ply)

	timer.Remove('dbg-char.respawn' .. ply:SteamID())
	ply:ClearMarkers('change-char')
	ply.dbgChar_respawnPos = nil
	netstream.Start(ply, 'dbg-char.updateState', false)

end
hook.Add('PlayerDeath', 'dbg-char', removeTimer)
hook.Add('PlayerSilentDeath', 'dbg-char', removeTimer)
hook.Add('PlayerDisconnected', 'dbg-char', removeTimer)

local function respawnCancel(ply)

	if not ply.dbgChar_respawnPos then
		ply:Notify('warning', L.you_not_already_change)
		return
	end

	removeTimer(ply)
	ply:Notify('warning', L.character_change_cancel)

end
netstream.Hook('dbg-char.respawn', function(ply, state)
	if state then
		respawnRequest(ply)
	else 
		respawnCancel(ply) 
	end
end)

netstream.Hook('dbg-characters.respawn', function(ply, state)
	if state then
		respawnRequest(ply)
	else 
		respawnCancel(ply) 
	end
end)

timer.Create('dbg-char.updateState', 4, 0, function()
	octolib.func.throttle(player.GetAll(), 10, 0.2, function(ply)
		if not IsValid(ply) or not ply.SaveCharState then return end
		if math.floor(ply:Health()) ~= (storedHealth[ply:SteamID()] or 100) then
			ply:SaveCharState()
		end
	end)
end)

local meta = FindMetaTable 'Player'
function meta:SetName(name)
	if not name or string.len(name) < 2 then return end
	hook.Run('onPlayerChangedName', self, self:Name(), name)
	self:SetNetVar('rpname', name)
end