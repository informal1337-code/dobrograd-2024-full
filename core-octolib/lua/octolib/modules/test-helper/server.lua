util.AddNetworkString('octolib.testHelper.sync')
util.AddNetworkString('octolib.testHelper.method')

octolib.testHelper.syncedPlayers = octolib.testHelper.syncedPlayers or {}

function octolib.testHelper.sync(ply)
    local targets = ply and {ply} or player.GetAll()
    
    for _, target in ipairs(targets) do
        netstream.Start(target, 'octolib.testHelper.sync', {
            categories = octolib.testHelper.categories,
            uiData = octolib.testHelper.uiData,
        })
        octolib.testHelper.syncedPlayers[target] = true
    end
end

function octolib.testHelper.unsync(ply)
    if ply then
        octolib.testHelper.syncedPlayers[ply] = nil
    else
        table.Empty(octolib.testHelper.syncedPlayers)
    end
end

netstream.Hook('octolib.testHelper.method', function(ply, id, ...)
    if not IsValid(ply) or not octolib.testHelper.handlers[id] then return end
    
    local handler = octolib.testHelper.handlers[id]
    if isfunction(handler) then
        handler(ply, ...)
    end
end)

hook.Add('PlayerDisconnected', 'octolib.testHelper', function(ply)
    octolib.testHelper.syncedPlayers[ply] = nil
end)

hook.Add('PlayerFinishedLoading', 'octolib.testHelper', function(ply)
    if next(octolib.testHelper.uiData) ~= nil then
        timer.Simple(1, function()
            if IsValid(ply) then
                octolib.testHelper.sync(ply)
            end
        end)
    end
end)