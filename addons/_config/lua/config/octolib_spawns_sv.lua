octolib_playerspawns = octolib_playerspawns or {
    ["gm_construct"] = {
        { pos = Vector(-100, 200, 100), ang = Angle(0, 90, 0) },
        { pos = Vector(300, -150, 100), ang = Angle(0, 180, 0) },
        { pos = Vector(0, 0, 100), ang = Angle(0, 0, 0) },
        { pos = Vector(-400, 100, 100), ang = Angle(0, 45, 0) },
        { pos = Vector(500, 300, 100), ang = Angle(0, -90, 0) }
    }
}

math.randomseed(os.time())

local function GetRandomSpawn()
    local currentMap = game.GetMap()
    local mapSpawns = octolib_playerspawns and octolib_playerspawns[currentMap]

    if not mapSpawns or #mapSpawns == 0 then
        octolib.logger.warning("No spawn points defined for map: " .. currentMap)
        return nil
    end

    return mapSpawns[math.random(1, #mapSpawns)]
end

local function TeleportPlayerToSpawn(ply, spawnData)
    if not IsValid(ply) or not spawnData then return false end

    local trace = util.TraceHull({
        start = spawnData.pos,
        endpos = spawnData.pos,
        mins = ply:OBBMins(),
        maxs = ply:OBBMaxs(),
        filter = ply
    })

    if trace.Hit then
        octolib.logger.warning("Spawn point blocked for player", ply, {
            pos = tostring(spawnData.pos),
            map = game.GetMap()
        })
        return false
    end

    ply:SetPos(spawnData.pos)
    if spawnData.ang then
        ply:SetAngles(spawnData.ang)
    end

    timer.Simple(0.1, function()
        if IsValid(ply) then
            ply:SetPos(spawnData.pos)
            if spawnData.ang then
                ply:SetAngles(spawnData.ang)
            end
        end
    end)

    return true
end

hook.Add("PlayerInitialSpawn", "octolib_spawn.InitialSpawn", function(ply)
    timer.Simple(0.5, function()
        if not IsValid(ply) then return end
        if ply.dbg_playertest or ply.passedTest == false then
            octolib.logger.debug("Skipping spawn teleport for player in test", ply)
            return
        end

        local spawn = GetRandomSpawn()
        if spawn then
            local success = TeleportPlayerToSpawn(ply, spawn)
            if success then
                octolib.logger.debug("Player spawned at custom location", ply, {
                    pos = tostring(spawn.pos),
                    map = game.GetMap()
                })
            end
        else
            octolib.logger.debug("Using default spawn for player", ply)
        end
    end)
end)

hook.Add("PlayerSpawn", "octolib_spawn.Respawn", function(ply)
    if ply.deathTime and (CurTime() - ply.deathTime) < 1 then
        ply.deathTime = nil
        return
    end

    if ply.dbg_playertest or ply.passedTest == false then
        return
    end

    if ply:Alive() and not ply:InVehicle() then
        local spawn = GetRandomSpawn()
        if spawn then
            TeleportPlayerToSpawn(ply, spawn)
        end
    end
end)

hook.Add("PlayerSelectSpawn", "octolib_spawn.OverrideDefault", function(ply)
    local spawn = GetRandomSpawn()
    if spawn then
        local spawnEnt = ents.Create("info_player_start")
        spawnEnt:SetPos(spawn.pos)
        if spawn.ang then
            spawnEnt:SetAngles(spawn.ang)
        end
        spawnEnt:Spawn()
        spawnEnt:SetName("octolib_custom_spawn_" .. ply:SteamID())

        timer.Simple(0.1, function()
            if IsValid(spawnEnt) then
                spawnEnt:Remove()
            end
        end)

        return spawnEnt
    end
end)

hook.Add("PlayerDeath", "octolib_spawn.TrackDeath", function(ply)
    ply.deathTime = CurTime()
end)
