local PM = FindMetaTable('Player')
local EM = FindMetaTable('Entity')

local baseTime = 10 * 60
local minTime = 5 * 60
local maxTime = 20 * 60

function dbgChars.ghosts.getSpawnTime(ply)
	if ply:GetDBVar('ghostTime') then return ply:GetDBVar('ghostTime') end
	if ply:Team() == TEAM_PRIEST then return minTime end
	local karma = ply:GetKarma()
	return math.Clamp(baseTime - (karma > 0 and (karma * 3) or (karma * 12)), minTime, maxTime)
end

function dbgChars.ghosts.triggerDeath(ply)
	local time = math.max(hook.Run('dbg-ghosts.overrideTime', ply) or dbgChars.ghosts.getSpawnTime(ply), 10)
	ply:SetNetVar('_SpawnTime', CurTime() + time)
	ply:SetNetVar('_GhostTime', CurTime() + math.min(time, dbgChars.ghosts.config.ghostTime))
	ply:SetNetVar('_TimeToGhost', CurTime())
	ply:SetDBVar('ghostTime', time)
end

local curGhosts = {}
function PM:SetGhost(val)
	if val then
		curGhosts[self] = true
		self:SetNetVar('Ghost', true)
	else
		curGhosts[self] = nil
		self:SetNetVar('Ghost', false)

		if self:GetNetVar('launcherActivated') then
			self:SetDBVar('ghostTime', nil)
			self:SetDBVar('ghostBuffs', nil)
		end
	end
end

hook.Add('GetPlayerChatColor', 'ghosts-chatcolor', function(ply, txt)
	if ply:IsGhost() or not ply:Alive() then
		return octochat.textColors.ooc
	end
end)

hook.Add('PlayerCanSeePlayersChat', 'chelog-death', function(txt, t, listener, talker)
	if talker:IsGhost() and not listener:IsGhost() and listener:Team() ~= TEAM_ADMIN then
		return false
	end
end)

local protectedNVars = { {'name', 'seesName'}, {'attacker'}, {'bullet', 'seesCaliber'}, {'weapon', 'seesCaliber'}, {'time', 'seesTime'} }
for _, v in ipairs(protectedNVars) do
	netvars.Register('Corpse.' .. v[1], {
		checkAccess = function(ply)
			return v[2] and ply:getJobTable()[v[2]] or ply:Team() == TEAM_ADMIN
		end,
	})
end

local deathCauses = L.deathCauses or {
	unknown = {'неизвестно'},
	bullet = {'пуля'},
	fall = {'падение'},
	vehicle = {'автомобиль'},
	prop = {'объект'},
	explosion = {'взрыв'},
	fire = {'огонь'},
	drown = {'утопление'},
	acid = {'кислота'},
	poison = {'яд'},
	radiation = {'радиация'},
}
function PM:CreateRagdoll(attacker, dmg)
	if not self:SetRagdollState(true, dbgChars.ghosts.config.nearDeathTime) then
		return
	end

	local ragdoll = self:GetRagdollEntity()
	if not IsValid(ragdoll) then return end

	local cause, weapon = table.Random(deathCauses.unknown)
	for k, v in pairs(deathCauses) do
		if isnumber(k) and dmg:IsDamageType(k) then
			cause = table.Random(v)
			weapon = self.lastWeapon or L.unknown
		end
	end

	ragdoll:SetNetVar('dbgLook', {
		name = '',
		desc = 'corpseDesc',
		descRender = true,
		time = 8,
	})

	ragdoll:SetNetVar('Corpse.name', self:Name())
	ragdoll:SetNetVar('Corpse.attacker', self.lastAttacker or L.unknown)
	ragdoll:SetNetVar('Corpse.bullet', dmg:IsDamageType(DMG_BULLET))
	ragdoll:SetNetVar('Corpse.cause', cause)
	ragdoll:SetNetVar('Corpse.weapon', weapon)
	ragdoll:SetNetVar('Corpse.time', CWI.TimeToString())
	if IsValid(attacker) and attacker:IsPlayer() and attacker ~= self then
		ragdoll:SetNetVar('Corpse.killer', attacker)
		ragdoll:SetNetVar('Corpse.wasDangerous', self:WasDangerousAtDeath())
	end

	local hitPos = dmg:GetDamagePosition()
	local force = dmg:GetDamageForce()
	local physNum = ragdoll:GetPhysicsObjectCount()
	local minDist, hitBone = 1000000
	for id = 0, physNum - 1 do
		local phys = ragdoll:GetPhysicsObjectNum(id)
		if IsValid(phys) then
			local bone = ragdoll:TranslatePhysBoneToBone(id)
			local pos, ang = self:GetBonePosition(bone)
			local testDist = hitPos:DistToSqr(pos)
			if testDist < minDist then
				hitBone = phys
				minDist = testDist
			end
		end
	end

	if hitBone then
		hitBone:ApplyForceOffset(force / 2, hitPos)
	end
	self:SetNetVar('DeathRagdoll', ragdoll)
	self:SetGhost(true)
	self:SetClothes(nil)
