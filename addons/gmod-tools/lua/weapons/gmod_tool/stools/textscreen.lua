TOOL.Category = 'EastCoast'
TOOL.Name = 'Текст'

dbgTextScreen = dbgTextScreen or {}

dbgTextScreen.backgrounds = {
	{
		name = 'Нет',
		func = octolib.func.zero
	},
	{
		name = 'Тень',
		func = function(line, x, y)
			local distance = line.background.size

			draw.SimpleText(
				line.text,
				dbgTextScreen.getFont(line.font.id, line.font.size),
				x + distance,
				y + distance,
				line.background.color,
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_CENTER
			)
		end,
	},
	{
		name = 'Заливка',
		func = function(line, x, y)
			local space = line.background.size

			surface.SetFont(dbgTextScreen.getFont(line.font.id, line.font.size))
			local textW, textH = surface.GetTextSize(line.text)

			textW, textH = textW + space, textH + space

			draw.RoundedBox(
				0,
				x - textW / 2,
				y - textH / 2,
				textW,
				textH,
				line.background.color
			)
		end,
	},
	{
		name = 'Обводка',
		func = function(line, x, y)
			draw.SimpleTextOutlined(
				line.text,
				dbgTextScreen.getFont(line.font.id, line.font.size),
				x,
				y,
				line.font.color,
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_CENTER,
				line.background.size,
				line.background.color
			)

			return true
		end,
	},
}

dbgTextScreen.fonts = {
	{
		name = 'Граффити 1',
		font = 'Pershotravneva55',
	},
	{
		name = 'Граффити 2 (англ.)',
		font = 'Street Rats',
	},
	{
		name = 'Граффити 3',
		font = 'Urban Decay SP',
	},
	{
		name = 'Граффити 4',
		font = 'Chicago Rockers',
	},
	{
		name = 'Бокстон',
		font = 'Boxtoon',
	},
	{
		name = 'Индико',
		font = 'Indico',
	},
	{
		name = 'Военный 1',
		font = 'Capture it',
	},
	{
		name = 'Винтажный 1',
		font = 'ST-Brigantina-free',
	},
	{
		name = 'Винтажный 2 (англ.)',
		font = 'Riesling',
	},
	{
		name = 'Робото',
		font = 'Roboto',
	},
	{
		name = 'Монтсеррат',
		font = 'Montserrat',
	},
	{
		name = 'Нунито',
		font = 'Nunito',
	},
	{
		name = 'Клаксон',
		font = 'Klyakson',
	},
	{
		name = 'Неоновый 1',
		font = 'Broadway-Neon',
	},
	{
		name = 'Неоновый 2',
		font = 'Neoneon',
	},
	{
		name = 'Морфин',
		font = 'MorfinSans',
	},
}

dbgTextScreen.defaultLine = {
	text = '',
	font = {
		id = 1,
		color = color_white,
		size = 72,
	},
	background = {
		id = 1,
		color = color_black,
		size = 5,
	},
}

dbgTextScreen.linesCount = 5
dbgTextScreen.debounceDelay = 0.3

