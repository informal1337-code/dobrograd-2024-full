-- "addons\\core-octogui\\lua\\octogui\\settings-tabs\\other.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
CreateClientConVar('cl_octolib_sticky_handbrake', '1', true, true)

hook.Add('octolib.settings.createTabs', 'other', function(add, buildFuncs)
	add({
		order = 8,
		name = 'Другое',
		icon = 'cog',
		build = function(p)
			p:GetCanvas():Clear()

			buildFuncs.title(p, 'Залипание')
			local cp = buildFuncs.childPanel(p)
			cp:DockPadding(10, 10, 10, 10)

			local lbl = octolib.label(cp, 'Двойное нажатие на клавиши заменяет их удерживание')
			lbl:SetMultiline(true)
			lbl:SetWrap(true)
			lbl:SetAutoStretchVertical(true)
			lbl:SetAlpha(100)
			lbl:DockMargin(0, 0, 0, 5)

			octolib.checkBox(cp, 'Приседание'):SetConVar('cl_octolib_sticky_duck')
			octolib.checkBox(cp, 'Прицел'):SetConVar('cl_octolib_sticky_attack2')
			octolib.checkBox(cp, 'Ручной тормоз'):SetConVar('cl_octolib_sticky_handbrake')

			buildFuncs.title(p, 'Фиксы')
			local cp = buildFuncs.childPanel(p)
			cp:DockPadding(5, 5, 5, 5)
			local function fix(title, click)
				local b = cp:Add 'DButton'
				b:Dock(TOP)
				b:DockMargin(0,0,0,5)
				b:SetTall(30)
				b:SetText(title)
				b.DoClick = click
			end
			fix('Отпустить все кнопки залипания', function() RunConsoleCommand('-duck') RunConsoleCommand('-attack2') end)
			fix('Остановить все звуки', function() RunConsoleCommand('stopsound') end)
			fix('Перезагрузить F4-меню', function() RunConsoleCommand('octogui_reloadf4') end)
			-- fix('Перезагрузить текстуры', function() RunConsoleCommand('advmat_reload') end)
			fix('Очистить иконки моделей', function() octolib.renderModel.clear() end)

			buildFuncs.title(p, 'Обучение')

			local cp = buildFuncs.childPanel(p)
			cp:DockPadding(5, 5, 5, 5)

			local b = cp:Add('DButton')
			b:Dock(TOP)
			b:DockMargin(0, 0, 0, 5)
			b:SetTall(30)
			b:SetText('Начать обучение')

			function b:Think()
				if LocalPlayer():GetLocalVar('dbgTutorial.started') then
					self:SetText('Отменить обучение')
				else
					self:SetText('Начать обучение')
				end
			end

			function b:DoClick()
				if LocalPlayer():GetLocalVar('dbgTutorial.started') then
					dbgTutorial.quest.skip()
				else
					dbgTutorial.quest.start()
				end
			end
		end,
	})
end)
