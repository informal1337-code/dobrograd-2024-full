local activeCalls = {}

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
        netstream.Start(caller, 'dbgPhone.endCall', "busy")
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

    netstream.Start(caller, 'dbgPhone.callingTo', target:Name())
    netstream.Start(target, 'dbgPhone.incomingCall', caller:Name())

    netstream.Start(nil, 'dbgPhone.callAnimation', caller, true, false)
    netstream.Start(nil, 'dbgPhone.callAnimation', target, true, false)

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

    netstream.Start(caller, 'dbgPhone.callStarted', ply:Name())
    netstream.Start(ply, 'dbgPhone.callStarted', caller:Name())

    caller:addMoney(-dbgPhone.callPrice)

    timer.Remove("dbgPhone.callTimeout_" .. caller:SteamID())
end

local function endCall(ply, reason)
    if not activeCalls[ply] then return end

    local otherParty = activeCalls[ply].target

    if IsValid(otherParty) then
        netstream.Start(otherParty, 'dbgPhone.endCall', reason or "normal")
        netstream.Start(nil, 'dbgPhone.callAnimation', otherParty, false, false)
    end

    netstream.Start(ply, 'dbgPhone.endCall', reason or "normal")
    netstream.Start(nil, 'dbgPhone.callAnimation', ply, false, false)

    if IsValid(otherParty) then
        activeCalls[otherParty] = nil
    end
    activeCalls[ply] = nil

    timer.Remove("dbgPhone.callTimeout_" .. ply:SteamID())
end

netstream.Hook('dbgPhone.makeCall', function(ply, targetSteamID)
    if not canUsePhone(ply) then
        ply:Notify("У вас нет телефона!")
        return
    end

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

netstream.Hook('dbgPhone.acceptCall', function(ply)
    if not canUsePhone(ply) then return end
    acceptCall(ply)
end)

netstream.Hook('dbgPhone.endCall', function(ply)
    endCall(ply, "normal")
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
