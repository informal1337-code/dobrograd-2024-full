-- "addons\\feature-citywork\\lua\\entities\\ent_dbg_workgraffiti\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type 		= 'anim'
ENT.Base 		= 'imgscreen'
ENT.PrintName	= L.workgraffiti
ENT.Category	= L.dobrograd
ENT.Author		= 'chelog'
ENT.Contact		= 'chelog@octothorp.team'

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Cleaned")
end
