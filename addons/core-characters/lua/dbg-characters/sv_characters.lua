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

local function savePresetsToData(ply, presets) -- аа говно shit фуу
    if not IsValid(ply) then return end
    
    local steamID = ply:SteamID()
    if not steamID then return end
    
    file.CreateDir('dbg_characters')
    file.Write('dbg_characters/' .. steamID .. '.txt', util.TableToJSON(presets or {}))
end
function dbgChars.sanitizeName(name)
    return string.Trim(octolib.string.camel(octolib.string.stripNonCyrillic(utf8.sub(name, 1, 35))))
end

function dbgChars.sanitizeDescription(desc)
    return string.Trim(octolib.string.stripNonWord(utf8.sub(desc, 1, 350), ',:%.0-9-;%(%)%/%"%\'a-zA-Z'))
end
local function loadPresetsFromData(ply)
    if not IsValid(ply) then return {} end
    
    local steamID = ply:SteamID()
    if not steamID then return {} end
    
    local fileName = 'dbg_characters/' .. steamID .. '.txt'
    if not file.Exists(fileName, 'DATA') then
        return {}
    end
    
    local data = file.Read(fileName, 'DATA')
    if not data or data == '' then
        return {}
    end
    
    return util.JSONToTable(data) or {}
end

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
    if ply.presets then
        netstream.Start(ply, 'dbg-characters.getPresets', ply.presets)
    else
        ply.presets = loadPresetsFromData(ply)
        netstream.Start(ply, 'dbg-characters.getPresets', ply.presets)
    end
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
    ply.presets = loadPresetsFromData(ply)
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

local function applyPresetAppearance(ply, preset)
    if not preset then return end
    
    ply:SetModel(preset.model)
    ply:SetSkin(preset.skin or 0)

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

local function spawnPlayer(ply)
    if not ply.passedTest then return end

    local selectedPreset = ply:GetNetVar('SelectedPreset')
    
    if selectedPreset then
        applyPresetAppearance(ply, selectedPreset)
        
        local name = selectedPreset.name
        local jobTeam = selectedPreset.jobTeam or 1 -- Используем jobTeam вместо jobCmd
        local desc = selectedPreset.desc

        local job = RPExtraTeams[jobTeam]
        if not job or job.noPreference or (job.customCheck and (not job.customCheck(ply))) then
            job = RPExtraTeams[1] -- Гражданин
        end

        if ply:Team() ~= jobTeam then
            ply:changeTeam(jobTeam, true, true)
        end

        ply:SetName(name)
        ply:SetSalary(job.salary)
        
        if desc and desc ~= '' then
            ply:SetNetVar('dbgDesc', desc)
        end
    else
        local name = ply:GetInfo('dbgChars.name')
        local model = ply:GetInfo('dbgChars.model')
        local skin = tonumber(ply:GetInfo('dbgChars.skin') or '0') or 0
        local face = ply:GetInfo('dbgChars.face') or ''
        local jobTeam = tonumber(ply:GetInfo('dbgChars.job')) or 1
        local desc = ply:GetInfo('dbgChars.desc') or ''
        
        local hasValidData = name and name ~= '' and model and model ~= '' and allowedModels[model]

        if not hasValidData then
            model, skin = getRandomModel()
            name = getRandomName(octolib.models.isMale(model))
            
            ply:ConCommand('dbgChars.name "' .. name .. '"')
            ply:ConCommand('dbgChars.model "' .. model .. '"')
            ply:ConCommand('dbgChars.skin "' .. skin .. '"')
            ply:ConCommand('dbgChars.job "citizen"')
            ply:ConCommand('dbgChars.desc ""')
        end

        local ok = allowedModels[model]
        if not ok or not util.IsValidModel(model) then
            model, skin = getRandomModel()
            ply:ConCommand('dbgChars.model "' .. model .. '"')
            ply:ConCommand('dbgChars.skin "' .. skin .. '"')
        end

        if skin < 0 or skin > 32 or (istable(ok) and not table.HasValue(ok, skin)) then
            skin = 0
            ply:ConCommand('dbgChars.skin "0"')
        end

        local job = RPExtraTeams[jobTeam]
        if not job or job.noPreference or (job.customCheck and (not job.customCheck(ply))) then
            job = RPExtraTeams[1]
            jobTeam = 1
            ply:ConCommand('dbgChars.job 1')
        end

        name = dbgChars.sanitizeName(name)
        if name == '' then
            name = getRandomName(octolib.models.isMale(model))
            ply:ConCommand('dbgChars.name "' .. name .. '"')
        end
        
        if not string.find(name, ' ') then
            name = getRandomName(octolib.models.isMale(model))
            ply:ConCommand('dbgChars.name "' .. name .. '"')
        end

        if ply:Name() ~= name then
            ply:SetName(name)
        end

        if ply:Team() ~= jobTeam then
            ply:changeTeam(jobTeam, true, true)
        end

        ply:SetModel(model)
        ply:SetSkin(skin)
        
        if face and face ~= '' then
            for i, mat in ipairs(ply:GetMaterials()) do
                if string.match(mat, '.+/sheet_%d+') then
                    ply:SetSubMaterial(i-1, face)
                end
            end
        else
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

local function respawnRequest(ply)
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

    local jobCmd = ply:GetInfo('dbgChars.job') or 'citizen'

    local jobTeam = tonumber(jobCmd) or 1
    local job = RPExtraTeams[jobTeam]

    if not job then
        ply:Notify('warning', 'Профессия не найдена')
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
end

local function removeTimer(ply)
    ply:ClearMarkers('change-char')
    ply.dbgChar_respawnPos = nil
    
    netstream.Start(ply, 'dbg-characters.updateState', false)
end

hook.Add('PlayerDeath', 'dbg-char', removeTimer)
hook.Add('PlayerSilentDeath', 'dbg-char', removeTimer)
hook.Add('PlayerDisconnected', 'dbg-char', removeTimer)

netstream.Hook('dbg-characters.respawn', function(ply, state)
    if state then
        respawnRequest(ply)
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