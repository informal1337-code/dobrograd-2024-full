-- "addons\\core-octogui\\lua\\octogui\\settings-tabs\\graphics.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local conVarNames = {
	'cl_showfps',
	'r_3dsky',
	'cl_drawownshadow',
	'r_shadowrendertotexture',
	'r_dynamic',
	'r_drawflecks',
	'r_drawmodeldecals',
	'r_WaterDrawReflection'
}

hook.Add('octolib.settings.createTabs', 'graphics', function(add, buildFuncs)
	add({
		order = 6,
		name = 'Графика',
		icon = 'picture',
		build = function(p)
			local cp = buildFuncs.childPanel(p)
			cp:DockPadding(10, 0, 10, 10)

			local e = octolib.comboBox(cp, 'Разрешение прицела', octolib.array.map({128, 256, 512, 1024}, function(side)
				return {side .. 'x' .. side, side, GetConVar('octoweapons_sight_resolution'):GetInt() == side}
			end))
			e:SetSortItems(false)
			function e:OnSelect(_, _, side)
				GetConVar('octoweapons_sight_resolution'):SetInt(side)
			end

			buildFuncs.fancyVarCheckbox(cp, 'graphics.cl_showfps', 'Счетчик FPS', 'Показатель количества кадров в секунду в верхнем правом углу экрана'):SetConVar('cl_showfps')
			buildFuncs.fancyCheckbox(cp, 'Размытие фона', 'Эффект размытия некоторых прозрачных частей интерфейса. Красиво, но довольно требовательно к ресурсам компьютера'):SetConVar('octolib_blur')
			buildFuncs.fancyVarCheckbox(cp, 'octolib.betterFrameShadows', 'Улучшенные тени в UI', 'Повышенная детализация теней у окон в интерфейсе. Немного влияет на производительность')
			buildFuncs.fancyVarCheckbox(cp, 'graphics.r_3dsky', '3D-скайбокс', 'Отображение неигровой зоны карты за ее пределами. Отключение может незначительно повысить производительность'):SetConVar('r_3dsky')
			buildFuncs.fancyVarCheckbox(cp, 'graphics.cl_drawownshadow','Моя тень', 'Тень под твоим персонажем при использовании физгана, тулгкана или камеры'):SetConVar('cl_drawownshadow')
			buildFuncs.fancyVarCheckbox(cp, 'graphics.r_shadowrendertotexture', 'Тени высокого качества', 'Отображение полных силуэтов объектов в тенях'):SetConVar('r_shadowrendertotexture')
			buildFuncs.fancyVarCheckbox(cp, 'graphics.r_dynamic', 'Свет высокого качества', 'Динамическое освещение, создаваемое некоторыми объектами'):SetConVar('r_dynamic')
			buildFuncs.fancyVarCheckbox(cp, 'graphics.r_drawflecks', 'Мелкие частицы', 'Например, осколки от поверхности при попадании в нее пули'):SetConVar('r_drawflecks')
			buildFuncs.fancyVarCheckbox(cp, 'graphics.r_drawmodeldecals', 'Декали на объектах', 'Например, следы крови на персонажах и машинах'):SetConVar('r_drawmodeldecals')
			buildFuncs.fancyVarCheckbox(cp, 'graphics.r_WaterDrawReflection', 'Отражение в воде', 'Отображение игрового мира в воде. Если выключить, может понадобиться перезайти на сервер'):SetConVar('r_WaterDrawReflection')
			buildFuncs.fancyCheckbox(cp, 'Тени от фар автомобилей', 'Высокое качество освещения от фар автомобилей. Сильно влияет на производительность. Настройка применяется после включения фар'):SetConVar('cl_simfphys_shadows')
			buildFuncs.fancyVarCheckbox(cp, 'graphics.flashlight_others', 'Фонарики других игроков', 'Отображение фонариков у других игроков. Сильно влияет на производительность')
			buildFuncs.fancyVarCheckbox(cp, 'graphics.flashlight_shadows', 'Тени от фонариков', 'Отображение теней от фонариков у игроков. Сильно влияет на производительность')

			buildFuncs.title(p, 'Погода')

			local cp = buildFuncs.childPanel(p)
			cp:DockPadding(10, 10, 10, 10)

			local cont = buildFuncs.childPanel(cp)
			cont:SetPaintBackground(false)
			cont:DockMargin(0, 0, 0, 15)

			local fps = StormFox2.Menu.FPSRing()
			cont:Add(fps)
			fps:SetY(0)

			local qu = StormFox2.Menu.QualityRing()
			cont:Add(qu)
			qu:SetY(0)

			local sup = StormFox2.Menu.SupportRing()
			cont:Add(sup)
			sup:SetY(0)

			local mth = StormFox2.Menu.MThreadRing()
			cont:Add(mth)
			mth:SetY(0)

			function cont:PerformLayout(w)
				local maxH, sumW = 0, 0
				for _, v in ipairs(self:GetChildren()) do
					maxH = math.max(maxH, v:GetTall())
					sumW = sumW + v:GetWide()
				end
				self:SetTall(maxH)
				local x = (w-sumW) / (#self:GetChildren() + 1)
				fps:SetX(x)
				qu:SetX(fps:GetX() + fps:GetWide() + x)
				sup:SetX(qu:GetX() + qu:GetWide() + x)
				mth:SetX(sup:GetX() + sup:GetWide() + x)
			end

			octolib.label(cp, 'Желаемый FPS')
			local fpsTarget = StormFox2.Menu.FPSTarget()
			cp:Add(fpsTarget)
			fpsTarget:Dock(TOP)
			fpsTarget:DockMargin(0, -15, 0, 0)
			fpsTarget.label_name:Remove()
			fpsTarget.description:Remove()

			local function shittyCheckbox(name, desc, setting)
				local cb = buildFuncs.fancyCheckbox(cp, name, desc)
				local obj = StormFox2.Setting.GetObject(setting)
				obj:AddCallback(function(val)
					cb:SetChecked(val)
				end, cb)
				function cb:OnChange(val)
					obj:SetValue(val)
				end
			end
			shittyCheckbox('Ультра-качество', 'Добавляет ещё больше эффектов', 'quality_ultra')

			local function shittyNumSlider(name, desc, min, max, prec, setting)
				local ns = buildFuncs.fancyNumSlider(cp, name, desc, min, max, prec)
				local obj = StormFox2.Setting.GetObject(setting)
				obj:AddCallback(function(val)
					ns:SetValue(val)
				end, cb)
				function ns:OnValueChanged(val)
					obj:SetValue(val)
				end
			end
			shittyNumSlider('Множитель темноты', 'Чем больше значение, тем темнее ночи', 0, 1, 2, 'extra_darkness_amount')
		end,
	})
end)

hook.Add('PlayerFinishedLoading', 'settings.graphics.loadConVars', function(ply)
	for _, name in pairs(conVarNames) do
		local value = octolib.vars.get('graphics.' .. name)
		if value == nil then continue end
		value = value and 1 or 0
		LocalPlayer():ConCommand(name .. " " .. value)
	end
end)
