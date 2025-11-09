-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_cityworker.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_cityworker.intro', {
	steps = {
		{
			title = 'Городской работник',
			content = 'Давай заработаем первые деньги и немного изучим город! Выполни 3 задания, играя за городского рабочего',
			button = true,
		},
	},
})

dbgTutorial.tours.register('stage_cityworker.outro', {
	steps = {
		{
			title = 'Городской работник',
			content = 'Отлично! Если тебе понадобится подзаработать, ты знаешь, что можно стать городским работником. Теперь сдай форму, чтобы продолжить обучение (зажми кнопку использования на ящике рабочего)',
			button = true,
		},
	},
})