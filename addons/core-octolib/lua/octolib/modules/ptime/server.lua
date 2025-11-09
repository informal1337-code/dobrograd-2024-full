if CFG.disabledModules.ptime then return end

local vars = {
	sessionStart = 'pt.sessionStart',
	here = {
		nv = 'pt.here',
		db = 'pt_' .. CFG.serverID,
	},
	total = {
		nv = 'pt.total',
		db = 'pt',
	},
}

local hasOldData = sql.TableExists('utime')
local function tryMigrate(ply)

	if not hasOldData or not IsValid(ply) then return end

	local sid = ply:SteamID()
	local row = sql.QueryRow('SELECT totaltime FROM utime WHERE steamid=\'' .. sid .. '\';')
	if not row then return end

	local old = tonumber(row.totaltime) or 0
	ply:SetNetVar(vars.here.nv, old)
	ply:SetDBVar(vars.here.db, old)

	local total = ply:GetNetVar(vars.total.nv)
	if old > total then
		ply:SetNetVar(vars.total.nv, old)
		ply:SetDBVar(vars.total.db, old)
	end

	sql.Query('DELETE FROM utime WHERE steamid=\'' .. sid .. '\';')

end

hook.Add('octolib.dbvars-loaded', 'play-time', function(ply)

	ply:SetNetVar(vars.total.nv, ply:GetDBVar(vars.total.db, 0))
	ply:SetNetVar(vars.here.nv, ply:GetDBVar(vars.here.db, 0))

	tryMigrate(ply)

	if not ply:IsAFK() then
		ply:SetNetVar(vars.sessionStart, CurTime())
	end

end)

hook.Add('PlayerDisconnected', 'play-time', function(ply)

	ply:SaveTime()

end)

hook.Add('octolib.afk.changed', 'play-time', function(ply, afk)

	if afk then
		ply:SaveTime()
		ply:SetNetVar(vars.sessionStart, nil)
	else
		ply:SetNetVar(vars.sessionStart, CurTime())
	end

end)

local pmeta = FindMetaTable('Player')

function pmeta:SaveTime()

	local ct = CurTime()
	local diff = ct - self:GetNetVar(vars.sessionStart, ct)
	if diff <= 0 then return end

	local time = self:GetNetVar(vars.total.nv, 0) + diff
	self:SetDBVar(vars.total.db, time)
	self:SetNetVar(vars.total.nv, time)

	time = self:GetNetVar(vars.here.nv, 0) + diff
	self:SetDBVar(vars.here.db, time)
	self:SetNetVar(vars.here.nv, time)

	self:SetNetVar(vars.sessionStart, ct)

end

function pmeta:AddTime(minutes)
	if not minutes or minutes == 0 then return end
	
	local seconds = minutes * 60
	self:SaveTime()
	
	local currentTotal = self:GetNetVar(vars.total.nv, 0)
	local currentHere = self:GetNetVar(vars.here.nv, 0)
	
	if minutes > 0 then
		self:SetTimeTotal(currentTotal + seconds)
		self:SetTimeHere(currentHere + seconds)
	else
		local newTotal = math.max(0, currentTotal + seconds) -- minutes отрицательные
		local newHere = math.max(0, currentHere + seconds)
		self:SetTimeTotal(newTotal)
		self:SetTimeHere(newHere)
	end
end

function pmeta:SetTimeTotal(val)

	self:SetNetVar(vars.total.nv, val)
	self:SetDBVar(vars.total.db, val)

end

function pmeta:SetTimeHere(val)
	self:SetNetVar(vars.here.nv, val)
	self:SetDBVar(vars.here.db, val)
end

------------
-- PTIMER --
------------
octolib.ptime = octolib.ptime or {}
octolib.ptime.timers = octolib.ptime.timers or {}

-- unique timer id, delay in minutes (int), callback
function octolib.ptime.createTimer(identifier, delay, func)
	if not (identifier and isnumber(delay) and isfunction(func)) then
		return ErrorNoHalt('Incorrect arguments')
	end
	octolib.ptime.timers[identifier] = { math.floor(delay), func }
end

function octolib.ptime.removeTimer(identifier)
	if identifier then octolib.ptime.timers[identifier] = nil end
end

timer.Create('octolib.ptime.iterate', 60, 0, function()
	for _, ply in ipairs(player.GetAll()) do
		if ply:IsAFK() then continue end

		local minutesPlayed = math.floor(ply:GetTimeTotal() / 60)
		for _, v in pairs(octolib.ptime.timers) do
			if minutesPlayed % v[1] == 0 and ply.lastRewards ~= minutesPlayed then
				ply.lastRewards = minutesPlayed
				v[2](ply, minutesPlayed)
			end
		end

	end
end)
--
-- COMMANDS
--

