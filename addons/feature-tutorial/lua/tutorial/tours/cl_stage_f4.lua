-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_f4.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function completeSubTask(index)
	netstream.Start(octoquests.tempHookId(LocalPlayer(), 'dbgTutorial.completeSubTask'), index)
end

dbgTutorial.tours.register('stage_f4', {
	steps = {
		{
			title = 'Вступление',
			content = 'Перед началом игры давай узнаем, где и что у нас находится — это облегчит тебе изучение сервера. Открой меню сервера, через которое можно перейти к различным вкладкам',
			target = {'octogui.f4'},
			keybinds = {
				{
					bind = 'gm_showspare2',
					text = 'открыть меню сервера',
				},
			},
			onEnter = function()
				if octogui.f4.panel:IsVisible() then
					octogui.f4.panel:Hide()
				end
			end,
			onExit = function()
				octogui.f4.panel:Show()
				octogui.f4.panel.isClosing = true
			end,
		},
		{
			title = 'F4: Статус квестов',
			content = 'Здесь ты сможешь отслеживать статус различных квестов. Например, сейчас ты видишь текущий статус стадии квеста "Вступительное обучение"',
			target = {
				{
					anchor = 'octoquests.subTasks',
					arrow = BOTTOM,
				},
			},
			button = true,
			onExit = function()
				completeSubTask(1)
			end,
		},
		{
			title = 'F4: Уведомления',
			content = 'В этой вкладке отображаются важные уведомления: прохождение тестов, скидки, квесты, обучение, сделки на рынке и другие. Заглядывай сюда почаще, чтобы ничего не пропустить',
			target = {
				{
					anchor = 'octogui.f4.notifications.tab',
					arrow = TOP,
					callback = octolib.tour.hide,
				},
				{
					anchor = 'octogui.f4.notifications',
				},
			},
			onExit = function()
				completeSubTask(2)
			end,
		},
		{
			title = 'F4: Магазин',
			content = 'Именно здесь можно заказать различные предметы. Некоторые категории (например, продукты или автозапчасти) доступны только определенным профессиям',
			target = {
				{
					anchor = 'octogui.f4.shop.tab',
					arrow = TOP,
					callback = octolib.tour.hide,
				},
				{
					anchor = 'octogui.f4.shop',
				},
			},
			onExit = function()
				completeSubTask(3)
			end,
		},
		{
			title = 'F4: Карта',
			content = 'Интерактивная карта — твой главный путеводитель по городу. На ней отмечены схема города, твое местоположение, точки интереса и зоны криминальной активности. Обратись к ней, если вдруг заблудишься',
			target = {
				{
					anchor = 'octogui.f4.map.tab',
					arrow = TOP,
					callback = octolib.tour.hide,
				},
				{
					anchor = 'octogui.f4.map',
				},
			},
			onExit = function()
				completeSubTask(4)
			end,
		},
		{
			title = 'F4: Гараж',
			content = 'Автосалон и автопарк в одном флаконе. Служит и каталогом автомобилей, которые можно приобрести, и твоим личным гаражом. Иногда транспорт продается с дисконтом, так что будь в курсе!',
			target = {
				{
					anchor = 'octogui.f4.dealer.tab',
					arrow = TOP,
					callback = octolib.tour.hide,
				},
				{
					anchor = 'octogui.f4.dealer',
				},
			},
			onExit = function()
				completeSubTask(5)
			end,
		},
		{
			title = 'F4: Справочник',
			content = 'Книга всех крафтов и рецептов, которые только есть! Не обязательно помнить какие-то из них, ведь достаточно в любой момент просто обратиться к справочнику',
			target = {
				{
					anchor = 'octogui.f4.octoinv.help.tab',
					arrow = TOP,
					callback = octolib.tour.hide,
				},
				{
					anchor = 'octogui.f4.octoinv.help',
				},
			},
			onExit = function()
				completeSubTask(6)
			end,
		},
		{
			title = 'F4: Рынок',
			content = 'На рынке можно купить или продать самые разные предметы: от кастрюли до пистолета! Все предложения формируются игроками, поэтому иногда здесь можно найти что-то редкое и коллекционное',
			target = {
				{
					anchor = 'octogui.f4.octoinv.market.tab',
					arrow = TOP,
					callback = octolib.tour.hide,
				},
				{
					anchor = 'octogui.f4.octoinv.market',
				},
			},
			onExit = function()
				completeSubTask(7)
			end,
		},
		{
			title = 'F4: Задания',
			content = 'Задания для подработки, прямо как у разнорабочего. Взяться можно как за легальные, так и не совсем — учитывай риски и свои возможности',
			target = {
				{
					anchor = 'octogui.f4.jobs.tab',
					arrow = TOP,
					callback = octolib.tour.hide,
				},
				{
					anchor = 'octogui.f4.jobs',
				},
			},
			onExit = function()
				completeSubTask(8)
			end,
		},
		{
			title = 'F4: Плюшки',
			content = 'Финальная вкладка — магазин плюшек. Здесь можно не только поддержать наш проект, но и приобрести аксессуары для персонажа, игровую валюту или расширить функционал',
			target = {
				{
					anchor = 'octogui.f4.donate.tab',
					arrow = TOP,
					callback = octolib.tour.hide,
				},
				{
					anchor = 'octogui.f4.donate',
				},
			},
			onExit = function()
				completeSubTask(9)
			end,
		},
		{
			align = BOTTOM,
			title = 'Освобождение курсора',
			content = 'Чтобы закрыть такое окно, нужно освободить курсор. Это пригодится, когда ты захочешь участвовать в голосованиях, ответить в окне общения с админами и других случаях',
			target = {
				{
					anchor = 'dbgTutorial.f3',
					arrow = TOP,
				},
			},
			keybinds = {
				{
					bind = 'gm_showspare1',
					text = 'освободить курсор',
				},
			},
			onEnter = function(_)
				octogui.f4.panel.isClosing = nil
				octogui.f4.panel:Hide()

				local frame = vgui.Create('DFrame')
				frame:SetSize(400, 200)
				frame:SetTitle('Какое-то окошечко')
				frame:SetTourAnchor('dbgTutorial.f3')
				frame:SetMouseInputEnabled(true)
				frame:Center()

				local label = vgui.Create('DLabel', frame)
				label:Dock(FILL)
				label:SetContentAlignment(5)
				label:SetText('Закрой это окно.')

				function frame:OnClose()
					octolib.tour.trigger('dbgTutorial.f3')
				end

				gui.EnableScreenClicker(false)
			end,
			onExit = function(_)
				gui.EnableScreenClicker(false)
			end,
		},
	},
	onExit = function()
		octogui.f4.panel.isClosing = nil
	end,
	onFinish = function()
		dbgTutorial.quest.next()
	end,
})