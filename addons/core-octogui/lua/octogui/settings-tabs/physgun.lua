-- "addons\\core-octogui\\lua\\octogui\\settings-tabs\\physgun.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add('octolib.settings.createTabs', 'physgun', function(add, buildFuncs)
	add({
		order = 7,
		name = 'Физган',
		icon = 'transform_move',
		build = function(p)
			local cp = buildFuncs.childPanel(p)
			cp:DockPadding(10, 10, 10, 10)

			buildFuncs.fancyVarCheckbox(cp, 'hideMyBeam', 'Не показывать мне луч моего физгана', 'Другие игроки все равно будут видеть луч твоего физгана, если тоже возьмут физган/тулган в руки')
			buildFuncs.fancyVarCheckbox(cp, 'hidePhysgunHalos', 'Скрыть обводку предметов, взятых физганом', 'Подойдет, если ты хочешь уменьшить количество мистики в этом городе. Иногда может увеличить производительность')

			local t = octolib.label(cp, 'Цвет физгана')
			t:SetFont('f4.normal')
			t.PerformLayout = sizeToContents
			local d = octolib.label(cp, 'Доступно только обладателям плюшек "Строитель", "Бизнесмен", "Добродей"')
			d:SetMultiline(true)
			d:SetWrap(true)
			d:DockMargin(5, 5, 0, 5)
			d.PerformLayout = sizeToContents

			local cb = octolib.vars.colorPicker(cp, 'physgunColor', nil, false, true)
			cb:DockMargin(5,5,5,5)
			cb:SetTall(200)
		end,
	})
end)
