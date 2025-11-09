--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-characters/lua/dbg-characters/cl_f4.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local allModels = {
	male = octolib.table.mapSequential(dbgChars.config.playerModels, function(modelData, model)
		if octolib.models.isMale(model) then
			return table.Merge({model = model}, modelData)
		end
	end),
	female = octolib.table.mapSequential(dbgChars.config.playerModels, function(modelData, model)
		if not octolib.models.isMale(model) then
			return table.Merge({model = model}, modelData)
		end
	end),
}
table.sort(allModels.male, function(a, b) return a.name < b.name end)
table.sort(allModels.female, function(a, b) return a.name < b.name end)

local function modelButPaint(self, w, h)
	draw.NoTexture()
	surface.SetDrawColor(CFG.skinColors.bg_d)
	surface.DrawRect(0, 0, w, h)

	if not self:IsHovered() then
		surface.SetDrawColor(CFG.skinColors.bg60)
		surface.DrawRect(1, 1, w-2, h-2)
	end
end

local function getNiceLights(camPivot, camAng)
	local light1Ang = Angle(camAng)
	local light2Ang = Angle(camAng)
	light1Ang:RotateAroundAxis(camAng:Up(), -140)
	light2Ang:RotateAroundAxis(camAng:Up(), 20)

	return {
		{
			type = MATERIAL_LIGHT_POINT,
			pos = camPivot - light1Ang:Forward() * 50 + light1Ang:Up() * 10,
			color = Vector(4, 4, 4),
			fiftyPercentDistance = 75,
			zeroPercentDistance = 100,
		},
		{
			type = MATERIAL_LIGHT_POINT,
			pos = camPivot - light2Ang:Forward() * 50 + light2Ang:Up() * 20,
			color = Vector(0.75, 0.75, 0.75),
			fiftyPercentDistance = 75,
			zeroPercentDistance = 100,
		},
	}
end

local function getCamPosRelativeToEyes(ent, relativePos, relativeAng)
	relativeAng = relativeAng or Angle(0, 180, 0)
	relativePos = relativePos or Vector(0, -40, 0)
	if not camAng then
		camAng = Angle(0, 0, 0)
	end
	if not IsValid(ent) then
		return relativePos, relativePos, relativeAng
	end

	local camPivot = vector_origin
	local camAng = angle_zero

	local eyes = ent:LookupAttachment('eyes')
	if eyes then
		local attachment = ent:GetAttachment(eyes)
		if attachment then
			camPivot = ent:LocalToWorld(attachment.Pos)
			camAng = ent:LocalToWorldAngles(attachment.Ang)
			camAng:RotateAroundAxis(camAng:Right(), relativeAng.p)
			camAng:RotateAroundAxis(camAng:Up(), relativeAng.y)
			camAng:RotateAroundAxis(camAng:Forward(), relativeAng.r)
		end
	end

	local camPos = camPivot
		+ camAng:Right() * relativePos.x
		+ camAng:Forward() * relativePos.y
		+ camAng:Up() * relativePos.z
	return camPivot, camPos, camAng
end

