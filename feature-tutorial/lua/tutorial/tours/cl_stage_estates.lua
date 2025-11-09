-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_estates.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_estates', {
	steps = {
		{
			align = TOP,
			title = 'Помещения',
			opacity = 0,
			content = 'Теперь давай купим жилье, чтобы начать строить! Подойди к двери жилого помещения и зажми кнопку использования для взаимодействия с ней. Помещение для бизнеса не подойдет! Все действующие помещения отмечены желтым цветом на карте',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+use',
					text = 'взаимодействие',
				},
			},
		},
		{
			align = TOP,
			title = 'Ключи',
			opacity = 0,
			content = 'Для открытия двери, необходимо выбрать "Руки" в панели оружия. Затем нажать кнопку атаки — для открытия замка двери, альтернативного огня — для закрытия замка. Теперь открой дверь своего дома!',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+attack',
					text = 'закрыть дверь',
				},
				{
					bind = '+attack2',
					text = 'открыть дверь',
				},
			},
		},
		{
			align = TOP,
			title = 'Строительство',
			opacity = 0,
			content = 'На Доброграде довольно обширные возможности для строительства. Чтобы начать строить, необходимо взять в руки физическую пушку и открыть меню создания. Попробуй обустроить свой дом!',
			contentOpacity = 1,
			keybinds = {
				{
					bind = 'invprev',
					text = 'открыть панель оружия',
				},
				{
					bind = '+menu',
					text = 'открыть меню создания',
				},
			},
			onEnter = function()
				hook.Add('PostRenderVGUI', 'dbgTutorial.stage_estates', function()
					octogui.drawWeaponSelector()
				end)
			end,
			onExit = function()
				hook.Remove('PostRenderVGUI', 'dbgTutorial.stage_estates')
			end,
		},
		{
			align = TOP,
			title = 'Сохранение построек',
			opacity = 0,
			content = 'Теперь сохрани постройку: используй инструмент "Advanced Duplicator 2"',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+menu',
					text = 'открыть меню создания',
				},
			},
		},
		{
			align = TOP,
			title = 'Сохранение построек',
			opacity = 0,
			content = '1. Нажми SHIFT + ПКМ - это покажет область сохранения\n2. Нажми ПКМ еще раз, чтобы подтвердить копирование\n3. В Q-меню нажми ПКМ по папке "Advanced Duplicator 2"\n4. Выбери пункт "Сохранить" и введи название файла\n5. Нажми на иконку сохранения (дискету)',
			contentOpacity = 1,
		},
		{
			title = 'Хранилище',
			content = 'Для долгосрочного хранения вещей на сервере существует хранилище. Открой С-меню, нажми "Поставить хранилище" и выбери модель для него, после чего оно появится перед тобой',
			target = {
				{
					anchor = 'dbgTutorial.placeStorage',
					arrow = RIGHT,
				},
				{
					anchor = 'dbgTutorial.placeStorage.action',
					callback = function()
						octolib.tour.hide()
						return false
					end,
				},
			},
			keybinds = {
				{
					bind = '+menu_context',
					text = 'открыть меню действий и команд',
				},
			},
		},
		{
			align = TOP,
			title = 'Хранилище',
			opacity = 0,
			content = 'Зажав кнопку использования на хранилище, ты можешь его открыть или закрепить. Объем содержимого ограничен, а само хранилище может быть взломано другими игроками, поэтому обязательно закрывай его после использования',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+use',
					text = 'использование',
				},
			},
		},
		{
			align = TOP,
			title = 'Хранилище',
			opacity = 0,
			content = 'Теперь убери хранилище, зажав кнопку использования на нем. В будущем такая возможность будет доступна только Добродеям. Кстати, после выхода из сервера хранилище еще 15 минут будет существовать в мире, поэтому не забудь про его безопасность',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+use',
					text = 'использование',
				},
			},
		},
	},
	onFinish = function()
		dbgTutorial.quest.next()
	end,
})