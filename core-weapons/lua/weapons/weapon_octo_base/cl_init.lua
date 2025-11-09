include 'shared.lua'

SWEP.PrintName = "Octothorp Weapon"
SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false

SWEP.VisualRecoilState = Vector()
SWEP.TriggerFingerAnimation = 0
SWEP.SmoothAimAng = nil

CreateClientConVar('octoweapons_sight_resolution', 512, true)
local sightMaterials = {}
local maskPoly, sightResolution, sightRT, sightMaterial
local sightOverlayMaterial = Material('octoteam/overlays/scope1')

local function updateSettings()
	sightResolution = GetConVar('octoweapons_sight_resolution'):GetInt()
	sightRT = GetRenderTarget('weaponSight-' .. sightResolution, sightResolution, sightResolution)
	if not sightMaterials[sightResolution] then
		sightMaterials[sightResolution] = CreateMaterial('weaponSight-' .. sightResolution, 'UnlitGeneric', {})
	end
	sightMaterial = sightMaterials[sightResolution]
	maskPoly = {}

	local x, y, r, seg = 0, 0, sightResolution / 2 - 1, 24
	maskPoly[#maskPoly + 1] = {x = x, y = y, u = 0.5, v = 0.5}
	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		maskPoly[#maskPoly + 1] = {x = x + math.sin(a) * r, y = y + math.cos(a) * r, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5}
	end
end
updateSettings()
cvars.AddChangeCallback('octoweapons_sight_resolution', updateSettings, 'octoweapons')

local isRenderingScope = false
local function renderScope(wep)
	isRenderingScope = true
	local pos, dir, ang = wep:GetShootPosAndDir()
	render.PushRenderTarget(sightRT)
	if util.TraceLine({
		start = pos - dir * 15,
		endpos = pos + dir * ((wep.SightZNear or 5) + 2),
		filter = LocalPlayer(),
	}).Hit then
		render.Clear(0,0,0, 255)
	else
		render.RenderView({
			origin = pos,
			angles = ang,
			fov = wep.SightFOV,
			znear = wep.SightZNear,
		})
	end
	render.PopRenderTarget()
	isRenderingScope = false
end

function SWEP:SetReady(b)

	if not self:GetNetVar('CanSetReady') then return end
	if b and not self.Owner:IsOnGround() then return end

	self.DrawCrosshair = b

end

function SWEP:Think()

	if self:GetNetVar('NoReadyInput') then return end
	if self.Owner:KeyDown(IN_ATTACK2) and not self:GetNetVar('IsReady') then
		self:SetReady(true)
	elseif not self.Owner:KeyDown(IN_ATTACK2) and self:GetNetVar('IsReady') then
		self:SetReady(false)
	end

end

--[[function SWEP:CalcView(a, i, o, l)
    self:UpdateVisualRecoil(a)
    self:UpdateTriggerFinger(a)
    if not self.__RANDOMIZE_AimPos__ then return end
    local e = dbgView.useSights and self:GetHoldType() == self.ActiveHoldType and self:GetNetVar("IsReady")
    local n = math.Approach(self.aimProgress or 0, e and 1 or 0, FrameTime() * (e and 1 or 3))
    self.aimProgress = n
    if n <= 0 then return end
    local t = a:LookupAttachment("anim_attachment_rh")
    if not t then return end
    if e then
        n = math.Clamp(n - 0.4, 0, 1) / 0.6
    end
    local e = dbgView.calcView(a, i, o, l)
    local a = a:GetAttachment(t)
    local t = Angle(self.VisualRecoilState.y, self.VisualRecoilState.x, 0)
    local t, a = LocalToWorld(self.__RANDOMIZE_AimPos__, self.__RANDOMIZE_AimAng__, a.Pos, a.Ang + t)
    local n = octolib.tween.easing.inOutQuad(n, 0, 1, 1)
    e.origin = LerpVector(n, e.origin, t)
    e.angles = LerpAngle(n, e.angles, a) + dbgView.lookOff
    e.znear = 0.5
    e.angles.r = 0
    return e
end]]

function SWEP:CalcView(a, i, o, l)
    self:UpdateVisualRecoil(a)
    self:UpdateTriggerFinger(a)
    if not self.__RANDOMIZE_AimPos__ then return end
    local e = dbgView.useSights and self:GetHoldType() == self.ActiveHoldType and self:GetNetVar("IsReady")
    local n = math.Approach(self.aimProgress or 0, e and 1 or 0, FrameTime() * (e and 1 or 3))
    self.aimProgress = n
    if n <= 0 then return end
    local t = a:LookupAttachment("anim_attachment_rh")
    if not t then return end
	if e then n = math.Clamp(n - .4, 0, 1) / .6 end
    local e = dbgView.calcView(a, i, o, l)
    local a = a:GetAttachment(t)
    local t = Angle(self.VisualRecoilState.y, self.VisualRecoilState.x, 0)
    local t, a = LocalToWorld(self.__RANDOMIZE_AimPos__, self.__RANDOMIZE_AimAng__, a.Pos, a.Ang + t)
    local n = octolib.tween.easing.inOutQuad(n, 0, 1, 1)
    e.origin = LerpVector(n, e.origin, t)
    e.angles = LerpAngle(n, e.angles, a) + dbgView.lookOff
    e.znear = 0.5
    e.angles.r = 0
    return e
end

function SWEP:DrawWorldModel()

	self:DrawModel()

	if self.SightPos and self.aimProgress and self.aimProgress > 0 then
		local ply = self:GetOwner()
		local attID = ply:LookupAttachment('anim_attachment_rh')
		if not attID then return end

		local att = ply:GetAttachment(attID)
		local sightPos, sightAng = LocalToWorld(self.SightPos, self.SightAng, att.Pos, att.Ang)

		local minusHalfRes = sightResolution / -2
		cam.Start3D2D(sightPos, sightAng, self.SightSize / sightResolution)
			cam.IgnoreZ(true)
			render.ClearStencil()
			render.SetStencilEnable(true)
			render.SetStencilTestMask(255)
			render.SetStencilWriteMask(255)
			render.SetStencilReferenceValue(42)

			-- draw mask
			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			surface.SetDrawColor(0,0,0, 1)
			draw.NoTexture()
			surface.DrawPoly(maskPoly)

			-- draw view
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_ZERO)
			render.SetStencilZFailOperation(STENCIL_ZERO)
			sightMaterial:SetTexture('$basetexture', sightRT)
			sightMaterial:SetFloat('$alpha', math.Clamp(math.Remap(self.aimProgress, 0.6, 1, 0, 1), 0, 1))
			surface.SetMaterial(sightMaterial)
			surface.DrawTexturedRect(minusHalfRes, minusHalfRes, sightResolution, sightResolution)
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(sightOverlayMaterial)
			surface.DrawTexturedRect(minusHalfRes, minusHalfRes, sightResolution, sightResolution)

			render.SetStencilEnable(false)
			cam.IgnoreZ(false)
		cam.End3D2D()
	end

	-- local pos, dir = self:GetShootPosAndDir()
	-- render.DrawLine(pos, pos + dir * 20, color_white, true)
	-- render.DrawWireframeSphere(pos, 1, 5, 5, color_white, true)

end

function SWEP:UpdateVisualRecoil(e)
	local e = self:GetOwner()
    local n = self.VisualRecoilState:Length2D()
    if n == 0 then return end
    local n = FrameTime() * self.VisualRecoilRecoverRate * math.max(n * 2, 0.1)
    self.VisualRecoilState = octolib.math.lerpVector(self.VisualRecoilState, vector_origin, 1, nil, n)
    if self.VisualRecoilState:Length2D() < 0.01 then
        self.VisualRecoilState:SetUnpacked(0, 0, 0)
    end
    --e:ManipulateBonePosition(e:LookupBone("ValveBiped.Bip01_R_Clavicle"), Vector(0, math.min(self.VisualRecoilState.y, 8) * -0.25, 0), false)
    e:ManipulateBoneAngles(e:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(self.VisualRecoilState.y, self.VisualRecoilState.x, 0), false)
end

-- Обновление анимации пальца
function SWEP:UpdateTriggerFinger(e)
	local e = self:GetOwner()
    if self.TriggerFingerAnimation == 0 then return end
    self.TriggerFingerAnimation = math.Approach(self.TriggerFingerAnimation, 0, FrameTime() / 0.2)
    local n = octolib.tween.easing.outQuad(self.TriggerFingerAnimation, 0, 1, 1)
    e:ManipulateBoneAngles(e:LookupBone("ValveBiped.Bip01_R_Finger11"), Angle(0, n * -40, 0), false)
end

function SWEP:ResetBones()
    local e = self:GetOwner()
    if not IsValid(e) then return end
    e:ManipulateBonePosition(e:LookupBone("ValveBiped.Bip01_R_Clavicle"), vector_origin)
    e:ManipulateBoneAngles(e:LookupBone("ValveBiped.Bip01_R_Hand"), angle_zero)
    e:ManipulateBoneAngles(e:LookupBone("ValveBiped.Bip01_R_Finger11"), angle_zero)
end

function SWEP:ShootEffects()
    --self.VisualRecoilState.x = self.VisualRecoilState.x + self.VisualRecoilHorizontal * math.Rand(-1, 1)
    --self.VisualRecoilState.y = self.VisualRecoilState.y + self.VisualRecoilVertical * math.Rand(0.8, 1.2)
    self.TriggerFingerAnimation = 1
    local e = EffectData()
    e:SetEntity(self)
    e:SetAttachment(self:LookupAttachment("muzzle"))
    e:SetScale(0.1)
    e:SetFlags(self.MuzzleflashFlag or 3)
    util.Effect("MuzzleFlash", e)
end

function SWEP:Reload()

	-- keep calm and do nothing

end

net.Receive('octoweapons.sound', function(len, ply)
	local amount = net.ReadUInt(5)
	local pos = net.ReadVector()
	for _ = 1, amount do
		sound.Play(net.ReadString(), pos)
	end
end)

hook.Add('CreateMove', 'octoweapons', function(cmd)
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep:GetNetVar('IsReady') and bit.band(cmd:GetButtons(), IN_JUMP) > 0 then
		cmd:SetButtons(cmd:GetButtons() - IN_JUMP)
	end
end)

hook.Add('HUDPaint', 'dbg-scare', function()
	local ply = LocalPlayer()
	local scare = ply:GetNetVar('ScareState', 0)
	if scare > 0 then
		draw.RoundedBox(0, -1, -1, ScrW()+2, ScrH()+2, Color(0,0,0, 180 * scare))
	end
end)

hook.Add('PreDrawEffects', 'octoweapons', function()
	if isRenderingScope then return end

	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep.SightPos and wep.aimProgress > 0 then
		renderScope(wep)
	end
end)

hook.Add('dbg-view.chTraceOverride', 'octoweapons', function()
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid(wep) or not wep.IsOctoWeapon then return end

	local pos, dir = wep:GetShootPosAndDir()
	return util.TraceLine({
		start = pos,
		endpos = pos + dir * 2000,
		filter = function(ent)
			return ent ~= ply and ent:GetRenderMode() ~= RENDERMODE_TRANSALPHA
		end
	})
end)

hook.Add('__RANDOMIZE_crosshair-should-draw__', 'octoweapons', function(tr)
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep.__RANDOMIZE_AimPos__ then
		return false
	end
end)

hook.Add('RenderScene', 'octoweapons', function(pos, ang, fov)
	local view = dbgView.calcWeaponView(LocalPlayer(), pos, ang, fov)
	if not view then return end

	render.Clear(0, 0, 0, 255, true, true, true)
	render.RenderView({
		x				= 0,
		y				= 0,
		w				= ScrW(),
		h				= ScrH(),
		angles			= view.angles,
		origin			= view.origin,
		drawhud			= true,
		drawviewmodel	= false,
		dopostprocess	= true,
		drawmonitors	= true,
	})

	return true
end)

local function requestBend(doBend)
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid(wep) or not wep.CanBend or not wep:GetNetVar('IsReady') then return end

	net.Start('octoweapons.bend')
		net.WriteBool(doBend)
	net.SendToServer()
end

local k_bend = 0
timer.Simple(0, function() k_bend = GetConVar('cl_dbg_key_bend'):GetInt() end)
cvars.AddChangeCallback('cl_dbg_key_bend', function(cv, old, new) k_bend = tonumber(new) end, 'octoweapons')

hook.Add('PlayerButtonDown', 'octoweapons', function(ply, key)
	if key == k_bend then requestBend(true) end
end)

hook.Add('PlayerButtonUp', 'octoweapons', function(ply, key)
	if key == k_bend then requestBend(nil) end
end)

local disableBindsWhileAiming = octolib.array.toKeys({ '+menu_context' })
hook.Add('PlayerBindPress', 'octoweapons', function(ply, bind, pressed)
	if not pressed or not disableBindsWhileAiming[bind] then return end
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or not wep.CanBend or not wep:GetNetVar('IsReady') then return end

	return true
end)

net.Receive('octoweapons.bend', function()
	local ply, fraction = net.ReadEntity(), net.ReadInt(8)

	local wep = ply:GetActiveWeapon()
	local targetAngles = octolib.table.map(IsValid(wep) and (wep.BendAngles[wep:GetHoldType()] or wep.BendAngles._default) or {}, function(ang)
		return ang * fraction
	end)
	octolib.manipulateBones(ply, targetAngles, 0.3)
end)

