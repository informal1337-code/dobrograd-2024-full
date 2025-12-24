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

netstream.Hook('dbgPhone.requestBlacklist', function(ply, action)
    if not canUsePhone(ply) then
        ply:Notify("У вас нет телефона!")
        return
    end

    if action == "add" then
        local players = {}
        for _, v in ipairs(player.GetAll()) do
            if v ~= ply then
                table.insert(players, {name = v:Name(), steamid = v:SteamID()})
            end
        end

        netstream.Start(ply, 'dbgPhone.openBlacklistMenu', players, "add")

    elseif action == "remove" then
        local blacklist = ply:GetPData("dbgPhone_blacklist", "[]")
        blacklist = util.JSONToTable(blacklist) or {}

        netstream.Start(ply, 'dbgPhone.openBlacklistMenu', blacklist, "remove")
    end
end)

netstream.Hook('dbgPhone.updateBlacklist', function(ply, action, steamid)
    if not canUsePhone(ply) then return end

    local blacklist = ply:GetPData("dbgPhone_blacklist", "[]")
    blacklist = util.JSONToTable(blacklist) or {}

    if action == "add" then
        local exists = false
        for _, v in ipairs(blacklist) do
            if v == steamid then
                exists = true
                break
            end
        end

        if not exists then
            table.insert(blacklist, steamid)
            ply:SetPData("dbgPhone_blacklist", util.TableToJSON(blacklist))
            ply:Notify("Номер добавлен в черный список")
        end

    elseif action == "remove" then
        for i, v in ipairs(blacklist) do
            if v == steamid then
                table.remove(blacklist, i)
                ply:SetPData("dbgPhone_blacklist", util.TableToJSON(blacklist))
                ply:Notify("Номер удален из черного списка")
                break
            end
        end
    end
end)
