--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/_config/lua/config/octomap/maps/rp_ndbg_winter.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

-- rp_ndbg_winter

local config = octomap.config
config.url = 'rpMx7yf.png'
config.streetsUrl = 'xPEbjE5.png'
config.buildingsUrl = 'VWW2AAE.png'
config.addX = -10
config.addY = 10
config.relX = 0.1003
config.relY = -0.1003
config.mapW = 4096
config.mapH = 4096
config.scaleMin = 0.18
config.scaleMax = 1
config.bgCol = Color(175, 212, 185)

config.markers = {
	{
		name = 'Причал',
		icon = 'octoteam/icons-16/clown_fish.png',
		pos = {
			Vector(-11390, 9803, -16),
			Vector(-8101, 10415, -30),
		},
	},
	{
		name = 'Банкомат',
		icon = 'octoteam/icons-16/card_money.png',
		sort = 1200,
		pos = {
			Vector(-14513, -14270, 0),
			Vector(-7360, -10767, 0),
			Vector(-2829, -5293, 0),
			Vector(4018, 14162, 0),
			Vector(-11543, -10767, 0),
			Vector(7520, 12333, 0),
			Vector(-12785, -14098, 0),
		},
	},
	{
		name = 'Заправка',
		icon = 'octoteam/icons-16/gas.png',
		sort = 1200,
		pos = {
			Vector(-11581, -7261, 0),
			Vector(12666, 12664, 0),
		},
	},
	{
		name = 'Шахта',
		icon = 'octoteam/icons-16/helmet_mine.png',
		pos = Vector(9179, 2558, -49),
	},
	{
		name = 'Мотель',
		icon = 'octoteam/icons-16/luggage.png',
		pos = Vector(9649, -4076, -21),
	},
	{
		name = 'Правительство',
		icon = 'octoteam/icons-16/entity.png',
		pos = Vector(-9203, -14306, 0),
	},
	{
		name = 'Полицейский департамент',
		icon = 'octoteam/icons-16/security.png',
		pos = Vector(-11009, -11517, 16),
	},
	{
		name = 'Медицинский центр',
		icon = 'octoteam/icons-16/health.png',
		pos = Vector(-7490, -11015, 0),
	},
	{
		name = 'Церковь',
		icon = 'octoteam/icons-16/church.png',
		pos = Vector(-5756, -2749, 24),
	},
}
