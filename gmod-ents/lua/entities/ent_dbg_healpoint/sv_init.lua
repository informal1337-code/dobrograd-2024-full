include("init.lua")

-- Триггер лечения
function ENT:Touch(ent)
    if not ent:IsPlayer() then return end
    if ent.healing then return end -- Уже лечится

    ent.healing = true
    ent.healProgress = 0
    net.Start("huy1111")
    net.Send(ent)

    timer.Create("heal_player_" .. ent:SteamID64(), 0.5, 0, function()
        if not IsValid(ent) or not ent:InVehicle(self) then
            ent.healing = false
            timer.Remove("heal_player_" .. ent:SteamID64())
            return
        end

        local hp = ent:Health()
        if hp < 100 then
            ent:SetHealth(hp + 1)
        else
            ent.healing = false
            timer.Remove("heal_player_" .. ent:SteamID64())
        end
    end)
end

function ENT:EndTouch(ent)
    if not ent:IsPlayer() then return end
    ent.healing = false
    timer.Remove("heal_player_" .. ent:SteamID64())
end

-- Сообщение в чат
util.AddNetworkString("huy1111")
net.Receive("huy1111", function(len, ply)
    ply:ChatPrint("[#] Ты начал лечиться")
end)