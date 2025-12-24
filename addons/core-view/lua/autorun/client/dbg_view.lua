dbgView = dbgView or {}
dbgView.mods = dbgView.mods or {}
dbgView.useSights = true

dbgView.disabledWeps = {
	gmod_camera = true,
	gmod_tool = true,
	weapon_physgun = true,
	dbg_admingun = true,
	octo_camera = true,
}

function dbgView.hideHead(hide)
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local headBone = ply:LookupBone('ValveBiped.Bip01_Head1') or 6
	ply:ManipulateBoneScale(headBone, hide and Vector(0.01, 0.01, 0.01) or Vector(1, 1, 1))
	dbgView.headHidden = hide
end

netstream.Hook('dbgView.hideHead', dbgView.hideHead)

function dbgView.flyTo(targetPos, targetAng, duration)
	duration = duration or 1
	dbgView.startPos = dbgView.lastPos
	dbgView.startAng = dbgView.lastAng
	dbgView.tgtPos = targetPos
	dbgView.tgtAng = targetAng
	dbgView.flyStart = CurTime()
	dbgView.flyEnd = CurTime() + duration
	dbgView.animActive = targetPos ~= nil
end

function dbgView.calcView(ply, origin, angles, fov)
	local calcViewHook = hook.GetTable().CalcView['dbg-view']
	if calcViewHook and dbgView.active then
		local result = calcViewHook(ply, origin, angles, fov)
		if result then
			return result
		end
	end
	return { origin = origin, angles = angles, fov = fov }
end

function dbgView.calcWeaponView(ply, origin, angles, fov)
	local weapon = ply:GetActiveWeapon()
	if IsValid(weapon) and weapon.CalcView then
		local result = weapon:CalcView(ply, origin, angles, fov)
		if not result then
			return
		end
		dbgView.viewpos = result.origin
		return result
	end
end

function dbgView.fovMod(offset, duration)
	dbgView.startFov = dbgView.fov
	dbgView.tgtFov = (GetConVar('fov_desired'):GetFloat() or 90) + (offset or 0)
	dbgView.fovStart = CurTime()
	dbgView.fovEnd = CurTime() + duration
end

function dbgView.lookMod(active, position, angles, radius)
	dbgView.lookActive = tobool(active) or nil
	if not dbgView.lookActive then
		dbgView.lookPosition = nil
		dbgView.lookAngles = nil
		dbgView.lookRadius = nil
		return
	end
	angles:Normalize()
	dbgView.lookPosition = position
	dbgView.lookRadius = radius
	dbgView.lookAngles = angles
end

function dbgView.setFov(fov, duration)
	if fov ~= 0 then
		fov = fov - (GetConVar('fov_desired'):GetFloat() or 90)
	end
	dbgView.fovMod(fov, duration)
end

netstream.Hook('dbg-view.setFov', dbgView.setFov)

local plyMeta = FindMetaTable('Player')
local oldSetFOV = plyMeta.SetFOV
function plyMeta:SetFOV(fov, duration)
	if oldSetFOV then oldSetFOV(self, fov, duration) end
	dbgView.setFov(fov, duration or 0)
end

local ply = NULL
local dummy = NULL
local lastAngles = Angle()
local freeViewActive = false
local stuck = false
local crosshairPos = Vector(0, 0, 0)
local crosshairAng = Angle(0, 90, 90)
local crosshairMat = Material('octoteam/icons/percent0.png')
local sensitivity = GetConVar('sensitivity'):GetFloat()
local lastModel = ''
local lastVehicle = NULL
local hullMax = Vector(5, 5, 3)
local hullMin = Vector(-5, -5, -3)

local function traceFilter(ent)
	if ent == ply then
		return false
	end
	if ent:GetNoDraw() or ent:GetRenderMode() == RENDERMODE_TRANSALPHA then
		return false
	end
	if ent:GetClass() == 'prop_ragdoll' then
		return false
	end
	return true
end

local function crosshairTraceFilter(ent)
	if ent == ply then
		return false
	end
	if ent:GetNoDraw() or ent:GetRenderMode() == RENDERMODE_TRANSALPHA then
		return false
	end
	return true
