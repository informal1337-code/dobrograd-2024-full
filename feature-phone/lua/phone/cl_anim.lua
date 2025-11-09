-- "addons\\feature-phone\\lua\\phone\\cl_anim.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PlayerMeta = FindMetaTable('Player')
local EntityMeta = FindMetaTable('Entity')

local phoneAnim = {
	default = {
		Bip01_L_Hand = { ang = Angle(15, 10, -35) },
		Bip01_L_Forearm = { ang = Angle(0, -100, -40) },
		Bip01_L_Clavicle = { ang = Angle(0, 0, 0) },
		Bip01_L_UpperArm = { ang = Angle(-20, -30, 0) },

		Bip01_L_Finger0 = { ang = Angle(-5, -28, 0) },
		Bip01_L_Finger02 = { ang = Angle(0, -20, 0) },
		Bip01_L_Finger1 = { ang = Angle(5, -18, -30) },
		Bip01_L_Finger12 = { ang = Angle(0, -10, 0) },
		Bip01_L_Finger2 = { ang = Angle(10, -18, -30) },
		Bip01_L_Finger22 = { ang = Angle(0, -10, 0) },

		Bip01_Head1 = { ang = Angle(0,-10,0) },
		fov = 0.55,
	},

	sitting = {
		Bip01_L_Hand = { ang = Angle(-10, -45, -105) },
		Bip01_L_Forearm = { ang = Angle(0, -22, -60) },
		Bip01_L_Clavicle = { ang = Angle(0, 0, 0) },
		Bip01_L_UpperArm = { ang = Angle(-10, -30, 0) },

		Bip01_L_Finger0 = { ang = Angle(-15, -10, 0) },
		Bip01_L_Finger02 = { ang = Angle(0, -20, 0) },
		Bip01_L_Finger1 = { ang = Angle(20, -18, -30) },
		Bip01_L_Finger12 = { ang = Angle(0, -10, 0) },
		Bip01_L_Finger2 = { ang = Angle(15, -12, -10) },
		Bip01_L_Finger22 = { ang = Angle(0, -10, 0) },

		Bip01_Head1 = { ang = Angle(0,-10,0) },
		fov = 0.3,
	},

	crouching = {
		Bip01_L_Hand = { ang = Angle(6, -30, -20) },
		Bip01_L_Forearm = { ang = Angle(0, 0, -40) },
		Bip01_L_Clavicle = { ang = Angle(5, 20, 0) },
		Bip01_L_UpperArm = { ang = Angle(30, -65, -5) },

		Bip01_L_Finger0 = { ang = Angle(-30, 0, 0) },
		Bip01_L_Finger02 = { ang = Angle(0, -15, 0) },
		Bip01_L_Finger1 = { ang = Angle(17, 23, 0) },
		Bip01_L_Finger12 = { ang = Angle(-10, 25, 0) },
		Bip01_L_Finger2 = { ang = Angle(15, 20, -10) },
		Bip01_L_Finger22 = { ang = Angle(0, 80, 30) },

		Bip01_Head1 = { ang = Angle(0,-10,0) },
		fov = 0.2,
	},
}

local phonePos = {
	pos = Vector(1.4, 0, 1),
	ang = Angle(-240, -10, 80)
}

hook.Add('dbg-view.setActive', 'dbg-phone.RemovePhoneDummy', function(isActive)
	local ply = LocalPlayer()
	if not IsValid(ply) or not IsValid(ply.Phone) then
		return
	end

	ply.Phone:SetNoDraw(not isActive)
end)

hook.Add('UpdateAnimation', 'dbg-phone.UpdateAnimation', function(ply, vel)
	if PlayerMeta.InVehicle(ply) or EntityMeta.GetModel(ply) == 'models/error.mdl' then return end

	ply.PhoneAnimWeight = math.Approach(
		ply.PhoneAnimWeight or 0,
		(ply:IsUsingPhone() and ply:OnGround()) and (1 - vel:LengthSqr() / 50000) or 0,
		FrameTime() * 5
	)

	local weight = ply.PhoneAnimWeight or 0
	if weight > 0 then
		local dummy = ply.Phone
		if IsValid(dummy) and dummy.PhoneCall then return end

		local anim = dbgPhone.getProperAnim(ply)
		for bone, data in pairs(anim) do
			if bone ~= 'fov' then
				local weapon = ply:GetActiveWeapon()
				if IsValid(weapon) and weapon:GetClass():find('octo', 1, false) and (bone == 'Bip01_R_Forearm' or bone == 'Bip01_R_Hand') then continue end

				local id = ply:LookupBone('ValveBiped.' .. bone)
				if not id then continue end

				if data.pos then ply:ManipulateBonePosition(id, data.pos * weight) end
				if data.ang then ply:ManipulateBoneAngles(id, data.ang * weight) end
			end
		end

		local state = (IsValid(ply:GetVehicle()) and 'sitting') or 'normal'

		if not IsValid(dummy) then
			dbgPhone.createDummy(ply)
		elseif ply.lastState ~= state then
			dbgPhone.removeDummy(ply)
			ply.lastState = state
		end
	elseif IsValid(ply.Phone) then
		dbgPhone.removeDummy(ply)
	end
end)


function dbgPhone.getProperAnim(ply)
	if IsValid(ply:GetVehicle()) then
		return phoneAnim.sitting
	end

	if ply:Crouching() then
		return phoneAnim.crouching
	end

	return phoneAnim.default
end

function dbgPhone.createDummy(ply)
	if not IsValid(ply) then return end

	local phone_m = ply.Phone
	if IsValid(phone_m) then return phone_m end

	local phoneModel = ply:GetNetVar('dbgPhone.phoneModel', 'models/octo/octophone2/octophone2.mdl')

	phone_m = octolib.dummy.create(phoneModel)

	phone_m:SetParent(ply, ply:LookupAttachment('anim_attachment_LH'))

	phone_m:SetLocalPos(phonePos.pos)
	phone_m:SetLocalAngles(phonePos.ang)

	phone_m:SetModelScale(ply:GetModelScale())

	ply.Phone = phone_m

	return phone_m
end

function dbgPhone.removeDummy(ply)
	if not IsValid(ply) then return end

	local phone = ply.Phone
	if not IsValid(phone) then return end

	phone:Remove()
	ply.Phone = nil

	for bone, data in pairs(dbgPhone.getProperAnim(ply)) do
		if bone ~= 'fov' then
			local id = ply:LookupBone('ValveBiped.' .. bone)
			if not id then continue end

			if data.pos then ply:ManipulateBonePosition(id, Vector()) end
			if data.ang then ply:ManipulateBoneAngles(id, Angle()) end
		end
	end
end

-- using this instead of octolib.player.state because PlayerInChat is called very often
local playersWithPhoneAnim = {}

hook.Add('EntityRemoved', 'dbgPhone.animations', function(ply, fullUpdate)
	if fullUpdate then return end
	playersWithPhoneAnim[ply] = nil
end)

netstream.Hook('dbgPhone.callAnimation', function(ply, state, stationaryCall)
	playersWithPhoneAnim[ply] = state or nil

	if not state then
		dbgPhone.removeDummy(ply)
	elseif not stationaryCall then
		local dummy = dbgPhone.createDummy(ply)
		if IsValid(dummy) then
			dummy.PhoneCall = true
			dummy:SetSkin(1)
		end
	end
end)

hook.Add('PlayerInChat', 'dbg-phone.PlayerInChat', function(ply)
	if playersWithPhoneAnim[ply] then
		return true
	end
end)
