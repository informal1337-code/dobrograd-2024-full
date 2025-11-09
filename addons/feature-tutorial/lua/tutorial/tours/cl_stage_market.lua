-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_market.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_market.intro', {
	steps = {
		{
			title = 'Рынок',
			content = 'Мы уже упоминали, что у нас есть рынок, поэтому давай научимся с ним взаимодействовать! Для начала подойди к ближайшему почтовому ящику — он был отмечен на твоем экране',
			button = true,
		},
	},
})

dbgTutorial.tours.register('stage_market', {
	steps = {
		{
			align = TOP,
			title = 'Рынок',
			opacity = 0,
			content = 'Для выставления предметов на рынок их нужно отправить. Открой контейнер "Отправка" и положи предметы',
			contentOpacity = 1,
			target = {
				{
					anchor = 'octoinv.containers.send',
					arrow = TOP,
					callback = octolib.func.no,
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
			title = 'Рынок',
			content = 'Отлично, теперь зайди на "Рынок" в F4-меню',
			target = {
				'octogui.f4',
				{
					anchor = 'octogui.f4.octoinv.market.tab',
					arrow = TOP,
				},
			},
			keybinds = {
				{
					bind = 'gm_showspare2',
					text = 'открыть меню сервера',
				},
			},
		},
		{
			align = RIGHT,
			title = 'Рынок',
			opacity = 0,
			content = 'Теперь найди предмет, который ты хочешь продать, укажи цену и выстави его на продажу',
			target = {
				{
					anchor = 'octoinv.market.search',
					arrow = LEFT,
					callback = octolib.func.no,
				},
				{
					anchor = 'octoinv.market.sellItem',
					arrow = LEFT,
					callback = octolib.func.no,
				},
				{
					anchor = 'octoinv.market.createConfirm',
					arrow = BOTTOM,
					callback = octolib.func.no,
				},
			},
		},
		{
			title = 'Рынок',
			content = 'Вот ты и выставил свой первый предмет на продажу. Теперь ты знаешь, как продавать подобные предметы',
			button = true,
		},
	},
	onFinish = function()
		dbgTutorial.quest.next()
	end,
})