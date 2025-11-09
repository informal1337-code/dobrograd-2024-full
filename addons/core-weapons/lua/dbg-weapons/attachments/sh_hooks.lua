-- "addons\\core-weapons\\lua\\dbg-weapons\\attachments\\sh_hooks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add('dbgWeapons.attachments.bipods', 'dbgWeapons.kickMultiplier', function(ply, wep)
	if wep:GetNetVar('isBipodsIntalled') and ply:Crouching() then
		return 0.5
	end
end)