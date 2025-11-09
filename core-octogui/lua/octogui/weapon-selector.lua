local c = "scroll_bar/scroll.ogg"
local h = "scroll_bar/select.ogg"
local d = ""
local s = 3
local a = 6
local l = GetConVar("cl_drawhud")
local e = {cardWidth = 150, cardHeight = 30, cardMargin = 5}
local r = false
local i = 0
local o = 1
local n = 1
local t = {}
for e = 1, a do
    t[e] = {}
end
local function u()
    for e = 1, a do
        t[e] = {}
    end
    for n, e in ipairs(LocalPlayer():GetWeapons()) do
        table.insert(
            t[e:GetSlot() + 1],
            {
                entity = e,
                class = e:GetClass(),
                name = octolib.string.truncate(language.GetPhrase(e:GetPrintName()), 17),
                hoverAnimation = 0
            }
        )
    end
    for n, e in ipairs(t) do
        table.sort(
            e,
            function(t, n)
                local e = t.entity:GetSlotPos()
                local o = n.entity:GetSlotPos()
                if e ~= o then
                    return e < o
                end
                return t.entity:GetPrintName() < n.entity:GetPrintName()
            end
        )
    end
end
local function g()
    if not l:GetBool() then
        return true
    end
    local e = LocalPlayer()
    if not e:IsValid() or not e:Alive() then
        return true
    end
    if e:InVehicle() and (not e:GetAllowWeaponsInVehicle() or e:GetVehicle():GetThirdPersonMode()) then
        return true
    end
    if #e:GetWeapons() <= 0 then
        return true
    end
    return false
end
local function f()
    local e = LocalPlayer():GetActiveWeapon()
    local n = IsValid(e) and e:GetClass()
    if not n then
        return 1, 1
    end
    local e = e:GetSlot() + 1
    local t, n =
        octolib.array.find(
        t[e],
        function(e)
            return e.class == n
        end
    )
    return e, n or 1
end
local function l(e)
    if e and g() then
        return
    end
    if e then
        timer.Create(
            "dbgWeaponSelector.autoClose",
            s,
            1,
            function()
                if not r then
                    return
                end
                l(false)
                LocalPlayer():EmitSound(d, nil, nil, .15)
            end
        )
    else
        timer.Remove("dbgWeaponSelector.autoClose")
    end
    if r == e then
        return
    end
    if e then
        u()
        o, n = f()
    else
        r = false
    end
    r = e
end
local function s(n)
    local e = octolib.math.loop(o + n, 1, a + 1)
    while #t[e] == 0 do
        e = octolib.math.loop(e + n, 1, a + 1)
    end
    return e
end
local function u(e)
    if not r then
        return
    end
    n = n + e
    if n > #t[o] then
        o = s(e)
        n = 1
    elseif n < 1 then
        o = s(e)
        n = #t[o]
    end
    LocalPlayer():EmitSound(c, nil, math.random(95, 105), .15)
end
local function s(e)
    if not r then
        return
    end
    if e ~= o then
        o = e
        n = 1
    else
        n = n + 1
    end
    if not t[o] or #t[o] <= 0 then
        l(false)
        return
    end
    if n > #t[o] then
        n = 1
    end
    LocalPlayer():EmitSound(c, nil, math.random(95, 105), .15)
