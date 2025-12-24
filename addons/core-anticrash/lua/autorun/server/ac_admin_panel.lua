if SERVER then

util.AddNetworkString("ac_admin_get_stats")
util.AddNetworkString("ac_admin_get_logs")
util.AddNetworkString("ac_admin_clear_logs")
util.AddNetworkString("ac_admin_kick_player")
util.AddNetworkString("ac_admin_ban_player")

net.Receive("ac_admin_get_stats", function(len, ply)
    if not serverguard.player:HasPermission(ply, "View AntiCrash") then return end

    local stats = {
        ["Active Players"] = #player.GetHumans(),
        ["Network Messages/Min"] = "Calculating...",
        ["Suspicious Activities"] = #networkMonitor.suspiciousActivity,
        ["Crash Attempts"] = networkMonitor.crashAttempts and table.Count(networkMonitor.crashAttempts) or 0,
        ["Log File Size"] = file.Exists("net_logger.txt", "DATA") and
            string.NiceSize(file.Size("net_logger.txt", "DATA")) or "0 B",
        ["System Uptime"] = string.format("%.1f hours", CurTime() / 3600)
    }

    net.Start("ac_admin_get_stats")
    net.WriteTable(stats)
    net.Send(ply)
end)

net.Receive("ac_admin_get_logs", function(len, ply)
    if not serverguard.player:HasPermission(ply, "View AntiCrash") then return end

    local logs = {}

    if file.Exists("net_logger.txt", "DATA") then
        local content = file.Read("net_logger.txt", "DATA")
        local lines = string.Split(content, "\n")
        local recentLines = {}

        for i = math.max(1, #lines - 50), #lines do
            if lines[i] and lines[i] ~= "" then
                table.insert(recentLines, lines[i])
            end
        end

        for _, line in ipairs(recentLines) do
            --DateStamp\t[SteamID]\tName\t"Message"\tSize
            local parts = string.Split(line, "\t")
            if #parts >= 4 then
                table.insert(logs, {
                    time = parts[1] or "Unknown",
                    player = string.format("%s (%s)", parts[3] or "Unknown", parts[2] or "Unknown"),
                    activity = parts[4] or "Unknown",
                    severity = "Info"
                })
            end
        end
    end

    table.Reverse(logs)

    net.Start("ac_admin_get_logs")
    net.WriteTable(logs)
    net.Send(ply)
end)

net.Receive("ac_admin_clear_logs", function(len, ply)
    if not serverguard.player:HasPermission(ply, "Manage AntiCrash") then return end

    if file.Exists("net_logger.txt", "DATA") then
        file.Delete("net_logger.txt")
        octolib.logger.info("Anti-crash logs cleared by admin", ply)
    end
end)

end
