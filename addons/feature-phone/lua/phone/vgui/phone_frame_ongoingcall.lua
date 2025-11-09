-- "addons\\feature-phone\\lua\\phone\\vgui\\phone_frame_ongoingcall.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

function PANEL:Init()
	self:SetTall(88)
	self:CenterVertical(0.25)
	self:SetTitle('')

	self:AddButton(L.end_call, function()
		netstream.Start('dbgPhone.endCall')
		self:Remove()
	end)

	local progress = self:Add('phone_callProgress')
	progress:Dock(TOP)
	progress:DockMargin(2, -20, 2, 0)
	progress:SetTall(6)
	progress:SetTime(60)
	self.progress = progress

	local lbl = self:Add('DLabel')
	lbl:SetPos(8, 32)
	lbl:SetWide(290)
	lbl:SetMultiline(true)
	lbl:SetAutoStretchVertical(true)
	lbl:SetWrap(true)
	self.lbl = lbl

	local lbl2 = self:Add('phone_callStatus')
	lbl2:SetPos(10, 34)
	lbl2:SetSize(290, 28)
	lbl2:Hide()
	self.lbl2 = lbl2
end

function PANEL:SetCallStarted(val)
	if val then
		self:SetTitle(L.call)

		self.progress:Hide()
		self.lbl:Hide()

		local lbl2 = self.lbl2
		lbl2:Show()
		lbl2:CallStarted()
	else
		self:SetTitle('')

		local progress = self.progress
		progress:SetTime(60)
		progress:Show()

		self.lbl:Show()
		self.lbl2:Hide()
	end
end

function PANEL:SetTarget(val)
	local lbl = self.lbl
	lbl:SetText(L.calling .. val)
	lbl:InvalidateLayout(true)

	self.lbl2:SetTarget(val)
end

vgui.Register('phone_frame_ongoingCall', PANEL, 'phone_frame')
