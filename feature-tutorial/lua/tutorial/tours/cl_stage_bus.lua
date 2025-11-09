-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_bus.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_bus', {
	steps = {
		{
			title = 'Навигация до причала',
			content = 'Теперь у тебя есть удочка! Самое время наловить рыбы, для этого тебе нужно добраться до причала у озера. Открой карту в F4-меню',
			target = {'octogui.f4', 'octogui.f4.map.tab'},
			keybinds = {
				{
					bind = 'gm_showspare2',
					text = 'открыть меню сервера',
				},
			},
			onExit = function()
				dbgTutorial.quest.next()
			end,
		},
		{
			align = TOP,
			title = 'Поездка на автобусе',
			opacity = 0,
			content = 'Теперь прокатимся по городу! Дойди до ближайшей остановки и дождись отправления автобуса!',
			contentOpacity = 1,
		},
		{
			align = BOTTOM,
			title = 'Посадка на объект',
			opacity = 0,
			content = 'Посмотри на лавочку и нажми кнопки бега и использования одновременно - так твой персонаж сядет на любой плоский предмет',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+speed',
					text = 'бег',
				},
				{
					bind = '+use',
					text = 'использование',
				},
			},
		},
		{
			align = BOTTOM,
			title = 'Поездка на автобусе',
			opacity = 0,
			content = 'Теперь дождись отправления автобуса. Как только автобус будет подъезжать, появится меню выбора остановок (белые точки на карте, после выбора она окрасится в зеленый)',
			contentOpacity = 1,
		},
	},
})