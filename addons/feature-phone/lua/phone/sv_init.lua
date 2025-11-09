util.AddNetworkString("dbg-phone.open")

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

net.Receive("dbg-phone.open", function(len, ply)
    if not canUsePhone(ply) then
        ply:Notify("У вас нет телефона!")
        return
    end
    
    net.Start("dbg-phone.open")
    net.WriteBool(net.ReadBool())
    net.Send(ply)
end)

hook.Add("PlayerSay", "dbgPhone.callCommand", function(ply, text)
    local args = string.Explode(" ", text)
    
    if args[1]:lower() == "/call" and #args >= 2 then
        if not canUsePhone(ply) then
            ply:Notify("У вас нет телефона!")
            return ""
        end
        
        local targetName = table.concat(args, " ", 2)
        local target
        
        for _, v in ipairs(player.GetAll()) do
            if string.find(v:Name():lower(), targetName:lower(), 1, true) then
                target = v
                break
            end
        end
        
        if not IsValid(target) then
            ply:Notify("Абонент не найден!")
            return ""
        end
        
        if startCall(ply, target) then
            ply:Notify("Звонок начат...")
        end
        
        return ""
    end
end)