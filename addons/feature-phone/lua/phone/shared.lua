local meta = FindMetaTable 'Player'
--addons\feature-phone\lua\phone\shared.lua
function meta:IsUsingPhone()
	return self:GetNetVar('UsingPhone', false)
end