local function addButtonWithPreview(parentBut, options)
	local modelButPreview = parentBut:Add 'octolib_model'
	modelButPreview:Dock(FILL)
	modelButPreview:SetSize(parentBut:GetSize())
	modelButPreview:SetMouseInputEnabled(false)

	local renderSettings = function(ent)
		local camPivot, camPos, camAng = getCamPosRelativeToEyes(ent, options.relativePos, options.relativeAng)
		if IsValid(ent) then
			ent:SetEyeTarget(camPivot + Vector(0, 50, 0))
		end

		return {
			camFov = options.fov,
			camAng = camAng,
			camPos = camPos,
			baseLightColor = Vector(0, 0, 0),
			lights = options.lights or getNiceLights(camPivot, camAng),
		}
	end
	local model, destination = options.getSetupParams(options.selected)
	modelButPreview:Setup(model, destination, renderSettings)

	function parentBut:DoClick()
		local totalOptions = #options.options + (options.optionsPremium and #options.optionsPremium or 0)
		local xGrid = 3
		local yGrid = 3
		local popupWidth = (parentBut:GetWide() + 10) * xGrid + (totalOptions > 9 and 20 or 0)
		local popupHeight = (parentBut:GetTall() + 10) * math.min(math.ceil(totalOptions / 3), yGrid)

		local popup = vgui.Create 'DPanel'
		popup:DockPadding(5,5,5,5)
		popup:SetSize(popupWidth, popupHeight)
		popup:SetPos(parentBut:LocalToScreen((parentBut:GetWide() - popup:GetWide()) / 2, parentBut:GetTall() + 5))
		popup:MakePopup()
		hook.Add('VGUIMousePressed', 'dbgChars.f4.popup', function(panel)
			if IsValid(panel) and not popup:IsOurChild(panel) then
				popup:Remove()
			end
		end)
		function popup:OnRemove()
			hook.Remove('VGUIMousePressed', 'dbgChars.f4.popup')
		end

		local scrollPanel = popup:Add 'DScrollPanel'
		scrollPanel:Dock(FILL)

		local iconLayout = scrollPanel:Add 'DIconLayout'
		iconLayout:Dock(FILL)
		iconLayout:SetSpaceX(10)
		iconLayout:SetSpaceY(10)

		local hasPremium = dbgChars.hasPremium(LocalPlayer())

		local function createButton(optionData, isPremium)
			local modelBut = iconLayout:Add 'DButton'
			modelBut:SetSize(parentBut:GetSize())
			modelBut:SetText('')
			modelBut.Paint = modelButPaint
			function modelBut:DoClick()
				popup:Remove()
				options.onSelect(optionData)
			end

			local selectButPreview = modelBut:Add 'octolib_model'
			selectButPreview:SetSize(modelBut:GetSize())
			selectButPreview:SetMouseInputEnabled(false)
			local selectModel, selectDestination = options.getSetupParams(optionData)
			selectButPreview:Setup(selectModel, selectDestination, renderSettings)

			if optionData == options.selected then
				modelBut:SetEnabled(false)
				modelBut:AddOctoHint('Выбрано')

				local selectedIcon = modelBut:Add 'DImageButton'
				selectedIcon:Dock(FILL)
				selectedIcon:SetMouseInputEnabled(false)
				selectedIcon:SetImage('octoteam/icons-32/tick.png')
				selectedIcon:SetStretchToFit(false)
			end

			if isPremium and not hasPremium then
				modelBut:AddOctoHint('Для Добродеев')
				selectButPreview:SetAlpha(75)
			end
		end

		for _, optionData in ipairs(options.options) do
			createButton(optionData, false)
		end
		if options.optionsPremium then
			for _, optionData in ipairs(options.optionsPremium) do
				createButton(optionData, true)
			end
		end
	end

	return modelButPreview
end

