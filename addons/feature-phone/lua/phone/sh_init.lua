-- "addons\\feature-phone\\lua\\phone\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local meta = FindMetaTable('Player')

function meta:IsUsingPhone()
	return self:GetNetVar('UsingPhone', false)
end