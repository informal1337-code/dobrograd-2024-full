dbgTutorial = dbgTutorial or {}

util.AddNetworkString('dbgTutorial.quest.start')
util.AddNetworkString('dbgTutorial.quest.skip')
util.AddNetworkString('dbgTutorial.quest.next')
util.AddNetworkString('dbgTutorial.completeSubTask')
util.AddNetworkString('dbgTutorial.onHelpOpened')
util.AddNetworkString('dbgTutorial.slideshow.open')
util.AddNetworkString('dbgTutorial.tours.start')
util.AddNetworkString('dbgTutorial.tours.finish')
util.AddNetworkString('dbgTutorial.tours.next')

dbgTutorial.quest = dbgTutorial.quest or {}

function dbgTutorial.quest.start(ply)
    if not IsValid(ply) then return end
    
    net.Start('dbgTutorial.slideshow.open')
    net.Send(ply)
    
    ply.dbgTutorial = ply.dbgTutorial or {
        stage = 0,
        completedStages = {},
        subtasks = {}
    }
end

function dbgTutorial.quest.next(ply)
    if not IsValid(ply) then return end
    
    local tutorial = ply.dbgTutorial
    if not tutorial then return end
    
    tutorial.stage = tutorial.stage + 1
    tutorial.completedStages[tutorial.stage] = true
    
    local tourId = dbgTutorial.quest.getTourForStage(tutorial.stage)
    if tourId then
        net.Start('dbgTutorial.tours.start')
        net.WriteString(tourId)
        net.Send(ply)
    end
    
    dbgTutorial.quest.saveProgress(ply)
end

function dbgTutorial.quest.skip(ply)
    if not IsValid(ply) then return end
    
    ply.dbgTutorial = {
        stage = 999,
        completedStages = {},
        subtasks = {},
        skipped = true
    }
    
    net.Start('dbgTutorial.tours.finish')
    net.WriteBool(false) -- false
    net.Send(ply)
    
    dbgTutorial.quest.saveProgress(ply)
end

function dbgTutorial.quest.completeSubTask(ply, index)
    if not IsValid(ply) or not ply.dbgTutorial then return end
    
    ply.dbgTutorial.subtasks[index] = true
    
    if dbgTutorial.quest.checkStageCompletion(ply) then
        dbgTutorial.quest.next(ply)
    end
    
    dbgTutorial.quest.saveProgress(ply)
end

function dbgTutorial.quest.getTourForStage(stage)
    local stageTours = {
        [1] = "stage_hands",
        [2] = "stage_closelook", 
        [3] = "stage_f4",
        [4] = "stage_atm.intro",
        [5] = "stage_atm",
        [6] = "stage_hunger.intro",
        [7] = "stage_hunger",
        [8] = "stage_job.intro",
        [9] = "stage_job",
        [10] = "stage_character.switch",
        [11] = "stage_character.job",
        [12] = "stage_cityworker.intro",
        [13] = "stage_cityworker.outro",
        [14] = "stage_crafting.intro",
        [15] = "stage_crafting",
        [16] = "stage_fishing.order",
        [17] = "stage_fishing.fishing",
        [18] = "stage_bus",
        [19] = "stage_mailbox",
        [20] = "stage_estates",
        [21] = "stage_ending"
    }
    
    return stageTours[stage]
end

function dbgTutorial.quest.checkStageCompletion(ply)
    if not ply.dbgTutorial then return false end
    
    local stage = ply.dbgTutorial.stage
    local subtasks = ply.dbgTutorial.subtasks
    if stage == 3 then -- f4
        return subtasks[1] and subtasks[2] and subtasks[3] and subtasks[4] and 
               subtasks[5] and subtasks[6] and subtasks[7] and subtasks[8] and subtasks[9]
    end
    return true
end

function dbgTutorial.quest.saveProgress(ply)
    if not IsValid(ply) then return end
    local steamID = ply:SteamID()
    local tutorialData = util.TableToJSON(ply.dbgTutorial or {})

    file.Write("dbg_tutorial/" .. steamID .. ".txt", tutorialData)
end

function dbgTutorial.quest.loadProgress(ply)
    if not IsValid(ply) then return end
    
    local steamID = ply:SteamID()
    if file.Exists("dbg_tutorial/" .. steamID .. ".txt", "DATA") then
        local tutorialData = file.Read("dbg_tutorial/" .. steamID .. ".txt", "DATA")
        ply.dbgTutorial = util.JSONToTable(tutorialData) or {}
    else
        ply.dbgTutorial = {
            stage = 0,
            completedStages = {},
            subtasks = {}
        }
    end
end

net.Receive('dbgTutorial.quest.start', function(len, ply)
    dbgTutorial.quest.start(ply)
end)

net.Receive('dbgTutorial.quest.skip', function(len, ply)
    dbgTutorial.quest.skip(ply)
end)

net.Receive('dbgTutorial.quest.next', function(len, ply)
    dbgTutorial.quest.next(ply)
end)

net.Receive('dbgTutorial.completeSubTask', function(len, ply)
    local index = net.ReadUInt(8)
    dbgTutorial.quest.completeSubTask(ply, index)
end)

net.Receive('dbgTutorial.onHelpOpened', function(len, ply)
    if ply.dbgTutorial and ply.dbgTutorial.stage == 14 then -- stage_crafting.intro
        dbgTutorial.quest.completeSubTask(ply, 1)
    end
end)

hook.Add("PlayerInitialSpawn", "dbgTutorial.InitPlayer", function(ply)
    timer.Simple(5, function()
        if IsValid(ply) then
            dbgTutorial.quest.loadProgress(ply)
            
            local tutorial = ply.dbgTutorial
            if not tutorial or (not tutorial.skipped and tutorial.stage < 999) then
                dbgTutorial.quest.start(ply)
            end
        end
    end)
end)

hook.Add("PlayerDisconnected", "dbgTutorial.SaveOnDisconnect", function(ply)
    if IsValid(ply) and ply.dbgTutorial then
        dbgTutorial.quest.saveProgress(ply)
    end
end)
