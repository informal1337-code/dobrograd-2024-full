-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_ending.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_ending', {
	steps = {
		{
			title = 'Конец',
			content = 'Ну вот и подошел конец этого обучения!\nЕсли у тебя остались какие-то вопросы, то смело заходи на Вики сервера, где ты можешь детальнее ознакомиться с механиками, или задавай администрации вопросы через чат, начиная сообщение с @',
			button = true,
		},
		{
			title = 'Конец',
			content = 'Чтобы вспомнить о какой-то базовой механике, ты всегда можешь открыть справку на кнопку F1. Приятной игры!',
			button = true,
		},
	},
	onFinish = function()
		dbgTutorial.quest.next()
	end,
})