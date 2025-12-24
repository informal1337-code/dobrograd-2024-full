---------------------------------------------------------------------
-- DATABASE
---------------------------------------------------------------------

CFG.db = {
	host = 'localhost',
	user = 'root',
	pass = '',
	port = '3306',

	main = 'dbg',
	admin = 'dbg',
	shop = 'dbg', --ddd
}
CFG.requireLauncher = false

octoservices = octoservices or {}
---------------------------------------------------------------------
-- USE
---------------------------------------------------------------------
CFG.use = CFG.use or {}
hook.Add('octolib.use-loadConfig', 'octolib', function()
	local fs, _ = file.Find('config/octolib-use/*.lua', 'LUA')
	for _, f in pairs(fs) do
		fname = 'config/octolib-use/' .. string.StripExtension(f)
		octolib.server(fname)
	end
end)

---------------------------------------------------------------------
-- BACKUP
---------------------------------------------------------------------
CFG.backupPeriod = 300
CFG.backupCleanupAfter = 600
CFG.backupPruneTime = 3600

---------------------------------------------------------------------
-- DATABASE
---------------------------------------------------------------------
CFG.dbTick = true
CFG.dbTickTime = 1

CFG.webhooks = CFG.webhooks or {}
CFG.webhooks.main = ""
CFG.webhooks.cheats = ""
CFG.webhooks.admin = ""

if SERVER then
	timer.Simple(5, function()
		if CFG.webhooks.main then
			octolib.logger.setWebhook(CFG.webhooks.main)
		end
		octolib.logger.setLevel("INFO")

		if CFG.webhooks.main then
			octolib.webhook.message(CFG.webhooks.main,
				"Server started successfully - " .. GetHostName(),
				GetHostName()
			)
		end
	end)
end

---------------------------------------------------------------------
-- PLAYERS
---------------------------------------------------------------------
octolib.admins = octolib.admins or {}
hook.Add('PlayerFinishedLoading', 'octolib.adminslots', function()
	hook.Remove('PlayerFinishedLoading', 'octolib.adminslots')
		local queryObj = serverguard.mysql:Select('serverguard_users')
		queryObj:WhereNotEqual('rank', 'user')
		queryObj:Callback(function(result)
			if (type(result) == 'table' and #result > 0) then
					serverguard.ranksCache = result
					for _, v in pairs(serverguard.ranksCache) do
						if CFG.adminRanks[v.rank] then
							octolib.admins[v.steam_id] = true
						end
					end
			end
		end)
	queryObj:Execute()

end)

CFG.adminSlots = 4
CFG.adminRanks = {
	trainee = true,
	tadmin = true,
	admin = true,
	sadmin = true,

	rpmanager = true,
	projectmanager = true,
	contentmanager = true,
	dev = true,

	superadmin = true,
	founder = true,
}

function CFG.isAdminSteamID(id)

	return octolib.admins[id]

end

--
-- REWARDS
--

local forumReward = 20000
CFG.forumRewardHandler = function(ply, forumData, finish)
	local id = ply:SteamID()
	octolib.func.chain({
		function(done)
			BraxBank.PlayerMoneyAsync(id, done)
		end,
		function(done, balance)
			if not IsValid(ply) then return end

			finish()
			BraxBank.UpdateMoney(id, balance + forumReward)
			octolib.notify.sendAll('hint', L.bonus_get:format(ply:Name(), forumData.name, DarkRP.formatMoney(forumReward)))

			timer.Simple(5, done)
		end,
		function()
			if IsValid(ply) then
				ply:Notify('hint', L.bonus_in_atm)
			end
		end,
	})
end

octolib.server('map')