end

hook.Add('PlayerShouldTakeDamage', 'dbg-death', function(ply)
	ply.lastVelocity = ply:GetVelocity()
end)

if not PM.GetRagdollEntityOld then
	PM.GetRagdollEntityOld = PM.GetRagdollEntity
end
function PM:GetRagdollEntity()
	local ent = self:GetNetVar('DeathRagdoll')
	if IsValid(ent) then
		return ent
	else
		return self:GetRagdollEntityOld()
	end
end

if not PM.GetRagdollOwnerOld then
	PM.GetRagdollOwnerOld = PM.GetRagdollOwner
end
function EM:GetRagdollOwner()
	local ent = self:GetNetVar('RagdollOwner')
	if IsValid(ent) then
		return ent
	end
	if self.ragdollSID then
		ent = player.GetBySteamID(self.ragdollSID)
		if IsValid(ent) then return ent end
	end
	return self.GetRagdollOwnerOld and self:GetRagdollOwnerOld() or Entity(0)
end

local function penalty(ply)
	if ply:GetNetVar('launcherActivated') and (ply:GetNetVar('Ghost') or not ply:Alive()) then
		ply:SetDBVar('ghostTime', ply:GetNetVar('_SpawnTime') - CurTime())
	end
end
hook.Add('PlayerDisconnected', 'dbg-ghost.setGhostAgain', penalty)

local function check(ply)
	if not IsValid(ply) then return end
	if not ply:GetDBVar('ghostTime') then return end
	ply:Notify('warning', L.death_leave)
	ply:KillSilent()
	ply.inv = nil
end
hook.Add('dbg-test.complete', 'dbg-ghost.checkGhost', check)

local function death(ply)
	ply:SetGhost(true)
	dbgChars.ghosts.triggerDeath(ply)
	ply:SetLocalVar('Energy', 100)
	ply.died = true
	if ply.UpdateCharState then ply:UpdateCharState() end
	if ply:isArrested() then ply:unArrest() end
end
hook.Add('PlayerDeath', 'Ghosts', death)

local function silentDeath(ply)
	ply:SetGhost(true)
	dbgChars.ghosts.triggerDeath(ply)
	ply:SetLocalVar('Energy', 100)
	if ply.UpdateCharState then ply:UpdateCharState() end
	if ply:isArrested() then ply:unArrest() end
end
hook.Add('PlayerSilentDeath', 'Ghosts', silentDeath)

local function flashlight(ply, enabled)
	if ply:GetNetVar('Ghost') and not enabled then
		return false
	end
end
hook.Add('PlayerSwitchFlashlight', 'GhostsCannotUseFlashlights', flashlight)

hook.Add('PlayerSpawn', 'GhostSpawn', function(ply)

	if ply:GetNetVar('Ghost') and (not ply:GetNetVar('launcherActivated') or ply:GetNetVar('_SpawnTime') > CurTime()) then
		local function reset(ply1)
			if not IsValid(ply) then return end

			ply1:StripWeapons()
			ply1:Give('dbg_hands')
			ply1:GodEnable()

			// i know it's done on death, but shit happens
			ply1:ImportInventory(octoinv.defaultInventory)
		end

		timer.Simple(0, reset)
		timer.Simple(5, reset)

		ply:SetColor(Color(255,255,255, 30))
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetCustomCollisionCheck(true)
		ply:CollisionRulesChanged()
		ply:DrawShadow(false)
		ply:SetMaterial('models/props/cs_office/clouds')
		ply:SetBloodColor(DONT_BLEED)
		ply:SetAvoidPlayers(false)
		ply:SetHealth(100)
		ply:SetLocalVar('Energy', 100)

		timer.Simple(0.5, function()
			local corpse = ply:GetNetVar('DeathRagdoll')
			if IsValid(corpse) then
				local pos = FindSuitablePosition(corpse:GetPos(), ply, {around = 40, above = 80}, player.GetAll())
				if pos then ply:SetPos(pos) end
			end
		end)
	end

end)

