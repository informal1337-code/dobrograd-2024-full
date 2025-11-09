local work = {}
work.priority = 75

function work.start(ply, time, maxDist)

    local graffiti, box
    for i, v in RandomPairs(ents.FindByClass('ent_dbg_workgraffiti')) do
        if not v:GetCleaned() and not v.pendingWorker and v:GetPos():DistToSqr(ply:GetPos()) < maxDist then 
            graffiti = v 
            break 
        end
    end
    if not IsValid(graffiti) then return end

    for i, v in RandomPairs(ents.FindByClass('ent_dbg_workerbox')) do
        if v:GetPos():DistToSqr(graffiti:GetPos()) < maxDist then box = v break end
    end
    if not IsValid(box) then return end

    ply:AddMarker {
        id = 'work1',
        txt = 'Взять средства для уборки',
        pos = box:GetPos() + Vector(0,0,40),
        col = Color(255,92,38),
        des = {'time', {time}},   -- СЛИВ ШОК СЛИВ ВВВВ ВОСТОЧНОЕ ЭПОЭБЕРЕЖНТЕ СЛИИВ СРОЧНО АЛЕ СРОЧНО!!!!! ПАСТИМ ЗА 5 МИНУТ ДБГ!!!!!!!!!!!
        icon = 'octoteam/icons-16/setting_tools.png',
    }

    ply:AddMarker {
        id = 'work2',
        txt = 'Убрать граффити',
        pos = graffiti:GetPos(),        
        col = Color(255,92,38),
        des = {'time', {time}},
        icon = 'octoteam/icons-16/paintcan.png',
    }

    local items = {}
    if math.random(2) == 1 then table.insert(items, {'tool_spray', 1}) end
    if math.random(2) == 1 then table.insert(items, {'tool_brush', 1}) end
    if math.random(3) == 1 then table.insert(items, {'craft_rag', 2}) end
    if math.random(3) == 1 then table.insert(items, {'craft_soap', 1}) end
    if #items < 1 then table.insert(items, {'tool_spray', 1}) end

    if box.inv.conts[ply:SteamID()] then box.inv.conts[ply:SteamID()]:Remove() end
    local cont = box.inv.conts[ply:SteamID()] or box.inv:AddContainer(ply:SteamID(), {name = L.city_warehouse, volume = 250, icon = octolib.icons.color('box1')})
    for i, v in ipairs(items) do cont:AddItem(v[1], v[2]) end

    graffiti:SetWork(ply, {
        items = items,
        time = math.random(15, 30),
        finish = dbgWork.finishWork,
    })

    return {
        cancelOnFinish = true,
        msg = 'На стене появилось вандальное граффити. Возьми средства для уборки и очисти стену',
        graffiti = graffiti,
        cont = cont,
        salary = math.random(80, 150),
    }

end

function work.finish(work)
    dbgWork.giveReward(work, 80, 150)
end

function work.cancel(work)
    if IsValid(work.graffiti) then
        work.graffiti:UnsetWork()
    end
    if work.cont then 
        work.cont:Remove() 
    end
end

dbgWork.registerWork('graffiti', work) -- петухи
--- петухи
-- петухи
-- петухи