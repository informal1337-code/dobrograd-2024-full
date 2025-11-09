-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_fishing.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_fishing.order', {
	steps = {
		{
			title = 'Покупка лески и наживки',
			content = 'Отлично! Теперь, используя телефон, закажи себе леску и наживку. Не забудь выбрать тип доставки — "Эксклюзив"!',
			target = {'octogui.f4', 'octogui.f4.shop.tab'},
			keybinds = {
				{
					bind = 'gm_showspare2',
					text = 'открыть меню сервера',
				},
			},
		},
	},
})

dbgTutorial.tours.register('stage_fishing.fishing', {
	steps = {
		{
			align = TOP,
			title = 'Удочка и леска',
			opacity = 0,
			content = 'В инвентаре нажми на удочку и прикрепи леску. Затем возьми удочку в руки, выбрав пункт "Взять в руки"',
			contentOpacity = 1,
			keybinds = {
				{
					key = MOUSE_LEFT,
					text = 'взаимодействие с предметом',
				},
			},
		},
		{
			align = TOP,
			title = 'Выбор наживки',
			opacity = 0,
			content = 'Не забудь зацепить на удочку приманку! Сделай это, нажав на любую наживку в своем инвентаре, держа в руках удочку',
			contentOpacity = 1,
			keybinds = {
				{
					key = MOUSE_LEFT,
					text = 'взаимодействие с предметом',
				},
			},
		},
		{
			align = TOP,
			title = 'Ловля рыбы',
			opacity = 0,
			content = 'Нажми кнопку атаки, чтоб закинуть поплавок в озеро и начать ловить рыбу. Дождись всплесков воды и доставай улов. Попробуй выловить 3 любых предмета из озера!',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+attack',
					text = 'закинуть удочку',
				},
			},
		},
		{
			align = TOP,
			title = 'Ловля рыбы',
			opacity = 0,
			content = 'К слову о наживках: каждый день выбирается два случайных вида из шести. Если ловить на одну из выбранных сервером приманок, то с шансом 25% можно выловить две рыбы за раз',
			contentOpacity = 1,
			onEnter = function()
				timer.Create('dbgTutorial.stage_fishing', 15, 1, function()
					octolib.tour.hide()
				end)
			end,
			onExit = function()
				timer.Remove('dbgTutorial.stage_fishing')
			end,
		},
		{
			align = TOP,
			title = 'Ловля рыбы',
			opacity = 0,
			content = 'Для подсечения рыбы нужно дождаться, когда она зацепится за крючок — вместе с этим появятся всплески воды. Затем нажми кнопку альтернативной атаки, чтобы достать рыбу',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+attack2',
					text = 'достать удочку',
				},
			},
			onEnter = function()
				timer.Create('dbgTutorial.stage_fishing', 15, 1, function()
					octolib.tour.finish()
				end)
			end,
			onExit = function()
				timer.Remove('dbgTutorial.stage_fishing')
			end,
		},
	},
})