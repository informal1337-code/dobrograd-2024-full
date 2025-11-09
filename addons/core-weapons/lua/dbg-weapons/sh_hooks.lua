-- "addons\\core-weapons\\lua\\dbg-weapons\\sh_hooks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add('KeyPress', 'dbg.weapons', function(ply, key)
	local attack1 = key == IN_ATTACK
	local attack2 = key == IN_ATTACK2
	if not attack1 and not attack2 then return end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return end

	if attack1 and wep.PrimaryAttackPressed then wep:PrimaryAttackPressed() end
	if attack2 and wep.SecondaryAttackPressed then wep:SecondaryAttackPressed() end
end)

hook.Add('KeyRelease', 'dbg.weapons', function(ply, key)
	local attack1 = key == IN_ATTACK
	local attack2 = key == IN_ATTACK2
	if not attack1 and not attack2 then return end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return end

	if attack1 and wep.PrimaryAttackReleased then wep:PrimaryAttackReleased() end
	if attack2 and wep.SecondaryAttackReleased then wep:SecondaryAttackReleased() end
end)