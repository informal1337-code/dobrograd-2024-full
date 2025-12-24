if SERVER then

local ANTICRASH_CONFIG = {
    MAX_NET_MESSAGES_PER_SECOND = 500,
    MAX_NET_CACHE_SIZE = 60,
    NET_SPAM_BAN_DURATION = 60, -- minutes
    LOG_NET_ACTIVITY = true,
    ENABLE_CRASH_DETECTION = true,
    MAX_LUA_ERRORS_PER_MINUTE = 10,
    ENABLE_CHEAT_COORDINATION = true,
    CHEAT_DETECTION_TIMEOUT = 30, -- seconds
    LOG_SUSPICIOUS_ACTIVITY = true,
    LOG_LEVEL = "WARNING"
}

local networkMonitor = {
    activeConnections = {},
    suspiciousActivity = {},
    crashAttempts = {}
}

function networkMonitor.init()
    if file.Exists("net_logger.txt", "DATA") and file.Size("net_logger.txt", "DATA") > 1024 * 1024 then
        file.Delete("net_logger.txt")
        octolib.logger.info("Cleaned up large network log file")
    end
    timer.Create("anticrash.cleanup", 300, 0, function()
        networkMonitor.cleanup()
    end)
end

function networkMonitor.cleanup()
    local currentTime = os.time()
    for steamid, data in pairs(networkMonitor.suspiciousActivity) do
        if currentTime - data.lastActivity > 3600 then
            networkMonitor.suspiciousActivity[steamid] = nil
        end
    end

    for _, ply in ipairs(player.GetHumans()) do
        if ply.netcache and ply.netcache > 10 then
            ply.netcache = math.floor(ply.netcache * 0.8)
        end
    end
end

-- Network monitoring disabled
-- local originalNetIncoming = net.Incoming
-- function net.Incoming(len, client)
--     if not IsValid(client) then
--         originalNetIncoming(len, client)
--         return
--     end

--     local i = net.ReadHeader()
--     local strName = util.NetworkIDToString(i)

--     if not strName then
--         originalNetIncoming(len, client)
--         return
--     end

--     networkMonitor.activeConnections[client:SteamID()] = networkMonitor.activeConnections[client:SteamID()] or {
--         netMessagesPerSecond = 0,
--         totalMessages = 0,
--         suspiciousMessages = 0,
--         lastActivity = CurTime(),
--         blockedMessages = {}
--     }

--     local playerData = networkMonitor.activeConnections[client:SteamID()]
--     playerData.netMessagesPerSecond = playerData.netMessagesPerSecond + 1
--     playerData.totalMessages = playerData.totalMessages + 1
--     playerData.lastActivity = CurTime()

--     local suspiciousMessages = {
--         "NetStreamDS", "_Detect", "StackGhost", "Sandbox_ArmDupe",
--         "Ulib_Message", "DarkRP_AdminWeapons"
--     }

--     local isSuspicious = table.HasValue(suspiciousMessages, strName) or
--                         string.find(strName:lower(), "hack") or
--                         string.find(strName:lower(), "cheat") or
--                         string.find(strName:lower(), "exploit")

--     if isSuspicious then
--         playerData.suspiciousMessages = playerData.suspiciousMessages + 1
--         networkMonitor.logSuspiciousActivity(client, strName, "Suspicious net message")
--     end

--     if playerData.netMessagesPerSecond > ANTICRASH_CONFIG.MAX_NET_MESSAGES_PER_SECOND then
--         networkMonitor.handleNetSpam(client)
--         return
--     end

--     client.netcache = (client.netcache or 0) + 1
--     timer.Simple(5, function()
--         if IsValid(client) then
--             client.netcache = (client.netcache or 0) - 1
--         end
--     end)

--     if client.netcache > ANTICRASH_CONFIG.MAX_NET_CACHE_SIZE then
--         networkMonitor.handleNetSpam(client)
--         return -- Block the message
--     end

--     if ANTICRASH_CONFIG.LOG_NET_ACTIVITY then
--         file.Append("net_logger.txt",
--             string.format("%s\t[%s]\t%s\t\"%s\"\t%d\n",
--                 util.DateStamp(),
--                 client:SteamID(),
--                 client:Nick(),
--                 strName:lower(),
--                 len
--             )
--         )
--     end

--     originalNetIncoming(len, client)
-- end

function networkMonitor.handleNetSpam(ply)
    if not IsValid(ply) then return end

    local steamid = ply:SteamID()
    local crashAttempts = networkMonitor.crashAttempts[steamid] or 0
    crashAttempts = crashAttempts + 1
    networkMonitor.crashAttempts[steamid] = crashAttempts

    if crashAttempts == 1 then
        ply:ChatPrint("Warning: Excessive network activity detected. Slow down!")
        octolib.logger.warning("Network spam warning", ply, {
            attempts = crashAttempts,
            net_per_sec = networkMonitor.activeConnections[steamid].netMessagesPerSecond
        })
    elseif crashAttempts == 2 then
        ply:Kick("Network spam detected - temporarily kicked")
        octolib.logger.warning("Network spam kick", ply, {attempts = crashAttempts})
    elseif crashAttempts >= 3 then
        if serverguard then
            RunConsoleCommand('sg', 'ban', steamid, tostring(ANTICRASH_CONFIG.NET_SPAM_BAN_DURATION),
                'Server crash attempts')
        end
        ply:Kick("Banned for server crash attempts")
        octolib.logger.error("Network spam ban", ply, {attempts = crashAttempts})

        if CFG.webhooks and CFG.webhooks.cheats then
            octolib.webhook.anticheat(CFG.webhooks.cheats,
                'Server Crash Attempt Detected',
                'Player banned for repeated crash attempts',
                ply,
                {{
                    name = 'Ban Duration',
                    value = string.format('%d minutes', ANTICRASH_CONFIG.NET_SPAM_BAN_DURATION),
                }, {
                    name = 'Total Attempts',
                    value = crashAttempts,
                }}
            )
        end
    end
