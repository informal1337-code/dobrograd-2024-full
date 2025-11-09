-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_hands.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_hands', {
	steps = {
		{
			title = 'Руки и инвентарь',
			opacity = 1,
			content = 'Основа основ — инвентарь, показатели здоровья и сытости персонажа. Чтобы открыть инвентарь, выбери "Руки" в панели оружия, затем нажми кнопку инвентаря',
			target = {'octoinv.toggle'},
			keybinds = {
				{
					bind = 'invprev',
					text = 'открыть панель оружия',
				},
				{
					bind = '+menu',
					text = 'открыть инвентарь',
				},
			},
			onEnter = function()
				hook.Add('PostRenderVGUI', 'dbgTutorial.stage_hands', function()
					octogui.drawWeaponSelector()
				end)
			end,
			onExit = function()
				hook.Remove('PostRenderVGUI', 'dbgTutorial.stage_hands')
			end,
		},
		{
			title = 'Инвентарь: Контейнеры',
			opacity = 0,
			content = 'Ты можешь поместить предметы в разные контейнеры: штаны, брюки и руки. Помни, что при выходе из сервера вещи в руках не будут сохранены, поэтому держи вещи в других контейнерах или в хранилище',
			contentOpacity = 1,
			target = {'octoinv.containers._hand', 'octoinv.containers.top', 'octoinv.containers.bottom'},
		},
		{
			title = 'Инвентарь: Индикаторы',
			opacity = 0.75,
			content = 'Эти шкалы предназначены для отслеживания состояния персонажа: красная — здоровье, бирюзовая — сытость',
			target = {
				{
					anchor = 'octoinv.bars.health',
					arrow = LEFT,
				},
				{
					anchor = 'octoinv.bars.hunger',
					arrow = RIGHT,
				},
			},
			button = true,
			onEnter = function()
				octoinv.show(true)
				octoinv.hangOpen()
			end,
		},
		{
			title = 'Инвентарь: Действия',
			opacity = 0.75,
			content = 'Тут можно открыть меню быстрых команд, еще оно открывается зажатием клавиши меню действий и команд (по умолчанию — C). Также в этом меню возможен выбор анимации, а быстрый вызов этого меню доступен на F2',
			target = {
				{
					anchor = 'octoinv.buttons.actions',
					arrow = TOP,
				},
				{
					anchor = 'octoinv.buttons.gestures',
				},
			},
			button = true,
		},
		{
			title = 'Меню действий и команд',
			opacity = 1,
			content = 'Давай изучим меню действий и команд — С-меню. Здесь множество функций, а у некоторых профессий могут появляться новые кнопки. Попробуй осмотреть своего персонажа',
			target = {'dbgTutorial.quickLook'},
			keybinds = {
				{
					bind = '+menu_context',
					text = 'открыть меню действий и команд',
				},
			},
		},
	},
	onFinish = function()
		timer.Simple(4, function()
			dbgTutorial.quest.next()
		end)
	end,
})