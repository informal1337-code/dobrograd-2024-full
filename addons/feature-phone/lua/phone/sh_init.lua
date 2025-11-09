dbgPhone = dbgPhone or {}

local meta = FindMetaTable('Player')

function meta:IsUsingPhone()
    return self:GetNetVar('UsingPhone', false)
end

if SERVER then
    util.AddNetworkString("dbgPhone.setUsingPhone")
    
    function meta:SetUsingPhone(state)
        self:SetNetVar("UsingPhone", state)
    end
end