hook.Add('octogui.f4-tabs', 'dbg-characters', function()
	octogui.f4.addButton({
		id = 'character',
		name = L.character,
		order = 10,
		icon = Material('octoteam/icons/man_m.png'),
		build = function(frame)
			dbgChars.fixConVars()

			frame:SetSize(800, 600)
			local ply = LocalPlayer()

			local modelContainer = vgui.Create 'DPanel'
			modelContainer:SetParent(frame)
			modelContainer:Dock(LEFT)
			modelContainer:DockMargin(5,5,5,5)
			modelContainer:SetWide(250)

			local modelPanel = vgui.Create 'DModelPanel'
			modelPanel:SetParent(modelContainer)
			modelPanel:Dock(FILL)
			modelPanel:SetCamPos(Vector(132,0,59))
			modelPanel:SetLookAng(Angle(10,180,0))
			modelPanel:SetFOV(15)
			modelPanel:SetCursor('none')
			function modelPanel:LayoutEntity(modelPanel)
				modelPanel:SetAngles(Angle(0, 5, 0))
				modelPanel.GetPlayerColor = function() return ply:GetPlayerColor() end
				return
			end
			modelPanel.UpdateEntityFromVars = octolib.func.debounce(function()
				if not IsValid(modelPanel) then return end

				modelPanel:SetModel(octolib.vars.get('dbgChars.model'))
				modelPanel.Entity:SetSkin(octolib.vars.get('dbgChars.skin'))
				for i, original in ipairs(modelPanel.Entity:GetMaterials()) do
					if string.find(original, 'facemap') then
						modelPanel.Entity:SetSubMaterial(i - 1, octolib.vars.get('dbgChars.face'))
					end
				end
			end, 0)
			modelPanel.UpdateEntityFromVars()

			local pnl = vgui.Create 'DPanel'
			pnl:SetParent(frame)
			pnl:Dock(FILL)
			pnl:DockPadding(5, 5, 5, 5)
			pnl:SetPaintBackground(false)

			do -- name
				local l = vgui.Create 'DLabel'
				l:SetParent(pnl)
				l:Dock(TOP)
				l:DockMargin(5,0,5,0)
				l:SetTall(30)
				l:SetText(L.name_character)
				l:SetFont('f4.normal')

				local e = vgui.Create 'DTextEntry'
				e:SetParent(pnl)
				e:Dock(TOP)
				e:DockMargin(5,5,5,20)
				e:SetTall(20)
				e:SetDrawLanguageID(false)
				e:SetUpdateOnType(true)
				e.OnValueChange = function(self, text)
					local oldCaretPos = self:GetCaretPos()
					local oldLen = utf8.len(self:GetText())

					local spaceWasLast = text:endsWith(' ')
					text = dbgChars.sanitizeName(text)
					octolib.vars.set('dbgChars.name', text)

					self:SetText(text .. (spaceWasLast and ' ' or ''))
					-- move caret back if we removed a character
					self:SetCaretPos(oldCaretPos - (utf8.len(self:GetText()) ~= oldLen and 1 or 0))
				end
				e.PaintOffset = 5

				frame.e_name = e
			end

			do -- short description
				local e, l = octolib.textEntry(pnl, L.desc_appereance)
				e:SetDrawLanguageID(false)
				e:SetText(octolib.vars.get('dbgChars.desc') or '')
				l:SetTall(30)
				l:SetFont('f4.normal')
				l:DockMargin(5,0,5,0)
				e:DockMargin(5,5,5,20)
				e:SetUpdateOnType(true)
				function e:OnValueChange(text)
					local oldCaretPos = self:GetCaretPos()
					local oldLen = utf8.len(self:GetText())

					local spaceWasLast = text:endsWith(' ')
					text = dbgChars.sanitizeDescription(text)
					octolib.vars.set('dbgChars.desc', text)

					self:SetText(text .. (spaceWasLast and ' ' or ''))
					-- move caret back if we removed a character
					self:SetCaretPos(oldCaretPos - (utf8.len(self:GetText()) ~= oldLen and 1 or 0))
				end
				e.PaintOffset = 5

				frame.e_desc = e
			end

			do -- appearance (model, face, skin)
				local appearanceCont = pnl:Add 'DPanel'
				appearanceCont:Dock(TOP)
				appearanceCont:DockMargin(0,0,0,15)
				appearanceCont:SetTall(150)
				appearanceCont:SetPaintBackground(false)

				local appearanceTitle = appearanceCont:Add 'DLabel'
				appearanceTitle:Dock(TOP)
				appearanceTitle:DockMargin(5,0,5,0)
				appearanceTitle:SetTall(30)
				appearanceTitle:SetText(L.appearance)
				appearanceTitle:SetFont('f4.normal')

				local modelButtonsCont = appearanceCont:Add 'DPanel'
				modelButtonsCont:Dock(FILL)
				modelButtonsCont:SetPaintBackground(false)

				local genderSelect = appearanceCont:Add 'DComboBox'
				genderSelect:Dock(TOP)
				genderSelect:DockMargin(0,0,0,10)
				genderSelect:SetTall(30)
				genderSelect:SetSortItems(false)
				for _, genderName in ipairs({'Мужчина', 'Женщина'}) do
					local isMale = genderName == 'Мужчина'
					genderSelect:AddChoice(genderName, genderName, isMale == octolib.models.isMale(octolib.vars.get('dbgChars.model')))
				end
				function genderSelect:OnSelect(i, v, data)
					local isMale = self:GetSelectedID() == 1
					local modelData = isMale and allModels.male[1] or allModels.female[1]
					octolib.vars.set('dbgChars.model', modelData.model)
					octolib.vars.set('dbgChars.face', modelData.faces[1])
					octolib.vars.set('dbgChars.skin', modelData.skins[1])
				end
				appearanceCont.genderSelect = genderSelect

				appearanceCont.Rebuild = octolib.func.debounce(function()
					local isMale = genderSelect:GetValue() == 'Мужчина'
					local models = isMale and allModels.male or allModels.female

					local model = octolib.vars.get('dbgChars.model')
					local face = octolib.vars.get('dbgChars.face')
					local skin = octolib.vars.get('dbgChars.skin')

					modelButtonsCont:Clear()

					local modelBut = modelButtonsCont:Add 'DButton'
					modelBut:Dock(LEFT)
					modelBut:DockMargin(0,0,10,0)
					modelBut:SetSize(80, 80)
					modelBut:SetText('')
					modelBut.Paint = modelButPaint
					modelBut:AddOctoHint('Голова')
					addButtonWithPreview(modelBut, {
						options = octolib.array.map(models, function(modelData) return modelData.model end),
						selected = model,
						onSelect = function(selected)
							octolib.vars.set('dbgChars.model', selected)
							octolib.vars.set('dbgChars.face', dbgChars.config.playerModels[selected].faces[1])
							octolib.vars.set('dbgChars.skin', dbgChars.config.playerModels[selected].skins[1])
						end,
						relativePos = Vector(2, -40, -1),
						relativeAng = Angle(0, -125, 0),
						fov = 15,
						getSetupParams = function(selected)
							return selected, {
								scale = 2,
							}
						end,
					})

					local faceBut = modelButtonsCont:Add 'DButton'
					faceBut:Dock(LEFT)
					faceBut:DockMargin(0,0,10,0)
					faceBut:SetSize(80, 80)
					faceBut:SetText('')
					faceBut.Paint = modelButPaint
					faceBut:AddOctoHint('Лицо')
					addButtonWithPreview(faceBut, {
						options = dbgChars.config.playerModels[model].faces,
						optionsPremium = dbgChars.config.playerModels[model].premiumFaces,
						selected = face,
						onSelect = function(selected)
							octolib.vars.set('dbgChars.face', selected)
						end,
						relativePos = Vector(0, -40, -1),
						relativeAng = Angle(0, 180, 0),
						fov = 15,
						getSetupParams = function(selected)
							return model, {
								scale = 2,
								subMats = {
									['.+facemap.+'] = selected,
								},
							}
						end,
					})

					local skinBut = modelButtonsCont:Add 'DButton'
					skinBut:Dock(LEFT)
					skinBut:SetSize(80, 80)
					skinBut:SetText('')
					skinBut.Paint = modelButPaint
					skinBut:AddOctoHint('Одежда')

					addButtonWithPreview(skinBut, {
						options = dbgChars.config.playerModels[model].skins,
						selected = skin,
						onSelect = function(selected)
							octolib.vars.set('dbgChars.skin', selected)
						end,
						relativePos = Vector(0, -100, -40),
						relativeAng = Angle(0, 180, 0),
						fov = 35,
						getSetupParams = function(selected)
							return octolib.vars.get('dbgChars.model'), {
								scale = 2,
								skin = selected,
							}
						end,
						lights = {
							{
								type = MATERIAL_LIGHT_POINT,
								pos = Vector(60, -30, 100),
								color = Vector(4, 4, 4),
								fiftyPercentDistance = 150,
								zeroPercentDistance = 200,
							},
							{
								type = MATERIAL_LIGHT_POINT,
								pos = Vector(-20, 50, 40),
								color = Vector(0.75, 0.75, 0.75),
								fiftyPercentDistance = 75,
								zeroPercentDistance = 100,
							},
						},
					})
				end, 0)
				appearanceCont:Rebuild()

				frame.appearanceCont = appearanceCont
			end

			do -- job
				local l = vgui.Create 'DLabel'
				l:SetParent(pnl)
				l:Dock(TOP)
				l:DockMargin(5,0,5,0)
				l:SetTall(30)
				l:SetText(L.citizen_work)
				l:SetFont('f4.normal')

				local e = vgui.Create 'DComboBox'
				e:SetParent(pnl)
				e:Dock(TOP)
				e:DockMargin(0,0,0,15)
				e:SetTall(30)
				e:SetSortItems(false)
				e.jobs = {}
				for _, job in ipairs(RPExtraTeams) do
					if not job.noPreference and (not job.hidden or isfunction(job.customCheck) and select(1, job.customCheck(ply))) then
						e:AddChoice(job.name, job.command, job.command == octolib.vars.get('dbgChars.job'))
						table.insert(e.jobs, job)
					end
				end
				function e:OnSelect(i, v, data)
					octolib.vars.set('dbgChars.job', data)
				end
				hook.Add('octolib.setVar', 'dbgChars.f4.job', function(var, val)
					if var ~= 'dbgChars.job' or not IsValid(e) then return end

					local newJob = DarkRP.getJobByCommand(val)
					if not newJob then
						octolib.vars.set('dbgChars.job', 'citizen')
						return
					end

					if not newJob.customCheck then return end

					local ok = newJob.customCheck(ply)
					if not ok then
						octolib.vars.set('dbgChars.job', 'citizen')
						return
					end

					e:SetValue(newJob.name)
				end)

				local oldOpen = e.OpenMenu
				function e:OpenMenu()
					oldOpen(self)
					for k, but in pairs(self.Menu:GetCanvas():GetChildren()) do
						local job = self.jobs[k]
						local limit = job.max == 0 or team.NumPlayers(job.team) < math.ceil(player.GetCount() * job.max)
						if not limit then
							but:SetEnabled(false)
							but:SetColor(Color(160,160,160))
							but:SetText(but:GetText() .. L.limit_hint)
						elseif isfunction(job.customCheck) then
							local can, reason = job.customCheck(ply)
							if not can then
								if not reason then reason = L.reason_unavailable end
								if reason:find(L.reason_find_dobro) then reason = L.reason_dobro end
								if reason:find(L.reason_play) then reason = L.need_play .. reason:gsub('[^%d]', '') .. 'ч' end
								but:SetEnabled(false)
								but:SetColor(Color(160,160,160))
								but:SetText(but:GetText() .. ' (' .. reason .. ')')
							end
						end
						but:SetIcon(octolib.icons.silk16(job.icon or 'error'))
					end
				end

				frame.e_job = e
			end

			do -- voice
				local voiceTitle = vgui.Create 'DLabel'
				voiceTitle:SetParent(pnl)
				voiceTitle:Dock(TOP)
				voiceTitle:DockMargin(5,0,5,0)
				voiceTitle:SetTall(30)
				voiceTitle:SetText(L.voice)
				voiceTitle:SetFont('f4.normal')

				local voiceCont = pnl:Add 'DPanel'
				voiceCont:Dock(TOP)
				voiceCont:DockMargin(0,0,0,15)
				voiceCont:SetTall(30)
				voiceCont:SetPaintBackground(false)

				local voiceSelect = vgui.Create 'DComboBox'
				voiceSelect:SetParent(voiceCont)
				voiceSelect:Dock(TOP)
				voiceSelect:DockMargin(0,0,0,15)
				voiceSelect:SetTall(30)
				voiceSelect:SetSortItems(false)
				voiceSelect:SetEnabled(true)
				voiceSelect:Clear()
				for _, add in ipairs(govorilka.voices) do
					voiceSelect:AddChoice(add.ru_name, add.en_name)
				end
				function voiceSelect:OnSelect(_, _, name)
					netstream.Start('govorilka.changeVoice', name)
					RunConsoleCommand('cl_govorilka_voice', name)
				end

				local voicePremiumNotice = voiceCont:Add 'DActionNotice'
				voicePremiumNotice:SetIcon('octoteam/icons-16/sound.png')
				voicePremiumNotice:SetText('Можно выбрать с говорилкой')
				voicePremiumNotice:SetButton('Купить', function()
					octoshop.openShopItem('govorilka')
				end)
				voicePremiumNotice:Dock(FILL)
				voicePremiumNotice.icon:SetWide(20)

				function voiceCont:SetNeedsPremium(needs)
					if needs then
						voiceCont:SetTall(35)
						voiceSelect:SetVisible(false)
						voicePremiumNotice:SetVisible(true)
						voiceSelect:SetValue(LocalPlayer():GetVoiceName())
					else
						voiceCont:SetTall(30)
						voiceSelect:SetVisible(true)
						voicePremiumNotice:SetVisible(false)
					end
				end

				hook.Add('octolib.netVarUpdate', 'dbgChars.f4.govorilka', function(index, key, value)
					if index ~= LocalPlayer():EntIndex() or key ~= 'os_govorilka' or not IsValid(voiceCont) then return end
					voiceCont:SetNeedsPremium(not value)
				end)
				voiceCont:SetNeedsPremium(not LocalPlayer():GetNetVar('os_govorilka'))
			end

			do -- respawn
				local cont = vgui.Create 'DPanel'
				cont:SetParent(pnl)
				cont:Dock(BOTTOM)
				function cont:SetNeedsPremium(needs)
					cont:Clear()

					if not needs then
						cont:SetTall(85)
						cont:DockPadding(5,5,5,5)

						local l = vgui.Create 'DLabel'
						l:SetParent(cont)
						l:Dock(TOP)
						l:DockMargin(5,0,5,0)
						l:SetTall(40)
						l:SetWrap(true)

						local e = vgui.Create 'DButton'
						e:SetParent(cont)
						e:Dock(TOP)
						e:DockMargin(0,5,0,0)
						e:SetTall(30)
						e:SetEnabled(true)

						function cont:SetCharacterSwitchActive(isActive)
							l:SetText(isActive and L.run_in_discreet_place or L.settings_in_respawn)
							e:SetText(isActive and L.cancel_changes or L.change_character)
							function e:DoClick()
								netstream.Start('dbg-characters.respawn', not isActive)
							end
						end
						cont:SetCharacterSwitchActive(false)
						netstream.Hook('dbg-characters.updateState', function(state)
							if not IsValid(cont) then return end
							cont:SetCharacterSwitchActive(state)
						end)
					else
						cont:SetTall(45)
						cont:DockPadding(0,0,0,0)

						local notice = cont:Add 'DActionNotice'
						notice:SetPaintBackground(false)
						notice:SetIcon('octoteam/icons-16/heart.png')
						notice:SetText('Выбранная внешность доступна только Добродеям')
						notice:SetButton('Купить', function()
							octoshop.openShopItem('jobs_1m')
						end)
						notice:Dock(FILL)
						notice.icon:SetWide(20)
					end
				end
				cont:SetNeedsPremium(false)

				frame.respawnCont = cont
			end

			function frame:UpdateFromPreset(preset)
				frame.e_name:SetValue(preset.name)
				frame.e_desc:SetValue(preset.desc)

				octolib.vars.set('dbgChars.model', preset.model)
				octolib.vars.set('dbgChars.skin', preset.skin)
				octolib.vars.set('dbgChars.face', preset.face)
				frame.appearanceCont:Rebuild()
			end

			function frame:UpdateFromConVars()
				self:UpdateFromPreset({
					name = octolib.vars.get('dbgChars.name'),
					desc = octolib.vars.get('dbgChars.desc'),
					model = octolib.vars.get('dbgChars.model'),
					skin = octolib.vars.get('dbgChars.skin'),
					face = octolib.vars.get('dbgChars.face'),
				})
			end

			-- charPresets
			local charsPnl = vgui.Create 'DPanel'
			charsPnl:SetParent(frame)
			charsPnl:Dock(RIGHT)
			charsPnl:SetWide(250)
			charsPnl:DockMargin(5,5,5,5)
			charsPnl:SetPaintBackground(false)
			do
				local topBar = vgui.Create 'DPanel'
				topBar:SetParent(charsPnl)
				topBar:Dock(TOP)
				topBar:DockMargin(0,0,0,0)
				topBar:SetTall(30)
				topBar:SetPaintBackground(false)

				local title = vgui.Create 'DLabel'
				title:SetParent(topBar)
				title:Dock(FILL)
				title:DockMargin(5,0,5,0)
				title:SetText('Сохраненные')
				title:SetFont('f4.normal')
				title:SetContentAlignment(4)

				local savePresetBut = vgui.Create 'DImageButton'
				savePresetBut:SetParent(topBar)
				savePresetBut:Dock(RIGHT)
				savePresetBut:SetWide(30)
				savePresetBut:SetImage('octoteam/icons-16/add.png')
				savePresetBut:SetText('')
				savePresetBut:AddOctoHint('Добавить')
				savePresetBut:SetStretchToFit(false)
				function savePresetBut:DoClick()
					-- note that there's validation on server
					dbgChars.savePreset({
						name = octolib.vars.get('dbgChars.name'),
						desc = octolib.vars.get('dbgChars.desc'),
						model = octolib.vars.get('dbgChars.model'),
						skin = octolib.vars.get('dbgChars.skin'),
						face = octolib.vars.get('dbgChars.face'),
					})
				end

				local charListPnl = vgui.Create 'DScrollPanel'
				charListPnl:SetParent(charsPnl)
				charListPnl:Dock(FILL)

				local function rebuildPresets(savedPresets)
					charListPnl:GetCanvas():Clear()

					savedPresets = savedPresets or {}
					for charId, preset in pairs(savedPresets) do
						local container = vgui.Create 'DPanel'
						container:SetParent(charListPnl)
						container:Dock(TOP)
						container:DockMargin(0,0,0,10)
						container:SetTall(80)

						local presetModelPanel = vgui.Create 'octolib_model'
						presetModelPanel:SetParent(container)
						presetModelPanel:Dock(LEFT)
						presetModelPanel:SetSize(96, 78)
						presetModelPanel:DockMargin(0,1,0,1)
						local renderSettings = function(ent)
							local camPivot, camPos, camAng = getCamPosRelativeToEyes(ent, Vector(0, -40, -1))
							if IsValid(ent) then
								ent:SetEyeTarget(camPos)
							end

							return {
								camFov = 15,
								camAng = camAng,
								camPos = camPos,
								baseLightColor = Vector(0, 0, 0),
								lights = getNiceLights(camPivot, camAng),
							}
						end
						presetModelPanel:Setup(preset.model, {
							skin = preset.skin,
							subMats = {
								['.+facemap.+'] = preset.face,
							},
						}, renderSettings)

						local nameLabel = container:Add 'DLabel'
						nameLabel:DockMargin(0,8,0,0)
						nameLabel:Dock(TOP)
						nameLabel:SetContentAlignment(4)
						nameLabel:SetTall(20)
						nameLabel:SetText(preset.name)
						nameLabel:SetFont('f4.semi-small')

						local descLabel = container:Add 'DLabel'
						descLabel:Dock(FILL)
						descLabel:SetContentAlignment(7)
						descLabel:SetText(preset.desc)
						descLabel:SetTooltip(preset.desc)
						descLabel:SetMouseInputEnabled(true)

						local bottomBar = vgui.Create 'DPanel'
						bottomBar:SetParent(container)
						bottomBar:Dock(BOTTOM)
						bottomBar:SetTall(25)
						bottomBar:SetPaintBackground(false)

						local moreActionsBut = vgui.Create 'DImageButton'
						moreActionsBut:SetParent(bottomBar)
						moreActionsBut:Dock(RIGHT)
						moreActionsBut:SetWide(25)
						moreActionsBut:SetImage('octoteam/icons-16/bullet_arrow_down.png')
						moreActionsBut:SetText('')
						moreActionsBut:AddOctoHint('Изменить')
						moreActionsBut:SetStretchToFit(false)
						function moreActionsBut:DoClick()
							octolib.menu({
								{'Перезаписать', 'octoteam/icons-16/user_edit.png', function()
									dbgChars.savePreset({
										name = octolib.vars.get('dbgChars.name'),
										skin = octolib.vars.get('dbgChars.skin'),
										desc = octolib.vars.get('dbgChars.desc'),
										face = octolib.vars.get('dbgChars.face'),
										model = octolib.vars.get('dbgChars.model'),
									}, charId)
								end},
								{'Удалить', 'octoteam/icons-16/delete.png', function()
									Derma_Query(
										'Это безвозвратно удалит сохраненного персонажа. Продолжить?',
										'Удаление персонажа',
										L.yes, function() dbgChars.removePreset(charId) end,
										L.no
									)
								end},
							}):Open()
						end

						local loadPresetBut = vgui.Create 'DImageButton'
						loadPresetBut:SetParent(bottomBar)
						loadPresetBut:Dock(RIGHT)
						loadPresetBut:SetWide(25)
						loadPresetBut:SetImage('octoteam/icons-16/tick.png')
						loadPresetBut:SetText('')
						loadPresetBut:AddOctoHint('Применить')
						loadPresetBut:SetStretchToFit(false)
						function loadPresetBut:DoClick()
							frame:UpdateFromPreset(preset)
						end
					end
				end

				hook.Add('dbg-characters.presetsUpdated', 'f4-tab', function(presets)
					if not IsValid(frame) then return end
					rebuildPresets(presets)
				end)

				hook.Add('octolib.setVar', 'dbgChars.f4.model', function(var)
					if var ~= 'dbgChars.model' and var ~= 'dbgChars.face' and var ~= 'dbgChars.skin' then return end

					if IsValid(modelPanel) then
						modelPanel:UpdateEntityFromVars()
					end

					if IsValid(frame.appearanceCont) then
						local isMale = octolib.models.isMale(octolib.vars.get('dbgChars.model'))
						frame.appearanceCont.genderSelect:SetValue(isMale and 'Мужчина' or 'Женщина')
						frame.appearanceCont:Rebuild()
					end

					if IsValid(frame.respawnCont) then
						local model = octolib.vars.get('dbgChars.model')
						local face = octolib.vars.get('dbgChars.face')
						local skin = octolib.vars.get('dbgChars.skin')

						local canUse, needsPremium = dbgChars.canUseModel(LocalPlayer(), model, face, skin)
						frame.respawnCont:SetNeedsPremium(not canUse and needsPremium)
					end
				end)

				dbgChars.fetchPresetsFromServer()
			end
		end,
		show = function(frame, st)
			if not st then return end

			dbgChars.fixConVars()
			frame:UpdateFromConVars()
		end,
	})
end)