function FindSuitablePosition(pos, ent, dist, filtr)
	// ply size: (32, 32, 72)
	local function checkPos(pos)
		local trace = { start = pos, endpos = pos, filter = filtr }
		local tr = util.TraceEntity(trace, ent)

		return not tr.Hit
	end

	if checkPos(pos) then return pos end

	local testpos
	for i = 0, 300, 60 do
		testpos = pos + Angle(0, i, 0):Forward() * dist.around
		if checkPos(testpos) then return testpos end
	end

	testpos = pos + Vector(0, 0, dist.above)
	if checkPos(pos + Vector(0, 0, dist.above)) then return testpos end

	return false
end

local function PlayerThink()
	for ply, _ in pairs(curGhosts) do
		if ply:GetNetVar('Ghost', false) and ply:GetNetVar('launcherActivated') and CurTime() >= ply:GetNetVar('_SpawnTime', 0) then
			ply:ExitVehicle()
			ply:SetGhost(false)
			ply:SetHealth(100)
			ply:SetLocalVar('Energy', 100)
			ply:Spawn()
			ply.died = false

			ply:GodDisable()

			ply:SetColor(Color(255, 255, 255, 255))
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetCustomCollisionCheck(false)
			ply:CollisionRulesChanged()
			ply:DrawShadow(true)
			ply:SetMaterial('')
			ply:SetBloodColor(BLOOD_COLOR_RED)
			ply:SetAvoidPlayers(false)
		end
		if not (IsValid(ply) and ply:GetNetVar('Ghost')) then curGhosts[ply] = nil end
	end
end
hook.Add('Think', 'GhostThink', PlayerThink)

local function updateGMFuncs()
	if not GAMEMODE then return end
	function GAMEMODE:PlayerDeathThink(ply)
		if CurTime() >= ply:GetNetVar('_GhostTime', 0) then
			ply:SetGhost(true)
			ply:Spawn()
		end

		return false
	end
end
hook.Add('darkrp.loadModules', 'dbg-ghosts', updateGMFuncs)
updateGMFuncs()

local function handleChat(listener, talker)
	if talker:IsGhost() and not listener:IsGhost() and listener:Team() ~= TEAM_ADMIN then
		return false
	end
end
hook.Add('PlayerCanHearPlayersVoice', 'GhostsHear', handleChat)

local function silentDont(ply)
	if IsValid(ply) and (not ply:Alive() or ply:GetNetVar('Ghost')) then return false end
end
hook.Add('PlayerCanPickupItem', 'GhostsCannotInteract', silentDont)
hook.Add('PlayerShouldTakeDamage', 'GhostsCannotTakeDamage', silentDont)
hook.Add('PlayerUse', 'GhostsCannotUse', silentDont)

hook.Add('shouldViewPunchOnDamage', 'GhostsCannotViewPunch', function(ply)
	if IsValid(ply) and (not ply:Alive() or ply:GetNetVar('Ghost')) then return true end
end)

local function noHandcuff(ply, victim)
	if victim:GetNetVar('Ghost') then
		return false
	end
end
hook.Add('CuffsCanHandcuff', 'noHandcuff', noHandcuff)

//darkrp hooks
local function dont(ply)
	if IsValid(ply) and ply:GetNetVar('Ghost') then
		ply:Notify('warning', L.dead_cant_do_this)
		return false
	end
end
hook.Add('canChangeJob', 'ghosts', dont)
hook.Add('canBuyAmmo', 'ghosts', dont)
hook.Add('canBuyCustomEntity', 'ghosts', dont)
hook.Add('canBuyPistol', 'ghosts', dont)
hook.Add('canBuyShipment', 'ghosts', dont)
hook.Add('canBuyVehicle', 'ghosts', dont)
hook.Add('canDemote', 'ghosts', dont)
hook.Add('canEditLaws', 'ghosts', dont)
hook.Add('canPropertyTax', 'ghosts', dont)
hook.Add('canRequestHit', 'ghosts', dont)
hook.Add('canRequestWarrant', 'ghosts', dont)
hook.Add('canStartVote', 'ghosts', dont)
hook.Add('canTax', 'ghosts', dont)
hook.Add('canUnwant', 'ghosts', dont)
hook.Add('canVote', 'ghosts', dont)
hook.Add('canWanted', 'ghosts', dont)
hook.Add('CanPickupWeapon', 'ghosts', dont)
hook.Add('PlayerSpawnObject', 'ghosts', dont)
hook.Add('dbg-talkie.canSpeak', 'ghosts', silentDont)
hook.Add('dbg-talkie.canListen', 'ghosts', silentDont)

hook.Add('PlayerPickupDarkRPWeapon', 'ghosts', function(ply)
	if ply:GetNetVar('Ghost') then
		return true
	end
end)

hook.Add('playerGetSalary', 'ghosts', function(ply)

	if ply:GetNetVar('Ghost') then
		return true, '', 0
	end

end)

