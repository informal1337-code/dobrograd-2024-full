if not octochat then
    print("Ошибка: octochat не загружен!")
    return
end

-- Форматирование времени (00:00:00)
local function niceTime(time)
    local h = math.floor(time / 3600)
    local m = math.floor((time % 3600) / 60)
    local s = math.floor(time % 60)
    return string.format("%02i:%02i:%02i", h, m, s)
end

-- Отправка OOC-сообщения всем
local function sendOOC(ply, txt)
    if not IsValid(ply) or not txt or txt == "" then return end
    txt = txt:gsub("\n", " ") -- Убираем переносы строк

    if ply:IsAdmin() then
        octochat.talkTo(nil, octochat.textColors.ooc, 
            ("[OOC] %s (%s): "):format(ply:SteamName(), ply:Name()), 
            color_white, 
            unpack(octolib.string.splitByUrl(txt))
        )
    else
        octochat.talkTo(nil, octochat.textColors.ooc, 
            ("[OOC] %s (%s): "):format(ply:SteamName(), ply:Name()), 
            color_white, 
            txt
        )
    end
end

-- Регистрация команды /ooc
octochat.registerCommand("/ooc", {
    log = true,
    cooldownBypass = "DBG: Нет ограничения на OOC",
    execute = function(ply, txt, _, cmd)
        if not txt or txt == "" then
            return "Формат: " .. cmd .. " Текст сообщения"
        end

        -- Проверка через хук PlayerCanOOC
        local can, why = hook.Run("PlayerCanOOC", ply, txt)
        if can == false then
            return why or "Нельзя отправить это сообщение."
        end

        -- Проверка кулдауна
        local nextOOC = ply:GetCooldown("ooc")
        if nextOOC and nextOOC > CurTime() then
            return "Подождите " .. niceTime(nextOOC - CurTime()) .. " перед следующим OOC сообщением"
        end

        -- Отправка сообщения
        sendOOC(ply, txt)

        -- Применение кулдауна (если нет привилегии bypass)
        if not ply:query("DBG: Нет ограничения на OOC") then
            ply:TriggerCooldown("ooc", 30 * 60) -- 30 минут
        end
    end,
    aliases = {"//", "/a"},
})

-- Регистрация команды /looc (локальный OOC)
octochat.registerCommand("/looc", {
    cooldown = 1.5,
    log = true,
    cooldownBypass = "DBG: Нет ограничения на OOC",
    execute = function(ply, txt, _, cmd)
        if not txt or txt == "" then
            return "Формат: " .. cmd .. " Текст сообщения"
        end

        if ply:IsAdmin() then
            octochat.talkToRange(ply, 250, octochat.textColors.ooc, 
                ("[LOOC] %s (%s): "):format(ply:SteamName(), ply:Name()), 
                color_white, 
                unpack(octolib.string.splitByUrl(txt))
            )
        else
            octochat.talkToRange(ply, 250, octochat.textColors.ooc, 
                ("[LOOC] %s (%s): "):format(ply:SteamName(), ply:Name()), 
                color_white, 
                txt
            )
        end
    end,
    aliases = {"/"},
})

-- Регистрация команды /pm (личные сообщения)
octochat.registerCommand("/pm", {
    cooldown = 3,
    log = true,
    cooldownBypass = "DBG: Нет ограничения на OOC",
    execute = function(ply, _, args)
        local target, txt = octochat.pickOutTarget(args)
        if not target then return txt or "Формат: /pm \"Имя игрока\" Текст сообщения" end
        if txt == "" then return "Формат: /pm \"Имя игрока\" Текст сообщения" end

        if ply:IsAdmin() then
            octochat.talkTo(target, octochat.textColors.ooc, 
                ("[PM] от %s (%s): "):format(ply:SteamName(), ply:Name()), 
                Color(250, 250, 200), 
                unpack(octolib.string.splitByUrl(txt))
            )
            octochat.talkTo(ply, octochat.textColors.ooc, 
                ("[PM] для %s (%s): "):format(target:SteamName(), target:Name()), 
                Color(250, 250, 200), 
                unpack(octolib.string.splitByUrl(txt))
            )
        else
            octochat.talkTo(target, octochat.textColors.ooc, 
                ("[PM] от %s (%s): "):format(ply:SteamName(), ply:Name()), 
                Color(250, 250, 200), 
                txt
            )
            octochat.talkTo(ply, octochat.textColors.ooc, 
                ("[PM] для %s (%s): "):format(target:SteamName(), target:Name()), 
                Color(250, 250, 200), 
                txt
            )
        end
    end,
})