end

local function createDummy()
	if IsValid(dummy) then dummy:Remove() end
	dummy = octolib.createDummy('models/props_junk/popcan01a.mdl')
	dummy:SetParent(ply, 1)
	dummy:SetLocalPos(Vector())
	dummy:SetLocalAngles(Angle())
	dummy:SetNoDraw(true)
	dummy:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
end

local function handleMouseInput(ply, x, y)
	if freeViewActive or dbgView.lookActive then
		if freeViewActive then
			dbgView.lookOff.p = math.Clamp(dbgView.lookOff.p + y * sensitivity / 200, -45, 45)
			dbgView.lookOff.y = math.Clamp(dbgView.lookOff.y - x * sensitivity / 200, -75, 75)
		end
		if dbgView.lookActive then
			dbgView.lookAngles = dbgView.lookAngles + Angle(y, -x, 0) * sensitivity / 200
			dbgView.lookAngles.pitch = math.Clamp(dbgView.lookAngles.pitch, -65, 90)
		end
		ply:SetMouseX(0)
		ply:SetMouseY(0)
		return true
	elseif dbgView.lookOff.p ~= 0 or dbgView.lookOff.y ~= 0 then
		dbgView.lookOff.p = math.Approach(dbgView.lookOff.p, 0, math.max(math.abs(dbgView.lookOff.p), 0.2) * FrameTime() * 10)
		dbgView.lookOff.y = math.Approach(dbgView.lookOff.y, 0, math.max(math.abs(dbgView.lookOff.y), 0.2) * FrameTime() * 10)
	end
end

local function checkStuck()
	stuck = false
	if ply:GetLocalVar('isStuck') then return end
	local vehicle = ply:GetVehicle()
	if ply:GetViewEntity() == ply and not IsValid(vehicle) and ply:GetMoveType() ~= MOVETYPE_NOCLIP then
		stuck = util.TraceHull({
			maxs = hullMax,
			mins = hullMin,
			start = dbgView.viewpos,
			endpos = dbgView.viewpos,
			filter = traceFilter
		}).Hit or util.TraceLine({
			start = ply:GetBonePosition(ply:LookupBone('ValveBiped.Bip01_Pelvis') or 0),
			endpos = dbgView.viewpos,
			filter = traceFilter
		}).Hit
	end
end

local function calcView(ply, origin, angles, fov)
	if ply:GetViewEntity() == ply and ply:Alive() and IsValid(dummy) then
		ply.viewAngs = Angle(angles.p, angles.y, angles.r)
		local model = ply:GetModel()
		if model ~= lastModel then
			for i = 0, ply:GetBoneCount() - 1 do
				ply:ManipulateBoneScale(i, Vector(1, 1, 1))
			end
			dbgView.hideHead(true)
			createDummy()
			lastModel = model
		end

		local vehicle = ply:GetVehicle()
		if vehicle ~= lastVehicle then
			createDummy()
			lastVehicle = vehicle
		end

		if not IsValid(dummy) or dummy:GetParent() ~= ply then
			createDummy()
		end

		local viewData = { fov = dbgView.fov, znear = 3 }
		if not ply:InVehicle() then
			ply:SetNetworkOrigin(origin - ply:GetCurrentViewOffset())
		end

		local pos = dummy:GetPos()
		angles = angles + dbgView.lookOff
		angles.p = math.Clamp(angles.p, -75, 75)
		viewData.angles = angles
		viewData.origin = pos
		dbgView.viewpos = viewData.origin

		if debugViewForwardDist then
			viewData.origin:Add(angles:Forward() * debugViewForwardDist)
		end

		dbgView.calcPos = viewData.origin
		dbgView.calcAng = viewData.angles

		if dbgView.flyStart then
			local frac = math.Clamp(math.TimeFraction(dbgView.flyStart, dbgView.flyEnd, CurTime()), 0, 1)
			local easeFrac = octolib.tween.easing.inOutQuad(frac, 0, 1, 1)
			if easeFrac > 0 then
				viewData.origin = LerpVector(easeFrac, dbgView.startPos, dbgView.tgtPos or dbgView.calcPos)
				viewData.angles = LerpAngle(easeFrac, dbgView.startAng, dbgView.tgtAng or dbgView.calcAng)
			elseif easeFrac == 1 and not dbgView.tgtPos then
				dbgView.flyStart = nil
			end
		end

		if dbgView.fovStart and dbgView.tgtFov then
			local frac = math.Clamp(math.TimeFraction(dbgView.fovStart, dbgView.fovEnd, CurTime()), 0, 1)
			local easeFrac = octolib.tween.easing.inOutQuad(frac, 0, 1, 1)
			if easeFrac > 0 then
				dbgView.fov = Lerp(easeFrac, dbgView.startFov, dbgView.tgtFov)
			elseif easeFrac == 1 then
				dbgView.fov = dbgView.tgtFov
				dbgView.fovStart = nil
			end
		end

		if dbgView.lookActive then
			local trace = util.TraceHull({
				start = dbgView.lookPosition,
				endpos = dbgView.lookPosition - dbgView.lookAngles:Forward() * dbgView.lookRadius,
				mins = Vector(-3, -3, -3),
				maxs = Vector(3, 3, 3),
				filter = ply,
			})
			viewData.origin = trace.HitPos
			viewData.angles = dbgView.lookAngles
		end

		dbgView.lastPos = viewData.origin
		dbgView.lastAng = viewData.angles
		return viewData
	else
		dbgView.viewpos = origin
	end
