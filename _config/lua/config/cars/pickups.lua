--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/_config/lua/config/cars/pickups.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

carDealer.addCategory('pickups', {
	name = 'Пикапы',
	icon = 'octoteam/icons-16/user.png',
	queue = true,
	canUse = carDealer.checks.civil,
	spawns = carDealer.civilSpawns,
})

carDealer.addVeh('bobcat2', {
	name = 'Bobcat',
	simfphysID = 'sim_fphys_gta4_bobcat',
	price = 550000,
	bodygroups = {
		[1] = {
			name = 'Стойка',
			variants = {
				{ 'Заводская', 1000 },
				[5] = { 'Укрепленная', 145000 },
			},
		},
		[2] = {
			name = 'Багажник',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Маленький', 90000 },
				{ 'Полный', 265000 },
			},
		},
		[3] = {
			name = 'Бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Кенгурятник', 80000 },
			},
		},
	},
})

carDealer.addVeh('rancher2', {
	name = 'Rancher',
	simfphysID = 'sim_fphys_gta4_rancher',
	price = 1200000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Кузов',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Короб', 550000 },
				{ 'Стойка', 180000 },
			},
		},
		[2] = {
			name = 'Бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Кенгурятник', 90000 },
				{ 'Фонари', 95000 },
			},
		},
	},
})

carDealer.addVeh('contender2', {
	name = 'Contender',
	simfphysID = 'sim_fphys_gta4_e109',
	price = 3500000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Кузов',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Козырек + покрытие', 325000 },
				{ 'Жеское покрытие', 280000 },
				{ 'Козырек', 65000 },
				{ 'Стойка + покрытие', 450000 },
			},
		},
		[2] = {
			name = 'Бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Кенгурятник', 145000 },
			},
		},
	},
})
