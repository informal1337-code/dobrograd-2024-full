--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/_config/lua/config/cars/police.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

carDealer.addCategory('police', {
	name = 'Полицейские',
	ems = true,
	icon = 'octoteam/icons-16/user_policeman_white.png',
	canUse = function(ply) return ply:isCP() and ply:Team() ~= TEAM_FBI and ply:Team() ~= TEAM_WCSO and ply:Team() ~= TEAM_MAYOR, 'Доступно только полиции' end,
	spawns = carDealer.policeSpawns,
	spawnCheck = carDealer.limits.police,
	limitGroup = 'police',
})

carDealer.addVeh('police-vapid', {
	category = 'police',
	name = 'Police Vapid',
	simfphysID = 'sim_fphys_gta4_police',
	price = 30000,
	deposit = true,
	police = true,
	radioWhitelist = carDealer.policeRadioStations,
})

carDealer.addVeh('police-merit', {
	category = 'police',
	name = 'Police Merit',
	simfphysID = 'sim_fphys_gta4_police2',
	price = 40000,
	deposit = true,
	police = true,
	radioWhitelist = carDealer.policeRadioStations,
})

-- carDealer.addVeh('police-patriot', {
-- 	category = 'police',
-- 	name = 'Police Patriot',
-- 	simfphysID = 'sim_fphys_gta4_polpatriot',
-- 	price = 50000,
-- 	deposit = true,
-- 	police = true,
-- 	canUse = carDealer.checks.dobro,
-- 	tags = { carDealer.tags.dobro },
--	radioWhitelist = carDealer.policeRadioStations,
-- })

carDealer.addVeh('police-buffalo', {
	category = 'police',
	name = 'Police Buffalo',
	simfphysID = 'sim_fphys_tbogt_police3',
	price = 75000,
	deposit = true,
	police = true,
	canUse = function(ply)
		if ply:Team() == TEAM_DPD then return true end
		if ply:isCP() and ply:Team() ~= TEAM_FBI and ply:Team() ~= TEAM_MAYOR then return carDealer.checks.dobro(ply) end
		return false
	end,
	tags = { carDealer.tags.dobro },
	radioWhitelist = carDealer.policeRadioStations,
})

-- carDealer.addVeh('police-enforcer', {
-- 	category = 'police',
-- 	name = 'Enforcer',
-- 	simfphysID = 'sim_fphys_gta4_nstockade',
-- 	price = 55000,
-- 	customFOV = 38,
-- 	deposit = true,
-- 	police = true,
-- 	bulletproof = true,
-- 	canUse = carDealer.checks.dobro,
-- 	tags = { carDealer.tags.dobro },
--	radioWhitelist = carDealer.policeRadioStations,
-- })
