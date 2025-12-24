ENT.Type 		= "anim"
ENT.Base 		= "base_gmodentity"
ENT.PrintName	= "Точка лечения"
ENT.Category	= L.dobrograd or "Доброград"
ENT.Author		= "chelog"
ENT.Contact		= "chelog@octothorp.team"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.HealAmount = 1
ENT.HealInterval = 0.5
ENT.MaxHealth = 100
ENT.UseVehicleCheck = true

function ENT:GetHealAmount()
    return self.HealAmount or 1
end

function ENT:GetHealInterval()
    return self.HealInterval or 0.5
end

function ENT:GetMaxHealth()
    return self.MaxHealth or 100
end

function ENT:ShouldCheckVehicle()
    return self.UseVehicleCheck ~= false
end
