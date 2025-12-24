if CLIENT then

local anticheat = anticheat or {}
anticheat.detections = {}
anticheat.isInitialized = false
anticheat.scanInterval = 60 -- seconds
anticheat.maxDetections = 50 -- limit stored detections

local ANTICHEAT_CONFIG = {
    ENABLE_GLOBAL_DETECTION = true,
    ENABLE_LIBRARY_PROTECTION = true,
    ENABLE_CONVAR_PROTECTION = true,
    ENABLE_COMMAND_DETECTION = true,
    ENABLE_HOOK_DETECTION = false, -- Disabled to prevent false positives
    ENABLE_TIMER_DETECTION = true,
    ENABLE_FILE_DETECTION = true,
    LOG_LOCAL_ACTIVITY = true,
    REPORT_TO_SERVER = true
}

local function readonlyTable(t)
    return setmetatable({}, {
        __index = t,
        __newindex = function() end,
        __metatable = true
    })
end

local function hashFunction(func)
    if not isfunction(func) then return "invalid" end
    local info = debug.getinfo(func)
    return string.format("%s_%d_%d", info.short_src or "unknown", info.linedefined or 0, info.lastlinedefined or 0)
end

local function isSuspiciousString(str)
    if not isstring(str) then return false end
    str = string.lower(str)

    local suspicious = {
        'cheat', 'hack', 'bypass', 'nospread', 'aim', 'aimbot', 'exploit',
        'fakelag', 'speedhack', 'wallhack', 'esp', 'triggerbot', 'autoshoot',
        'norecoil', 'rapidfire', 'infiniteammo', 'godmode', 'flyhack'
    }

    for _, pattern in ipairs(suspicious) do
        if string.find(str, pattern) then
            return true
        end
    end
    return false
end

function anticheat.addDetection(type, details, severity)
    if #anticheat.detections >= anticheat.maxDetections then
        table.remove(anticheat.detections, 1)
    end

    local detection = {
        _id = math.random(10000, 99999),
        _type = type,
        _details = details or "No details",
        _severity = severity or 1,
        _timestamp = os.time(),
        _source = debug.getinfo(2, "S").short_src
    }

    table.insert(anticheat.detections, detection)

    if ANTICHEAT_CONFIG.LOG_LOCAL_ACTIVITY then
        octolib.logger.warning(string.format("Client AC: %s (%s)", type, details))
    end

    if ANTICHEAT_CONFIG.REPORT_TO_SERVER then
        anticheat.reportToServer()
    end
end

function anticheat.reportToServer()
    if #anticheat.detections == 0 then return end

    net.Start('ac.detect')
    net.WriteTable(anticheat.detections)
    net.SendToServer()

    anticheat.detections = {}
end

local protected = {
    pairs = pairs,
    ipairs = ipairs,
    type = type,
    tostring = tostring,
    isfunction = isfunction,
    istable = istable,
    isstring = isstring,
    require = require,
    rawset = rawset,
    rawget = rawget,
    HTTP = HTTP,
    ScrH = ScrH,
    ScrW = ScrW,
}

protected._G = readonlyTable(_G)
protected.debug = readonlyTable(debug)
protected.render = readonlyTable(render)
protected.concommand = readonlyTable(concommand)
protected.hook = readonlyTable(hook)
protected.timer = readonlyTable(timer)
protected.file = readonlyTable(file)
protected.net = readonlyTable(net)

local originalHashes = {}
local protectedLibs = {'debug', 'render', 'concommand', 'hook', 'timer', 'file', 'net'}
local protectedFunctions = {
    'GetConVar', 'GetConVarNumber', 'GetConVarString', 'RunConsoleCommand',
    'setfenv', 'getfenv', 'rawset', 'rawget', 'RunString', 'RunStringEx',
    'CompileString', 'CompileFile', 'require'
}

