util.AddNetworkString("dbgPhone.requestBlacklist")
util.AddNetworkString("dbgPhone.openBlacklistMenu")
util.AddNetworkString("dbgPhone.updateBlacklist")

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

net.Receive("dbgPhone.updateBlacklist", function(len, ply)
    if not canUsePhone(ply) then return end
    
    local action = net.ReadString()
    local steamid = net.ReadString()
    
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