end

local function createMove(cmd)
	dbgView.realang = dbgView.realang + cmd:GetViewAngles() - lastAngles
	local vehicle = ply:GetVehicle()
	if IsValid(vehicle) then
		freeViewActive = false
		dbgView.realang.y = dbgView.realang.y - 90
		dbgView.realang:Normalize()
		dbgView.realang.y = math.Clamp(dbgView.realang.y, -110, 110)
		if vehicle:GetNetVar('saw') then
			dbgView.realang.p = math.Clamp(dbgView.realang.p, -75, 10 + 35 * (1 - (math.abs(dbgView.realang.y) / 135) ^ 2))
		else
			dbgView.realang.p = math.Clamp(dbgView.realang.p, -25, 20 * (1 - (math.abs(dbgView.realang.y) / 135) ^ 2))
		end
		local negativeY = dbgView.realang.y < 0
		dbgView.realang.y = dbgView.realang.y + 90
		dbgView.realang.r = (negativeY and -1 or 1) * (math.pow(dbgView.realang.y - 90, 2)) * (dbgView.realang.p - 0) / 28000
	else
		dbgView.realang.p = math.Clamp(dbgView.realang.p, -75, 75)
		dbgView.realang.r = 0
	end
	dbgView.realang:Normalize()
	cmd:SetViewAngles(dbgView.realang)
	lastAngles = cmd:GetViewAngles()
end

local function shouldDrawLocalPlayer()
	return true
end

local function hudShouldDraw(element)
	if element == 'CHudCrosshair' then return false end
end

local function postDrawEffects()
	if stuck then
		draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, color_black)
	end
end

