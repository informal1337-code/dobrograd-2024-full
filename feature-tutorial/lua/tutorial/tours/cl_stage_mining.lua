-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_mining.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_mining.order', {
	steps = {
		{
			title = 'Покупка кирки',
			content = 'Теперь давай заглянем в шахту, но перед этим обязательно прикупи себе кирку через магазин',
			target = {'octogui.f4', 'octogui.f4.shop.tab'},
			keybinds = {
				{
					bind = 'gm_showspare2',
					text = 'открыть меню сервера',
				},
			},
		},
	},
})

dbgTutorial.tours.register('stage_mining.navigation', {
	steps = {
		{
			title = 'Навигация до шахты',
			content = 'Самое время отправиться в шахту и добыть руды, ведь добытое сырье хорошо продается на рынке и может стать источником для заработка. Доберись до шахты!',
			target = {'octogui.f4', 'octogui.f4.map.tab'},
			keybinds = {
				{
					bind = 'gm_showspare2',
					text = 'открыть меню сервера',
				},
			},
		},
	},
})

dbgTutorial.tours.register('stage_mining.mining', {
	steps = {
		{
			align = TOP,
			title = 'Шахта',
			opacity = 0,
			content = 'Возьми кирку в руки через инвентарь. Затем, используя "Приглядывание", найди жилу с рудой и просто бей по ней, пока не разобьешь. Добудь 3 штуки любой руды, чтобы двигаться дальше!',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+attack',
					text = 'бить киркой',
				},
			},
		},
		{
			title = 'Шахта',
			content = 'Поздравляем! Теперь ты можешь попробовать продать эти предметы или оставить их на будущее',
			button = true,
		},
	},
	onFinish = function()
		dbgTutorial.quest.next()
	end,
})