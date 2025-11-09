AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"
local lastUses = {}

function ENT:Initialize()
    self:SetModel('models/hunter/plates/plate2x3.mdl')
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetRenderMode(RENDERMODE_TRANSALPHA)
    self:SetColor(Color(0, 0, 0, 0))

    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
end

function ENT:Use(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    ply:DelayedAction('reviverKarma', L.confession, {
        time = 60,
        check = function() return octolib.use.check(ply, self) end,
        succ = function()
            local sID = ply:SteamID()
            if CurTime() - (lastUses[sID] or -2400) > 2400 then
                ply:AddKarma(1, L.confession_help)
                print('[KARMA] ' .. ply:Nick() .. ' +1 karma for prayer')
                lastUses[sID] = CurTime()
            else
                ply:Notify('warning', L.god_love_you)
            end
        end,
    }, {
        time = 3,
        inst = true,
        action = function()
            ply:DoAnimation(ACT_GMOD_GESTURE_BOW)
        end,
    })
end
