-- "addons\\core-characters\\lua\\dbg-characters\\ragdoll\\sh_ragdoll.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgChars.ragdoll = dbgChars.ragdoll or {}

dbgChars.ragdoll.amountPerPlayer = 1 -- max ragdolls per one player (default: 1)
dbgChars.ragdoll.amountPerServer = 8 -- max ragdolls per server (default: 8)

local plyMeta = FindMetaTable('Player')
local entityMeta = FindMetaTable('Entity')

plyMeta.GetRagdollEntityOld = plyMeta.GetRagdollEntityOld or plyMeta.GetRagdollEntity
function plyMeta:GetRagdollEntity()
	local ent = self:GetNetVar('Ragdoll', {})[1]
	if IsValid(ent) then
		return ent
	end

	return self:GetRagdollEntityOld()
end

function plyMeta:GetRagdollDuration()
	return self:GetNetVar('RagdollDuration', -1)
end

function plyMeta:GetRagdollTimeLeft()
	return self:GetNetVar('RagdollTimeLeft', -1)
end

function plyMeta:GetRagdollEndsAt()
	return self:GetNetVar('RagdollEndsAt')
end

function plyMeta:IsRagdollPaused()
	return self:GetNetVar('RagdollPaused', false)
end

entityMeta.GetRagdollOwnerOld = entityMeta.GetRagdollOwnerOld or entityMeta.GetRagdollOwner
function entityMeta:GetRagdollOwner()
	local ent = self:GetNetVar('RagdollOwner')
	if IsValid(ent) then
		return ent
	end

	if self.ragdollSID then
		local ply = player.GetBySteamID(self.ragdollSID)
		if IsValid(ply) then
			return ply
		end
	end

	return self:GetRagdollOwnerOld() or Entity(0)
end
