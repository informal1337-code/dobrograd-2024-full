local work = {}
work.priority = 60

local trashPositions = {
    Vector(378, 61, -31),
    Vector(1983, -455, -31),
    Vector(584, -518, -31),
    Vector(-617, -478, -31),
    Vector(-1435, 1398, 0)
}

local spawnedTrash = {}

function work.spawnTrash()
    for _, trash in ipairs(spawnedTrash) do
        if IsValid(trash) then
            trash:Remove()
        end
    end
    spawnedTrash = {}
    
    for _, pos in ipairs(trashPositions) do
        local trash = ents.Create("ent_dbg_workgarbage")
        if IsValid(trash) then
            trash:SetPos(pos)
            trash:Spawn()
            table.insert(spawnedTrash, trash)
        end
    end
end

function work.start(ply, time, maxDist)
    local garbage, box
    for _, v in RandomPairs(spawnedTrash) do
        if not v:GetIsCleaned() and not v.pendingWorker and v:GetPos():DistToSqr(ply:GetPos()) < maxDist then
            garbage = v
            break
        end
    end
    if not IsValid(garbage) then return end

    for _, v in RandomPairs(ents.FindByClass('ent_dbg_workerbox')) do
        if v:GetPos():DistToSqr(garbage:GetPos()) < maxDist then 
            box = v 
            break 
        end
    end
    if not IsValid(box) then return end

    ply:AddMarker {
        id = 'work1',
        txt = 'Взять инструменты для уборки',
        pos = box:GetPos() + Vector(0,0,40),
        col = Color(255,92,38),
        des = {'time', {time}},
        icon = 'octoteam/icons-16/setting_tools.png',
    }

    ply:AddMarker {
        id = 'work2',
        txt = 'Убрать мусор (' .. garbage:GetTrashCount() .. ' шт.)',
        pos = garbage:GetPos(),
        col = Color(255,92,38),
        des = {'time', {time}},
        icon = 'octoteam/icons-16/bin.png',
    }

    local items = {
        {'broom', 1}
    }

    if box.inv.conts[ply:SteamID()] then 
        box.inv.conts[ply:SteamID()]:Remove() 
    end
    
    local cont = box.inv.conts[ply:SteamID()] or box.inv:AddContainer(ply:SteamID(), {
        name = L.city_warehouse, 
        volume = 250, 
        icon = octolib.icons.color('box1')
    })
    
    for _, v in ipairs(items) do 
        cont:AddItem(v[1], v[2]) 
    end

    garbage:StartWork(ply, {
        items = items,
        time = time,
        finish = dbgWork.finishWork,
        trashCount = garbage:GetTrashCount()
    })

    return {
        msg = 'На улице скопился мусор. Возьми инструменты и убери ' .. garbage:GetTrashCount() .. ' куч мусора',
        cancelOnFinish = true,
        garbage = garbage,
        cont = cont, -- вообще я нге пониаю почему не работает, но это будет как штука которая спасет вас от нищеты
        salary = garbage:GetTrashCount() * 45, -- 45 денег за каждую кучу мусора
    }
end

function work.finish(work)
    dbgWork.giveReward(work, work.garbage:GetTrashCount() * 40, work.garbage:GetTrashCount() * 50)
end

function work.cancel(work)
    if IsValid(work.garbage) then
        work.garbage:UnsetWork()
    end
    if work.cont then 
        work.cont:Remove() 
    end
end

dbgWork.registerWork('garbage', work)

hook.Add("InitPostEntity", "dbg-work-garbage-spawn", work.spawnTrash)
hook.Add("PostCleanupMap", "dbg-work-garbage-respawn", work.spawnTrash)