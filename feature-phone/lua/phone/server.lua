util.AddNetworkString("dbgPhone.requestBlacklist")
util.AddNetworkString("dbgPhone.callingTo")
util.AddNetworkString("dbgPhone.incomingCall")
util.AddNetworkString("dbgPhone.callStarted")
util.AddNetworkString("dbgPhone.endCall")
util.AddNetworkString("dbgPhone.acceptCall")
util.AddNetworkString("dbgPhone.makeCall")
util.AddNetworkString("dbgPhone.callAnimation")

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

net.Receive("dbgPhone.requestBlacklist", function(len, ply)
    if not canUsePhone(ply) then
        ply:Notify("У вас нет телефона!")
        return
    end
    
    local action = net.ReadString()
    
    if action == "add" then
        local players = {}
        for _, v in ipairs(player.GetAll()) do
            if v ~= ply then
                table.insert(players, {name = v:Name(), steamid = v:SteamID()})
            end
        end

        net.Start("dbgPhone.openBlacklistMenu")
        net.WriteTable(players)
        net.WriteString("add")
        net.Send(ply)
        
    elseif action == "remove" then
        local blacklist = ply:GetPData("dbgPhone_blacklist", "[]")
        blacklist = util.JSONToTable(blacklist) or {}
        
        net.Start("dbgPhone.openBlacklistMenu")
        net.WriteTable(blacklist)
        net.WriteString("remove")
        net.Send(ply)
    end
end)

local activeCalls = {}

local function startCall(caller, target)
    if not IsValid(caller) or not IsValid(target) then return false end
    
    local callerBlacklist = caller:GetPData("dbgPhone_blacklist", "[]")
    callerBlacklist = util.JSONToTable(callerBlacklist) or {}
    
    for _, steamid in ipairs(callerBlacklist) do
        if steamid == target:SteamID() then
            caller:Notify("Этот номер в черном списке!")
            return false
        end
    end
    
    if not caller:canAfford(dbgPhone.callPrice) then
        caller:Notify("Недостаточно средств на счету!")
        return false
    end
    
    if activeCalls[target] then
        net.Start("dbgPhone.endCall")
        net.WriteString("busy")
        net.Send(caller)
        return false
    end
    
    activeCalls[caller] = {
        target = target,
        startTime = CurTime(),
        status = "calling"
    }
    
    activeCalls[target] = {
        target = caller,
        startTime = CurTime(),
        status = "incoming"
    }
    
    net.Start("dbgPhone.callingTo")
    net.WriteString(target:Name())
    net.Send(caller)
    
    net.Start("dbgPhone.incomingCall")
    net.WriteString(caller:Name())
    net.Send(target)
    
    net.Start("dbgPhone.callAnimation")
    net.WriteEntity(caller)
    net.WriteBool(true)
    net.WriteBool(false) -- stationaryCall
    net.SendPVS(caller:GetPos())
    
    net.Start("dbgPhone.callAnimation")
    net.WriteEntity(target)
    net.WriteBool(true)
    net.WriteBool(false)
    net.SendPVS(target:GetPos())
    
    timer.Create("dbgPhone.callTimeout_" .. caller:SteamID(), dbgPhone.timeout, 1, function()
        if activeCalls[caller] then
            endCall(caller, "timeout")
        end
    end)
    
    return true
end

local function acceptCall(ply)
    if not activeCalls[ply] or activeCalls[ply].status ~= "incoming" then return end
    
    local caller = activeCalls[ply].target
    if not IsValid(caller) then return end
    
    activeCalls[caller].status = "active"
    activeCalls[caller].startTime = CurTime()
    
    activeCalls[ply].status = "active"
    activeCalls[ply].startTime = CurTime()
    
    net.Start("dbgPhone.callStarted")
    net.WriteString(ply:Name())
    net.Send(caller)
    
    net.Start("dbgPhone.callStarted")
    net.WriteString(caller:Name())
    net.Send(ply)
    
    caller:addMoney(-dbgPhone.callPrice)
    
    timer.Remove("dbgPhone.callTimeout_" .. caller:SteamID())
end

local function endCall(ply, reason)
    if not activeCalls[ply] then return end
    
    local otherParty = activeCalls[ply].target
    
    if IsValid(otherParty) then
        net.Start("dbgPhone.endCall")
        net.WriteString(reason or "normal")
        net.Send(otherParty)
        
        net.Start("dbgPhone.callAnimation")
        net.WriteEntity(otherParty)
        net.WriteBool(false)
        net.WriteBool(false)
        net.SendPVS(otherParty:GetPos())
    end
    
    net.Start("dbgPhone.endCall")
    net.WriteString(reason or "normal")
    net.Send(ply)
    
    net.Start("dbgPhone.callAnimation")
    net.WriteEntity(ply)
    net.WriteBool(false)
    net.WriteBool(false)
    net.SendPVS(ply:GetPos())
    
    if IsValid(otherParty) then
        activeCalls[otherParty] = nil
    end
    activeCalls[ply] = nil
    
    timer.Remove("dbgPhone.callTimeout_" .. ply:SteamID())
end

net.Receive("dbgPhone.makeCall", function(len, ply)
    if not canUsePhone(ply) then
        ply:Notify("У вас нет телефона!")
        return
    end
    
    local targetSteamID = net.ReadString()
    local target
    
    for _, v in ipairs(player.GetAll()) do
        if v:SteamID() == targetSteamID then
            target = v
            break
        end
    end
    
    if not IsValid(target) then
        ply:Notify("Абонент недоступен!")
        return
    end
    
    if target == ply then
        ply:Notify("Нельзя позвонить самому себе!")
        return
    end
    
    startCall(ply, target)
end)

net.Receive("dbgPhone.acceptCall", function(len, ply)
    if not canUsePhone(ply) then return end
    acceptCall(ply)
end)

net.Receive("dbgPhone.endCall", function(len, ply)
    endCall(ply, "normal")
end)

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

hook.Add("PlayerSay", "dbgPhone.chatCommands", function(ply, text)
    local args = string.Explode(" ", text)
    local command = args[1]:lower()
    
    if command == "/call" and #args >= 2 then
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
        
    elseif command == "/sms" and #args >= 3 then
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

hook.Add("PlayerDisconnected", "dbgPhone.disconnect", function(ply)
    if activeCalls[ply] then
        endCall(ply, "disconnect")
    end
end)

hook.Add("PlayerDeath", "dbgPhone.death", function(ply)
    if activeCalls[ply] then
        endCall(ply, "death")
    end
end)

function dbgPhone.getActiveCall(ply)
    return activeCalls[ply]
end

function dbgPhone.getAllActiveCalls()
    return activeCalls
end