function anticheat.initialize()
    if anticheat.isInitialized then return end
    for _, libName in ipairs(protectedLibs) do
        originalHashes[libName] = {}
        local lib = protected[libName]
        if lib then
            for k, v in pairs(lib) do
                if isfunction(v) then
                    originalHashes[libName][k] = hashFunction(v)
                end
            end
        end
    end
    originalHashes._G = {}
    for _, funcName in ipairs(protectedFunctions) do
        local func = protected._G[funcName]
        if func then
            originalHashes._G[funcName] = hashFunction(func)
        end
    end

    anticheat.isInitialized = true
end

local scans = {}

scans.libraryIntegrity = function()
    if not ANTICHEAT_CONFIG.ENABLE_LIBRARY_PROTECTION then return end

    for libName, functions in pairs(originalHashes) do
        if libName ~= "_G" then
            local currentLib = protected[libName]
            if currentLib then
                for funcName, originalHash in pairs(functions) do
                    local currentFunc = currentLib[funcName]
                    if currentFunc and hashFunction(currentFunc) ~= originalHash then
                        anticheat.addDetection("Library Modification",
                            string.format("%s.%s modified", libName, funcName), 3)
                    end
                end
            end
        end
    end
end

scans.globalFunctionIntegrity = function()
    if not ANTICHEAT_CONFIG.ENABLE_LIBRARY_PROTECTION then return end

    for funcName, originalHash in pairs(originalHashes._G or {}) do
        local currentFunc = protected._G[funcName]
        if currentFunc and hashFunction(currentFunc) ~= originalHash then
            anticheat.addDetection("Global Function Modification",
                string.format("_G.%s modified", funcName), 3)
        end
    end
end

scans.convarProtection = function()
    if not ANTICHEAT_CONFIG.ENABLE_CONVAR_PROTECTION then return end

    local protectedConvars = {
        {'sv_cheats', 0},
        {'sv_allowcslua', 0},
        {'host_timescale', 1},
        {'mat_wireframe', 0},
        {'mat_fullbright', 0},
        {'r_drawparticles', 1},
        {'fog_override', 0}
    }

    for _, convarData in ipairs(protectedConvars) do
        local name, expectedValue = unpack(convarData)
        if ConVarExists(name) then
            local currentValue = GetConVarNumber(name)
            if currentValue ~= expectedValue then
                anticheat.addDetection("Protected ConVar Modified",
                    string.format("%s = %s (expected %s)", name, currentValue, expectedValue), 2)
            end
        end
    end
end

scans.knownCheatDetection = function()
    if not ANTICHEAT_CONFIG.ENABLE_GLOBAL_DETECTION then return end

    local knownCheats = {
        'Lenny', 'GDAAP_CLIENT_INTERFACE', 'R8', 'MOTDgd', 'lmfao1', 'iZNX',
        'odium', 'Betrayed', 'BackdoorLaunch', 'toxic', 'ValidNetString',
        'Bhop', 'LoadSmegHack', 'UnloadSmegHack', 'ReloadSmegHack', 'SmegHack',
        'IdiotBox', 'memoriam', 'FAUCHEUSE', 'horizon', 'blacksmurf', 'Xray',
        'defqon', 'smeghack', 'rainbow', '_z_open'
    }

    for _, cheatName in ipairs(knownCheats) do
        if _G[cheatName] ~= nil then
            anticheat.addDetection("Known Cheat Detected",
                string.format("Global variable: %s", cheatName), 4)
        end
    end
end

