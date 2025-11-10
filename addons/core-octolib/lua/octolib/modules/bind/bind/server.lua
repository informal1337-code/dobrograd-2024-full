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