util.AddNetworkString("dbgPhone.receiveSMS")
util.AddNetworkString("dbg-phone.typingSMS")
util.AddNetworkString("dbg-phone.updateTypeStatus")

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

local function sendSMS(sender, recipientName, message)
    if not canUsePhone(sender) then return false end
    
    local recipient
    for _, v in ipairs(player.GetAll()) do
        if v:Name() == recipientName then
            recipient = v
            break
        end
    end
    
    if not IsValid(recipient) then
        sender:Notify("Абонент не найден!")
        return false
    end
    
    if not canUsePhone(recipient) then
        sender:Notify("Абонент недоступен!")
        return false
    end
    
    local recipientBlacklist = recipient:GetPData("dbgPhone_blacklist", "[]")
    recipientBlacklist = util.JSONToTable(recipientBlacklist) or {}
    
    for _, steamid in ipairs(recipientBlacklist) do
        if steamid == sender:SteamID() then
            sender:Notify("Абонент заблокировал ваши сообщения!")
            return false
        end
    end
    
    net.Start("dbgPhone.receiveSMS")
    net.WriteString(sender:Name())
    net.WriteString(message)
    net.Send(recipient)
    
    local phone = recipient.inv and recipient:FindItem({class = 'phone', on = true})
    if phone then
        if phone:GetData('notification') then
            recipient:EmitSound('phone/phone_notification.wav', 38)
        end
        if phone:GetData('vibration') then
            recipient:EmitSound('phone/phone_vibration.wav', 25)
        end
    end
    
    print(string.format("[SMS] %s -> %s: %s", sender:Name(), recipient:Name(), message))
    
    return true
end

net.Receive("dbg-phone.typingSMS", function(len, ply)
    if not canUsePhone(ply) then return end
    ply:SetNetVar("UsingPhone", true)
end)

net.Receive("dbg-phone.updateTypeStatus", function(len, ply)
    if not canUsePhone(ply) then return end
    ply:SetNetVar("UsingPhone", net.ReadBool())
end)

hook.Add("PlayerSay", "dbgPhone.smsCommand", function(ply, text)
    local args = string.Explode(" ", text)
    
    if args[1]:lower() == "/sms" and #args >= 3 then
        if not canUsePhone(ply) then
            ply:Notify("У вас нет телефона!")
            return ""
        end
        
        local targetName = string.sub(args[2], 2, -2)
        local message = table.concat(args, " ", 3)
        
        if sendSMS(ply, targetName, message) then
            ply:Notify("SMS отправлено!")
        end
        
        return ""
    end
end)