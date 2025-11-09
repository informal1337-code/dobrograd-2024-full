--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-characters/lua/cmenu/items/clothes.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local function hasMask(ply, slot, mask)
	local curMasks = ply:GetNetVar('hMask')
	if not istable(curMasks) then return false end

	local maskData = curMasks[slot]
	return maskData and maskData.mask == mask
end

octogui.cmenu.registerItem('clothes', 'gasmask', {
	text = function(ply)
		return ('%s противогаз'):format(hasMask(ply, 'eyes', 'gasmask') and 'Снять' or 'Надеть')
	end,
	icon = octolib.icons.silk16('arrow_rotate_clockwise'),
	check = function(ply)
		return ply:GetActiveRank('dpd') == 'swat'
			or ply:GetActiveRank('wcso') == 'seb'
	end,
	say = '/gasmask',
})

octogui.cmenu.registerItem('clothes', 'medmask', {
	text = function(ply)
		return ('%s мед. маску'):format(hasMask(ply, 'mouth', 'medical_mask') and 'Снять' or 'Надеть')
	end,
	icon = octolib.icons.silk16('arrow_rotate_clockwise'),
	check = function(ply)
		return ply:isMedic()
	end,
	say = '/medmask',
})

octogui.cmenu.registerItem('clothes', 'takeoff', {
	text = 'Снять',
	icon = octolib.icons.silk16('attach'),
	options = function(ply)
		local options = {}

		local maskOptions = {}
		for slot, mask in pairs(dbgChars.masks.getCurMasks(ply)) do
			local text = mask and mask.name or ('Аксессуар: слот "%s"'):format(slot)
			if maskOptions[text] then continue end

			table.insert(options, {
				text = text,
				netstream = {'dbgChars.masks.unequip', slot},
				icon = 'octoteam/icons-16/kids.png',
			})

			maskOptions[text] = true
		end

		local customClothes = ply:GetNetVar('customClothes')
		if customClothes ~= nil then
			table.insert(options, {
				text = istable(customClothes) and customClothes.name or 'Одежду',
				netstream = 'dbgChars.clothes.unequip',
				icon = 'octoteam/icons-16/shirt_polo.png',
			})
		elseif ply:GetNetVar('warmClothes') ~= nil then
			table.insert(options, {
				text = 'Одежду',
				netstream = 'dbgChars.clothes.unequip',
				icon = 'octoteam/icons-16/shirt_polo.png',
			})
		end

		return options
	end,
})
