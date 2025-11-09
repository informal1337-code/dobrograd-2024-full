-- "addons\\core-weapons\\lua\\dbg-weapons\\scare\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add('PlayerSwitchWeapon', 'dbg-scare', function(ply, oldW, newW)
	if ply:GetAccumulatableValue('dbgWeapons.scare') > 0.6 and IsValid(newW) and newW:GetClass() ~= 'weapon_cuffed' then
		return true
	end
end)
