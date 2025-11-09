-- "addons\\core-weapons\\lua\\dbg-weapons\\cl_hooks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add('PlayerSwitchWeapon', 'dbg.weaponGroups', function()
	return true
end)

hook.Add('PlayerFinishedLoading', 'dbg.weapons', function()
	weapons.GetStored('gmod_tool').ShootSound = ''
end)

timer.Simple(0, function()
	function GAMEMODE:AdjustMouseSensitivity()
		local ply = LocalPlayer()
		if not IsValid(ply) then
			return -1
		end

		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep.AdjustMouseSensitivity then
			return wep:AdjustMouseSensitivity()
		end

		return -1
	end
end)

local disableBindsWhileAiming = octolib.array.toKeys({'+menu_context'})
hook.Add('PlayerBindPress', 'octoweapons', function(ply, bind, pressed)
	if not pressed then return end

	local disableCallback = disableBindsWhileAiming[bind]
	if not disableCallback then return end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or not wep.CanBend or not wep:GetNetVar('IsReady') then return end

	if isfunction(disableCallback) then
		disableCallback(ply, wep)
	end

	return true
end)

local nextZoom = 0
local function changeZoom(ply, wep, val)
	if not wep.SightPos then return end

	local zoom = math.Clamp(wep.currentZoomLevel + val, 1, #wep.SightZoomLevels)
	if zoom == wep.currentZoomLevel then return end

	local curTime = CurTime()
	if nextZoom > curTime then return end

	nextZoom = curTime + 0.1

	wep.currentZoomLevel = zoom
	ply:EmitSound('weapons/zoom.wav', 50)
end

disableBindsWhileAiming['invprev'] = function(ply, wep)
	changeZoom(ply, wep, 1)
end

disableBindsWhileAiming['invnext'] = function(ply, wep)
	changeZoom(ply, wep, -1)
end

hook.Add('CreateMove', 'octoweapons', function(cmd)
	local ply = LocalPlayer()

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or not wep:GetNetVar('IsReady') then return end

	if bit.band(cmd:GetButtons(), IN_JUMP) > 0 then
		cmd:SetButtons(cmd:GetButtons() - IN_JUMP)
	end
end)

hook.Add('YoEloZrYzBUpAMAvpDOaaSHOIlGnOtjmhoXWNPvNQPCRcDM', 'octoweapons', function(tr)
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep.YNNMJhGLIMVUyUuAwyXDvgWxRJaxGuNf then
		return false
	end
end)

hook.Add('dbg-view.chTraceOverride', 'octoweapons', function()
	local ply = LocalPlayer()

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or not wep.IsOctoWeapon then return end

	local pos, dir = wep:yNvkGiYfgUsfpjgTlrsiMJGJOldGgooeCkPISooz()
	return util.TraceLine({
		start = pos,
		endpos = pos + dir * 2000,
		filter = function(ent)
			return ent ~= ply and ent:GetRenderMode() ~= RENDERMODE_TRANSALPHA
		end
	})
end)

hook.Add('octolib.netVarUpdate', 'octoweapons', function(id, key, value)
	if key ~= 'bodygroups' or not istable(value) then return end

	local ent = Entity(id or 0)
	if not IsValid(ent) or not ent:IsWeapon() then return end

	local csEnt = ent.csEnt
	if not IsValid(csEnt) then return end

	for bgID, _ in ipairs(csEnt:GetBodyGroups()) do
		csEnt:SetBodygroup(bgID, value[csEnt:GetBodygroupName(bgID)] or 0)
	end
end)