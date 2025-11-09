--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/_config/lua/config/cars/large.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

carDealer.addCategory('large', {
	name = 'Большие',
	icon = 'octoteam/icons-16/user.png',
	queue = true,
	canUse = carDealer.checks.civil,
	spawns = carDealer.civilSpawns,
})

carDealer.addVeh('ingot2', {
	name = 'Ingot',
	simfphysID = 'sim_fphys_gta4_ingot',
	price = 1000000,
	bodygroups = {
		[1] = {
			name = 'Передний бампер',
			variants = {
				{'Заводской', 1000},
				{'С решеткой', 45000},
			},
		},
		[2] = {
			name = 'Пороги',
			variants = {
				{'Заводские', 1000},
				{'Увеличенные', 35000},
			},
		},
		[3] = {
			name = 'Решетка радиатора',
			variants = {
				{'Заводская', 1000},
				{'Без эмблемы', 25000},
			},
		},
		[4] = {
			name = 'Крыша',
			variants = {
				{'Заводская', 1000},
				{'С рейлингами', 40000},
			},
		},
	},
})

carDealer.addVeh('rebla2', {
	name = 'Rebla',
	simfphysID = 'sim_fphys_gta4_rebla',
	price = 1750000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Пороги',
			variants = {
				{'Заводские', 1000},
				{'Тюнер', 85000},
			},
		},
		[2] = {
			name = 'Передний бампер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 115000},
			},
		},
		[3] = {
			name = 'Задний бампер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 130000},
			},
		},
		[4] = {
			name = 'Спойлер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 75000},
			},
		},
		[5] = {
			name = 'Выхлоп',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 120000},
			},
		},
	},
})

carDealer.addVeh('habanero2', {
	name = 'Habanero',
	simfphysID = 'sim_fphys_gta4_habanero',
	price = 2600000,
	hasAlarm = true,
})

carDealer.addVeh('pony2', {
	name = 'Pony',
	simfphysID = 'sim_fphys_gta4_pony',
	price = 3500000,
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{'Заводская', 1000},
				{'Рейлинги', 120000},
			},
		},
	},
})

carDealer.addVeh('moonbeam2', {
	name = 'Moonbeam',
	simfphysID = 'sim_fphys_gta4_moonbeam',
	price = 3600000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{'Заводская', 1000},
				{'Рейлинги', 95000},
				{'Багажник', 650000},
			},
		},
		[2] = {
			name = 'Пороги',
			variants = {
				{'Заводские', 1000},
				{'Спортивные', 135000},
				{'Металлические', 110000},
				{'Со вставками', 140000},
			},
		},
		[3] = {
			name = 'Окна',
			variants = {
				{'Заводские', 1000},
				{'Закрытые', 60000},
			},
		},
		[4] = {
			name = 'Аксессуары',
			variants = {
				{'Заводские', 1000},
				{'Запаска + лестница', 120000},
			},
		},
		[5] = {
			name = 'Решетка',
			variants = {
				{'Заводская', 1000},
				{'Во всю ширину', 200000},
			},
		},
	},
})

carDealer.addVeh('huntley2', {
	name = 'Huntley',
	simfphysID = 'sim_fphys_gta4_huntley',
	price = 4000000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Тюнинг',
			variants = {
				{'Заводской', 1000},
				{'Выхлоп + решетка', 250000},
			},
		},
	},
})

carDealer.addVeh('mule2', {
	name = 'Mule',
	simfphysID = 'sim_fphys_gta4_mule',
	price = 4400000,
	customFOV = 38,
})

carDealer.addVeh('landstalker2', {
	name = 'Landstalker',
	simfphysID = 'sim_fphys_gta4_landstalker',
	price = 4500000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Пороги',
			variants = {
				{'Заводские', 1000},
				{'Металлические', 90000},
				{'Расширенные', 150000},
			},
		},
		[2] = {
			name = 'Крыша',
			variants = {
				{'Заводская', 1000},
				{'Рейлинги', 95000},
			},
		},
		[3] = {
			name = 'Сидения',
			variants = {
				{'Заводские', 1000},
				{'С экранами', 50000},
			}
		},
	},
})

carDealer.addVeh('patriot2', {
	name = 'Patriot',
	simfphysID = 'sim_fphys_gta4_patriot',
	price = 4850000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Тюнинг',
			variants = {
				{'Заводской', 1000},
				{'Выхлоп + огни', 320000},
			},
		},
		[2] = {
			name = 'Бампер',
			variants = {
				{'Заводской', 1000},
				{'Кунгурятник', 180000},
			},
		},
	},
})

carDealer.addVeh('cavalcade2', {
	name = 'Cavalcade',
	simfphysID = 'sim_fphys_gta4_cavalcade',
	price = 4650000,
	hasAlarm = true,
	tags = {carDealer.tags.new},
	bodygroups = {
		[1] = {
			name = 'Пороги',
			variants = {
				{'Заводские', 1000},
				{'Хромированные', 90000},
			},
		},
		[2] = {
			name = 'Крыша',
			variants = {
				{'Заводская', 1000},
				{'Рейлинги', 115000},
			},
		},
		[3] = {
			name = 'Багажник',
			variants = {
				{'Заводской', 1000},
				{'Аудиосистема', 95000},
			}
		},
	},
})
