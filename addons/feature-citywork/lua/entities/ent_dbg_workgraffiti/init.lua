AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
    self:SetCleaned(false)
    self.pendingWorker = nil
end

function ENT:SetWork(ply, workData)
    if self.pendingWorker or self:GetCleaned() then return false end
    self.pendingWorker = ply
    self.workData = workData
    return true
end

function ENT:CleanGraffiti()
    if not self.pendingWorker then return end

    self:SetCleaned(true)
    if self.workData and self.workData.finish then
        self.workData.finish(self.pendingWorker)
    end
    self.pendingWorker = nil
    timer.Simple(math.random(600, 1200), function() -- 10-20 минут
        if IsValid(self) then
            self:ResetGraffiti()
        end
    end)
end

function ENT:ResetGraffiti()
    self:SetCleaned(false)
    self.pendingWorker = nil
end

function ENT:UnsetWork()
    self.pendingWorker = nil
    self.workData = nil
end
