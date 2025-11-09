-- "addons\\core-weapons\\lua\\dbg-weapons\\cl_binds.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function t(n)
    local e = LocalPlayer():GetActiveWeapon()
    if not IsValid(e) or not e.CanBend or not e:GetNetVar("IsReady") then
        return
    end
    net.Start("octoweapons.bend")
    net.WriteBool(n)
    net.SendToServer()
end
local e, n = 0, 0
timer.Simple(
    0,
    function()
        e = GetConVar("cl_dbg_key_bend"):GetInt()
        n = GetConVar("cl_dbg_key_firemode"):GetInt()
    end
)
cvars.AddChangeCallback( "cl_dbg_key_firemode", function(t, t, e) n = tonumber(e) end, "octoweapons" )
cvars.AddChangeCallback( "cl_dbg_key_bend", function(t, t, n) e = tonumber(n) end, "octoweapons" )
hook.Add( "PlayerButtonDown", "octoweapons", function(d, o)
    if not IsFirstTimePredicted() then return end
    if o == e then
        t(true)
    end
    if o == n then
        netstream.Start("octoweapons-changeFiremode")
    end
end)
hook.Add( "PlayerButtonUp", "octoweapons", function(o, n)
    if not IsFirstTimePredicted() then return end
    if n == e then
        t(nil)
    end
end)
