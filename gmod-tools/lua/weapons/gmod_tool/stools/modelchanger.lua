local PLUGIN_NAME = "ModelChanger"
local PLUGIN_AUTHOR = "111"
local PLUGIN_VERSION = "1.0"

local plugin = {}

function plugin.Init(callback)
    callback(true)
end

function plugin.Activate(callback)
    callback(true)
end

function plugin.Deactivate(callback)
    callback(true)
end

function plugin.Run(callback)
    if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetNWEntity()) then
        if LocalPlayer():GetNWBool(PLUGIN_NAME .. "IsAdmin", false) then
            LocalPlayer():ChatPrint("[" .. PLUGIN_NAME .. "] Activated!")
            LocalPlayer():SetNWBool(PLUGIN_NAME .. "IsAdmin", true)
        else
            LocalPlayer():ChatPrint("[" .. PLUGIN_NAME .. "] Access denied!")
        end
    end
    callback(true)
end

function plugin.OnPlayerDeath(ply, attacker, inflictor, weapon)
    if IsValid(ply) and IsValid(ply:GetNWEntity()) then
        ply:SetNWBool(PLUGIN_NAME .. "IsAdmin", false)
    end
end

function plugin.OnPlayerConnect(ply)
    if IsValid(ply) and IsValid(ply:GetNWEntity()) then
        ply:SetNWBool(PLUGIN_NAME .. "IsAdmin", false)
    end
end

function plugin.OnPlayerDisconnect(ply)
    if IsValid(ply) and IsValid(ply:GetNWEntity()) then
        ply:SetNWBool(PLUGIN_NAME .. "IsAdmin", false)
    end
end

function plugin.OnPlayerClick(ply, button)
    if IsValid(ply) and IsValid(ply:GetNWEntity()) and ply:GetNWBool(PLUGIN_NAME .. "IsAdmin", false) then
        if button == MOUSE_LEFT then
            local model = "models/citizen/citizen.mdl"
            if IsValid(LocalPlayer():GetNWEntity()) then
                model = LocalPlayer():GetNWString(PLUGIN_NAME .. "SelectedModel", model)
            end
            ply:SetModel(model)
        elseif button == MOUSE_RIGHT then
            ply:SetModel("models/citizen/citizen.mdl")
        end
    end
end

function plugin.OnPlayerClipboard(ply, text)
    if IsValid(ply) and IsValid(ply:GetNWEntity()) and ply:GetNWBool(PLUGIN_NAME .. "IsAdmin", false) then
        if text:len() > 0 then
            ply:SetNWString(PLUGIN_NAME .. "SelectedModel", text)
        end
    end
end

function plugin.OnPlayerKey(ply, key, down)
    if IsValid(ply) and IsValid(ply:GetNWEntity()) and ply:GetNWBool(PLUGIN_NAME .. "IsAdmin", false) then
        if key == IN_USE and down then
            if IsValid(LocalPlayer():GetNWEntity()) then
                local models = {}
                for k, v in pairs(GetAllModels()) do
                    table.insert(models, v)
                end
                LocalPlayer():ChatPrint("Select a model:")
                for i, model in ipairs(models) do
                    LocalPlayer():ChatPrint(i .. ". " .. model)
                end
                LocalPlayer():ChatPrint("Type the number of the model you want to select.")
                LocalPlayer():SetNWString(PLUGIN_NAME .. "SelectedModel", models[LocalPlayer():GetNWInt(PLUGIN_NAME .. "SelectedModel", 1)])
            end
        end
    end
end

plugin.Author = PLUGIN_AUTHOR
plugin.Name = PLUGIN_NAME
plugin.Version = PLUGIN_VERSION

return plugin