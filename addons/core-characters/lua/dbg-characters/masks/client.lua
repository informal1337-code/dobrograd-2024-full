--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-characters/lua/dbg-characters/masks/client.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local angle_zero = Angle(0, 0, 0)


function dbgChars.masks.shouldShowPlayerMasks(ply)
	if ply.masksVisible ~= nil then
		return ply.masksVisible
	end

	return ply ~= LocalPlayer()
end
netstream.Hook('dbgChars.masks.setShowPlayerMasks', dbgChars.masks.setShowPlayerMasks)

function dbgChars.masks.setShowPlayerMasks(ply, show)
	ply.masksVisible = show

	for _, ent in pairs(ply.hMasks or {}) do
		if IsValid(ent) then
			ent:SetNoDraw(not dbgChars.masks.shouldShowPlayerMasks(ply))
		end
	end
end

function dbgChars.masks.removeMaskEnts(ply)
	for maskID in pairs(ply.hMasks or {}) do
		if ply.hMasks[maskID] then
			if IsValid(ply.hMasks[maskID]) then
				ply.hMasks[maskID]:Remove()
			end
			ply.hMasks[maskID] = nil
		end
	end
end

local maskEnts = {}
local maxDistSqr = 1500 ^ 2
timer.Create('dbg-masks', 1, 0, function()

	local me = LocalPlayer()
	if not IsValid(me) then return end

	local pos = me:EyePos()
	for _, ply in ipairs(player.GetAll()) do
		local masks = ply:GetNetVar('hMask') or {}
		for slot in pairs(masks) do
			local class = ply:GetMaskId(slot)

			ply.hMasks = ply.hMasks or {}
			local mask = ply.hMasks[class]

			if not class
			or IsValid(mask) and mask.maskClass ~= class
			or ply:GetPos():DistToSqr(pos) > maxDistSqr
			or ply:GetNoDraw()
			or ply:IsGhost() then
				if IsValid(ply.hMasks[class]) then
					ply.hMasks[class]:Remove()
				end
				continue
			end

			if not IsValid(mask) then
				local data = CFG.masks[class]
				if not data then continue end

				local attachmentId = ply:LookupAttachment(data.att or 'eyes')
				if not attachmentId then continue end

				if data.femaleProps and not ply:IsMale() then
					data = table.Merge(table.Copy(data), data.femaleProps)
				end

				mask = octolib.createDummy(data.mdl)
				mask.maskClass = class

				ply.hMasks[class] = mask

				mask:SetParent(ply, attachmentId)
				mask:SetLocalPos(data.pos)
				mask:SetLocalAngles(data.ang or angle_zero)
				if data.scale then mask:SetModelScale(data.scale) end
				if data.skin then mask:SetSkin(data.skin) end
				if data.mat then mask:SetMaterial(data.mat) end
				mask:SetPredictable(true)

				table.insert(maskEnts, mask)
				mask:SetNoDraw(not dbgChars.masks.shouldShowPlayerMasks(ply))
			end
		end

		for maskID in pairs(ply.hMasks or {}) do
			if ply.hMasks[maskID] then
				local slots = dbgChars.masks.getMaskSlots(maskID) or {}
				local slot = slots[1]
				if not slot then continue end

				if not masks[slot] or masks[slot].mask ~= maskID then
					if IsValid(ply.hMasks[maskID]) then ply.hMasks[maskID]:Remove() end
					ply.hMasks[maskID] = nil
				end
			end
		end
	end

	for i = #maskEnts, 1, -1 do
		local mask = maskEnts[i]
		if IsValid(mask) and not IsValid(mask:GetParent()) then
			mask:Remove()
		end
		if not IsValid(mask) then table.remove(maskEnts, i) end
	end

end)

netstream.Hook('dbgChars.masks.reload', function(ply)
	if not IsValid(ply) then return end
	dbgChars.masks.removeMaskEnts(ply)
end)
