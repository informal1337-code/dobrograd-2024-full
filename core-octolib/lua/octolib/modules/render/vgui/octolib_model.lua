-- "addons\\core-octolib\\lua\\octolib\\modules\\render\\vgui\\octolib_model.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local defaultRenderSettings = {
	camFov = 10,
	camFovMod = 0.50,
	camAng = Angle(0, -180, 0),
	camPos = Vector(0.0, 0.0, -0.1),
}

local matLoading = Material('icon16/hourglass.png')

--
-- ITEM
--

local PANEL = {}

function PANEL:Init()
	self:SetSize(96, 96)
end

function PANEL:Rebuild()
	octolib.renderModel.clear(self.renderData, self.renderSettings)
end

function PANEL:Setup(model, destination, renderSettings)
	destination = destination or {}
	self.renderData = table.Merge({
		model = model,
		width = destination.width or self:GetWide(),
		height = destination.height or self:GetTall(),
	}, destination)
	self.renderSettings = renderSettings
end

function PANEL:Paint(w, h)
	if not self.renderData then return end
	if not self.renderData.image then
		surface.SetMaterial(matLoading)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect((w - 16) / 2, (h - 16) / 2, 16, 16)

		self.modelAlpha = 0
		return octolib.renderModel.queueRender(self.renderData, self.renderSettings or defaultRenderSettings)
	end

	self.modelAlpha = math.Approach(self.modelAlpha, 1, RealFrameTime() * 2)

	local iw, ih = self.renderData.width, self.renderData.height
	local x, y = (w - iw) / 2, (h - ih) / 2
	surface.SetMaterial(self.renderData.image)
	surface.SetDrawColor(255,255,255, self.modelAlpha * 255)
	surface.DrawTexturedRect(x, y, iw, ih)
end

vgui.Register('octolib_model', PANEL, 'DPanel')
