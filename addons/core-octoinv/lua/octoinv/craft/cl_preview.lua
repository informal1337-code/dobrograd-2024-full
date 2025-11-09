local lastDir, lastAng, lastPos, woke

local activatePreviewPhysics = octolib.func.debounce(function()
	if not IsValid(octoinv.preview) then return end
	local physObj = octoinv.preview:GetPhysicsObject()
	if IsValid(physObj) then physObj:Wake() end
end, 0.3)

netstream.Hook('octoinv.craftPreview', function(mdl, rotate, distance)
	if IsValid(octoinv.preview) then octoinv.preview:Remove() end
	if mdl then
		octoinv.preview = ents.CreateClientProp(mdl)
		octoinv.preview:PhysicsInit(SOLID_VPHYSICS)
		octoinv.preview:SetMoveType(MOVETYPE_VPHYSICS)
		octoinv.preview:SetNotSolid(true)
		octoinv.preview:SetRenderMode(RENDERMODE_TRANSCOLOR)
		octoinv.preview:SetColor(Color(255, 255, 255, 180))
		octoinv.preview.rotate = rotate
		octoinv.preview.distance = distance or 0
		lastDir, lastAng, lastPos, woke = nil
	end
end)

hook.Add('Think', 'octoinv.craftPreview', function()

	if not IsValid(octoinv.preview) then return end
	local ply = LocalPlayer()
	local physObj = octoinv.preview:GetPhysicsObject()

	local dir = ply:GetAimVector()
	dir.z = 0
	dir:Normalize()

	local ang = ply:EyeAngles()
	ang.p = 0
	ang.r = 0
	ang.y = ang.y + 180 - (octoinv.preview.rotate or 0)

	local pos = ply:GetShootPos() + dir * (25 + octoinv.preview.distance)
	if lastDir == dir and lastAng == ang and lastPos == pos then
		if not woke then
			activatePreviewPhysics()
			woke = true
		end
		return
	end
	lastDir, lastAng, lastPos, woke = dir, ang, Vector(pos.x, pos.y, pos.z), false
	if IsValid(physObj) then physObj:Sleep() end
	octoinv.preview:SetPos(pos)
	octoinv.preview:SetAngles(ang)
	pos = octoinv.preview:NearestPoint(pos + dir * 512)
	octoinv.preview:SetPos(pos)

end)

local function spikesPreviewRemove()
	hook.Remove('HUDPaint', 'octoinv.spikesPreview')
	hook.Remove('PlayerButtonDown', 'octoinv.spikesPreview')

	if IsValid(octoinv.preview) then octoinv.preview:Remove() end
end

netstream.Hook('octoinv.spikesPreview', function()
	hook.Add('HUDPaint', 'octoinv.spikesPreview', function()
		draw.SimpleText('ЛКМ - Положить шипы', 'octolib.normal', ScrW() * 0.5, ScrH() - 80, color_white, TEXT_ALIGN_CENTER)
		draw.SimpleText('ПКМ - Отменить', 'octolib.normal', ScrW() * 0.5, ScrH() - 60, color_white, TEXT_ALIGN_CENTER)
	end)

	hook.Add('PlayerButtonDown', 'octoinv.spikesPreview', function(ply, pressed)
		if not IsFirstTimePredicted() then return end

		if pressed == MOUSE_LEFT then
			spikesPreviewRemove()
			netstream.Start('octoinv.spikesPlace', item)
		end

		if pressed == MOUSE_RIGHT then
			spikesPreviewRemove()
		end
	end)
end)