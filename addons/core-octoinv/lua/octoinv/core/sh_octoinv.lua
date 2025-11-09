--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-octoinv/lua/octoinv/core/sh_octoinv.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

-- default data to be returned if it's missing from both class and item tables
octoinv.defaultData = {
	amount = 1,
	volume = 0,
	mass = 0,
	name = L.unknown,
	icon = 'icon16/exclamation.png',
	model = 'models/props_junk/garbage_bag001a.mdl',
}

octoinv.defaultHand = {
	name = L.inventory_hands,
	volume = 100,
	icon = octolib.icons.color('hand'),
	craft = true,
}

-- default inventory setup for new players
octoinv.defaultInventory = {
	top = {
		name = L.jacket,
		volume = 5,
		icon = octolib.icons.color('clothes_jacket'),
		items = {},
	},
	bottom = {
		name = L.pants,
		volume = 1,
		icon = octolib.icons.color('clothes_jeans'),
		items = {},
	},
	_hand = defaultHand,
}

function octoinv.getItemData(field, class, data)
	local classTbl = octoinv.items[class]
	if not classTbl then return end

	if field == 'amount' and isnumber(data) then
		return data
	end

	return istable(data) and data[field] or classTbl[field] or octoinv.defaultData[field] or nil
end

function octoinv.itemStr(item)
	local amount = isnumber(item[2]) and item[2] or octoinv.getItemData('amount', item[1], item[2])
	return ('%sx%s'):format(amount, octoinv.getItemData('name', item[1], item[2]))
end

function octoinv.makePersistent(item)
	item[2].persistent = true
	return item
end