if CLIENT then
	octolib.vars.init('tools.textScreen', {})

	local storedFonts = {}
	function dbgTextScreen.getFont(id, size)
		local fontName = string.format('ts.%s.%s', id, size)

		if not storedFonts[fontName] then
			local fontInfo = dbgTextScreen.fonts[id]
			if not fontInfo then
				fontInfo = dbgTextScreen.fonts[1]
			end

			surface.CreateFont(fontName, {
				font = fontInfo.font,
				size = size,
				weight = 500,
				extended = true,
			})

			storedFonts[fontName] = true
		end

		return fontName
	end

	function dbgTextScreen.drawLine(line, x, y)
		local text = line.text

		local font = line.font
		local fontName = dbgTextScreen.getFont(font.id, font.size)

		local bg = dbgTextScreen.backgrounds[line.background.id]
		if bg and bg.func(line, x, y) == true then
			return
		end

		draw.SimpleText(
			text,
			fontName,
			x,
			y,
			font.color,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end

	function dbgTextScreen.precacheLines(lines)
		local y = 0

		for _, line in ipairs(lines) do
			if not dbgTextScreen.validateLine(line) then continue end

			surface.SetFont(dbgTextScreen.getFont(line.font.id, line.font.size))
			local _, textH = surface.GetTextSize(line.text)

			line.y = y + textH / 2
			y = y + textH
		end

		return y
	end

	function dbgTextScreen.drawLines(lines, x, yOffset)
		for _, line in ipairs(lines) do
			local y = line.y
			if not y then continue end

			dbgTextScreen.drawLine(line, x, y + yOffset)
		end
	end
end

function dbgTextScreen.validateLine(line)
	line.text = string.Trim(line.text)

	if utf8.len(line.text) == 0 then
		return nil
	end

	return line
end

local skipSaving = false
local linesHeight = 0
local function saveVar(lines)
	if skipSaving then
		return
	end

	linesHeight = dbgTextScreen.precacheLines(lines)

	octolib.vars.set('tools.textScreen', lines)
end

local function formatLineForList(line)
	local text = line.text
	if utf8.len(text) <= 0 then
		text = '<пусто>'
	end

	return text
end

function TOOL:LeftClick(tr)
	if tr.Entity:GetClass() == 'player' then return false end
	if CLIENT then return true end
	if not self:GetWeapon():CheckLimit('textscreens') then return false end

	local ply = self:GetOwner()

	ply:GetClientVar('tools.textScreen', function(vars)
		local lines = octolib.table.mapSequential(
			vars['tools.textScreen'],
			dbgTextScreen.validateLine
		)

		if #lines == 0 then return end

		local ent = ents.Create('textscreen')
		ent:SetPos(tr.HitPos + tr.HitNormal * 0.5)

		local hitAngle = tr.HitNormal:Angle()
		local angle = hitAngle + angle_zero

		angle:RotateAroundAxis(hitAngle:Right(), -90)
		angle:RotateAroundAxis(hitAngle:Forward(), 90)

		ent:SetAngles(angle)

		ent:Spawn()

		ent.lines = lines
		ent:SetNetVar('lines', lines)

		undo.Create('textscreen')
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
		undo.Finish()

		ply:AddCount('textscreens', ent)
		ply:AddCleanup('textscreens', ent)
	end)

	return true
end

function TOOL:RightClick(tr)
	local ent = tr.Entity
	local ply = self:GetOwner()

	if ent:GetClass() ~= 'textscreen' then return false end
	if ent:CPPIGetOwner() ~= ply then return false end

	if CLIENT then return true end

	ply:GetClientVar('tools.textScreen', function(vars)
		local lines = octolib.table.mapSequential(
			vars['tools.textScreen'],
			dbgTextScreen.validateLine
		)

		ent.lines = lines
		ent:SetNetVar('lines', lines)
	end)
end

function TOOL:BuildCPanel()
	octolib.vars.presetManager(self, 'tools.textScreen', {'tools.textScreen'})

	local lines = table.Copy(octolib.vars.get('tools.textScreen'))
	local selectedLineId = 1

	local preview = vgui.Create('DPanel')
	preview.Paint = function(s, w, h)
		if h ~= linesHeight then
			s:SetTall(linesHeight)
		end

		dbgTextScreen.drawLines(lines, w / 2, 0)
	end
	self:AddItem(preview)

	local function refreshLineEditorValues()
		local line = lines[selectedLineId]
		if not line then
			line = table.Copy(dbgTextScreen.defaultLine)
			lines[selectedLineId] = line
		end

		skipSaving = true
		self.textEntry:SetValue(line.text)
		self.fontEntry:SetValue(dbgTextScreen.fonts[line.font.id].name)
		self.typeEntry:SetValue(dbgTextScreen.backgrounds[line.background.id].name)
		self.sizeSlider:SetValue(line.font.size)
		self.shadowSlider:SetValue(line.background.size)
		self.tMixer:SetColor(line.font.color)
		self.tShadowMixer:SetColor(line.background.color)
		skipSaving = false

		linesHeight = dbgTextScreen.precacheLines(lines)
	end

	local lineListContainer = vgui.Create('DPanel')
	lineListContainer:DockPadding(0, 1, 0, 0)
	lineListContainer:SetTall(87)
	self:AddItem(lineListContainer)

	local lineList = vgui.Create('DListView', lineListContainer)
	lineList:Dock(FILL)
	lineList:DisableScrollbar()
	lineList:SetMultiSelect(false)
	lineList:AddColumn('Строка')
	lineList:SetHideHeaders(true)
	lineList.Refresh = function()
		lineList:Clear()

		for lineId = 1, dbgTextScreen.linesCount do
			local line = lines[lineId]
			if not line then
				line = table.Copy(dbgTextScreen.defaultLine)
				lines[lineId] = line
			end

			lineList:AddLine(formatLineForList(line))
		end

		lineList:SelectFirstItem()
	end
	lineList.OnRowSelected = function(_, lineId)
		selectedLineId = lineId
		refreshLineEditorValues()
	end

	local lineContainer = vgui.Create('DPanel')
	lineContainer:SetPaintBackground(false)
	self:AddItem(lineContainer)

	-- Текст
	local textEntry = octolib.textEntry(lineContainer, 'Текст')
	textEntry:SetPlaceholderText('Продам крутые пушки, звони - *номер*')
	textEntry:SetUpdateOnType(true)
	textEntry.OnValueChange = octolib.func.debounce(function(_, val)
		lines[selectedLineId].text = val
		lineList:GetLine(selectedLineId):SetColumnText(1, formatLineForList(lines[selectedLineId]))
		saveVar(lines)
	end, dbgTextScreen.debounceDelay)
	self.textEntry = textEntry

	-- Шрифт
	local fontEntry = octolib.comboBox(lineContainer, 'Шрифт', octolib.array.map(dbgTextScreen.fonts, function(fontData, fontId)
		return {fontData.name, fontId}
	end))
	fontEntry.OnSelect = octolib.func.debounce(function(_, _, _, val)
		lines[selectedLineId].font.id = val
		saveVar(lines)
	end, dbgTextScreen.debounceDelay)
	self.fontEntry = fontEntry

	-- Тип
	local typeEntry = octolib.comboBox(lineContainer, 'Фон', octolib.array.map(dbgTextScreen.backgrounds, function(bgData, bgId)
		return {bgData.name, bgId}
	end))
	typeEntry.OnSelect = octolib.func.debounce(function(_, _, _, val)
		lines[selectedLineId].background.id = val
		saveVar(lines)
	end, dbgTextScreen.debounceDelay)
	self.typeEntry = typeEntry

	-- Размер
	local sizeSlider = octolib.slider(lineContainer, 'Размер', 12, 100, 0)
	sizeSlider.OnValueChanged = octolib.func.debounce(function(_, val)
		lines[selectedLineId].font.size = math.Round(val)
		saveVar(lines)
	end, dbgTextScreen.debounceDelay)
	self.sizeSlider = sizeSlider

	-- Расстояние тени
	local shadowSlider = octolib.slider(lineContainer, 'Размер фона', 1, 100, 0)
	shadowSlider.OnValueChanged = octolib.func.debounce(function(_, val)
		lines[selectedLineId].background.size = math.Round(val)
		saveVar(lines)
	end, 0.5)
	self.shadowSlider = shadowSlider

	-- Цвет текста
	local tMixer = octolib.colorPicker(lineContainer, 'Цвет текста', true, false)
	function tMixer:ValueChanged(col)
		lines[selectedLineId].font.color = col
		saveVar(lines)
	end
	self.tMixer = tMixer

	-- Цвет тени/фона
	local tShadowMixer = octolib.colorPicker(lineContainer, 'Цвет тени/фона', true, false)
	function tShadowMixer:ValueChanged(col)
		lines[selectedLineId].background.color = col
		saveVar(lines)
	end
	self.tShadowMixer = tShadowMixer

	self:DockPadding(0, 0, 0, 10)
	lineContainer:InvalidateLayout(true)
	lineContainer:SizeToChildren(false, true)

	hook.Add('octolib.setVar', 'tool.textScreen', function(var, val)
		if not IsValid(self) then
			hook.Remove('octolib.setVar', 'tool.textScreen')
			return
		end

		if var ~= 'tools.textScreen' or val == lines then
			return
		end

		for lineId = 1, dbgTextScreen.linesCount do
			refreshLineEditorValues(lineId)
		end
		lines = table.Copy(val)

		lineList:Refresh()
	end)

	lineList:Refresh()
end

cleanup.Register('textscreens')

if CLIENT then
	TOOL.Information = {
		{name = 'left'},
		{name = 'right'},
	}

	language.Add('tool.textscreen.name', 'Текст')
	language.Add('tool.textscreen.desc', 'Создает текст в 3D-пространстве')
	language.Add('tool.textscreen.left', 'Создать новый текст')
	language.Add('tool.textscreen.right', 'Обновить параметры существующего текста')
	language.Add('undone.textscreens', 'Отмена текстов')
	language.Add('Undone_textscreens', 'Отмена текстов')
	language.Add('cleanup.textscreens', 'Тексты')
	language.Add('cleaned.textscreens', 'Очищены все текста')
	language.Add('cleaned_textscreens', 'Очищены все текста')
	language.Add('SBoxLimit.textscreens', 'Ты достиг лимита текстов')
	language.Add('SBoxLimit_textscreens', 'Ты достиг лимита текстов')
end