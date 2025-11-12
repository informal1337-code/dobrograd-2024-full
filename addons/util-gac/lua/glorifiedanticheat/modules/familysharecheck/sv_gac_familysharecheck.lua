local _hook_Add = hook.Add
local _string_len = string.len
local _tonumber = tonumber
local _util_JSONToTable = util.JSONToTable
local _http_Fetch = http.Fetch
local _timer_Simple = timer.Simple
local _timer_Create = timer.Create
local _timer_Remove = timer.Remove
local _player_GetAll = player.GetAll
local _IsValid = IsValid

gAC.FamilyShareCache = gAC.FamilyShareCache or {}

local function ValidateConfig()
    if _string_len(gAC.config.STEAM_API_KEY or "") <= 1 then
        gAC.Print("Steam API Key not configured - Family Share checks disabled")
        return false
    end
    
    if not gAC.config.ENABLE_FAMILY_SHARE_CHECKS then
        return false
    end
    
    return true
end

local function HandleAPIResponse(ply, body)
    if not _IsValid(ply) then return end
    
    if not body or body == "" then
        gAC.DBGPrint("Empty API response for " .. ply:SteamID())
        return
    end
    
    local success, bodyTable = pcall(_util_JSONToTable, body)
    if not success or not bodyTable then
        gAC.DBGPrint("Invalid JSON response for " .. ply:SteamID())
        return
    end
    
    local response = bodyTable.response or {}
    local lenderSteamID = response.lender_steamid
    
    if not lenderSteamID or lenderSteamID == "0" then
        gAC.FamilyShareCache[ply:SteamID64()] = true
        gAC.DBGPrint(ply:Name() .. " owns the game (not family shared)")
        return
    end
    
    local ownerSteamID = _tonumber(lenderSteamID)
    if ownerSteamID and ownerSteamID > 0 then
        gAC.FamilyShareCache[ply:SteamID64()] = false
        
        gAC.AddDetection(ply, 
            "Family shared account detected [Code 105]", 
            gAC.config.FAMILY_SHARE_PUNISHMENT, 
            gAC.config.FAMILY_SHARE_BANTIME
        )
        
        gAC.Print(ply:Name() .. " joined using family shared account (Owner: " .. ownerSteamID .. ")")
    end
end

local function PerformFamilyShareCheck(ply)
    if not _IsValid(ply) then return end
    
    local steamID64 = ply:SteamID64()
    if not steamID64 or steamID64 == "0" then return end

    if gAC.FamilyShareCache[steamID64] ~= nil then
        if gAC.FamilyShareCache[steamID64] == false then
            gAC.AddDetection(ply, 
                "Family shared account detected [Code 105]", 
                gAC.config.FAMILY_SHARE_PUNISHMENT, 
                gAC.config.FAMILY_SHARE_BANTIME
            )
        end
        return
    end

    local apiURL = "http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/" ..
                   "?key=" .. gAC.config.STEAM_API_KEY ..
                   "&format=json" ..
                   "&steamid=" .. steamID64 ..
                   "&appid_playing=4000"

    _http_Fetch(apiURL, 
        function(body)
            HandleAPIResponse(ply, body)
        end,
        
        function(error)
            gAC.DBGPrint("Family Share API request failed for " .. ply:SteamID() .. ": " .. (error or "Unknown error"))
            
            if not ply.gAC_FamilyShareRetries then
                ply.gAC_FamilyShareRetries = 0
            end
            
            if ply.gAC_FamilyShareRetries < 3 then
                ply.gAC_FamilyShareRetries = ply.gAC_FamilyShareRetries + 1
                _timer_Simple(5 * ply.gAC_FamilyShareRetries, function()
                    if _IsValid(ply) then
                        PerformFamilyShareCheck(ply)
                    end
                end)
            else
                gAC.Print("Failed to check family share status for " .. ply:Name() .. " after 3 attempts")
            end
        end
    )
end

function gAC.FamilyShareCheck(ply)
    if not ValidateConfig() then return end
    if not _IsValid(ply) then return end

    _timer_Simple(2, function()
        if _IsValid(ply) then
            PerformFamilyShareCheck(ply)
        end
    end)
end

function gAC.FamilyShareCheckAll()
    if not ValidateConfig() then return end
    
    local players = _player_GetAll()
    gAC.Print("Performing family share check on all players...")
    
    for _, ply in ipairs(players) do
        if _IsValid(ply) then
            PerformFamilyShareCheck(ply)
        end
    end
end

function gAC.CleanFamilyShareCache()
    local currentPlayers = {}
    for _, ply in ipairs(_player_GetAll()) do
        if _IsValid(ply) then
            currentPlayers[ply:SteamID64()] = true
        end
    end
    
    for steamID64, _ in pairs(gAC.FamilyShareCache) do
        if not currentPlayers[steamID64] then
            gAC.FamilyShareCache[steamID64] = nil
        end
    end
end

_hook_Add("PlayerInitialSpawn", "g-ACFamilyShareCheckInitialSpawn", function(ply)
    gAC.FamilyShareCheck(ply)
end)

_hook_Add("PlayerDisconnected", "g-ACFamilyShareCacheCleanup", function(ply)
    if ply and ply:SteamID64() then
        gAC.FamilyShareCache[ply:SteamID64()] = nil
    end
end)

_timer_Create("gAC_FamilyShareCacheCleanup", 300, 0, function()
    gAC.CleanFamilyShareCache()
end)

concommand.Add("gac_checkfamilyshare", function(ply)
    if ply and ply:IsValid() and not ply:IsSuperAdmin() then
        ply:ChatPrint("You need to be a superadmin to use this command!")
        return
    end
    
    gAC.FamilyShareCheckAll()
    
    if ply and ply:IsValid() then
        ply:ChatPrint("Family share check initiated for all players.")
    else
        gAC.Print("Family share check initiated for all players via console.")
    end
end)

concommand.Add("gac_familyshare_status", function(ply)
    if ply and ply:IsValid() and not ply:IsSuperAdmin() then
        ply:ChatPrint("You need to be a superadmin to use this command!")
        return
    end
    
    local cacheCount = 0
    for _ in pairs(gAC.FamilyShareCache) do
        cacheCount = cacheCount + 1
    end
    
    local msg = string.format("Family Share Cache: %d entries", cacheCount)
    
    if ply and ply:IsValid() then
        ply:ChatPrint(msg)
    else
        gAC.Print(msg)
    end
end)

_hook_Add("Initialize", "gAC_FamilyShareConfigCheck", function()
    _timer_Simple(5, function()
        if not ValidateConfig() then
            gAC.Print("Family Share Checks: DISABLED (Check STEAM_API_KEY configuration)")
        else
            gAC.Print("Family Share Checks: ENABLED")
        end
    end)
end)

gAC.Print("Family Share Check System loaded successfully")