local function drawCrosshair()
	local crosshairEnabled = hook.Run('MXOudYNkhQgYsTHCDGojCrdKMyNkiRhvpvpSUDCBTjaMCiO', ply)
	if crosshairEnabled == nil then
		local weapon, vehicle = ply:GetActiveWeapon(), ply:GetVehicle()
		if IsValid(weapon) and not dbgView.disabledWeps[weapon:GetClass()] and weapon.DrawCrosshair then
			crosshairEnabled = not IsValid(vehicle) or ply:GetAllowWeaponsInVehicle()
		end
	end
	if not crosshairEnabled then return end

	local forward = (ply.viewAngs or ply:EyeAngles()):Forward()
	local traceOverride = hook.Run('dbg-view.chTraceOverride')
	if not traceOverride then
		local shootPos = ply:GetShootPos()
		local traceEnd = shootPos + forward * 2000
		traceOverride = util.TraceLine({
			start = shootPos,
			endpos = traceEnd,
			filter = crosshairTraceFilter,
		})
	end

	local mat, alpha, scale, color = hook.Run('dbg-view.chOverride', traceOverride)
	local normal = traceOverride.Hit and traceOverride.HitNormal or -forward
	if math.abs(normal.z) > 0.98 then
		normal:Add(-forward * 0.01)
	end

	local pos, ang = LocalToWorld(crosshairPos, crosshairAng, traceOverride.HitPos or traceEnd, normal:Angle())
	cam.Start3D2D(pos, ang, math.pow(traceOverride.Fraction, 0.5) * (scale or 0.2))
	cam.IgnoreZ(true)
	if not hook.Run('dbg-view.chPaint', traceOverride, mat) then
		local crosshairColor = color or (not mat and octolib.vars.get('dbg-crosshair.color')) or color_white
		surface.SetDrawColor(crosshairColor.r, crosshairColor.g, crosshairColor.b, alpha or 150)
		surface.SetMaterial(mat or crosshairMat)
		surface.DrawTexturedRect(-32, -32, 64, 64)
	end
	cam.IgnoreZ(false)
	cam.End3D2D()
end

local freeViewKey = 0
local sightsKey = 0

cvars.AddChangeCallback('cl_dbg_key_freeview', function(var, old, new) freeViewKey = tonumber(new) end, 'dbg-view')
cvars.AddChangeCallback('cl_dbg_key_sights', function(var, old, new) sightsKey = tonumber(new) end, 'dbg-view')

local function playerButtonDown(ply, button)
	if not IsFirstTimePredicted() then return end
	if button == freeViewKey then
		freeViewActive = true
	end
	if button == sightsKey then
		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) and weapon:GetNetVar('IsReady') then
			dbgView.useSights = not dbgView.useSights
		end
	end
end

local function playerButtonUp(ply, button)
	if button == freeViewKey and IsFirstTimePredicted() then
		freeViewActive = false
	end
end

local function enableView()
	ply = LocalPlayer()
	dbgView.realang = ply:EyeAngles()
	dbgView.viewpos = ply:GetShootPos()
	dbgView.lookOff = Angle()
	dbgView.fov = GetConVar('fov_desired'):GetFloat() or 90
	lastAngles = dbgView.realang
	freeViewKey = GetConVar('cl_dbg_key_freeview'):GetInt()
	sightsKey = GetConVar('cl_dbg_key_sights'):GetInt()

	hook.Add('Think', 'dbg-view', checkStuck)
	hook.Add('CalcView', 'dbg-view.getRealView', function(ply, origin, angles, fov)
		dbgView.originalPos = origin
		dbgView.originalAng = angles
		dbgView.originalFov = fov
	end, -10)
	hook.Add('CalcView', 'dbg-view', calcView)
	hook.Add('CalcView', 'dbg-view.weapon', dbgView.calcWeaponView, -1)
	hook.Add('CreateMove', 'dbg-view', createMove)
	hook.Add('PostDrawEffects', 'dbg-view', postDrawEffects, -10)
	hook.Add('HUDShouldDraw', 'dbg-view', hudShouldDraw)
	hook.Add('InputMouseApply', 'dbg-view', handleMouseInput)
	hook.Add('PlayerButtonDown', 'dbg-view', playerButtonDown)
	hook.Add('PlayerButtonUp', 'dbg-view', playerButtonUp)
	hook.Add('PostDrawTranslucentRenderables', 'dbg-view', drawCrosshair, 1)
	hook.Add('ShouldDrawLocalPlayer', 'dbg-view', shouldDrawLocalPlayer)

	dbgView.hideHead(true)
	createDummy()
	timer.Create('dbg-view.validateAnchor', 10, 0, function()
		if not IsValid(dummy) or ply:GetPos():DistToSqr(dummy:GetPos()) > 10000 then
			createDummy()
		end
	end)

	dbgView.active = true
	hook.Run('dbg-view.setActive', dbgView.active)
