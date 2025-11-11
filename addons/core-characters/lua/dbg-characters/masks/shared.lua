dbgChars.masks = dbgChars.masks or {}
local plyMeta = FindMetaTable('Player')

function dbgChars.masks.getConflictingSlot(ply, maskId)
	local slots = dbgChars.masks.getMaskSlots(maskId)
	local curMasks = ply:GetNetVar('hMask') or {}

	for _, slot in ipairs(slots or {}) do
		if curMasks[slot] then
			return slot
		end
	end

	return nil
end

function dbgChars.masks.getCurMasks(ply)
	local curMasks = ply:GetNetVar('hMask')
	return curMasks or {}
end

function dbgChars.masks.getCurMasksUnique(ply)
	local result = dbgChars.masks.getCurMasks(ply)
	result = octolib.table.mapSequential(result, function(v) return v end)
	result = octolib.array.toKeys(result)
	return table.GetKeys(result)
end

function dbgChars.masks.hasWarmMask(ply)
	local curMasks = dbgChars.masks.getCurMasks(ply)
	if not curMasks then
		return false
	end

	for _, mask in pairs(curMasks) do
		if mask.warm then
			return true
		end
	end

	return false
end

function dbgChars.masks.getItem(maskId)
	local maskData = CFG.masks[maskId]
	if not maskData then
		error('Mask with this ID is not registered: ' .. id)
	end

	return {'h_mask', {
		mask = maskId,
		name = maskData.name,
		desc = maskData.desc,
		icon = maskData.icon,
		model = maskData.mdl,
		skin = maskData.skin,
		warm = maskData.warm,
	}}
end

function plyMeta:GetMask(slot)
	local curMasks = self:GetNetVar('hMask')
	return curMasks and curMasks[slot]
end

function plyMeta:GetMaskId(slot)
	local mask = self:GetMask(slot)
	return mask and (mask.mask or mask[1])
end

function plyMeta:GetMaskExpire(slot)
	local curMasks = self:GetNetVar('hMask')
	if not curMasks then return end

	local data = curMasks[slot]
	if not data then return end
	return istable(data) and data.expire or nil
end

function plyMeta:CanUnmask(slot)
	local curMasks = self:GetNetVar('hMask')
	if not curMasks then return false end

	-- а если в слоте будет дизорик, то все поломается
	if slot then
		local data = curMasks[slot]
		return data and istable(data)
	end

	-- проверяем есть ли хотя бы одна снимаемая маска -- да щиткодер поговори тут еще пузян
	for _, data in pairs(curMasks) do
		if istable(data) then
			return true
		end
	end

	return false
end

function dbgChars.masks.getMaskSlots(maskId)
	local maskData = CFG.masks[maskId]
	if not maskData then return end

	return maskData.slots
end

function dbgChars.masks.hasGasmask(ply)
	local curMasks = ply:GetNetVar('hMask') or {}

	local hMask = curMasks.eyes
	return hMask and hMask.mask == 'gasmask'
end