-- "addons\\core-characters\\lua\\dbg-characters\\ghosts\\cl_ghosts.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
surface.CreateFont('dbg-chars.timer', {
	size = 64,
	weight = 800,
	antialias = true,
	shadow = false,
	font = 'Default',
})

surface.CreateFont('dbg-chars.progress', {
	font = 'Calibri',
	extended = true,
	size = 26,
	weight = 500,
})

local function getRagdoll(ply)
	local body = ply:GetRagdollEntity()
	if not body or not IsValid(body) then
		body = ply:GetParent()
	end

	if not body or not IsValid(body) or body:IsVehicle() then
		return
	end

	return body
end

hook.Add('HUDShouldDraw', 'dbg-characters.ghosts', function(name)
	if name ~= 'CHudCrosshair' then return end

	local ply = LocalPlayer()
	local body = getRagdoll(ply)
	if not body then
		return
	end

	if ply:GetNetVar('Ragdolled') then
		return false
	end
end)

-- add first person death
hook.Add('CalcView', 'dbg-characters.ghosts', function(ply)
	local body = getRagdoll(ply)
	if not body then
		return
	end

	local head = body:LookupBone('ValveBiped.Bip01_Head1')
	if ply:GetNetVar('Ragdolled') then
		-- make head disappear
		body:ManipulateBoneScale(head, Vector(0, 0, 0))

		local eyes = body:GetAttachment(body:LookupAttachment('eyes'))
		local view = {
			origin = eyes.Pos - eyes.Ang:Forward() * 6,
			angles = eyes.Ang,
			fov = 90
		}

		return view
	else
		-- restore head after spawn
		body:ManipulateBoneScale(head, Vector(1, 1, 1))
	end
end, -10)

local curState, lastState = 0, 0
hook.Add('PostDrawHUD', 'dbg-characters.ghosts', function()
	if isHoldingCamera then return end

	local ply, ct, ft = LocalPlayer(), CurTime(), FrameTime()
	local imDead = ply:IsGhost()
	local spTime = ply:GetLocalVar('_SpawnTime', 0)
	local nearDeath = ply:GetNetVar('nearDeath')

	if not imDead and not nearDeath then
		local tgtState
		if ply:Alive() then
			tgtState = 1 - math.Clamp((ply:Health() or 0) / ply:GetMaxHealth(), 0, 1)
		else
			tgtState = 1
		end

		local delta = (tgtState - curState) * (ft < 1 and ft or 1)
		if math.abs(delta) < .01 then
			delta = delta > 0 and .01 or -.01
		end
		if tgtState - curState < .01 then
			delta = tgtState - curState
		end
		curState = curState + delta

		if curState ~= 0 then
			local deathColors = {
				['$pp_colour_addr'] = 0,
				['$pp_colour_addg'] = 0,
				['$pp_colour_addb'] = 0,
				['$pp_colour_brightness'] = 0,
				['$pp_colour_contrast'] = 1 - curState * 0.7,
				['$pp_colour_colour'] = 1 - curState,
				['$pp_colour_mulr'] = 0,
				['$pp_colour_mulg'] = 0,
				['$pp_colour_mulb'] = 0
			}
			DrawColorModify(deathColors)

			if curState > 0.5 then
				local _prc = (curState - 0.5) / 0.5
				DrawBloom(0.1, (_prc^3) * 1, 6, 6, 1, 0.25, 1, 1, 1)
			end
		end

		if curState ~= lastState then
			local dsp = 1
			if curState > 0.8 then
				dsp = 16
			elseif curState > 0.65 then
				dsp = 15
			elseif curState > 0.5 then
				dsp = 14
			end
			ply:SetDSP(dsp)
		end

		if ply:Alive() then
			local fadeout = math.Clamp((ct - spTime) / dbgChars.ghosts.config.fadeInSpawn, 0, 1)
			local al = 255 * (1 - fadeout^3)
			if al > 0 then
				draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, Color(255, 255, 255, al))
			end
		end
	elseif ply:GetNetVar('launcherActivated') and not ply:GetLocalVar('dbgChars.selecting') then
		local deathColors = {
			['$pp_colour_addr'] = 0,
			['$pp_colour_addg'] = 0,
			['$pp_colour_addb'] = 0.1,
			['$pp_colour_brightness'] = 0,
			['$pp_colour_contrast'] = 0.95,
			['$pp_colour_colour'] = 0.25,
			['$pp_colour_mulr'] = 0,
			['$pp_colour_mulg'] = 0,
			['$pp_colour_mulb'] = 0
		}
		DrawColorModify(deathColors)

		if curState ~= lastState then
			ply:SetDSP(1)
		end

		if not nearDeath then
			local ghTime = ply:GetLocalVar('_TimeToGhost')

			local fadein = math.Clamp((ct - ghTime - 1) / dbgChars.ghosts.config.fadeInGhost, 0, 1)
			local al = 255 * (1 - fadein^3)
			if al > 0 then
				draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, Color(0, 0, 0, al))
			end
		end
	end

	lastState = curState
end)

function player.GetGhosts()
	local tbl = {}
	for _, v in ipairs(player.GetAll()) do
		if v:IsGhost() then tbl[#tbl + 1] = v end
	end
	return tbl
end

hook.Add('PlayerFinishedLoading', 'dbg-characters.ghosts', function()
	octolib.func.loop(function(done)
		local lp = LocalPlayer()
		local imDead = lp:IsGhost()

		octolib.func.throttle(player.GetAll(), 10, 0.05, function(ply)
			if not IsValid(ply) then return end

			local dead = ply:IsGhost()
			if imDead then
				ply:SetColor(Color(255,255,255, 30))
			else
				if dead and not lp:getJobTable().seesGhosts then
					ply:SetColor(Color(255,255,255, 0))
				else
					ply:SetColor(Color(255,255,255, 30))
				end
			end
		end, done)
	end)
end)