end

function networkMonitor.logSuspiciousActivity(ply, activity, description)
    local steamid = ply:SteamID()
    networkMonitor.suspiciousActivity[steamid] = networkMonitor.suspiciousActivity[steamid] or {
        activities = {},
        lastActivity = 0
    }

    table.insert(networkMonitor.suspiciousActivity[steamid].activities, {
        activity = activity,
        description = description,
        timestamp = os.time()
    })

    networkMonitor.suspiciousActivity[steamid].lastActivity = os.time()

    if CFG.webhooks and CFG.webhooks.cheats and ANTICRASH_CONFIG.LOG_SUSPICIOUS_ACTIVITY then
        octolib.webhook.anticheat(CFG.webhooks.cheats,
            'Suspicious Activity Detected',
            description,
            ply,
            {{
                name = 'Activity',
                value = activity,
                inline = true
            }}
        )
    end

    octolib.logger.warning(description, ply, {
        activity = activity,
        total_suspicious = #networkMonitor.suspiciousActivity[steamid].activities
    })
end

timer.Create("anticrash.net_per_sec_reset", 1, 0, function()
    for steamid, data in pairs(networkMonitor.activeConnections) do
        data.netMessagesPerSecond = 0
    end
end)

util.AddNetworkString("_Detect")
util.AddNetworkString('Sandbox_ArmDupe')
util.AddNetworkString('Ulib_Message')
util.AddNetworkString('DarkRP_AdminWeapons')
util.AddNetworkString('ac.detect')

-- Suppress unknown command errors for client convars
concommand.Add("mat_shadowstate", function() end)

net.Receive("DarkRP_AdminWeapons", function(len, ply)
    networkMonitor.logSuspiciousActivity(ply, "DarkRP_AdminWeapons", "Attempted admin weapon exploit")
    ply:Kick("Exploits detected")
end)

net.Receive("StackGhost", function(len, ply)
    networkMonitor.logSuspiciousActivity(ply, "StackGhost", "Stack ghost exploit attempt")
    ply:Kick("Exploits detected")
end)

net.Receive("Sandbox_ArmDupe", function(len, ply)
    networkMonitor.logSuspiciousActivity(ply, "Sandbox_ArmDupe", "ArmDupe exploit attempt")
    ply:Kick("Exploits detected")
end)

net.Receive("Ulib_Message", function(len, ply)
    networkMonitor.logSuspiciousActivity(ply, "Ulib_Message", "ULib message exploit attempt")
    ply:Kick("Exploits detected")
end)

net.Receive("_Detect", function(len, ply)
    local detection = net.ReadString()
    if detection == "external" then
        networkMonitor.logSuspiciousActivity(ply, "_Detect:external", "External Lua execution detected")
        ply:Kick("External code execution")
    elseif detection == '' then
        networkMonitor.logSuspiciousActivity(ply, "_Detect:empty", "Suspicious detection signal")
        ply:Kick("Suspicious activity")
    end
end)

net.Receive('ac.detect', function(len, ply)
    local detections = net.ReadTable()
    local screenshot = net.ReadString()

    if detections and #detections > 0 then
        local detectionSummary = ""
        for _, detection in ipairs(detections) do
            detectionSummary = detectionSummary .. detection._type .. ", "
        end
        detectionSummary = detectionSummary:sub(1, -3)

        networkMonitor.logSuspiciousActivity(ply, "ClientAC:" .. detectionSummary,
            "Client-side anti-cheat detected issues")

        if #detections >= 3 then
            ply:Kick("Multiple cheat detections")
        else
            ply:ChatPrint("Warning: Suspicious activity detected on your client")
        end
    end
end)

hook.Add('PlayerSpawnedProp', 'AntiPropKill', function(ply, mdl, ent)
    if not IsValid(ent) then return end

    timer.Simple(0, function()
        if not IsValid(ent) then return end

        local center = ent:LocalToWorld(ent:OBBCenter())
        local radius = ent:BoundingRadius()

        for _, ent2 in ipairs(ents.FindInSphere(center, radius)) do
            if ent2:IsPlayer() and not ent2:InVehicle() and ent2:GetObserverMode() == OBS_MODE_NONE then
                local dist = ent:NearestPoint(ent2:NearestPoint(ent:GetPos())):Distance(
                    ent2:NearestPoint(ent2:GetPos()))

                if dist <= 25 then
                    ent:Remove()
                    ply:SendLua("GAMEMODE:AddNotify('Your prop could trap a player - removed for safety.', NOTIFY_GENERIC, 5)")

                    octolib.logger.info("Removed potentially dangerous prop", ply, {
                        model = mdl,
                        reason = "could_trap_player"
                    })
                    break
                end
            end
        end
    end)
end)

end
