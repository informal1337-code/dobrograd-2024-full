concommand.Add("inf_copypos", function(ply)
    local pos = ply:GetPos()
    local ang = ply:GetAngles()

    local code = string.format("{ Vector(%.2f, %.2f, %.2f), Angle(%.2f, %.2f, %.2f) },", 
        pos.x, pos.y, pos.z, ang.p, ang.y, ang.r)

    ply:ChatPrint("poscopied: " .. code)

    if SetClipboardText then
        SetClipboardText(code)
        ply:ChatPrint("text copied in bufer epta")
    end
end)