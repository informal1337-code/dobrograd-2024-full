-- "addons\\feature-police\\lua\\entities\\ent_dbg_policefines\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
	render.DrawBubble(self, Vector(0, 0.45, 7), Angle(0, 180, 90), 'Оплата штрафов', 200, 200)
end