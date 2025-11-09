-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_job.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_job.intro', {
	steps = {
		{
			title = 'Первое задание',
			content = 'Давай научимся чему-то новому - доберись до стройки',
			button = true,
		},
	},
})

dbgTutorial.tours.register('stage_job', {
	steps = {
		{
			align = TOP,
			title = 'Первое задание',
			opacity = 0,
			content = 'Теперь зайди в F4-меню, открой вкладку "Задания" и прими задание "Помощь по стройке"',
			contentOpacity = 1,
			keybinds = {
				{
					bind = 'gm_showspare2',
					text = 'открыть меню сервера',
				},
			},
		},
		{
			align = TOP,
			title = 'Первое задание',
			opacity = 0,
			content = 'Чтобы тащить объекты, выбери "Руки", наведись на объект и зажми кнопку перетаскивания. Выполни задание!',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+attack',
					text = 'тащить объект',
				},
			},
		},
		{
			title = 'Первое задание',
			content = 'Отлично! Награда за выполненную работу перечислена на твой банковский счет. Также запомни, что во вкладке "Задания" ты всегда можешь найти подработку',
			button = true,
		},
	},
	onFinish = function()
		dbgTutorial.quest.next()
	end,
})