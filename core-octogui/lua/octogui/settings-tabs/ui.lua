-- "addons\\core-octogui\\lua\\octogui\\settings-tabs\\ui.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local tickMat = Material('octoteam/icons-16/tick.png')
local lockMat = Material('octoteam/icons-16/lock.png')
local customThemeMat = Material('octoteam/icons-32/color_wheel.png')

hook.Add('octolib.settings.createTabs', 'ui', function(add, buildFuncs)
	add({
		order = 0,
		name = 'Оформление',
		icon = 'palette',
		build = function(p)
			local themesCont = buildFuncs.childPanel(p)
			themesCont:DockPadding(15, 15, 15, 15)
			function themesCont:PerformLayout(...)
				self:SizeToChildren(false, true)
			end

			local function paintTheme(self, w, h)
				draw.NoTexture()

				surface.SetDrawColor(self.theme.secondary)
				draw.Circle(w / 2, h / 2, 32, 30)

				surface.SetDrawColor(self.theme.primary)
				draw.Circle(w / 2, h / 2, 24, 30)

				if not self.id then
					surface.SetMaterial(customThemeMat)
					surface.SetDrawColor(color_white)
					surface.DrawTexturedRect((w - 32) / 2, (h - 32) / 2, 32, 32)
				end

				local isCustomThemeAndSelected = not self.id and octolib.vars.get('octogui.themes.custom')
				local isSelectedTheme = not octolib.vars.get('octogui.themes.custom') and octolib.vars.get('octogui.themes.id') == self.id
				if isCustomThemeAndSelected or isSelectedTheme then
					surface.SetMaterial(tickMat)
					surface.SetDrawColor(color_white)
					surface.DrawTexturedRect((w - 16) / 2, (h - 16) / 2, 16, 16)
				elseif self.disabled then
					surface.SetMaterial(lockMat)
					surface.SetDrawColor(color_white)
					surface.DrawTexturedRect((w - 16) / 2, (h - 16) / 2, 16, 16)
				end
			end

			local function clickTheme(self)
				if self.disabled then return end
				octolib.changeSkinColor(self.theme.secondary, self.theme.primary)

				if self.id then
					octolib.vars.set('octogui.themes.id', self.id)
				end

				octolib.vars.set('octogui.themes.custom', self.id == nil)
			end

			local function rebuildThemes()
				themesCont:Clear()

				local themesIconLayout = themesCont:Add 'DIconLayout'
				themesIconLayout:Dock(TOP)
				themesIconLayout:SetPaintBackground(false)
				themesIconLayout:SetSpaceX(15)
				themesIconLayout:SetSpaceY(15)
				function themesIconLayout:PerformLayout(...)
					DIconLayout.PerformLayout(self, ...)
					self:SizeToChildren(false, true)
				end

				for i, theme in ipairs(octogui.themes.presets) do
					local themeBut = themesIconLayout:Add 'DButton'
					themeBut:DockMargin(0, -5, 0, 0)
					themeBut:SetText('')
					themeBut:SetSize(64, 64)
					themeBut:SetTooltip(theme.name)
					themeBut.theme = theme
					if theme.check then
						local ok, reason = theme.check(LocalPlayer())
						if not ok then
							themeBut.disabled = true
							themeBut:SetCursor('arrow')
							themeBut:SetTooltip(reason)
						end
					end
					themeBut.id = i
					themeBut.Paint, themeBut.DoClick = paintTheme, clickTheme
				end

				local customThemeBut = themesIconLayout:Add 'DButton'
				customThemeBut:DockMargin(0, -5, 0, 0)
				customThemeBut:SetText('')
				customThemeBut:SetSize(64, 64)
				customThemeBut.theme = {
					name = 'Свое оформление',
					primary = octolib.vars.get('octogui.themes.custom.primary') or octogui.themes.presets[1].primary,
					secondary = octolib.vars.get('octogui.themes.custom.secondary') or octogui.themes.presets[1].secondary,
				}
				customThemeBut:SetTooltip(customThemeBut.theme.name)
				if not LocalPlayer():IsPremium() then
					customThemeBut.disabled = true
					customThemeBut:SetCursor('arrow')
					customThemeBut:SetTooltip('Только для Добродеев')
				end
				customThemeBut.Paint, customThemeBut.DoClick = paintTheme, clickTheme

				local customThemeMixersContainer = themesCont:Add 'DPanel'
				customThemeMixersContainer:Dock(TOP)
				customThemeMixersContainer:SetPaintBackground(false)
				customThemeMixersContainer:DockMargin(0, 15, 0, 0)
				function customThemeMixersContainer:PerformLayout(...)
					self:SizeToChildren(false, true)
				end

				octolib.label(customThemeMixersContainer, 'Цвет акцента')
				octolib.vars.colorPicker(customThemeMixersContainer, 'octogui.themes.custom.primary', nil, false, true)
					:SetTall(200)
				octolib.label(customThemeMixersContainer, 'Цвет фона')
				octolib.vars.colorPicker(customThemeMixersContainer, 'octogui.themes.custom.secondary', nil, false, true)
					:SetTall(200)

				customThemeMixersContainer:SetVisible(octolib.vars.get('octogui.themes.custom') == true)

				hook.Add('octolib.setVar', 'octogui.customTheme.mixers', function(var, val)
					if not IsValid(customThemeMixersContainer) then return end

					if var == 'octogui.themes.custom' then
						customThemeMixersContainer:SetVisible(val == true)
						themesCont:InvalidateLayout()
					end
					if var == 'octogui.themes.custom.primary' then
						customThemeBut.theme.primary = val
					end
					if var == 'octogui.themes.custom.secondary' then
						customThemeBut.theme.secondary = val
					end
				end)
			end
			rebuildThemes()
			local rebuildOnNetvars = octolib.array.toKeys({'osDobro', 'halloweenTheme'})
			hook.Add('octolib.netVarUpdate', 'octogui.customTheme.mixers', function(index, key, value)
				if index ~= LocalPlayer():EntIndex() or not rebuildOnNetvars[key] or not IsValid(themesCont) then return end
				rebuildThemes()
			end)

			buildFuncs.title(p, 'Цвет прицела')
			local crosshairCont = buildFuncs.childPanel(p)
			local cb = octolib.vars.colorPicker(crosshairCont, 'dbg-crosshair.color', nil, false, true)
			cb:DockMargin(5,5,5,5)
			cb:SetTall(200)
		end,
	})
end)
