--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/_config/lua/config/cars/event.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

carDealer.addCategory('event', {
	name = 'Ивентовые',
	icon = octolib.icons.silk16('star'),
	queue = true,
	canSee = carDealer.checks.no,
	canUse = carDealer.checks.civil,
	spawns = carDealer.civilSpawns,
})

carDealer.addVeh('halloween_sedan', {
	name = 'Peyote',
	simfphysID = 'sim_fphys_gta4_peyote',
	price = 0,
	tags = {carDealer.tags.halloween},
	default = {
		col = {Color(192, 91, 23), Color(16, 16, 16), Color(0,0,0)},
	},
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{'Заводская', 1000},
				{'Закрытая', 320000},
			},
		},
		[2] = {
			name = 'Заднее крепление',
			variants = {
				{'Ничего', 1000},
				{'Запаска', 185000},
			},
		},
		[3] = {
			name = 'Сидения',
			variants = {
				{'Заводские', 1000},
				{'Зебра', 210000},
				{'Черные', 75000},
			},
		},
	},
})

carDealer.addVeh('halloween_pickup', {
	name = 'Regina',
	simfphysID = 'sim_fphys_tlad_regina',
	price = 0,
	tags = {carDealer.tags.halloween},
	default = {
		col = {Color(192, 91, 23), Color(16, 16, 16), Color(0,0,0)},
	},
})

carDealer.addVeh('halloween_bender', {
	name = 'Bender',
	simfphysID = 'sim_fphys_gta4_virgo',
	price = 0,
	tags = {carDealer.tags.halloween},
	default = {
		col = {Color(16, 16, 16), Color(192, 91, 23), Color(0,0,0)},
	},
})

carDealer.addVeh('halloween_falcon', {
	name = 'Falcon',
	simfphysID = 'sim_fphys_gta4_vigero2',
	price = 0,
	tags = {carDealer.tags.halloween},
	default = {
		col = {Color(192, 91, 23), Color(0,0,0)},
		bg = {[1] = 2}
	},
	bodygroups = {
		[1] = {
			name = 'Корпус',
			variants = {
				{'Побитый справа', 1000},
				{'Побитый слева', 1000},
				{'Восстановленный', 350000},
			},
		},
	},
})
