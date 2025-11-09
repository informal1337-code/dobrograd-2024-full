--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/_config/lua/config/cars/4doors.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

carDealer.addCategory('4doors', {
	name = 'Четырехдверные',
	icon = 'octoteam/icons-16/user.png',
	queue = true,
	canUse = carDealer.checks.civil,
	spawns = carDealer.civilSpawns,
})

carDealer.addVeh('premier2', {
	name = 'Premier',
	simfphysID = 'sim_fphys_gta4_premier',
	price = 450000,
})

carDealer.addVeh('esperanto2', {
	name = 'Esperanto',
	simfphysID = 'sim_fphys_gta4_esperanto',
	price = 600000,
})

carDealer.addVeh('dilettante2', {
	name = 'Dilettante',
	simfphysID = 'sim_fphys_gta4_dilettante',
	price = 700000,
})

carDealer.addVeh('merit2', {
	name = 'Merit',
	simfphysID = 'sim_fphys_gta4_merit',
	price = 850000,
})

carDealer.addVeh('pinnacle2', {
	name = 'Pinnacle',
	simfphysID = 'sim_fphys_gta4_pinnacle',
	price = 1100000,
	tags = {carDealer.tags.new},
})

carDealer.addVeh('df2', {
	name = 'DF8-90',
	simfphysID = 'sim_fphys_gta4_df8',
	price = 1350000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Спойлер',
			variants = {
				{'Заводской', 1000},
				{'Высокий', 180000},
				{'Низкий', 120000},
			},
		},
	},
})

carDealer.addVeh('emperor2', {
	name = 'Emperor',
	simfphysID = 'sim_fphys_gta4_emperor',
	price = 1450000,
	hasAlarm = true,
})

carDealer.addVeh('schafter2', {
	name = 'Schafter',
	simfphysID = 'sim_fphys_gta4_schafter',
	price = 2000000,
	hasAlarm = true,
	default = {
		bg = {[1] = 1},
	},
	bodygroups = {
		[1] = {
			name = 'Решетка',
			variants = {
				{'Частая', 95000},
				{'Заводская', 1000},
			},
		},
		[2] = {
			name = 'Передний бампер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 120000},
			},
		},
		[3] = {
			name = 'Пороги',
			variants = {
				{'Заводские', 1000},
				{'Тюнер', 90000},
			},
		},
		[4] = {
			name = 'Задний бампер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 135000},
			},
		},
	},
})

carDealer.addVeh('vincent2', {
	name = 'Vincent',
	simfphysID = 'sim_fphys_gta4_vincent',
	price = 2200000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Спойлер',
			variants = {
				{'Заводской', 1000},
				{'Спортивный', 115000},
			},
		},
	},
})

carDealer.addVeh('marbella2', {
	name = 'Marbella',
	simfphysID = 'sim_fphys_gta4_marbella',
	price = 2450000,
	hasAlarm = true,
	tags = {carDealer.tags.new},
})

carDealer.addVeh('intruder2', {
	name = 'Intruder',
	simfphysID = 'sim_fphys_gta4_intruder',
	price = 2750000,
	hasAlarm = true,
	tags = {carDealer.tags.new},
	bodygroups = {
		[1] = {
			name = 'Передний бампер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 120000},
			},
		},
		[2] = {
			name = 'Задний бампер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 135000},
			},
		},
		[3] = {
			name = 'Пороги',
			variants = {
				{'Заводские', 1000},
				{'Тюнер', 110000},
			},
		},
		[4] = {
			name = 'Спойлер',
			variants = {
				{'Заводской', 1000},
				{'Спортивный', 140000},
			},
		},
		[5] = {
			name = 'Аксессуар',
			variants = {
				{'Ничего', 1000},
				{'Подвеска на зеркало', 90000},
			},
		},
	},
})

carDealer.addVeh('admiral2', {
	name = 'Admiral',
	simfphysID = 'sim_fphys_gta4_admiral',
	price = 3200000,
	hasAlarm = true,
})

carDealer.addVeh('oracle2', {
	name = 'Oracle',
	simfphysID = 'sim_fphys_gta4_oracle',
	price = 3600000,
	hasAlarm = true,
	tags = {carDealer.tags.new},
	default = {
		bg = {[2] = 1},
	},
	bodygroups = {
		[1] = {
			name = 'Пороги и выхлоп',
			variants = {
				{'Заводские', 1000},
				{'Тюнер', 160000},
			},
		},
		[2] = {
			name = 'Значки',
			variants = {
				{'Ничего', 60000},
				{'Заводские', 1000},
			},
		},
		[3] = {
			name = 'Передний бампер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 125000},
			},
		},
		[4] = {
			name = 'Задний бампер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 95000},
			},
		},
	},
})

carDealer.addVeh('cognoscenti2', {
	name = 'Cognoscenti',
	simfphysID = 'sim_fphys_gta4_cognoscenti',
	price = 5250000,
	hasAlarm = true,
})

carDealer.addVeh('superdiamond2', {
	name = 'Super Diamond',
	simfphysID = 'sim_fphys_tbogt_superd',
	price = 5800000,
	hasAlarm = true,
})

carDealer.addVeh('superdiamond-coupe2', {
	name = 'Super Diamond Coupe',
	simfphysID = 'sim_fphys_tbogt_superd2',
	price = 6000000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{'Заводская', 1000},
				{'Мягкая', 450000},
			},
		},
	},
})

--
-- DOBRO
--

carDealer.addVeh('hakumai2', {
	name = 'Hakumai',
	simfphysID = 'sim_fphys_gta4_hakumai',
	price = 2250000,
	hasAlarm = true,
	bodygroups = {
		[1] = {
			name = 'Пороги',
			variants = {
				{'Заводские', 1000},
				{'Тюнер', 140000},
			},
		},
		[2] = {
			name = 'Спойлер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 180000},
			},
		},
		[3] = {
			name = 'Передний бампер',
			variants = {
				{'Заводской', 1000},
				{'Тюнер', 145000},
			},
		},
		[4] = {
			name = 'Огни',
			variants = {
				{'Заводские', 1000},
				{'Противотуманки', 95000},
			},
		},
	},
	canUse = carDealer.checks.dobro,
	tags = {carDealer.tags.dobro},
})

--
-- EVENT
--

carDealer.addVeh('halloween_pickup', {
	name = 'Regina',
	simfphysID = 'sim_fphys_tlad_regina',
	price = 0,
	tags = {carDealer.tags.halloween},
	canSee = carDealer.checks.no,
	canUse = carDealer.checks.civil,
})
