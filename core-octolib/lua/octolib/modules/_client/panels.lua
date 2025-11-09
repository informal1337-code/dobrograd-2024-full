--[[
	Namespace: octolib

	Group: panels
]]

local function doMenu(menu, entries)
	for i, entry in ipairs(entries) do
		if istable(entry) then
			local name, icon, more = unpack(entry)

			local subMenu, menuOption
			if isfunction(more) then
				menuOption = menu:AddOption(name, more)
			elseif istable(more) then
				subMenu, menuOption = menu:AddSubMenu(name)
				doMenu(subMenu, more)
			end

			if icon and menuOption then menuOption:SetIcon(icon) end
		elseif entry == 'spacer' then
			menu:AddSpacer()
		end
	end
end

--[[
	Function: menu
		Builds interactive context menu

	Arguments:
		<table> entries - Sequential table of <ContextMenuItem>

	Returns:
		<Panel> - <DMenu: https://wiki.facepunch.com/gmod/DMenu>

	Example:
		--- Lua
		local menu = octolib.menu({
			{ 'Hello', 'icon16/tick.png', function() print('Hello') end }, -- with icon
			{ 'I am', nil, function() print('There') end }, -- without icon
			{ 'Menu', nil, { -- with submenu
				{ 'Submenu item', nil, function() print('So sub') end },
			}},
		})

		menu:Open()
		---
]]
function octolib.menu(entries)
	local menu = DermaMenu()
	doMenu(menu, entries)

	return menu
end

function octolib.fQuery(...)
	local args = {...}
	return function() Derma_Query(unpack(args)) end
end

function octolib.fStringRequest(...)
	local args = {...}
	return function() Derma_StringRequest(unpack(args)) end
end

function octolib.overlay(parent, classOrPanel, persist, col)
	local overlay = vgui.Create(persist and 'DPanel' or 'DButton')
	if IsValid(parent) then parent:Add(overlay) end

	local container
	if isstring(classOrPanel) then
		container = overlay:Add(classOrPanel)
	else
		classOrPanel:SetParent(overlay)
		container = classOrPanel
	end

	function overlay:Think()
		local overlayParent = self:GetParent()
		if not IsValid(overlayParent) then return end

		local newW, newH = overlayParent:GetSize()
		if newW ~= self.overlay_oldW or self.overlay_oldH ~= newH then
			self:SetPos(0, 0)
			self:SetSize(newW, newH)
			if IsValid(container) then container:Center() end
		end
		self.overlay_oldW, self.overlay_oldH = newW, newH
	end

	overlay.bgCol = col or Color(0,0,0, 200)
	function overlay:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, self.bgCol)
	end

	if not persist then
		overlay:SetText('')
		function overlay:DoClick()
			self:Remove()
		end
	end

	function container:OnRemove() overlay:Remove() end

	return container, overlay
end

--
-- QUICK PANEL CREATION
--

function octolib.button(parent, text, onClick)
	local button = vgui.Create 'DButton'
	if parent.AddItem then parent:AddItem(button) else parent:Add(button) end
	button:Dock(TOP)
	button:SetTall(25)
	button:SetText(text)
	button.DoClick = onClick

	return button
end

function octolib.label(parent, txt)
	local label = vgui.Create 'DLabel'
	if parent.AddItem then parent:AddItem(label) else parent:Add(label) end
	label:Dock(TOP)
	label:SetTall(18)
	label:SetContentAlignment(4)
	label:SetText(txt)

	return label
end

function octolib.slider(parent, text, min, max, prc)
	local slider = vgui.Create 'DNumSlider'
	if parent.AddItem then parent:AddItem(slider) else parent:Add(slider) end
	slider:Dock(TOP)
	slider:SetTall(30)
	slider:SetText(text)
	slider:SetMinMax(min, max)
	slider:SetDecimals(prc)
	slider.Slider.Knob:NoClipping(false)

	return slider
end

function octolib.checkBox(parent, txt)
	local checkBox = vgui.Create 'DCheckBoxLabel'
	if parent.AddItem then parent:AddItem(checkBox) else parent:Add(checkBox) end
	checkBox:Dock(TOP)
	checkBox:DockMargin(0, 5, 0, 5)
	checkBox:SetText(txt)

	return checkBox
end

function octolib.textEntry(parent, txt)
	local label = txt and octolib.label(parent, txt) or nil
	if label then
		label:DockMargin(3, 5, 0, 0)
	end

	local entry = vgui.Create 'DTextEntry'
	if parent.AddItem then parent:AddItem(entry) else parent:Add(entry) end
	entry:Dock(TOP)
	entry:SetTall(25)
	entry:DockMargin(0, 0, 0, 5)

	return entry, label
end