end

local function disableView()
	hook.Remove('Think', 'dbg-view')
	hook.Remove('CalcView', 'dbg-view')
	hook.Remove('CalcView', 'dbg-view.weapon')
	hook.Remove('CreateMove', 'dbg-view')
	hook.Remove('PostDrawEffects', 'dbg-view')
	hook.Remove('HUDShouldDraw', 'dbg-view')
	hook.Remove('InputMouseApply', 'dbg-view')
	hook.Remove('PlayerButtonDown', 'dbg-view')
	hook.Remove('PlayerButtonUp', 'dbg-view')
	hook.Remove('PostDrawTranslucentRenderables', 'dbg-view')
	hook.Remove('ShouldDrawLocalPlayer', 'dbg-view')

	dbgView.hideHead(false)
	if IsValid(dummy) then dummy:Remove() end
	timer.Remove('dbg-view.validateAnchor')

	dbgView.active = false
	hook.Run('dbg-view.setActive', dbgView.active)
end

hook.Add('Think', 'dbg-view.override', function()
	local enabled = hook.Run('dbg-view.override') ~= false
	if not enabled and dbgView.active then
		disableView()
	elseif enabled and not dbgView.active then
		enableView()
	end
end)

netstream.Hook('dbg-quickLook', function()
	if not dbgView.active then
		octolib.notify.show('warning', 'Ты не можешь взглянуть на себя, когда держишь в руках физган, тулган или камеру')
		return
	end

	local ply = LocalPlayer()
	local offset = dbgView.lastAng:Forward() + dbgView.lastAng:Right() * 0.3
	offset.z = -0.2
	offset:Normalize()
	local targetPos = dbgView.lastPos + offset * 40

	local trace = util.TraceHull({
		start = dbgView.lastPos,
		endpos = targetPos,
		mins = Vector(-3, -3, -3),
		maxs = Vector(3, 3, 3),
		filter = ply,
	})
	if trace.Hit then
		targetPos = trace.HitPos
	end

	local headPos = ply:GetPos() + Vector(0, 0, 42)
	local targetAng = (headPos - targetPos):Angle()

	dbgView.flyTo(targetPos, targetAng, 1)
	timer.Simple(0.2, function()
		dbgView.hideHead(false)
		dbgChars.masks.setShowPlayerMasks(ply, true)
	end)

	local lookPos = targetPos + targetAng:Forward() * dbgView.lastPos:Distance(targetPos)
	timer.Simple(1, function()
		dbgView.lookMod(true, lookPos, targetAng, 40)
	end)

	local sphereData = { radius = 300, alpha = 0 }
	hook.Add('PostDrawTranslucentRenderables', 'dbg-view.quickLook', function()
		render.SetColorMaterial()
		render.CullMode(MATERIAL_CULLMODE_CW)
		render.DrawSphere(headPos, sphereData.radius, 20, 20, Color(30, 25, 30, sphereData.alpha))
		render.CullMode(MATERIAL_CULLMODE_CCW)
	end)
	hook.Add('Think', 'dbg-view.quickLook', function()
		local light = DynamicLight(8)
		light.pos = EyePos()
		light.r = 255
		light.g = 255
		light.b = 255
		light.brightness = 1
		light.Decay = 1000
		light.Size = 300 * (sphereData.alpha / 255)
		light.DieTime = CurTime() + 1
	end)

	octolib.tween.create(1, sphereData, { radius = 50, alpha = 500 }, 'inOutQuad')
	timer.Simple(3, function()
		dbgView.flyTo(nil, nil, 1)
		dbgView.lookMod(false)
		timer.Simple(0.7, function()
			dbgView.hideHead(true)
			dbgChars.masks.setShowPlayerMasks(ply, nil)
		end)
		octolib.tween.create(1, sphereData, { radius = 300, alpha = 0 }, 'inOutQuad', function()
			hook.Remove('PostDrawTranslucentRenderables', 'dbg-view.quickLook')
			hook.Remove('Think', 'dbg-view.quickLook')
		end)
	end)
end)

