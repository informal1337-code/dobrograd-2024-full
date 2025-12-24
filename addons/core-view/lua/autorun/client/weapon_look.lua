hook.Add('dbgCloseLook.getDescription', 'weapon_look', function(ent, ply)
	if not ent:IsWeapon() or not ent.IsOctoWeapon or ply:GetActiveWeapon() ~= ent or ent:GetNetVar('IsReady') then return end

	local name = 'Оружие'
	local desc = ''
	local params = {}

	local itemData = ent:GetNetVar('itemData')
	if itemData then
		name = itemData.name or name
	else
		local wepData = weapons.Get(ent:GetClass())
		name = wepData.PrintName
	end

	if ent.currentFireMode then
		params[#params + 1] = L.weapon_mode .. L['weapon_mode_' .. ent.FireModes[ent.currentFireMode]]
	end

	local clip1 = ent:Clip1()
	if clip1 ~= -1 then
		params[#params + 1] = 'Патронов в магазине: ' .. clip1
		params[#params + 1] = 'Патронов в запасе: ' .. ent:Ammo1()
	end

	for _, v in ipairs(params) do
		desc = desc .. '- ' .. v .. '\n'
	end

	return {
		name = name,
		desc = desc,
		time = 2,
		bone = 'ValveBiped.Bip01_R_Hand',
		attachment = 'shell',
		eyeAngles = {60, 75},
	}

end)