-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_mailbox.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_mailbox', {
	steps = {
		{
			title = 'Инвентарь: Контейнеры',
			content = 'Не только у персонажа есть контейнеры для предметов, но и у других объектов. Открой контейнер для получения',
			target = {
				'octoinv.toggle',
				{
					anchor = function()
						return 'octoinv.containers.' .. LocalPlayer():SteamID()
					end,
					arrow = TOP,
				},
			},
			keybinds = {
				{
					bind = '+menu',
					text = 'открыть инвентарь',
				},
			},
		},
		{
			title = 'Инвентарь: Перемещение',
			opacity = 0,
			content = 'Чтобы переместить предмет из одного контейнера в другой, нужно сначала их открыть, а затем перетащить предмет из одного контейнера в другой, прямо как файлы на рабочем столе!',
			contentOpacity = 1,
			target = {
				{
					anchor = 'octoinv.containers.top',
					arrow = TOP,
					callback = octolib.func.no,
				},
			},
		},
		{
			title = 'Инвентарь: Использование',
			opacity = 0,
			content = 'С предметами тоже можно взаимодействовать! Просто нажми по предмету в инвентаре, чтобы открыть меню взаимодействия. Сейчас включи свой телефон',
			contentOpacity = 1,
			keybinds = {
				{
					key = MOUSE_LEFT,
					text = 'взаимодействие с предметом',
				},
			},
		},
		{
			title = 'Телефон',
			content = 'Поздравляем! Теперь ты сможешь получать сообщения, совершать звонки и оформлять заказы в магазине',
			button = true,
			onExit = function()
				dbgTutorial.quest.next()
			end,
		},
	},
})