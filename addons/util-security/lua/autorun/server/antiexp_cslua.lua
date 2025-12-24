-- Anti-cheat: Client-side script detection
-- Monitors for unauthorized client script usage

local bannedPlayers = {}

-- Load existing bans on startup
if file.Exists('octolib_banned_players.json', 'DATA') then
	local data = file.Read('octolib_banned_players.json', 'DATA')
	bannedPlayers = util.JSONToTable(data) or {}
end

local function SaveBanList()
	file.Write('octolib_banned_players.json', util.TableToJSON(bannedPlayers, true))
end

local function BanPlayer(ply, reason)
	local steamID = ply:SteamID()
	local steamID64 = ply:SteamID64()
	
	bannedPlayers[steamID] = {
		name = ply:GetName(),
		steamid64 = steamID64,
		reason = reason,
		banned_at = os.time(),
	}
	
	SaveBanList()
	
	-- Log ban
	octolib.logger.warning('Player banned for cheating', ply, {
		action = 'ban_applied',
		reason = reason,
		steamid64 = steamID64
	})
end

hook.Add("PlayerConnect", "octolib.anticheat.banCheck", function(steamID)
	if bannedPlayers[steamID] then
		local banInfo = bannedPlayers[steamID]
		return string.format("You are banned for: %s\nBanned on: %s", 
			banInfo.reason or "cheating", 
			os.date('%Y-%m-%d %H:%M:%S', banInfo.banned_at or 0))
	end
end)

netstream.Hook('octolib_anticheat_cslua', function(ply)
	-- Don't trigger if server has cheats enabled (for debugging)
	if GetConVar('sv_cheats'):GetBool() or GetConVar('sv_allowcslua'):GetBool() then 
		return 
	end

	local reason = "Unauthorized client-side script usage"
	BanPlayer(ply, reason)

	-- Send detailed Discord notification
	if CFG.webhooks and CFG.webhooks.cheats then
		octolib.webhook.anticheat(CFG.webhooks.cheats,
			'Client-Side Cheat Detected',
			'Player was caught using unauthorized client scripts',
			ply,
			{{
				name = 'Detection Type',
				value = 'Client-side Lua execution',
			}, {
				name = 'Action',
				value = 'Permanent ban applied',
			}}
		)
	end

	ply:Kick('Anti-cheat: Unauthorized client script usage detected')
end)
