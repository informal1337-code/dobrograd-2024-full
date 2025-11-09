-- "addons\\core-octogui\\lua\\octogui\\settings-tabs\\chat.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add('octolib.settings.createTabs', 'chat', function(add, buildFuncs)
	add({
		order = 9,
		name = 'Чат',
		icon = 'scroll_pane_text',
		build = function(panel)
			local cp = buildFuncs.childPanel(panel)
			cp:DockPadding(10, 10, 10, 10)
			cp:SetTall(390)

			if not octochat.settings and octochat.load then
				octochat.load()
			end

			if not octochat.settings then
				octochat.settings = {
					color = Color(85,68,85,235),
					msgLength = 10,
					msgFade = 3,
					textSize = 18,
					bold = false,
					autoCursor = true,
					showEntry = true,
					closeOnSend = false,
					showHint = true,
					showTime = false,
					closeEmptySend = true,
					showSeconds = false,
					openEnter = true,
					shadow = true,
					noLinks = true,
				}
			end

			local tCol = CFG.skinColors.bg
			local defaultCol = Color(tCol.r, tCol.g, tCol.b, 235)

			local e = {}

			local function addSpacer(h)
				local sp = vgui.Create('DPanel', cp)
				sp:Dock(TOP)
				sp:SetTall(h or 4)
				sp.Paint = nil
			end

			e.c = vgui.Create('DColorMixer', cp)
			e.c:Dock(TOP)
			e.c:SetTall(170)
			e.c:SetAlphaBar(true)
			e.c:SetWangs(true)
			e.c:SetPalette(false)
			function e.c:ValueChanged(col)
				octochat.settings.color = col
			end
			addSpacer(8)

			local function stdSlider(txt, min, max, decimals)
				local s = vgui.Create('DNumSlider', cp)
				s:Dock(TOP)
				s:DockMargin(0,0,0,0)
				s:SetText(txt)
				s:SetTall(32)
				s:SetMinMax(min, max)
				s:SetDecimals(decimals or 0)
				return s
			end

			e.s1 = stdSlider(L.display_time_sec, 1, 60, 0)
			function e.s1:OnValueChanged(val)
				val = math.Clamp(val, 1, 60)
				octochat.settings.msgLength = val
				if e.s2:GetValue() > val then e.s2:SetValue(val) end
			end

			e.s2 = stdSlider(L.damping_time_sec, 1, 15, 0)
			function e.s2:OnValueChanged(val)
				val = math.Clamp(val, 1, 15)
				octochat.settings.msgFade = val
				if e.s1:GetValue() < val then e.s1:SetValue(val) end
			end

			e.s3 = stdSlider(L.font_size, 10, 24, 0)
			function e.s3:OnValueChanged(val)
				val = math.Clamp(val, 10, 24)
				octochat.settings.textSize = val
				if octochat.recreateFont then octochat.recreateFont() end
			end

			addSpacer(4)

			local function stdCheck(text, onChange)
				local cb = vgui.Create('DCheckBoxLabel', cp)
				cb:Dock(TOP)
				cb:DockMargin(4,4,0,0)
				cb:SetTall(22)
				cb:SetText(text)

				function cb:OnChange(val)
					onChange(val)
				end

				return cb
			end

			e.cb1 = stdCheck(L.use_bold, function(v)
				octochat.settings.bold = v
				if octochat.recreateFont then octochat.recreateFont() end
			end)

			e.cb2 = stdCheck(L.show_cursor_open, function(v) octochat.settings.autoCursor = v end)
			e.cb3 = stdCheck(L.show_entering_text, function(v) octochat.settings.showEntry = v end)
			e.cb4 = stdCheck(L.close_sent_msg, function(v) octochat.settings.closeOnSend = v end)
			e.cb5 = stdCheck(L.show_help_manage, function(v) octochat.settings.showHint = v end)
			e.cb6 = stdCheck(L.add_time_msg, function(v) octochat.settings.showTime = v end)
			e.cb7 = stdCheck(L.close_chat_empty, function(v) octochat.settings.closeEmptySend = v end)
			e.cb8 = stdCheck(L.show_seconds_in_time, function(v) octochat.settings.showSeconds = v end)
			e.cb9 = stdCheck(L.enter_open_chat, function(v) octochat.settings.openEnter = v end)
			e.cb10 = stdCheck(L.add_text_shadow, function(v)
				octochat.settings.shadow = v
				if octochat.recreateFont then octochat.recreateFont() end
			end)

			e.cb11 = stdCheck('Не отображать кликабельные ссылки', function(v) octochat.settings.noLinks = v end)

			addSpacer(8)

			local reset = vgui.Create('DButton', cp)
			reset:Dock(TOP)
			reset:DockMargin(0,8,90,0)
			reset:SetTall(30)
			reset:SetText(L.reset_chat)
			function reset:DoClick()
				e.c:SetColor(defaultCol)
				e.s1:SetValue(10)
				e.s2:SetValue(3)
				e.s3:SetValue(18)
				e.cb1:SetValue(false)
				e.cb2:SetValue(true)
				e.cb3:SetValue(true)
				e.cb4:SetValue(false)
				e.cb5:SetValue(true)
				e.cb6:SetValue(false)
				e.cb7:SetValue(true)
				e.cb8:SetValue(false)
				e.cb9:SetValue(true)
				e.cb10:SetValue(true)
				e.cb11:SetValue(true)
				if octochat.save then octochat.save() end
			end

			local saveBtn = vgui.Create('DButton', cp)
			saveBtn:Dock(TOP)
			saveBtn:DockMargin(0,4,90,0)
			saveBtn:SetTall(28)
			saveBtn:SetText(L.save or 'Сохранить')
			function saveBtn:DoClick()
				if octochat.save then octochat.save() end
			end

			e.c:SetColor(octochat.settings.color)
			e.s1:SetValue(octochat.settings.msgLength)
			e.s2:SetValue(octochat.settings.msgFade)
			e.s3:SetValue(octochat.settings.textSize)
			e.cb1:SetValue(octochat.settings.bold)
			e.cb2:SetValue(octochat.settings.autoCursor)
			e.cb3:SetValue(octochat.settings.showEntry)
			e.cb4:SetValue(octochat.settings.closeOnSend)
			e.cb5:SetValue(octochat.settings.showHint)
			e.cb6:SetValue(octochat.settings.showTime)
			e.cb7:SetValue(octochat.settings.closeEmptySend)
			e.cb8:SetValue(octochat.settings.showSeconds)
			e.cb9:SetValue(octochat.settings.openEnter)
			e.cb10:SetValue(octochat.settings.shadow)
			e.cb11:SetValue(octochat.settings.noLinks)

			local function autoSaveHook()
				if octochat.save then octochat.save() end
			end

			for _, ctrl in pairs(e) do
				if IsValid(ctrl) then
					if ctrl.ValueChanged and ctrl ~= e.c then
						local old = ctrl.OnValueChanged
						function ctrl:OnValueChanged(val)
							if old then
								old(self, val)
							end
							autoSaveHook()
						end
					elseif ctrl.OnChange then
						local old = ctrl.OnChange
						function ctrl:OnChange(val)
							if old then
								old(self,val)
							end
							autoSaveHook()
						end
					end
				end
			end
			if e.c then
				local oldVC = e.c.ValueChanged
				function e.c:ValueChanged(col)
					if oldVC then oldVC(self,col) end
					autoSaveHook()
				end
			end
		end
	})
end)
