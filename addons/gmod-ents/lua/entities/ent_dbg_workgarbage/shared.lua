ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Work Garbage"
ENT.Category = "DBG Entities"
ENT.Author = "DBG"
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:Initialize()
    self:SetModel("models/props_junk/TrashDumpster01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end

    -- Add your logic here
    activator:ChatPrint("You used the work garbage!")
end
