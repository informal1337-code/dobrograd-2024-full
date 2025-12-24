include('shared.lua')

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
end

netstream.Hook("dbg.healpoint.start", function()
    LocalPlayer():ChatPrint("Вы зашли в зону лечения. Ваше здоровье будет восстанавливаться.")
end)

netstream.Hook("dbg.healpoint.stop", function()
    LocalPlayer():ChatPrint("[#] Лечение остановлено")
end)
