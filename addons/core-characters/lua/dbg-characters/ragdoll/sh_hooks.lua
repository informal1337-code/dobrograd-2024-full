-- "addons\\core-characters\\lua\\dbg-characters\\ragdoll\\sh_hooks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add('PlayerSwitchWeapon', 'dbgChars.ragdoll', function(ply)
	if ply:GetNetVar('Ragdolled') then
		return true
	end
end)
