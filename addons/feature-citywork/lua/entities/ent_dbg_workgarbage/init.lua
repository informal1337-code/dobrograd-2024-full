AddCSLuaFile()

function ENT:Initialize()
    self:SetModel("models/props_junk/garbage128_composite001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetTrashCount(3)
    self:SetMaxTrashCount(3)
    self:SetIsCleaned(false)
    
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end
end

function ENT:StartWork(ply, workData)
    if self.pendingWorker or self:GetIsCleaned() then return false end
    self.pendingWorker = ply
    self.workData = workData
    self.cleanedTrash = 0
    return true
end

function ENT:CleanTrash()
    if not self.pendingWorker then return end
    
    self.cleanedTrash = (self.cleanedTrash or 0) + 1
    
    if self.cleanedTrash >= self:GetTrashCount() then
        self:SetIsCleaned(true)
        if self.workData and self.workData.finish then
            self.workData.finish(self.pendingWorker)
        end
        self.pendingWorker = nil
        timer.Simple(math.random(300, 600), function() -- 5-10 минут
            if IsValid(self) then
                self:ResetTrash()
            end
        end)
    end
end

function ENT:ResetTrash()
    self:SetIsCleaned(false)
    self.pendingWorker = nil
    self.cleanedTrash = 0
    self:SetTrashCount(math.random(2, 5))
end

function ENT:UnsetWork()
    self.pendingWorker = nil
    self.workData = nil
end