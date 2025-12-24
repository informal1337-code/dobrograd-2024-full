local plyMeta = FindMetaTable('Player')
local entityMeta = FindMetaTable('Entity')

local function updateRagdollTimer(ply, timeLeft, paused)
	ply:SetNetVar('RagdollTimeLeft', timeLeft)
	ply:SetNetVar('RagdollDuration', timeLeft + (paused and 0 or CurTime()))
	ply:SetNetVar('RagdollEndsAt', paused and 0 or CurTime() + timeLeft)
	ply:SetNetVar('RagdollPaused', paused)
end

function plyMeta:SetRagdollState(enabled, duration, silent)
	if enabled then
		if not self:Alive() then return false end

		local ragdoll = ents.Create('prop_ragdoll')
		if not IsValid(ragdoll) then return false end

		local vel = self:GetVelocity()
		local pos = self:GetPos()
		local ang = self:GetAngles()

		ragdoll:SetPos(pos)
		ragdoll:SetAngles(ang)
		ragdoll:SetModel(self:GetModel())
		ragdoll:SetSkin(self:GetSkin())
		ragdoll:SetColor(self:GetColor())
		ragdoll:SetMaterial(self:GetMaterial())
		ragdoll:Spawn()
		ragdoll:Activate()

		ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		ragdoll:SetNetVar('RagdollOwner', self)
		ragdoll.ragdollSID = self:SteamID()

		for i = 0, self:GetNumBodyGroups() - 1 do
			ragdoll:SetBodygroup(i, self:GetBodygroup(i))
		end

		for i = 0, self:GetNumMaterials() - 1 do
			ragdoll:SetSubMaterial(i, self:GetSubMaterial(i))
		end

		local physCount = ragdoll:GetPhysicsObjectCount()
		for i = 0, physCount - 1 do
			local phys = ragdoll:GetPhysicsObjectNum(i)
			if IsValid(phys) then
				local bone = ragdoll:TranslatePhysBoneToBone(i)
				local playerBonePos, playerBoneAng = self:GetBonePosition(bone)

				if playerBonePos then
					phys:SetPos(playerBonePos)
					phys:SetAngles(playerBoneAng)
				end

				phys:AddVelocity(vel)
			end
		end

		self:SetNetVar('Ragdolled', true)
		self:SetNetVar('Ragdoll', {ragdoll})
		self:SetParent(ragdoll)

		self:SetNoDraw(true)
		self:SetNotSolid(true)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(false)

		if duration and duration > 0 then
			updateRagdollTimer(self, duration, false)
			timer.Create('dbgChars.ragdoll.' .. self:SteamID(), duration, 1, function()
				if IsValid(self) then
					self:SetRagdollState(false)
				end
			end)
		end

		if not silent then
			self:SetLocalVar('RagdollVoiceDisabled', true)
		end

		netstream.Start(self, 'dbgChars.ragdoll.enabled', {ragdoll})

		hook.Run('dbgChars.ragdoll.enabled', self, ragdoll)
		return true
	else
		local ragdoll = self:GetRagdollEntity()
		if not IsValid(ragdoll) then return false end

		local pos = ragdoll:GetPos()
		local ang = ragdoll:GetAngles()

		timer.Remove('dbgChars.ragdoll.' .. self:SteamID())

		self:SetNetVar('Ragdolled', false)
		self:SetNetVar('Ragdoll', {})
		self:SetParent()

		self:SetNoDraw(false)
		self:SetNotSolid(false)
		self:SetMoveType(MOVETYPE_WALK)
		self:DrawShadow(true)

		self:SetPos(pos)
		self:SetAngles(ang)
		self:SetVelocity(ragdoll:GetVelocity())

		updateRagdollTimer(self, -1, false)

		self:SetLocalVar('RagdollVoiceDisabled', false)

		timer.Simple(0.1, function()
			if IsValid(ragdoll) then
				ragdoll:Remove()
			end
		end)

		netstream.Start(self, 'dbgChars.ragdoll.disabled')

		hook.Run('dbgChars.ragdoll.disabled', self)
		return true
	end
end

function plyMeta:PauseRagdollTimer(pause)
	local timerName = 'dbgChars.ragdoll.' .. self:SteamID()
	local timeLeft = timer.TimeLeft(timerName)

	if pause then
		timer.Pause(timerName)
		updateRagdollTimer(self, timeLeft, true)
	else
		timer.UnPause(timerName)
		updateRagdollTimer(self, timeLeft, false)
	end
end

hook.Add('PlayerDisconnected', 'dbgChars.ragdoll.cleanup', function(ply)
	local ragdoll = ply:GetRagdollEntity()
	if IsValid(ragdoll) then
		ragdoll:Remove()
	end

	timer.Remove('dbgChars.ragdoll.' .. ply:SteamID())
end)

hook.Add('PlayerShouldTakeDamage', 'dbgChars.ragdoll', function(ply)
	if ply:GetNetVar('Ragdolled') then
		return false
	end
end)
