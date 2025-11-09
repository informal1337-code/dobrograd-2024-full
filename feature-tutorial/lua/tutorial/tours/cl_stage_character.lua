-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_character.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_character.switch', {
	steps = {
		{
			title = 'Смена профессии',
			content = 'Самое время научиться менять профессии. Для этого нужно перейти в меню настройки персонажа. Открой С-меню, выбери пункт "Сменить персонажа" и отправляйся на точку смены персонажа',
			target = {
				{
					anchor = 'dbgTutorial.switchCharacter',
					arrow = RIGHT,
				},
			},
			keybinds = {
				{
					bind = '+menu_context',
					text = 'открыть меню действий и команд',
				},
			},
		},
	},
})

dbgTutorial.tours.register('stage_character.job', {
	steps = {
		{
			align = LEFT,
			title = 'Смена профессии',
			opacity = 0,
			content = 'Выбери профессию "Городской работник", чтобы освоить свою первую работу на сервере и подзаработать немного денег. К слову, через кнопку "Сменить персонажа" ты сможешь переключаться между персонажами или настраивать их',
			contentOpacity = 1,
			target = {
				{
					anchor = 'dbgChars.selector.edit',
					arrow = TOP,
				},
				{
					anchor = 'dbgChars.editor.job',
					arrow = LEFT,
				},
				{
					anchor = 'dbgChars.editor.confirm',
					arrow = LEFT,
				},
			},
		},
	},
})