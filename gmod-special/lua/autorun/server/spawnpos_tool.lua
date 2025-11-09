do return end
concommand.Add("str_getpos", function(ply, cmd, args)

    if not ply:IsUserGroup("founder") then
        ply:ChatPrint("[Ошибка] Только основатель сервера может использовать эту команду!")
        return
    end


    local pos = ply:GetPos()
    local ang = ply:EyeAngles()


    local output = string.format(
        "{ pos = Vector(%.2f, %.2f, %.2f), ang = Angle(%.2f, %.2f, %.2f) },",
        pos.x, pos.y, pos.z,
        ang.p, ang.y, ang.r
    )


    ply:ChatPrint("Позиция скопирована в консоль сервера!")
    print("[str_getpos] Новая точка спавна от пользователя " .. ply:Nick())
    print("Добавьте эту строку в таблицу SpawnPoints:")
    print("-------------------------------------")
    print(output)
    print("-------------------------------------")
end)
