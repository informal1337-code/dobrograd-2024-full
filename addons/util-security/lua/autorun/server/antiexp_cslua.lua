local bannedPlayers = {}

local function BanPlayer(ply)
    local steamID = ply:SteamID()
    bannedPlayers[steamID] = true

    file.Write("octolib_banned_players.txt", util.TableToJSON(bannedPlayers)) -- Сохраняем черный список
end

hook.Add("PlayerConnect", "octolib.anticheat.banCheck", function(steamID)
    if bannedPlayers[steamID] then
        return "You are banned for cheating."
    end
end)

netstream.Hook('6ylc0mkzd5ZhwPkcf2f9or7gi1WnLx', function(ply)
    if GetConVar('sv_cheats'):GetBool() ~= false or GetConVar('sv_allowcslua'):GetBool() ~= false then return end

    BanPlayer(ply) -- Автоматически баним игрока

    if CFG.webhooks.cheats then
        octoservices:post('/discord/webhook/' .. CFG.webhooks.cheats, {
            username = GetHostName(),
            embeds = {{
                title = 'Попытка использовать клиентские скрипты',
                fields = {{
                    name = L.player,
                    value = ply:GetName() .. '\n[' .. ply:SteamID() .. '](' .. 'https://steamcommunity.com/profiles/' .. ply:SteamID64() .. ')',
                }},
            }},
        })
    end

    ply:Kick('exploits')
end)