octolib.testHelper.addCategory('dbgView', {
	name = 'Вид от 1-го лица',
	icon = octolib.icons.silk16('eye'),
})
octolib.testHelper.addMethod('dbgView.setDist', {
	name = 'Сдвиг камеры',
	parent = 'dbgView',
	args = {{
		type = 'numSlider',
		txt = 'Расстояние',
		min = -500,
		max = 500,
		value = 0,
	}},
}, function(distance)
	debugViewForwardDist = distance ~= 0 and distance or nil
end)

hook.Add('dbg-view.override', 'dbg-view.disabledWeapons', function()
	local weapon = LocalPlayer():GetActiveWeapon()
	if IsValid(weapon) and dbgView.disabledWeps[weapon:GetClass()] then
		return false
	end
end)

local progressCenterX = 0
local progressCenterY = 0
local progressRadius = 40
local progressPoints = {}
local progressPolygons = {}

for i = 1, 36 do
	local angle1 = math.rad((i - 1) * -10 + 180)
	local angle2 = math.rad(i * -10 + 180)
	progressPoints[i] = {
		x = progressCenterX + math.sin(angle1) * progressRadius,
		y = progressCenterY + math.cos(angle1) * progressRadius
	}
	progressPolygons[i] = {{
		x = progressCenterX,
		y = progressCenterY
	}, {
		x = progressCenterX + math.sin(angle1) * progressRadius,
		y = progressCenterY + math.cos(angle1) * progressRadius
	}, {
		x = progressCenterX + math.sin(angle2) * progressRadius,
		y = progressCenterY + math.cos(angle2) * progressRadius
	}}
end

hook.Add('dbg-view.override', 'octolib.flyEditor', function()
	if octolib.flyEditor.active then return false end
end)

local hasDelayedActions = false
hook.Add('MXOudYNkhQgYsTHCDGojCrdKMyNkiRhvpvpSUDCBTjaMCiO', 'octolib.delayedActions', function()
	hasDelayedActions = table.Count(octolib.delayedActions.active) > 0
	if hasDelayedActions then return true end
end, -2)

hook.Add('dbg-view.chPaint', 'octolib.delayedActions', function(trace, mat)
	for actionID, actionData in pairs(octolib.delayedActions.active) do
		local progress = math.min(math.ceil((CurTime() - actionData.start) / actionData.time * 36), 36)
		local text = actionData.text .. ('.'):rep(math.floor(CurTime() * 2 % 4))
		draw.SimpleText(text, 'octolib.use-sh', 0 + 60, 0, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(text, 'octolib.use', 0 + 60, 0, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.NoTexture()
		surface.SetDrawColor(255, 255, 255, 50)
		surface.DrawPoly(progressPoints)
		surface.SetDrawColor(255, 255, 255, 150)
		for i = 1, progress do
			surface.DrawPoly(progressPolygons[i])
		end
		return true
	end
end)

hook.Add('dbg-view.chOverride', 'octolib.delayedActions', function(trace)
	local ply = LocalPlayer()
	if hasDelayedActions and (not trace.Hit or trace.Fraction > 0.03) then
		local forward = (ply.viewAngs or ply:EyeAngles()):Forward()
		trace.HitPos = ply:GetShootPos() + forward * 60
		trace.HitNormal = -forward
		trace.Fraction = 0.03
	end
end)

hook.Add('ContextMenuCreated', 'dbg-removePlayerEditor', function()
	list.Set('DesktopWindows', 'PlayerEditor', nil)
end)

hook.Add('PopulateMenuBar', 'hideMenuBar', function(menu)
	timer.Simple(0, function()
		if not IsValid(menu) then return end
		menu:Clear()
		menu:SetAlpha(0)
	end)
end)

hook.Add('ContextMenuShowTool', 'dbg-removeToolgunContextMenu', function()
	local weaponClass = LocalPlayer():GetActiveWeapon():GetClass()
	return weaponClass and (weaponClass == 'gmod_tool' or weaponClass == 'weapon_physgun')
end)