function octolib.iconPickerEntry(parent, txt, path)
	local entry, label = octolib.textEntry(parent, txt)

	local iconPickerButton = entry:Add 'DButton'
	iconPickerButton:Dock(RIGHT)
	iconPickerButton:SetWide(25)
	iconPickerButton:SetText('')
	iconPickerButton:SetIcon(octolib.icons.silk16('color_swatch'))
	iconPickerButton:SetPaintBackground(false)
	function iconPickerButton:DoClick()
		if IsValid(self.picker) then return end
		self.picker = octolib.icons.picker(function(val) icon:SetValue(val) end)
	end

	return entry, label, iconPickerButton
end

function octolib.numberWang(parent, txt, defaultValue, min, max)
	local label = txt and octolib.label(parent, txt) or nil
	if label then
		label:DockMargin(3, 5, 0, 0)
	end

	local numberWang = vgui.Create 'DNumberWang'
	if parent.AddItem then parent:AddItem(numberWang) else parent:Add(numberWang) end
	numberWang:Dock(TOP)
	numberWang:SetTall(25)
	numberWang:DockMargin(0, 0, 0, 5)
	if min then numberWang:SetMin(min) end
	if max then numberWang:SetMax(max) end
	if defaultValue then numberWang:SetValue(defaultValue) end

	function numberWang.Up:DoClick()
		if numberWang:IsEnabled() then
			numberWang:SetValue(numberWang:GetValue() + numberWang:GetInterval())
		end
	end
	function numberWang.Down:DoClick()
		if numberWang:IsEnabled() then
			numberWang:SetValue(numberWang:GetValue() - numberWang:GetInterval())
		end
	end
	function numberWang:OnChange()
		local val = self:GetValue()
		local fixed = val
		if self:GetMin() then fixed = math.max(self:GetMin(), fixed) end
		if self:GetMax() then fixed = math.min(self:GetMax(), fixed) end
		fixed = math.Round(fixed, self:GetDecimals())
		if fixed ~= val then
			local cpos = self:GetCaretPos()
			self:SetText(fixed)
			self:SetCaretPos(math.min(cpos, utf8.len(tostring(fixed))))
		else
			self:OnValueChanged(val)
		end
	end

	return numberWang, label
end

