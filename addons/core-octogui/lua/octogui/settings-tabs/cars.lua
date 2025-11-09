-- "addons\\core-octogui\\lua\\octogui\\settings-tabs\\cars.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
CreateClientConVar('cl_dbg_turnsignaloff', '1', true, true)

hook.Add('octolib.settings.createTabs', 'cars', function(add, buildFuncs)
	add({
		order = 2,
		name = 'Автомобиль',
		icon = 'small_car',
		build = function(p)
			local cp = buildFuncs.childPanel(p)
			cp:DockPadding(10, 0, 10, 5)

			buildFuncs.fancyCheckbox(cp, 'Выключать поворотники автоматически', 'При повороте в противоположную сторону или при длительном простое автоматически выключать поворотники'):SetConVar('cl_dbg_turnsignaloff')
			buildFuncs.fancyNumSlider(cp, 'Скорость поворота руля', 'Скорость, с которой движение мышью изменяет положение руля', 0.1, 5, 2):SetConVar('dbg_cars_ms_sensitivity')
			buildFuncs.fancyNumSlider(cp, 'Мертвая зона руля', 'Размер области, в которой поворот считается нулевым (машина едет прямо)', 0, 0.3, 2):SetConVar('dbg_cars_ms_deadzone')
			buildFuncs.fancyNumSlider(cp, 'Возврат руля', 'Скорость, с которой руль возвращается в положение прямо', 0, 2, 2):SetConVar('dbg_cars_ms_return')
		end,
	})
end)