local disallowed = {
	'/rockpaperscissors',
	'/coin',
	'/dice',
	'/roll',
	'/sms',
	'//it',
	'/toit',
	'/me',
	'/yell',
	'/y',
	'/whisper',
	'/w',
	'/advert',
	'/broadcast',
	'/cr',
	'/drop',
	'/moneyput',
	'/putmoney',
	'/dropmoney',
	'/moneydrop',
	'/putmoney',
	'/moneyput',
	'/dropweapon',
	'/g',
	'/give',
	'/lockdown',
	'/unlockdown',
	'/unwarrant',
	'/warrant',
	'/write',
}

local function cantChatCommand(ply, cmd)
	if ply:IsGhost() and table.HasValue(disallowed, cmd) then
		return false, L.dead_cant_do_this
	end
end

hook.Add('octochat.canExecute', 'ghosts-cantchatcommands', cantChatCommand)

local nearDeathPlayers = {}

function PM:GetRagdollTimeLeft()
	local ragdoll = self:GetRagdollEntity()
	if not IsValid(ragdoll) then return 0 end
	local deathTime = ragdoll:GetNetVar('DeathTime', CurTime())
	local endTime = deathTime + dbgChars.ghosts.config.nearDeathTime
	return math.max(0, endTime - CurTime())
end

function PM:GetRagdollEndsAt()
	local ragdoll = self:GetRagdollEntity()
	if not IsValid(ragdoll) then return CurTime() end
	local deathTime = ragdoll:GetNetVar('DeathTime', CurTime())
	return deathTime + dbgChars.ghosts.config.nearDeathTime
end

function PM:GetRagdollDuration()
	return dbgChars.ghosts.config.nearDeathTime
end

local function checkNearDeath()
	for ply, _ in pairs(nearDeathPlayers) do
		if not IsValid(ply) or ply:Alive() then
			nearDeathPlayers[ply] = nil
			ply:SetNetVar('nearDeath', false)
			continue
		end
		local timeLeft = ply:GetRagdollTimeLeft()
		if timeLeft <= 0 then
			local ragdoll = ply:GetRagdollEntity()
			if IsValid(ragdoll) then
				local killer = ragdoll:GetNetVar('Corpse.killer')
				if IsValid(killer) and killer ~= ply then
					local wasDangerous = ragdoll:GetNetVar('Corpse.wasDangerous', false)
					local job = killer:getJobTable()
					if not job.noKarmaDamagePenalty or not wasDangerous then
						killer:AddKarma(-5, L.karma_kill)
					end
				end
			end

			ply:SetNetVar('nearDeath', false)
			nearDeathPlayers[ply] = nil
			ply:CreateRagdoll(nil, DamageInfo())
		end
	end
end
timer.Create('dbgChars.ghosts.nearDeathCheck', 1, 0, checkNearDeath)

local function startNearDeath(ply)
	if ply:GetNetVar('Ghost') or ply:Alive() then return end
	nearDeathPlayers[ply] = true
	ply:SetNetVar('nearDeath', true)
	ply:SetNetVar('reviveTime', nil)
end

local function stopNearDeath(ply)
	nearDeathPlayers[ply] = nil
	ply:SetNetVar('nearDeath', false)
	ply:SetNetVar('reviveTime', nil)
end

hook.Add('PlayerSilentDeath', 'dbgChars.ghosts.nearDeath', function(ply)
	timer.Simple(0.1, function()
		if IsValid(ply) and not ply:Alive() and not ply:GetNetVar('Ghost') then
			startNearDeath(ply)
		end
	end)
end)

local function tryRevive(ply, reviver)
	if not nearDeathPlayers[ply] then return false end

	ply:SetNetVar('reviveTime', CurTime() + dbgChars.ghosts.config.reviveTime)

	timer.Simple(dbgChars.ghosts.config.reviveTime, function()
		if not IsValid(ply) or not nearDeathPlayers[ply] then return end

		ply:SetNetVar('reviveTime', nil)
		stopNearDeath(ply)
		ply:Spawn()

		//if IsValid(reviver) then
			//приколюхи для того кто воскресит
		//end
	end)

	return true
end

netstream.Hook('dbgChars.ghosts.tryRevive', function(ply, target)
	if not IsValid(target) or not nearDeathPlayers[target] then return end

	local dist = ply:GetPos():Distance(target:GetPos())
	if dist > 150 then return end

	tryRevive(target, ply)
end)

netstream.Hook('dbgChars.giveUp', function(ply)
	if not nearDeathPlayers[ply] then return end

	stopNearDeath(ply)
	ply:CreateRagdoll(nil, DamageInfo())
end)
