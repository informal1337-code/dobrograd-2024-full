-- "addons\\feature-citywork\\lua\\entities\\ent_dbg_workgraffiti\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include 'shared.lua'

function ENT:Draw()
	self.BaseClass.Draw(self)

	if octolib.drawDebug then
		self:DrawModel()
	end
end
