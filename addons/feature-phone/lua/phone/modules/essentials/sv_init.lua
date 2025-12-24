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

netstream.Hook('dbg-phone.cr', function(ply, message)
    if not canUsePhone(ply) then return end

    if (ply.nextEMSRequest or 0) > CurTime() then
        ply:Notify("Подождите перед следующим вызовом!")
        return
    end

    local name = ply:Nick()

    DarkRP.callEMS(ply, name, tostring(message))

    ply.nextEMSRequest = CurTime() + 60
end)
