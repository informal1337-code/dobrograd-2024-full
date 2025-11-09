octolib.render = octolib.render or {}

octolib.drawDebug = false

surface.CreateFont('3d.medium', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
})

timer.Create('octolib.drawDebug', 2, 0, function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	octolib.drawDebug = hook.Run('octolib.shouldDrawDebug') or false
end)

local colors = CFG.skinColors
function render.DrawBubble(ent, pos, ang, text, maxDist, fadeDist)
	if IsValid(ent) then
		pos, ang = LocalToWorld(pos, ang, ent:GetPos(), ent:GetAngles())
	end

	local al = math.Clamp(1 - (pos:DistToSqr(EyePos()) - fadeDist * fadeDist) / (maxDist * maxDist), 0, 1) * 255
	if al <= 0 then return end

	cam.Start3D2D(pos, ang, 0.1)
		surface.SetFont('3d.medium')
		local w, h = surface.GetTextSize(text)
		draw.RoundedBox(8, -w/2 - 10, -h/2 - 3, w + 20, h + 6, ColorAlpha(colors.bg50, al))

		draw.SimpleText(text, '3d.medium', 0, 0, Color(238,238,238, al), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function octolib.render.drawMasked(drawFunc, maskFunc, invert)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilReferenceValue(1)

	render.SetStencilFailOperation(STENCIL_REPLACE)
	render.SetStencilPassOperation(STENCIL_ZERO)
	render.SetStencilZFailOperation(STENCIL_ZERO)
	render.SetStencilCompareFunction(STENCIL_NEVER)

	maskFunc()

	render.SetStencilFailOperation(STENCIL_ZERO)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilZFailOperation(STENCIL_ZERO)
	render.SetStencilCompareFunction(invert and STENCIL_NOTEQUAL or STENCIL_EQUAL)

	drawFunc()

	render.SetStencilEnable(false)
end

local function xIntersection(x, y, target)
	return y / x * target
end

local function yIntersection(x, y, target)
	return x / y * target
end

function octolib.render.radialToSquare(r, progress)
	progress = progress % 1

	local rad = math.pi * 2 * (5 / 8 + progress)
	local sin = math.sin(rad)
	local cos = math.cos(rad)

	if progress < 0.25 then
		return yIntersection(cos, sin, -r), -r
	elseif progress < 0.5 then
		return r, xIntersection(cos, sin, r)
	elseif progress < 0.75 then
		return yIntersection(cos, sin, r), r
	else
		return -r, xIntersection(cos, sin, -r)
	end
end

local function polyPoint(cx, cy, x, y)
	return {x = cx + x, y = cy + y}
end

-- works from 0 to 0.5 progress
local function drawSquareSegmentMask(x, y, r, startAngle, progress)
	startAngle = startAngle or 0

	local startProgress = startAngle / 360
	local endProgress = startProgress + progress
	local points = {
		polyPoint(x, y, octolib.render.radialToSquare(r, startProgress)),
	}

	local curProgress = math.floor(startProgress / 0.25) * 0.25 + 0.25
	while curProgress < endProgress do
		points[#points + 1] = polyPoint(x, y, octolib.render.radialToSquare(r, curProgress))
		curProgress = curProgress + 0.25
	end

	points[#points + 1] = polyPoint(x, y, octolib.render.radialToSquare(r, endProgress))
	points[#points + 1] = polyPoint(x, y, 0, 0)

	draw.NoTexture()
	surface.SetDrawColor(color_white)
	surface.DrawPoly(points)
end

function octolib.render.drawRadialSegment(x, y, r, startAngle, progress, drawFunc)
	if progress <= 0 then return end
	if progress >= 1 then
		drawFunc()
		return
	end

	octolib.render.drawMasked(drawFunc, function()
		if progress <= 0.5 then
			drawSquareSegmentMask(x, y, r, startAngle, progress)
		else
			drawSquareSegmentMask(x, y, r, startAngle + progress * 360, 1 - progress)
		end
	end, progress > 0.5)
end

local shadowFuncs = {
	[16] = GWEN.CreateTextureBorder(0, 0, 32, 32, 15, 15, 15, 15, Material('octoteam/shadows/16.png', 'noclamp smooth')),
	[32] = GWEN.CreateTextureBorder(0, 0, 64, 64, 31, 31, 31, 31, Material('octoteam/shadows/32.png', 'noclamp smooth')),
	[64] = GWEN.CreateTextureBorder(0, 0, 128, 128, 62, 62, 62, 62, Material('octoteam/shadows/64.png', 'noclamp smooth')),
	[128] = GWEN.CreateTextureBorder(0, 0, 256, 256, 126, 126, 126, 126, Material('octoteam/shadows/128.png', 'noclamp smooth')),
}

function octolib.render.drawShadow(radius, x, y, w, h, color)
	shadowFuncs[radius](x, y, w, h, color)
end

function octolib.render.computeCirclePoly(x, y, r, seg, uvScale)
	uvScale = uvScale or 1

	local poly = {}
	poly[#poly + 1] = {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5,
	}

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		local sin = math.sin(a)
		local cos = math.cos(a)
		poly[#poly + 1] = {
			x = x + sin * r,
			y = y + cos * r,
			u = sin / 2 / uvScale + 0.5,
			v = cos / 2 / uvScale + 0.5,
		}
	end

	return poly
end