hook.Add('PlayerSay', 'ptime.chatCommands', function(ply, text)

	local lowerText = text:lower()

	if lowerText:sub(1, 10) == '!addptime ' then
		if not ply:IsSuperAdmin() then
			ply:Notify('warning', 'Только для суперадминов')
			return ''
		end

		local args = octolib.string.split(text:sub(11), ' ')
		if #args < 2 then
			ply:Notify('warning', 'Использование: !addptime <ник> <минуты>')
			return ''
		end

		local target = octolib.findPlayer(args[1])
		if not IsValid(target) then
			ply:Notify('warning', 'Игрок не найден')
			return ''
		end

		local minutes = tonumber(args[2])
		if not minutes or minutes <= 0 then
			ply:Notify('warning', 'Укажите корректное количество минут (больше 0)')
			return ''
		end

		local seconds = minutes * 60
		
		target:SaveTime()

		local currentTotal = target:GetNetVar(vars.total.nv, 0)
		local currentHere = target:GetNetVar(vars.here.nv, 0)

		target:SetTimeTotal(currentTotal + seconds)
		target:SetTimeHere(currentHere + seconds)

		ply:Notify('hint', 'Вы добавили ' .. minutes .. ' минут игроку ' .. target:Name())
		target:Notify('hint', 'Вам добавлено ' .. minutes .. ' минут игрового времени')

		print(string.format('[PTIME] %s (%s) добавил %d минут игроку %s (%s)',
			ply:Name(), ply:SteamID(), minutes, target:Name(), target:SteamID()))

		return ''
	end

	if lowerText:sub(1, 13) == '!removeptime ' then
		if not ply:IsSuperAdmin() then
			ply:Notify('warning', 'Только для суперадминов')
			return ''
		end

		local args = octolib.string.split(text:sub(14), ' ')
		if #args < 2 then
			ply:Notify('warning', 'Использование: !removeptime <ник> <минуты>')
			return ''
		end

		local target = octolib.findPlayer(args[1])
		if not IsValid(target) then
			ply:Notify('warning', 'Игрок не найден')
			return ''
		end

		local minutes = tonumber(args[2])
		if not minutes or minutes <= 0 then
			ply:Notify('warning', 'Укажите корректное количество минут (больше 0)')
			return ''
		end

		local seconds = minutes * 60
		
		target:SaveTime()

		local currentTotal = target:GetNetVar(vars.total.nv, 0)
		local currentHere = target:GetNetVar(vars.here.nv, 0)

		local newTotal = math.max(0, currentTotal - seconds)
		local newHere = math.max(0, currentHere - seconds)

		target:SetTimeTotal(newTotal)
		target:SetTimeHere(newHere)

		ply:Notify('hint', 'Вы удалили ' .. minutes .. ' минут у игрока ' .. target:Name())
		target:Notify('hint', 'У вас удалено ' .. minutes .. ' минут игрового времени')

		print(string.format('[PTIME] %s (%s) удалил %d минут у игрока %s (%s)',
			ply:Name(), ply:SteamID(), minutes, target:Name(), target:SteamID()))

		return ''
	end

	if lowerText:sub(1, 11) == '!setptime ' then
		if not ply:IsSuperAdmin() then
			ply:Notify('warning', 'Только для суперадминов')
			return ''
		end

		local args = octolib.string.split(text:sub(12), ' ')
		if #args < 2 then
			ply:Notify('warning', 'Использование: !setptime <ник> <минуты>')
			return ''
		end

		local target = octolib.findPlayer(args[1])
		if not IsValid(target) then
			ply:Notify('warning', 'Игрок не найден')
			return ''
		end

		local minutes = tonumber(args[2])
		if not minutes or minutes < 0 then
			ply:Notify('warning', 'Укажите корректное количество минут (0 или больше)')
			return ''
		end

		local seconds = minutes * 60
		
		target:SaveTime()

		target:SetTimeTotal(seconds)
		target:SetTimeHere(seconds)

		ply:Notify('hint', 'Вы установили ' .. minutes .. ' минут игроку ' .. target:Name())
		target:Notify('hint', 'Вам установлено ' .. minutes .. ' минут игрового времени')

		print(string.format('[PTIME] %s (%s) установил %d минут игроку %s (%s)',
			ply:Name(), ply:SteamID(), minutes, target:Name(), target:SteamID()))

		return ''
	end

end)