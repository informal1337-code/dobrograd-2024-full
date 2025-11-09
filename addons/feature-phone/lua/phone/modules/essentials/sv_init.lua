util.AddNetworkString("dbg-phone.cr")

local function canUsePhone(ply)
    if not IsValid(ply) then return false end
    if ply:IsGhost() then return false end

    if ply.inv and ply:FindItem({class = 'phone', on = true}) then
        return true
    end

    local trace = ply:GetEyeTrace()
    if IsValid(trace.Entity) and trace.Entity:GetClass() == 'ent_dbg_phone' and not trace.Entity.off then
        return true
    end
    
    return false
end

net.Receive("dbg-phone.cr", function(len, ply)
    if not canUsePhone(ply) then return end
    
    if (ply.nextEMSRequest or 0) > CurTime() then 
        ply:Notify("Подождите перед следующим вызовом!")
        return 
    end
    
    local message = net.ReadString()
    local name = ply:Nick()
    
    DarkRP.callEMS(ply, name, tostring(message))
    
    ply.nextEMSRequest = CurTime() + 60
end)