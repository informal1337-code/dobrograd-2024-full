dbgChars.presets = dbgChars.presets or {}

octolib.vars.init('dbgChars.name', '')
octolib.vars.init('dbgChars.model', '')
octolib.vars.init('dbgChars.skin', 0)
octolib.vars.init('dbgChars.job', 'citizen')
octolib.vars.init('dbgChars.desc', '')

function dbgChars.savePreset(preset, id)
    id = id or (#dbgChars.presets + 1)
    dbgChars.presets[id] = preset
    
    net.Start('dbg-characters.savePresets')
    net.WriteTable(dbgChars.presets)
    net.SendToServer()
    
    hook.Run('dbg-characters.presetsUpdated', dbgChars.presets)
end

function dbgChars.removePreset(id)
    table.remove(dbgChars.presets, id)
    
    net.Start('dbg-characters.savePresets')
    net.WriteTable(dbgChars.presets)
    net.SendToServer()
    
    hook.Run('dbg-characters.presetsUpdated', dbgChars.presets)
end

function dbgChars.fetchPresetsFromServer()
    net.Start('dbg-characters.getPresets')
    net.SendToServer()
end

net.Receive('dbg-characters.getPresets', function()
    local presets = net.ReadTable()
    dbgChars.presets = presets or {}
    hook.Run('dbg-characters.presetsUpdated', dbgChars.presets)
end)

function dbgChars.fixConVars()
    local model = octolib.vars.get('dbgChars.model')
    local face = octolib.vars.get('dbgChars.face')
    local skin = octolib.vars.get('dbgChars.skin')

    if not model or not skin or not dbgChars.canUseModel(LocalPlayer(), model, face, skin) then
        local randomModel, randomFace, randomSkin = dbgChars.getRandomModel()
        model = randomModel
        face = randomFace
        skin = randomSkin
        octolib.vars.set('dbgChars.model', model)
        octolib.vars.set('dbgChars.face', face)
        octolib.vars.set('dbgChars.skin', skin)
    end

    local name = octolib.vars.get('dbgChars.name')
    if not name or string.Trim(name) == '' then
        name = dbgChars.getRandomName(octolib.models.isMale(model))
        octolib.vars.set('dbgChars.name', name)
    end

    local sanitizedName = dbgChars.sanitizeName(name)
    if sanitizedName ~= name then
        octolib.vars.set('dbgChars.name', sanitizedName)
    end

    local desc = octolib.vars.get('dbgChars.desc')
    local sanitizedDesc = dbgChars.sanitizeDescription(desc)
    if sanitizedDesc ~= desc then
        octolib.vars.set('dbgChars.desc', sanitizedDesc)
    end
end