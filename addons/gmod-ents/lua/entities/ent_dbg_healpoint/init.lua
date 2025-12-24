AddCSLuaFile 'cl_init.lua'


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

function ENT:Touch(ent)
    if not ent:IsPlayer() then return end
    if ent.healing then return end

    ent.healing = true
    ent.healProgress = 0
    netstream.Start(ent, "dbg.healpoint.start")

    local healInterval = self:GetHealInterval()
    local healAmount = self:GetHealAmount()
    local maxHealth = self:GetMaxHealth()

    timer.Create("heal_player_" .. ent:SteamID64(), healInterval, 0, function()
        if not IsValid(ent) then
            if IsValid(self) then
                self:StopHealing(ent)
            end
            return
        end

        local shouldCheckVehicle = self:ShouldCheckVehicle()
        if shouldCheckVehicle and not ent:InVehicle(self) then
            self:StopHealing(ent)
            return
        end

        local hp = ent:Health()
        if hp < maxHealth then
            ent:SetHealth(math.min(hp + healAmount, maxHealth))
        else
            self:StopHealing(ent)
        end
    end)
end

function ENT:StopHealing(ply)
    if not IsValid(ply) then return end
    ply.healing = false
    timer.Remove("heal_player_" .. ply:SteamID64())
    netstream.Start(ply, "dbg.healpoint.stop")
end

function ENT:EndTouch(ent)
    if not ent:IsPlayer() then return end
    self:StopHealing(ent)
end
