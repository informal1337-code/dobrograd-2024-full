local SpawnPoints = {
    ["gm_construct"] = {
        { pos = Vector(-100, 200, 100), ang = Angle(0, 90, 0) },
        { pos = Vector(300, -150, 100), ang = Angle(0, 180, 0) },
        { pos = Vector(0, 0, 100), ang = Angle(0, 0, 0) }
    },
} -- пожалуйста, нормально делайте и не пишите мне.

math.randomseed(os.time())

local function GetRandomSpawn()
    local currentMap = game.GetMap()
    local mapSpawns = SpawnPoints[currentMap]

    if not mapSpawns or #mapSpawns == 0 then
        return nil
    end

    return mapSpawns[math.random(1, #mapSpawns)]
end

local function TeleportPlayer(ply)
    if not IsValid(ply) then return end

    local spawn = GetRandomSpawn()

    if not spawn then
        return
    end

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
    timer.Simple(0.1, function()
        if GetRandomSpawn() then
            TeleportPlayer(ply)
        end
    end)
end)

hook.Add("PlayerSpawn", "CustomRespawn", function(ply)
    if GetRandomSpawn() then
        TeleportPlayer(ply)
    end
end)

hook.Add("PlayerSelectSpawn", "OverrideSpawn", function(ply)
    local spawn = GetRandomSpawn()
    if spawn then
        return {
            pos = spawn.pos,
            ang = spawn.ang
        }
    end
end)