end
local l = {
    ["invprev"] = function(e)
        if e:KeyDown(IN_ATTACK) or e:KeyDown(IN_ATTACK2) then
            return
        end
        l(true)
        u(-1)
        return true
    end,
    ["invnext"] = function(e)
        if e:KeyDown(IN_ATTACK) or e:KeyDown(IN_ATTACK2) then
            return
        end
        l(true)
        u(1)
        return true
    end,
    ["slot"] = function(n, n, e)
        l(true)
        s(e)
        return true
    end,
    ["lastinv"] = function(e)
        local e = e:GetPreviousWeapon()
        if e:IsWeapon() then
            input.SelectWeapon(e)
        end
        return true
    end,
    ["cancelselect"] = function(e)
        l(false)
        e:EmitSound(d, nil, nil, .15)
        return true
    end,
    ["+attack"] = function(a)
        if not r then
            return
        end
        local e = t[o]
        if not e then
            return
        end
        local e = e[n]
        if not e or not IsValid(e.entity) then
            return
        end
        input.SelectWeapon(e.entity)
        e.isSelected = true
        a:EmitSound(h, nil, nil, .15)
        l(false)
        return true
    end,
    ["+attack2"] = function(e)
        if not r then
            return
        end
        l(false)
        e:EmitSound(d, nil, nil, .15)
        return true
    end
}
hook.Add(
    "PlayerBindPress",
    "dbgWeaponSelector",
    function(n, e, t)
        if not t or not n:Alive() or n:InVehicle() and not n:GetAllowWeaponsInVehicle() or vgui.CursorVisible() then
            return
        end
        e = string.lower(e)
        if string.sub(e, 1, 4) == "slot" then
            local e = tonumber(string.sub(e, 5))
            return l["slot"](n, t, e)
        else
            local e = l[e]
            return e and e(n, t) or nil
        end
    end,
    8
)
surface.CreateFont("dbgWeaponSelector.slot", {font = "Roboto Bold", extended = true, size = 18, weight = 300})
surface.CreateFont("dbgWeaponSelector.weapon", {font = "Roboto Regular", extended = true, size = 18, weight = 300})
local c, d
local function l()
    c = 30
    d = (ScrW() - (e.cardWidth + e.cardMargin) * a - e.cardMargin) / 2
end
l()
hook.Add("OnScreenSizeChanged", "dbgWeaponSelector", l)
local function u(o, t, n, r)
    n.hoverAnimation = math.Approach(n.hoverAnimation, r and 1 or 0, FrameTime() * (r and 8 or 4))
    if n.hoverAnimation > 0 then
        octolib.render.drawShadow(
            16,
            o - 6,
            t - 6,
            e.cardWidth + 12,
            e.cardHeight + 12,
            ColorAlpha(CFG.skinColors.g, n.hoverAnimation * 255)
        )
    end
    if r then
        draw.RoundedBox(4, o, t, e.cardWidth, e.cardHeight, CFG.skinColors.g)
        if not n.isSelected then
            draw.RoundedBox(4, o + 1, t + 1, e.cardWidth - 2, e.cardHeight - 2, CFG.skinColors.bg60)
        end
    else
        draw.RoundedBox(4, o, t, e.cardWidth, e.cardHeight, CFG.skinColors.bg)
        draw.RoundedBox(4, o + 1, t + 1, e.cardWidth - 2, e.cardHeight - 2, CFG.skinColors.bg_d)
    end
    draw.SimpleText(
        n.name,
        "dbgWeaponSelector.weapon",
        o + e.cardWidth / 2,
        t + e.cardHeight / 2,
        color_white,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end
hook.Add(
    "PostDrawHUD",
    "dbgWeaponSelector",
    function()
        i = math.Approach(i, r and 1 or 0, FrameTime() * (r and 8 or 4))
        if i <= 0 then
            return
        end
        local r = octolib.tween.easing.outQuad(i, 0, 1, 1)
        local i = math.ceil((1 - r) * -30)
        surface.SetAlphaMultiplier(r)
        for r, l in ipairs(t) do
            local a = d + (e.cardWidth + e.cardMargin) * (r - 1)
            if #l > 0 then
                for t = #l, 1, -1 do
                    local l = l[t]
                    local e = c + (e.cardHeight + e.cardMargin) * (t - 1) + i
                    u(a, e, l, r == o and n == t)
                end
                local n = a + e.cardWidth / 2
                local e = 12
                draw.RoundedBox(4, n - 14, -8, 28, e + 21, CFG.skinColors.bg)
                draw.RoundedBox(4, n - 13, -8, 26, e + 20, CFG.skinColors.bg_d)
                draw.SimpleText(r, "dbgWeaponSelector.slot", n, e, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        surface.SetAlphaMultiplier(1)
    end
)
hook.Add(
    "HUDShouldDraw",
    "dbgWeaponSelector",
    function(e)
        if e == "CHudWeaponSelection" then
            return false
        end
    end
)