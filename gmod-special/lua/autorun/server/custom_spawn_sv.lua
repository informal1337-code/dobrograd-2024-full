do return end
local SpawnPoints = {
    { pos = Vector(-3793, 2446, 0), ang = Angle(2, -90, 0) },
    { pos = Vector(-3771, 2627, 0), ang = Angle(0, -91, 0) },
    { pos = Vector(-3769, 2783, 0), ang = Angle(0, -91, 0) },
    { pos = Vector(-3259, 2773, 0), ang = Angle(0, -91, 0) },
    { pos = Vector(-3262, 2647, 0), ang = Angle(0, -91, 0) },
    { pos = Vector(-3264, 2521, 0), ang = Angle(0, -91, 0) }
}
math.randomseed(os.time())


local function GetRandomSpawn()
    return SpawnPoints[math.random(1, #SpawnPoints)]
end


local function TeleportPlayer(ply)
    if not IsValid(ply) then return end

    local spawn = GetRandomSpawn()
    

    ply:SetPos(spawn.pos)
    ply:SetAngles(spawn.ang)
    
    timer.Simple(0, function()
        if IsValid(ply) then
            ply:SetPos(spawn.pos)
            ply:SetAngles(spawn.ang)
        end
    end)
end

hook.Add("PlayerInitialSpawn", "CustomInitialSpawn", function(ply)
    timer.Simple(0.1, function() TeleportPlayer(ply) end)
end)

hook.Add("PlayerSpawn", "CustomRespawn", function(ply)
    TeleportPlayer(ply)
end)

hook.Add("PlayerSelectSpawn", "OverrideSpawn", function(ply)
    local spawn = GetRandomSpawn()
    return {
        pos = spawn.pos,
        ang = spawn.ang
    }
end)


