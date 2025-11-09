--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/_config/lua/config/cars/mech.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

carDealer.addCategory('mech', {
	name = 'Механики',
	icon = octolib.icons.silk16('wrench'),
	canUse = function(ply) return ply:Team() == TEAM_MECH, 'Доступно только механикам' end,
	spawns = carDealer.civilSpawns,
	spawnCheck = carDealer.limits.mech,
	limitGroup = 'mech',
})

carDealer.addVeh('towtruck', {
	category = 'mech',
	name = 'Tow Truck',
	simfphysID = 'sim_fphys_gta4_bobcat_towtruck',
	price = 30000,
	deposit = true,
})
