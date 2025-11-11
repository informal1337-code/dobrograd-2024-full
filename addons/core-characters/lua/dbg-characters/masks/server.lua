local plyMeta = FindMetaTable 'Player'

function plyMeta:Unmask()
	local curMasks = self:GetNetVar('hMask')
	if not curMasks or table.IsEmpty(curMasks) then 
		self:Notify('warning', 'На тебе нет масок')
		return 
	end

	if not self:CanUnmask() then 
		self:Notify('warning', 'Ты не можешь снять маску сейчас')
		return 
	end

	if not self:Alive() or self:IsGhost() then
		self:Notify('warning', 'Ты мертв!')
		return
	end

	local cont = self.inv and self.inv.conts._hand
	if not cont then
		self:Notify('warning', L.hands_free)
		return
	end

	for slot, maskData in pairs(curMasks) do
		if istable(maskData) and maskData.mask then
			local maskId = maskData.mask
			local maskCFG = CFG.masks[maskId]
			if not maskCFG then continue end

			local itemData = {
				name = maskCFG.name,
				icon = maskCFG.icon,
				desc = maskCFG.desc,
				mask = maskId,
				expire = maskData.expire,
			}

			local item = cont:AddItem('h_mask', itemData)
			if not item or item == 0 then
				self:Notify('warning', 'В руках недостаточно места')
				return
			end

			curMasks[slot] = nil
			self:SetNetVar('hMask', curMasks)
			self:SetDBVar('hMask', curMasks)

			hook.Run('dbg-masks.unmask', self, maskCFG.name)
			self:Notify('Ты снял(а) ' .. maskCFG.name)
			return
		end
	end

	self:Notify('warning', 'Не удалось снять маску')
end
concommand.Add('dbg_unmask', function(ply) ply:Unmask() end)

hook.Add('PlayerFinishedLoading', 'dbg-masks', function(ply)
	timer.Simple(10, function()
		if not IsValid(ply) then return end
		local mask = ply:GetDBVar('hMask')

		if istable(mask) then
			for slot, maskData in pairs(mask) do
				if istable(maskData) and maskData.expire and maskData.expire <= os.time() then
					mask[slot] = nil
					ply:Notify('У твоего аксессуара закончился срок годности')
				elseif istable(maskData) and maskData.expire then
					ply.maskExpireUid = ply.maskExpireUid or {}
					ply.maskExpireUid[slot] = 'octoinv.maskExpire' .. octolib.string.uuid() .. slot
					timer.Create(ply.maskExpireUid[slot], maskData.expire - os.time(), 1, function()
						if not IsValid(ply) then return end
						local curMasks = ply:GetDBVar('hMask') or {}
						curMasks[slot] = nil
						ply:SetNetVar('hMask', curMasks)
						ply:SetDBVar('hMask', curMasks)
						ply:Notify('У твоего аксессуара закончился срок годности')
					end)
				end
			end

			if table.IsEmpty(mask) then
				ply:SetDBVar('hMask', nil)
				mask = nil
			end
		end

		if mask then
			ply:SetNetVar('hMask', mask)
			hook.Run('dbg-masks.mask', ply, mask, true)
		end
	end)
end)

hook.Add('PlayerDeath', 'dbg-masks', function(ply)
	local curMasks = ply:GetNetVar('hMask') or {}
	if table.IsEmpty(curMasks) then return end

	local shouldDrop = ply:CanUnmask()

	ply:SetNetVar('hMask', nil)
	ply:SetDBVar('hMask', nil)
	
	if ply.maskExpireUid then
		for slot, timerId in pairs(ply.maskExpireUid) do
			timer.Remove(timerId)
		end
		ply.maskExpireUid = nil
	end

	if not shouldDrop then return end

	for slot, maskData in pairs(curMasks) do
		if istable(maskData) and maskData.mask then
			local maskId = maskData.mask
			local maskCFG = CFG.masks[maskId]
			if not maskCFG or maskCFG.noDrop then continue end

			local ent = ents.Create 'octoinv_item'
			ent:SetPos(ply:GetShootPos())
			ent:SetAngles(AngleRand())
			ent:SetData('h_mask', {
				name = maskCFG.name,
				icon = maskCFG.icon,
				desc = maskCFG.desc,
				mask = maskId,
				expire = maskData.expire,
			})
			ent.droppedBy = ply

			ent:Spawn()
			ent:Activate()

			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:SetVelocity(ply:GetAimVector() * 150)
			end
		end
	end
end)

hook.Add('PlayerDisconnected', 'dbg-masks', function(ply)
	ply:SetNetVar('hMask', nil)
	if ply.maskExpireUid then
		for slot, timerId in pairs(ply.maskExpireUid) do
			timer.Remove(timerId)
		end
	end
end)