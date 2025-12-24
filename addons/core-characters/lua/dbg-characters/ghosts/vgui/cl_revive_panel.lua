-- "addons\\core-characters\\lua\\dbg-characters\\ghosts\\vgui\\cl_revive_panel.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

function PANEL:Init()
	self:SetSize(300, 30)

	local button = vgui.Create('DButton', self)
	button:SetSize(100, 30)
	button:Center()
	button:SetTextColor(Color(150, 150, 150))
	button:SetEnabled(false)
	button:SetText('Сдаться')
	timer.Simple(dbgChars.ghosts.config.giveUpTime, function()
		if not IsValid(button) then
			return
		end

		button:SetEnabled(true)
		button:SetTextColor(Color(255, 255, 255))
		button.DoClick = function()
			netstream.Start('dbgChars.giveUp')
		end
	end)

	local progress = vgui.Create('DPanel', self)
	progress:Dock(FILL)
	progress.Paint = function(self, w, h)
		local reviveTime = 1 - (LocalPlayer():GetLocalVar('reviveTime') - CurTime()) / dbgChars.ghosts.config.reviveTime
		draw.RoundedBox(8, 0, 0, w, h, CFG.skinColors.g_d)
		draw.RoundedBox(8, 3, 3, math.min((w - 6) * reviveTime, w - 6), h - 6, CFG.skinColors.g)
		draw.SimpleText('Тебя поднимают...', 'dbg-chars.progress', w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.progress = progress
	self.button = button
end

function PANEL:ShowButton()
	self.progress:SetVisible(false)
	self.button:SetVisible(true)
end

function PANEL:ShowProgress()
	self.button:SetVisible(false)
	self.progress:SetVisible(true)
end

vgui.Register('dbg_chars_revivePanel', PANEL, 'EditablePanel')