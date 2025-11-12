octolib = octolib or {}
octolib.bind = octolib.bind or {}

util.AddNetworkString('octolib.bind.sync')

function octolib.bind.sync(ply)
    net.Start('octolib.bind.sync')
    net.WriteTable(octolib.bind.cache or {})
    net.Send(ply)
end

hook.Add('PlayerInitialSpawn', 'octolib.bind', function(ply)
    timer.Simple(1, function()
        if IsValid(ply) then
            octolib.bind.sync(ply)
        end
    end)
end)

function octolib.bind.save(steamID, binds)
        octolib.db:PrepareQuery([[
        INSERT INTO player_binds (steamid, binds, server_group) 
        VALUES (?, ?, ?) 
        ON DUPLICATE KEY UPDATE binds = ?, updated_at = NOW()
    ]], {
        steamID,
        util.TableToJSON(binds),
        CFG.serverGroupIDvars or CFG.serverGroupID,
        util.TableToJSON(binds)
    })
end

function octolib.bind.load(steamID, callback)
    octolib.db:PrepareQuery([[
        SELECT binds FROM player_binds 
        WHERE steamid = ? AND server_group = ?
    ]], {
        steamID,
        CFG.serverGroupIDvars or CFG.serverGroupID
    }, function(q, st, res)
        if st and res and #res > 0 then
            local binds = util.JSONToTable(res[1].binds or '[]')
            callback(binds or {})
        else
            callback({})
        end
    end)
end


net.Receive('octolib.bind.set', function(len, ply)
    local id = net.ReadUInt(8)
    local button = net.ReadUInt(8)
    local action = net.ReadString()
    local data = net.ReadString()
    local on = net.ReadString()

    -- if button = 0, значит это удаление
    if button == 0 then

        if id > 0 then
            table.remove(octolib.bind.cache, id)
        end
    else
        local bindData = {
            button = button,
            action = action,
            data = util.JSONToTable(data) or {},
            on = on
        }

        if id == 0 then
            table.insert(octolib.bind.cache, bindData)
        else
            octolib.bind.cache[id] = bindData
        end
    end

    octolib.bind.save(ply:SteamID(), octolib.bind.cache)

    octolib.bind.sync(ply)
end)