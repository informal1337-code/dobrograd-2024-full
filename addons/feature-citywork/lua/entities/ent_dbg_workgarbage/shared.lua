ENT.Type = 'anim'
ENT.Base = 'base_entity'
ENT.PrintName	= L.workgarbage
ENT.Category	= L.dobrograd
ENT.Author		= 'chelog'
ENT.Contact		= 'pidaras'
ENT.Spawnable = false
function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "TrashCount")
    self:NetworkVar("Int", 1, "MaxTrashCount")
    self:NetworkVar("Bool", 0, "IsCleaned")
end