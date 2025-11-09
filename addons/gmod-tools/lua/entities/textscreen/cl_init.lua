include('shared.lua')

function ENT:Initialize()
    self:UpdateLines(self:GetNetVar('lines'))
end

function ENT:UpdateLines(lines)
    if not lines then return end

    -- ensure height is a number even if precacheLines returns nil
    local height = dbgTextScreen.precacheLines(lines) or 0
    self.yOffset = -height / 2
end

hook.Add('octolib.netVarUpdate', 'dbgTextScreen', function(index, key, value)
    if key ~= 'lines' then return end

    local ent = Entity(index)
    if not IsValid(ent) or ent:GetClass() ~= 'textscreen' then return end

    ent:UpdateLines(value)
end)

local function drawTextScreen(lines, y)
    render.PushFilterMin(TEXFILTER.ANISOTROPIC)
    -- Use pcall to ensure PopFilterMin is called even on error
    local ok, err = pcall(function()
        dbgTextScreen.drawLines(lines, 0, y)
    end)
    render.PopFilterMin()
    if not ok then
        error(err)
    end
end

local tDist, tDistFade = 2000 * 2000, 500 * 500

function ENT:Draw()
    local textAlpha = math.Clamp(1 - (self:GetPos():DistToSqr(EyePos()) - tDistFade) / tDist, 0, 1)
    if textAlpha <= 0 then return end

    local pos, ang = self:GetPos(), self:GetAngles()

    local lines = self:GetNetVar('lines')
    if not lines then return end

    cam.Start3D2D(pos, ang, 0.25)
        surface.SetAlphaMultiplier(textAlpha)
        drawTextScreen(lines, self.yOffset or 0) -- сэйфгуард.
        surface.SetAlphaMultiplier(1)
    cam.End3D2D()
end

-- fixed by zeta collcective