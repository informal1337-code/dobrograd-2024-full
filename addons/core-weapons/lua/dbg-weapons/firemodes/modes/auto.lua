-- "addons\\core-weapons\\lua\\dbg-weapons\\firemodes\\modes\\auto.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgWeapons.registerFireMode('auto', {
	init = function(wep)
		wep.Primary.Automatic = true
	end,
	shoot = function(wep)
		wep:ShootBullet()
		return 1 / (wep.Primary.RPM / 60)
	end,
})