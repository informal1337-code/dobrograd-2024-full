-- "addons\\feature-citywork\\lua\\entities\\ent_dbg_workgarbage\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type 		= 'anim'
ENT.Base 		= 'base_gmodentity'
ENT.PrintName	= L.workgarbage
ENT.Category	= L.dobrograd
ENT.Author		= 'chelog'
ENT.Contact		= 'chelog@octothorp.team'
ENT.Spawnable = false
function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "TrashCount")
    self:NetworkVar("Int", 1, "MaxTrashCount")
    self:NetworkVar("Bool", 0, "IsCleaned")
end