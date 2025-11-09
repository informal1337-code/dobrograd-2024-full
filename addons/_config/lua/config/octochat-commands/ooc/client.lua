-- client.lua

if not octochat then return end

netstream.Hook("octochat.ooc", function(ply, txt)
    if not IsValid(ply) or not txt or txt == "" then return end

    local nextOOC = ply:GetCooldown("ooc")
    if nextOOC and nextOOC > CurTime() then
        ply:Notify("warning", "Следующее сообщение в ООС-чат можно будет отправить через " .. niceTime(nextOOC - CurTime()))
        return
    end

    local can, why = hook.Run("PlayerCanOOC", ply, txt)
    if can == false then
        ply:Notify("warning", why or "Нельзя отправить это сообщение.")
        return
    end

    sendOOC(ply, txt)

    if not ply:query("DBG: Нет ограничения на OOC") then
        ply:TriggerCooldown("ooc", 1 * 60)
    end
end)