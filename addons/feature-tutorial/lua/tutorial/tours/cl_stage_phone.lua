-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_phone.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_phone', {
	steps = {
		{
			title = 'Стационарный телефон',
			content = 'В настоящее время без телефона жизнь — не жизнь. Самое время обзавестись им! Чтобы это сделать, нужно найти стационарный телефон и оформить заказ в магазине, он придет в ближайший почтовый ящик',
			button = true,
			onExit = function()
				dbgTutorial.quest.next()
			end,
		},
		{
			align = BOTTOM,
			title = 'Стационарный телефон',
			opacity = 0,
			content = 'На твоем экране был отмечен ближайший телефон, осмотрись вокруг и подойди к нему',
			contentOpacity = 1,
			onEnter = function()
				timer.Create('dbgTutorial.stage_phone', 10, 1, function()
					octolib.tour.hide()
				end)
			end,
			onExit = function()
				timer.Remove('dbgTutorial.stage_phone')
			end,
		},
		{
			align = BOTTOM,
			title = 'Стационарный телефон',
			opacity = 0,
			content = 'Используй стационарный телефон для вызова его меню. Выбери "Сделать заказ", чтобы открыть окно магазина',
			contentOpacity = 1,
			keybinds = {
				{
					bind = '+use',
					text = 'открыть меню телефона',
				},
			},
			target = {
				{
					anchor = 'dbgPhone.menu.make_order',
					arrow = RIGHT,
				},
			},
		},
		{
			align = RIGHT,
			title = 'Каталог магазина',
			opacity = 0,
			content = 'Для начала перейди во вкладку "Магазин"',
			target = {
				{
					anchor = 'octoinv.shop.list',
					arrow = TOP,
				},
			},
		},
		{
			align = RIGHT,
			title = 'Выбор предмета',
			opacity = 0,
			content = 'Теперь, используя поиск, найди телефон и добавь его в корзину',
			target = {
				{
					anchor = 'octoinv.shop.search',
					arrow = RIGHT,
				},
				{
					anchor = 'octoinv.shop.basketAdd',
					arrow = RIGHT,
				},
			},
			onEnter = function()
				hook.Add('octoinv.shop.onBasketAdded', 'dbgTutorial.phone', function(class)
					if class ~= 'phone' then
						return
					end

					octolib.tour.nextStep()
				end)
			end,
			onExit = function()
				hook.Remove('octoinv.shop.onBasketAdded', 'dbgTutorial.phone')
			end,
		},
		{
			align = RIGHT,
			title = 'Обзор корзины',
			opacity = 0,
			content = 'Перейди в корзину для оформления заказа',
			target = {
				{
					anchor = 'octoinv.shop.basket',
					arrow = TOP,
				},
			},
		},
		{
			align = RIGHT,
			title = 'Оформление заказа',
			opacity = 0,
			content = 'Почти готово! Осталось выбрать тип доставки — "Эксклюзив" и нажать кнопку "Заказать"',
			target = {
				{
					anchor = 'octoinv.shop.method',
					arrow = LEFT,
				},
				{
					anchor = 'octoinv.shop.buy',
					arrow = RIGHT,
				},
			},
		},
	},
})

dbgTutorial.tours.register('stage_phone.outro', {
	steps = {
		{
			title = 'Покупка телефона',
			content = 'Ты оформил свой первый заказ! Теперь осталось дождаться его доставки',
			button = true,
		},
	},
})