scans.commandDetection = function()
    if not ANTICHEAT_CONFIG.ENABLE_COMMAND_DETECTION then return end

    local suspiciousCommands = {
        ['phack_lua_reload'] = true, ['mapex_dancin'] = true, ['mapex_esp'] = true,
        ['mapex_allents'] = true, ['mapex_wall'] = true, ['sasha_menu'] = true,
        ['0_u_found'] = true, ['external'] = true, ['aspire_reload'] = true,
        ['cs_unload'] = true, ['cs_load'] = true, ['xhack_menu'] = true,
        ['r8_menu'] = true, ['exploits_open'] = true, ['music_troll'] = true,
        ['blacksmurf_noclip'] = true, ['ace_menu'] = true, ['ace_ents'] = true,
        ['ace_players'] = true, ['betrayed_open'] = true, ['betrayed_configs'] = true,
        ['betrayed_exploit'] = true, ['toxic.pro'] = true, ['defqon_bigmenu'] = true
    }

    for command, _ in pairs(concommand.GetTable()) do
        command = string.lower(command)
        if suspiciousCommands[command] then
            anticheat.addDetection("Suspicious Command",
                string.format("Command registered: %s", command), 3)
        elseif isSuspiciousString(command) then
            anticheat.addDetection("Suspicious Command Pattern",
                string.format("Command: %s", command), 2)
        end
    end
end

scans.hookDetection = function()
    if not ANTICHEAT_CONFIG.ENABLE_HOOK_DETECTION then return end

    local whitelistedHooks = {
        "OnSaveSpawnlist", -- Legitimate spawn menu hook from sandbox gamemode
        -- Add other known legitimate hooks here if needed
    }

    for hookName, hooks in pairs(hook.GetTable()) do
        if isSuspiciousString(hookName) and not table.HasValue(whitelistedHooks, hookName) then
            anticheat.addDetection("Suspicious Hook",
                string.format("Hook name: %s", hookName), 2)
        end
    end
end

scans.timerDetection = function()
    if not ANTICHEAT_CONFIG.ENABLE_TIMER_DETECTION then return end

    local suspiciousTimers = {
        ['lovedarkexploitsxd'] = true, ['exploit_revive'] = true, ['1tap'] = true,
        ['blacksmurf_exploit_money'] = true, ['blacksmurf_exploit_shekels'] = true,
        ['blacksmurf_exploit_errorz'] = true, ['chatspam1'] = true
    }

    for timerName, _ in pairs(timer.Exists and {} or {}) do -- timer.GetTable()
        timerName = string.lower(timerName)
        if suspiciousTimers[timerName] then
            anticheat.addDetection("Suspicious Timer",
                string.format("Timer: %s", timerName), 3)
        end
    end
end

scans.fileDetection = function()
    if not ANTICHEAT_CONFIG.ENABLE_FILE_DETECTION then return end

    local suspiciousFiles = {
        ['gmcl_aaa_win32.dll'] = true, ['gmcl_bsendpacket_win32.dll'] = true,
        ['gmcl_dickwrap_win32.dll'] = true, ['gmcl_fhook_win32.dll'] = true,
        ['gm_No_core.dll'] = true, ['gm_No_fvar.dll'] = true,
        ['gmcl_nspred_win32.dll'] = true, ['gmcl_spreadthebutter_win32.dll'] = true,
        ['gmcl_svm_win32.dll'] = true
    }

    for fileName, _ in pairs(suspiciousFiles) do
        if file.Exists('bin/' .. fileName, 'LUA') then
            anticheat.addDetection("Suspicious File",
                string.format("File detected: %s", fileName), 4)
        end
    end
end

timer.Create("anticheat_scan", anticheat.scanInterval, 0, function()
    if not anticheat.isInitialized then anticheat.initialize() end

    for scanName, scanFunc in pairs(scans) do
        local success, err = pcall(scanFunc)
        if not success then
            octolib.logger.error("Anti-cheat scan error in " .. scanName, LocalPlayer(), {error = err})
        end
    end
end)

concommand.Add("ac_scan", function()
    octolib.logger.info("Manual anti-cheat scan triggered")
    for scanName, scanFunc in pairs(scans) do
        local success, err = pcall(scanFunc)
        if not success then
            octolib.logger.error("Manual scan error in " .. scanName, LocalPlayer(), {error = err})
        end
    end
    octolib.logger.info("Manual anti-cheat scan completed")
end)

net.Receive("ac_config", function()
    local config = net.ReadTable()
    table.Merge(ANTICHEAT_CONFIG, config)
    octolib.logger.info("Anti-cheat configuration updated from server")
end)

end
