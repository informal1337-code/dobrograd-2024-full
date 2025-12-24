-- "addons\\core-characters\\lua\\dbg-characters\\ghosts\\sh_ghosts.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgChars.ghosts = dbgChars.ghosts or {}
dbgChars.ghosts.config = {
	spawnTime = octolib.time.toSeconds(5, 'minutes'), -- time (s) after death to spawn (default: 10 minutes)
	ghostTime = 4, -- time (s) to become ghost (default: 5 seconds)
	fadeInDeath = 3, -- time (ms) how long screen fades in after death (default: 1)
	fadeInGhost = 2, -- time (ms) how long screen fades in after death (default: 4)
	fadeInSpawn = 4, -- time (ms) how long screen fades in after spawn (default: 4)
	minCorpseTime = octolib.time.toSeconds(20, 'minutes'),
	nearDeathTime = octolib.time.toSeconds(7, 'minutes'),
	giveUpTime = 60, -- time (s) how long you have to wait before giving up
	ragdollHealth = 10,
	reviveTime = 30 -- time (s) to revive player
}

local PM = FindMetaTable('Player')

function PM:IsGhost()
	return self:GetNetVar('Ghost', false)
end

function PM:WasDangerousAtDeath()
	local wep = self:GetActiveWeapon()
	return CurTime() - (self.lastAim or -20) < 20 or -- if victim aimed recently
		   (IsValid(wep) and dbgWeaponGroups[wep:GetClass()] ~= 'allowAll') -- if victim had dangerous weapon
end

function player.GetGhosts()
	local tbl = {}
	for _, v in ipairs(player.GetAll()) do
		if v:IsGhost() then tbl[#tbl + 1] = v end
	end
	return tbl
end
