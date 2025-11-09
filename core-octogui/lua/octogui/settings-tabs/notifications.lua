-- "addons\\core-octogui\\lua\\octogui\\settings-tabs\\notifications.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
CreateClientConVar('cl_dbg_enter', '1', true, true)
CreateClientConVar('cl_dbg_salary', '1', true, true)
CreateClientConVar('cl_dbg_karma_increase', '1', true, true)
CreateClientConVar('cl_dbg_karma_decrease', '1', true, true)
CreateClientConVar('cl_dbg_arrest', '1', true, true)
CreateClientConVar('cl_dbg_unarrest', '1', true, true)
CreateClientConVar('cl_dbg_admins', '1', true, true)
CreateClientConVar('cl_dbg_ooc', '1', true, true)
CreateClientConVar('cl_dbg_looc', '1', true, true)
CreateClientConVar('cl_dbg_pm', '1', true, true)
CreateClientConVar('cl_dbg_demote', '1', true, true)
CreateClientConVar('cl_dbg_lottery', '1', true, true)
CreateClientConVar('cl_dbg_lags', '1', true, true)
CreateClientConVar('cl_dbg_sgnotify', '1', true, true)
CreateClientConVar('cl_dbg_rent', '1', true, true)
CreateClientConVar('cl_dbg_panic_button', '1', true, true)

hook.Add('octolib.settings.createTabs', 'notifications', function(add, buildFuncs)
	add({
		order = 4,
		name = 'Уведомления',
		icon = 'mailing_list',
		build = function(p)
			local cp = buildFuncs.childPanel(p)
			cp:DockPadding(10, 0, 10, 10)

			if LocalPlayer():query('Admin Chat') then
				buildFuncs.fancyCheckbox(cp, 'Админ-чат', 'Показывать сообщения из админ-чата'):SetConVar('cl_dbg_admins')
			end

			buildFuncs.fancyCheckbox(cp, 'PM-сообщения', 'Показывать PM-сообщения'):SetConVar('cl_dbg_pm')
			buildFuncs.fancyCheckbox(cp, 'LOOC-чат', 'Показывать сообщения LOOC-чата'):SetConVar('cl_dbg_looc')
			buildFuncs.fancyCheckbox(cp, 'OOC-чат', 'Показывать сообщения OOC-чата'):SetConVar('cl_dbg_ooc')
			buildFuncs.fancyCheckbox(cp, 'Лотерея', 'Показывать окна и сообщения о лотереях'):SetConVar('cl_dbg_lottery')
			buildFuncs.fancyCheckbox(cp, 'Пролаги', 'Показывать сообщения о лагах'):SetConVar('cl_dbg_lags')
			buildFuncs.fancyCheckbox(cp, 'Действия администрации', 'Показывать сообщения о действиях администрации (например, блокировках)'):SetConVar('cl_dbg_sgnotify')
			buildFuncs.fancyCheckbox(cp, 'Получение зарплаты', 'Показывать сообщение при получении зарплаты'):SetConVar('cl_dbg_salary')
			buildFuncs.fancyCheckbox(cp, 'Уменьшение кармы', 'Показывать сообщение при уменьшении кармы'):SetConVar('cl_dbg_karma_decrease')
			buildFuncs.fancyCheckbox(cp, 'Увеличение кармы', 'Показывать сообщение при увеличении кармы'):SetConVar('cl_dbg_karma_increase')
			buildFuncs.fancyCheckbox(cp, 'Увольнения', 'Показывать сообщения об увольнении игроков'):SetConVar('cl_dbg_demote')
			buildFuncs.fancyCheckbox(cp, 'Аресты', 'Показывать сообщения об арестах игроков'):SetConVar('cl_dbg_arrest')
			buildFuncs.fancyCheckbox(cp, 'Выход из тюрьмы', 'Показывать сообщения о выходе игроков из тюрьмы'):SetConVar('cl_dbg_unarrest')
			buildFuncs.fancyCheckbox(cp, 'Присоединение игроков к серверу', 'Показывать сообщения "…на пути в город Доброград!"'):SetConVar('cl_dbg_enter')
			buildFuncs.fancyCheckbox(cp, 'Уведомления от телефона, кроме пропущенных звонков', 'Показывает все уведомления, приходящие от звонков'):SetConVar('cl_dbg_phone_notifies')
			buildFuncs.fancyCheckbox(cp, 'Списания за аренду', 'Показывать сообщения об аренде'):SetConVar('cl_dbg_rent')
			buildFuncs.fancyCheckbox(cp, 'Кнопка паники', 'Воспроизводить звук при нажатии кнопки паники'):SetConVar('cl_dbg_panic_button')
		end,
	})
end)
