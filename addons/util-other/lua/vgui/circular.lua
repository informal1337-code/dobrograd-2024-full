local circleMat = Material('octoteam/shapes/circle-empty-128.png')

local PANEL = {}

function PANEL:Init()
	self:SetAnimationTime(0.5)
	self:SetStartAngle(0)
	self:SetBackgroundColor(Color(0,0,0))
	self:SetColor(Color(255, 255, 255))

	self.anim = {
		progress = 0,
	}
end

function PANEL:Paint(w, h)
	local cx, cy = w / 2, h / 2

	surface.SetDrawColor(self.bgColor)
	surface.SetMaterial(circleMat)
	surface.DrawTexturedRect(cx - 64, cy - 64, 128, 128)

	octolib.render.drawRadialSegment(cx, cy, 64, self.startAngle, self.anim.progress, function()
		surface.SetDrawColor(self.color)
		surface.SetMaterial(circleMat)
		surface.DrawTexturedRect(cx - 64, cy - 64, 128, 128)
	end)
end

function PANEL:SetAnimationTime(time)
	self.animationTime = time
end

function PANEL:SetStartAngle(angle)
	self.startAngle = 45 + angle
end

function PANEL:SetBackgroundColor(color)
	self.bgColor = color
end

function PANEL:SetColor(color)
	self.color = color
end

function PANEL:SetProgress(progress, skipAnimation)
	progress = math.Clamp(progress, 0, 1)

	if skipAnimation then
		self.anim.progress = progress
		return
	end

	if self.progressTween then
		self.progressTween:remove()
	end

	self.progressTween = octolib.tween.create(self.animationTime, self.anim, {
		progress = progress
	}, 'outQuad')
end

derma.DefineControl('CircularProgress', '', PANEL, 'DPanel')
