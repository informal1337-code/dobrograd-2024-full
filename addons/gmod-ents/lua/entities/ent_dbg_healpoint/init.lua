AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'sv_init.lua'

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Триггер лечения"
ENT.Category = "siska"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:Initialize()
    self:SetModel("models/hunter/plates/plate1x1.mdl") 
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) 
    self:SetColor(Color(255, 255, 255, 0)) 
end

function ENT:Use(activator, caller)
    
end

function ENT:OnRemove()
    for _, timerName in ipairs(timer.GetAll()) do
        if string.StartWith(timerName, "heal_player_") then
            timer.Remove(timerName)
        end
    end
end