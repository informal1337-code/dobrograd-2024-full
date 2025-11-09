-- "addons\\core-weapons\\lua\\dbg-weapons\\cl_scope.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
CreateClientConVar('octoweapons_sight_resolution', 512, true)
local r = {}
local t, e, o, a
local c = Material('octoteam/overlays/scope1')
local function l()
    e = GetConVar('octoweapons_sight_resolution'):GetInt()
    o = GetRenderTarget('weaponSight-' .. e, e, e)
    if not r[e] then r[e] = CreateMaterial('weaponSight-' .. e, 'UnlitGeneric', {}) end
    a = r[e]
    t = {}
    local n, a, r, e = 0, 0, e / 2 - 1, 24
    t[#t + 1] = {
        x = n,
        y = a,
        u = .5,
        v = .5
    }

    for o = 0, e do
        local e = math.rad((o / e) * -360)
        t[#t + 1] = {
            x = n + math.sin(e) * r,
            y = a + math.cos(e) * r,
            u = math.sin(e) / 2 + .5,
            v = math.cos(e) / 2 + .5
        }
    end
end

l()
cvars.AddChangeCallback('octoweapons_sight_resolution', l, 'octoweapons')
local r = false
local function n(e)
    r = true
    local a, t, n = e:AlvWULRKzsZItVPGVsyffWssAoESvCpvolR()
    render.PushRenderTarget(o)
    if util.TraceLine({
        start = EyePos(),
        endpos = a + t * ((e.SightZNear or 5) + 7),
        filter = LocalPlayer(),
        mask = MASK_VISIBLE_AND_NPCS,
    }).Hit then
        render.Clear(0, 0, 0, 255)
    else
        local t = e.SightZoomLevels
        render.RenderView({
            origin = a,
            angles = n,
            fov = e.SightFOV / t[math.Clamp(e.currentZoomLevel, 1, #t)],
            znear = e.SightZNear,
        })
    end

    render.PopRenderTarget()
    r = false
end

hook.Add('RenderScene', 'octoweapons', function(e, t, r)
    local e = dbgView.calcWeaponView(LocalPlayer(), e, t, r)
    if not e then return end
    render.Clear(0, 0, 0, 255, true, true, true)
    render.RenderView({
        x = 0,
        y = 0,
        w = ScrW(),
        h = ScrH(),
        angles = e.angles,
        origin = e.origin,
        drawhud = true,
        drawviewmodel = false,
        dopostprocess = true,
        drawmonitors = true,
    })
    return true
end)

hook.Add('PreDrawEffects', 'octoweapons', function()
    if r then return end
    local e = LocalPlayer():GetActiveWeapon()
    if IsValid(e) and e.SightPos and e.aimProgress > 0 then n(e) end
end)

function dbgWeapons.renderScope(r)
    local l = r:GetOwner()
    local n = l:LookupAttachment('anim_attachment_rh')
    if not n then return end
    local n = l:GetAttachment(n)
    local i, l = LocalToWorld(r.SightPos, r.SightAng, n.Pos, n.Ang)
    local n = e / -2
    cam.Start3D2D(i, l, r.SightSize / e)
    cam.IgnoreZ(true)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilTestMask(255)
    render.SetStencilWriteMask(255)
    render.SetStencilReferenceValue(42)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    surface.SetDrawColor(0, 0, 0, 1)
    draw.NoTexture()
    surface.DrawPoly(t)
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_ZERO)
    render.SetStencilZFailOperation(STENCIL_ZERO)
    a:SetTexture('$basetexture', o)
    a:SetFloat('$alpha', math.Clamp(math.Remap(r.aimProgress, .6, 1, 0, 1), 0, 1))
    surface.SetMaterial(a)
    surface.DrawTexturedRect(n, n, e, e)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(c)
    surface.DrawTexturedRect(n, n, e, e)
    render.SetStencilEnable(false)
    cam.IgnoreZ(false)
    cam.End3D2D()
end

local i = Color(255, 50, 50)
local o = {}
hook.Add('dbgWeapons.preDrawWeapon', 'dbgWeapons.attachments.scope', function(n, t)
    local e = t:FindBodygroupByName('scope')
    if e == -1 then return end
    if t:GetBodygroup(e) ~= 1 then return end
    local e = EyePos()
    local c = -t:GetAngles().z
    local r, a = n:AlvWULRKzsZItVPGVsyffWssAoESvCpvolR()
    local l = r + a * 1e3
    local l = util.IntersectRayWithPlane(e, l - e, r, a)
    if not l then return end
    local r = n.ScopeReticleMaterial
    if not r then return end
    local e = o[r]
    if not e then
        e = Material(r)
        o[r] = e
    end

    local r = n.ScopeReticleSize
    local a = -a
    octolib.render.drawMasked(function()
        render.SetMaterial(e)
        render.DrawQuadEasy(l, a, r, r, i, c)
    end, function() t:DrawModel() end)
end)