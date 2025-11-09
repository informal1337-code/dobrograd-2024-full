-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_hunger.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_hunger.intro', {
	steps = {
		{
			title = 'Голод',
			content = 'Голод — важная потребность персонажа! Еду можно купить как в магазине, так и в кафе, которые открывают другие игроки с профессией "Повар". Сейчас либо закажи еду через телефон, либо найди кафе и приобрети еду там',
			button = true,
		},
	},
})

dbgTutorial.tours.register('stage_hunger', {
	steps = {
		{
			title = 'Голод',
			content = 'Теперь открой инвентарь и съешь свой первый перекус',
			target = {'octoinv.toggle'},
			keybinds = {
				{
					bind = '+menu',
					text = 'открыть инвентарь',
				},
			},
		},
		{
			title = 'Голод',
			opacity = 0,
			content = 'Чтобы съесть еду, нужно открыть меню взаимодействия с предметом и выбрать любой вариант употребления. К слову, еда может надоесть персонажу, если он будет кушать одно и тоже — это снизит сытость блюд из одной категории',
			contentOpacity = 1,
			keybinds = {
				{
					key = MOUSE_LEFT,
					text = 'взаимодействие с предметом',
				},
			},
		},
		{
			title = 'Голод',
			content = 'Когда голод опустится до нуля, твой персонаж перестанет бегать. Кстати, самую сытную еду могут приготовить только игроки с профессией "Повар"',
			target = {
				{
					anchor = 'octoinv.bars.hunger',
					arrow = TOP,
				},
			},
			button = true,
		},
	},
	onFinish = function()
		timer.Simple(3, function()
			dbgTutorial.quest.next()
		end)
	end,
})