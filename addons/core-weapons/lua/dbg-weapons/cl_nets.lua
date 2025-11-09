-- "addons\\core-weapons\\lua\\dbg-weapons\\cl_nets.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
net.Receive('octoweapons.sound', function(len, ply)
	local amount = net.ReadUInt(5)
	local pos = net.ReadVector()
	for _ = 1, amount do
		sound.Play(net.ReadString(), pos)
	end
end)

net.Receive('octoweapons.shootEffects', function(len, ply)
	local wep = net.ReadEntity()
	if not IsValid(wep) or wep:GetOwner() == LocalPlayer() then
		return
	end

	wep:ShootEffects()
end)

netstream.Hook('dbgWeapons.syncParameters', function(wep, params)
	if not IsValid(wep) or not wep.IsOctoWeapon then return end

	table.Merge(wep, params)
end)