function octolib.numberScratch(parent, txt, val, min, max, decimals)
	decimals = decimals or 3
	min = min or 0
	max = max or 100
	val = math.Round(val or 0, decimals)

	local entry, label = octolib.textEntry(parent, txt)
	entry:SetNumeric(true)
	entry:SetText(val)
	entry:SetEnterAllowed(false)

	local numberScratch = vgui.Create('DNumberScratch', entry)
	numberScratch:SetImage(octolib.icons.silk16('seek_bar_050'))
	numberScratch:SetValue(val)
	numberScratch:SetDecimals(decimals)
	numberScratch:SetMin(min)
	numberScratch:SetMax(max)
	numberScratch:Dock(RIGHT)
	numberScratch:DockMargin(0, 0, 5, 0)

	function entry:OnChange()
		local newval = tonumber(self:GetValue())

		local clampval = math.Round(math.Clamp(tonumber(newval) or 0, min, max), decimals)
		if clampval ~= newval then
			self:SetText(clampval)
			self:SetCaretPos(#tostring(clampval))
		end

		numberScratch:SetValue(clampval)
		self:OnValueChange(clampval)
	end

	function numberScratch:OnValueChanged(newval)
		entry:SetValue(math.Round(newval, decimals))
	end

	return entry, label
end

function octolib.colorPicker(parent, txt, enableAlpha, enablePalette)
	local label = txt and octolib.label(parent, txt) or nil
	if label then
		label:DockMargin(3, 5, 0, 0)
	end

	local mixer = vgui.Create 'DColorMixer'
	if parent.AddItem then parent:AddItem(mixer) else parent:Add(mixer) end
	mixer:Dock(TOP)
	mixer:SetTall(150)
	mixer:DockMargin(0, 0, 0, 5)
	mixer:SetAlphaBar(enableAlpha == true)
	mixer:SetWangs(true)
	mixer:SetPalette(enablePalette == true)

	return mixer, label
end

function octolib.comboBox(parent, txt, choices)
	local label = txt and octolib.label(parent, txt) or nil
	if label then
		label:DockMargin(3, 5, 0, 0)
	end

	local comboBox = vgui.Create 'DComboBox'
	if parent.AddItem then parent:AddItem(comboBox) else parent:Add(comboBox) end
	comboBox:Dock(TOP)
	comboBox:SetTall(25)
	comboBox:DockMargin(0, 0, 0, 5)
	comboBox:SetSortItems(false)

	choices = choices or {}
	for i, v in ipairs(choices) do
		comboBox:AddChoice(v[1], v[2], v[3])
	end

	return comboBox, label
end

function octolib.textEntryIcon(parent, text, path)
	local label = text and octolib.label(parent, text) or nil
	if label then
		label:DockMargin(3, 5, 0, 0)
	end

	local entry = vgui.Create 'DTextEntry'
	if parent.AddItem then parent:AddItem(entry) else parent:Add(entry) end
	entry:Dock(TOP)
	entry:SetTall(25)
	entry:DockMargin(0, 0, 0, 5)

	local button = entry:Add 'DButton'
	button:Dock(RIGHT)
	button:SetWide(25)
	button:SetText('')
	button:SetIcon('octoteam/icons-16/color_swatch.png')
	button:SetPaintBackground(false)
	function button:DoClick()
		if IsValid(self.picker) then return end
		self.picker = octolib.icons.picker(
			function(val) entry:SetValue(val) end,
			entry:GetValue(),
			path
		)
	end

	return entry, label
end

function octolib.confirmDialog(parent, question, callback, noCancel)
	local frame = octolib.overlay(parent, 'DPanel')
	frame:SetSize(180, 60)
	octolib.label(frame, question):SetContentAlignment(5)

	local bottomPanel = frame:Add('DPanel')
	bottomPanel:Dock(FILL)
	bottomPanel:SetPaintBackground(false)

	local yesButton = octolib.button(bottomPanel, 'Да', function() callback(true) frame:Remove() end)
	yesButton:Dock(LEFT)
	yesButton:SetWide(50)
	yesButton:DockMargin(5, 0, 5, 5)

	local noButton = octolib.button(bottomPanel, 'Нет', function() callback(false) frame:Remove() end)
	noButton:Dock(LEFT)
	noButton:SetWide(50)
	noButton:DockMargin(5, 0, 5, 5)

	if not noCancel then
		local cancelButton = octolib.button(bottomPanel, 'Отмена', function() frame:Remove() end)
		cancelButton:Dock(FILL)
		cancelButton:DockMargin(5, 0, 5, 5)
	end
end

function octolib.binder(parent, txt, val)
	local panel = txt and octolib.label(parent, txt) or nil
	if panel then
		panel:DockMargin(3, 5, 0, 0)
	end

	local binder = vgui.Create 'DBinder'
	if parent.AddItem then parent:AddItem(binder) else parent:Add(binder) end
	binder:Dock(TOP)
	binder:SetTall(24)
	binder:SetContentAlignment(5)
	if val then
		binder:SetSelectedNumber(val)
	end

	return binder
end

hook.Add('Think', 'octolib.panels', function()
	hook.Remove('Think', 'octolib.panels')

	local Panel = FindMetaTable 'Panel'
	surface.CreateFont('octolib.hint', {
		font = 'Calibri',
		extended = true,
		size = 18,
		weight = 350,
	})

	surface.CreateFont('octolib.hint-sh', {
		font = 'Calibri',
		extended = true,
		size = 40,
		weight = 350,
		blursize = 10,
	})

	local function paintHint(self, w, h)
		surface.DisableClipping(true)

		local alpha = self.anim
		surface.SetFont('octolib.hint')
		local tw = surface.GetTextSize(self.hint)
		local x, y = w / 2, -16 * #self.lines

		local boxX, boxY = math.floor((w - tw - 14) / 2), y - 10
		local boxW, boxH = tw + 14, -y + 6

		octolib.render.drawShadow(16, boxX - 8, boxY - 5, boxW + 16, boxH + 16, ColorAlpha(color_black, alpha * 75))

		draw.RoundedBox(4, boxX, boxY, boxW, boxH, ColorAlpha(CFG.skinColors.o, alpha * 255))
		for i, line in ipairs(self.lines) do
			draw.SimpleText(line, 'octolib.hint', x, y + (i - 1) * 16, ColorAlpha(color_white, alpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		draw.SimpleText('u', 'marlett', x, -10, ColorAlpha(CFG.skinColors.o, alpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.DisableClipping(false)
	end

	local function thinkHint(self)
		self.anim = math.Approach(self.anim, self.Hovered and 1 or 0, FrameTime() / 0.1)
	end

	-- Class: Panel

	--[[
		Function: AddHint
			Adds simple fading tooltop above the panel generally used to place usage hints

		Arguments:
			<string> text - Text to place into tooltip
	]]
	function Panel:AddHint(text)
		self.realPaint = self.realPaint or self.Paint or function() end
		self.realThink = self.realThink or self.Think or function() end
		self.realEnter = self.realEnter or self.OnCursorEntered or function() end
		self.realExit = self.realExit or self.OnCursorExited or function() end

		self.anim = 0
		self.hint = isfunction(text) and '' or text or 'Hint text'
		self.lines = self.hint:split('\n')

		self.Paint = function(self, w, h)
			if self.anim > 0 then paintHint(self, w, h) end
			self:realPaint(w, h)
		end

		self.Think = function(self)
			self:realThink()
			thinkHint(self)
			if self.anim > 0 and isfunction(text) then
				self.hint = text()
				self.lines = self.hint:split('\n')
			end
		end

		self.OnCursorEntered = function(self)
			self:realEnter()
			self:SetDrawOnTop(true)
		end

		self.OnCursorExited = function(self)
			self:realExit()
			self:SetDrawOnTop(false)
		end
	end
end)
