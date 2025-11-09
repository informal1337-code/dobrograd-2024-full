-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_atm.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_atm.intro', {
	steps = {
		{
			title = 'Банкомат',
			content = 'Загляни в свои карманы, так хранить деньги — непорядок, их могут украсть! Сходи и положи их в банк через ближайший банкомат. Найти его сможешь на карте',
			target = {'octogui.f4'},
			keybinds = {
				{
					bind = 'gm_showspare2',
					text = 'открыть меню сервера',
				},
				{
					bind = '+menu',
					text = 'открыть инвентарь',
				},
			},
		},
	},
})

dbgTutorial.tours.register('stage_atm', {
	steps = {
		{
			align = TOP,
			title = 'Банкомат',
			opacity = 0,
			content = 'Меню управления банкоматом очень простое: ты можешь положить или снять деньги. Выбрав нужную операцию, просто введи сумму и подтверди действие — деньги будут либо зачислены на счет, либо сняты с него',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+use',
					text = 'взаимодействие с банкоматом',
				},
			},
		},
	},
})