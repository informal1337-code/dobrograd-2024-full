AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

util.AddNetworkString("dbg-police.fines.openMenu")

function ENT:Initialize()
	self:SetModel('models/props/cs_office/offcorkboarda.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
end

function ENT:Use(ply)
	if not IsValid(ply) then return end
	
	local fines = dbgPolice.fines.get(ply)
	if table.Count(fines) == 0 then
		ply:Notify('У вас нет неоплаченных штрафов')
		return
	end
	
	net.Start("dbg-police.fines.openMenu")
	net.WriteEntity(ply)
	net.WriteTable(fines)
	net.Send(ply)
end