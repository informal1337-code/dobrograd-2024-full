-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_crafting.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_crafting.intro', {
	steps = {
		{
			title = 'Создание предметов',
			opacity = 0,
			content = 'На сервере существует множество предметов, которые можно получить только путем крафта из других предметов. Все рецепты крафтов есть в разделе "Справочник" в F4-меню. Открой его и посмотри, какие предметы существуют на сервере',
			contentOpacity = 1,
			target = {'octogui.f4', 'octogui.f4.octoinv.help.tab'},
			keybinds = {
				{
					bind = 'gm_showspare2',
					text = 'открыть F4-меню',
				},
			},
			onExit = function()
				netstream.Start(octoquests.tempHookId(LocalPlayer(), 'dbgTutorial.onHelpOpened'))
			end,
		},
		{
			align = RIGHT,
			title = 'Создание предметов',
			opacity = 0,
			content = 'Все крафты и процессы разделены по категориям для удобства. Сейчас найди крафт удочки и купи нужные предметы для ее создания. Не забудь использовать доставку "Эксклюзив"!',
			contentOpacity = 1,
			onEnter = function()
				timer.Create('dbgTutorial.stage_crafting.init', 15, 1, function()
					octolib.tour.finish()
				end)
			end,
			onExit = function()
				timer.Remove('dbgTutorial.stage_crafting.init')
			end,
		},
	},
})

dbgTutorial.tours.register('stage_crafting', {
	steps = {
		{
			title = 'Создание предметов',
			content = 'Чтобы скрафтить предмет, для начала нужно открыть инвентарь и сложить все предметы в руки, если ты это еще не сдела',
			target = {'octoinv.containers._hand'},
			keybinds = {
				{
					bind = '+menu',
					text = 'открыть инвентарь',
				},
			},
		},
		{
			align = TOP,
			title = 'Создание предметов',
			opacity = 0,
			content = 'Нажми на молоточек в окне контейнера рук и выбери предмет, который ты хочешь скрафтить. Попробуй собрать удочку!',
			contentOpacity = 1,
			target = {
				{
					anchor = 'octoinv.craft',
					arrow = TOP,
				},
			},
		},
	},
})