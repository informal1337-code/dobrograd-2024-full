-- "addons\\feature-phone\\lua\\phone\\vgui\\phone_callprogress.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

AccessorFunc(PANEL, 'createTime', 'StartTime', FORCE_NUMBER)

function PANEL:SetTime(time)
    self.time = time
    self:SetStartTime(CurTime())
end

function PANEL:GetTime()
    return self.time
end

function PANEL:Think()
    self:SetFraction((CurTime() - self:GetStartTime()) / self:GetTime())
end

vgui.Register('phone_callProgress', PANEL, 'DProgress')