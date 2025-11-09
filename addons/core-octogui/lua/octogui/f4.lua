octogui.f4 = octogui.f4 or {}

local panel
local options = {}

surface.CreateFont('f4.small', {
	font = 'Calibri',
	extended = true,
	size = 14,
	weight = 350,
})
surface.CreateFont('f4.small-sh', {
	font = 'Calibri',
	extended = true,
	size = 14,
	blursize = 3,
	weight = 350,
})

surface.CreateFont('f4.counter', {
	font = 'Arial',
	extended = true,
	size = 14,
	weight = 600,
})
surface.CreateFont('f4.counter.norm', {
	font = 'Arial',
	extended = true,
	size = 20,
	weight = 600,
})
surface.CreateFont('f4.semi-small', {
	font = 'Tahoma',
	extended = true,
	size = 14,
	weight = 700,
})

surface.CreateFont('f4.normal', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})
surface.CreateFont('f4.normal-sh', {
	font = 'Calibri',
	extended = true,
	size = 27,
	blursize = 5,
	weight = 350,
})

surface.CreateFont('f4.medium', {
	font = 'Calibri',
	extended = true,
	size = 42,
	weight = 350,
})
surface.CreateFont('f4.medium-sh', {
	font = 'Calibri',
	extended = true,
	size = 42,
	blursize = 8,
	weight = 350,
})

local function ease(t, b, c, d)
	t = t / d
	return -c * t * (t - 2) + b
end

local function playTime(time)
	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format('%02i:%02i:%02i', h, m, s)
end

local function drawText(text, font, x, y, xal, yal, col, shCol)
	draw.Text {
		text = text,
		font = font .. '-sh',
		pos = {x, y + 2},
		xalign = xal,
		yalign = yal,
		color = shCol,
	}

	draw.Text {
		text = text,
		font = font,
		pos = {x, y},
		xalign = xal,
		yalign = yal,
		color = col,
	}
end

local function getAdminsCount()
    local count = 0
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsAdmin() or (serverguard and serverguard.player:GetRank(ply) ~= 'user') then
            count = count + 1
        end
    end
    return count
end

local function drawStatBox(x, y, w, h, icon, text, textColor, shadowColor)
    draw.RoundedBox(4, x, y, w, h, CFG.skinColors.hvr)

    if icon and not icon:IsError() then
        surface.SetMaterial(icon)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(x + 15, y + (h - 24) / 2, 24, 24)
    end

    local font = 'f4.normal'
    local shFont = 'f4.normal-sh'

    draw.SimpleText(text, shFont, x + 50, y + h / 2, shadowColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(text, font, x + 50, y + h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

local cols = {
	txt = Color(238,238,238, 255),
	txtSh = Color(0,0,0, 255),
	indicator = Color(255,255,255, 200),
}

local function insertAndSort(data)
	if not data.id then
		error('Cannot add option without "id" field')
		return
	end

	local new = true
	for i, option in ipairs(options) do
		if option.id == data.id then
			options[i] = data
			new = false
			break
		end
	end

	if new then
		table.insert(options, data)
	end

	table.SortByMember(options, 'order', true)
end

local colRed = CFG.skinColors.r
local function paintBut(self, w, h)

	surface.SetAlphaMultiplier(panel.al)

	local open = IsValid(self.window) and self.window:IsVisible()
	surface.SetDrawColor(255,255,255, (open or self.Hovered) and 255 or 150)
	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect(w / 2 - 32, h / 2 - 32, 64, 64)

	if open then
		draw.RoundedBox(4, w / 2 - 16, -5, 32, 8, cols.indicator)
	end

	if isstring(self.counter) or self.counter > 0 then
		surface.DisableClipping(true)
		surface.SetFont('f4.counter')
		local tw = math.max(surface.GetTextSize(self.counter), 8)
		local x, y = w / 2 + 30, h / 2 - 30
		draw.RoundedBox(8, x - 4 - tw / 2, y - 8, tw + 8, 16, colRed)
		draw.SimpleText(self.counter, 'f4.counter', tostring(self.counter):len() <= 1 and (x + 1) or x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.DisableClipping(false)
	end

	surface.SetAlphaMultiplier(1)

end

local function showWindow(w)
	w:SetVisible(true)
	if w.showFunc then w:showFunc(true) end

	if not w.oldPos then
		w.oldPos = {w:GetPos()}
		w.oldPos[2] = w.oldPos[2] - 20
	end

	w:MoveToFront()
	w:MoveTo(w.oldPos[1], w.oldPos[2], 0.2, 0, 0.5)
	w:AlphaTo(255, 0.2, 0)
	timer.Simple(0.2, function()
		w:SetVisible(true)
		w:SetAlpha(255)
		w:SetPos(w.oldPos[1], w.oldPos[2])
	end)
end

local function hideWindow(w)
	w.oldPos = {w:GetPos()}
	w:MoveTo(w.oldPos[1], w.oldPos[2] + 20, 0.2, 0, 2)
	w:AlphaTo(0, 0.2, 0)
	timer.Simple(0.2, function()
		if w.showFunc then w:showFunc(false) end
		w:SetPos(w.oldPos[1], w.oldPos[2] + 20)
		w:SetAlpha(0)
		w:SetVisible(false)
	end)
end

local function teamName(ply)
	local name = team.GetName(ply:Team())
	local customJob = ply:GetNetVar('customJob')
	if customJob then name = customJob[1] end
	return name
end

local statIcons = {
    time = Material('octoteam/icons/clock.png', 'noclamp'),
    money = Material('materials/octoteam/icons-16/wallet.png', 'noclamp'),
    salary = Material('materials/octoteam/icons-16/money_add.png', 'noclamp'),
    players = Material('octoteam/icons-32/bullet_user.png', 'noclamp'),
    admin = Material('octoteam/icons-32/administrator.png', 'noclamp'),
    police = Material('octoteam/icons-32/user_policeman_white.png', 'noclamp')
}

function octogui.f4.show()
	if not IsValid(panel) then octogui.f4.reload() end
	panel:Show()
end

function octogui.f4.hide()
	if not IsValid(panel) then octogui.f4.reload() end
	panel:Hide()
end

function octogui.f4.setCounter(id, count)
	if not IsValid(panel) then octogui.f4.reload() end
	panel:SetCounter(id, count)
end

function octogui.f4.openWindow(id)
	if not IsValid(panel) then octogui.f4.reload() end
	panel:OpenWindow(id)
end
surface.CreateFont('f4.zetnik', {
	font = 'Calibri',
	extended = true,
	size = 23,
	weight = 300,
})
function octogui.f4.reload()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	if IsValid(octogui.f4.panel) then
		octogui.f4.panel:Remove()
	end
	table.Empty(options)

	local f = vgui.Create 'DFrame'
	f:SetSize(ScrW(), ScrH())
	f:SetTitle('')
	f:MakePopup()
	f:SetVisible(false)
	f:SetDraggable(false)
	f.btnClose:SetVisible(false)
	f.btnMinim:SetVisible(false)
	f.btnMaxim:SetVisible(false)
	f.openTime = 0
	f.windows = {}
	f.buttons = {}
	f.counters = f.counters or {}
	panel = f
	octogui.f4.panel = panel

	hook.Add('VGUIMousePressed', 'f4', function(pnl)
		if not panel:IsVisible() then return end
		for _, v in pairs(f.windows) do
			if pnl == v or v:IsOurChild(pnl) then v:MoveToFront() end
		end
	end)

	local bClose = f:Add 'DButton'
	bClose:SetSize(64,64)
	bClose:AlignRight(15)
	bClose:AlignTop(15)
	bClose:SetText('')
	bClose:SetTooltip(L.close)
	bClose.icon = Material('octoteam/icons/cross.png')
	function bClose:DoClick() f:Hide() end
	function bClose:Paint(w, h)
		if self.Hovered then
			surface.SetDrawColor(255,255,255, 255)
		else
			surface.SetDrawColor(0,0,0, 100 * panel.al)
		end
		surface.SetMaterial(self.icon)
		surface.DrawTexturedRect(w / 2 - 32, h / 2 - 32, 64, 64)
	end

	local blur, skinCols = Material('pp/blurscreen'), CFG.skinColors
	function f:Paint(w, h)
		local a = ease(self.isClosing and (math.max(self.isClosing - CurTime(), 0) / 0.3) or (1 - math.max(self.openTime + 0.3 - CurTime(), 0) / 0.3), 0, 1, 1)
		self.al = a

		local colMod = {
			['$pp_colour_addr'] = 0,
			['$pp_colour_addg'] = 0,
			['$pp_colour_addb'] = 0,
			['$pp_colour_mulr'] = 0,
			['$pp_colour_mulg'] = 0,
			['$pp_colour_mulb'] = 0,
			['$pp_colour_brightness'] = -0.2 * a,
			['$pp_colour_contrast'] = 1 + 0.5 * a,
			['$pp_colour_colour'] = 1 - a,
		}

		if GetConVar('octolib_blur'):GetBool() then
			DrawColorModify(colMod)

			surface.SetDrawColor(255, 255, 255, 255 * a)
			surface.SetMaterial(blur)

			for i = 1, 3 do
				blur:SetFloat('$blur', a * i * 2)
				blur:Recompute()

				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect(-1, -1, w + 2, h + 2)
			end
		else
			colMod['$pp_colour_brightness'] = -0.4 * a
			colMod['$pp_colour_contrast'] = 1 + 0.2 * a
			DrawColorModify(colMod)
		end

		draw.NoTexture()
		surface.SetDrawColor(skinCols.bg.r, skinCols.bg.g, skinCols.bg.b, 100 * a)
		surface.DrawRect(-1, -1, w + 2, h + 2)

		surface.SetAlphaMultiplier(a)
		local ply = LocalPlayer()
		local hvrPnl = vgui.GetHoveredPanel()

-- Заменяем весь блок с панелями статистики:

local panelWidth = 250
local panelHeight = 60
local margin = 3

-- Поднимаем все панели выше, освобождая место для увеличенной панели статистики
local startY = h - panelHeight * 3 - margin * 2 - 40 -- Уменьшил отступ снизу

local colorTimePanel = Color(100, 70, 50, 220)  
local colorMoneyPanel = Color(40, 40, 40, 220)    
local colorStatsPanel = Color(40, 40, 40, 220)
local colorProgressFill = Color(70, 180, 150, 200)

-- Панель времени (самая верхняя)
draw.RoundedBox(4, 20, startY, panelWidth, panelHeight, colorTimePanel)

if statIcons.time and not statIcons.time:IsError() then
	surface.SetMaterial(statIcons.time)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(70, startY + (panelHeight - 46) / 2, 24, 24)
end

draw.SimpleText(playTime(ply:GetTimeTotal()), 'f4.normal', 100, startY + panelHeight / 3 - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

local barX = 20 + 20
local barY = startY + panelHeight / 2 + 4
local barW = panelWidth - 40
local barH = 20

draw.RoundedBox(20, barX, barY, barW, barH, Color(0, 0, 0, 150))

local totalSeconds = ply:GetTimeTotal()
local hours = math.floor(totalSeconds / 3600)
local progressVal = math.min(hours, 24)
local fillW = math.max(1, barW * (progressVal / 24))
draw.RoundedBox(60, barX, barY, fillW, barH, colorProgressFill)

draw.SimpleText("ОТЧЕТ до приезда ТЦК", 'f4.semi-small', barX + barW / 2, barY + barH / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

-- Панель денег (посередине)
draw.RoundedBox(4, 20, startY + panelHeight + margin, panelWidth, panelHeight/2 - margin/2, colorMoneyPanel)

if statIcons.money and not statIcons.money:IsError() then
	surface.SetMaterial(statIcons.money)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(37, startY + panelHeight + margin + (panelHeight/2 - margin/2 - 19) / 2, 20, 20)
end

draw.SimpleText(DarkRP.formatMoney(ply:GetNetVar('money') or 0), 'f4.zetnik', 20 + 50, startY + panelHeight + margin + (panelHeight/2 - margin/2) / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

draw.RoundedBox(4, 20, startY + panelHeight + margin + panelHeight/2 - margin/2, panelWidth, panelHeight/2 - margin/2, colorMoneyPanel)

if statIcons.salary and not statIcons.salary:IsError() then
	surface.SetMaterial(statIcons.salary)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(37, startY + panelHeight + margin + panelHeight/2 - margin/5 + (panelHeight/2 - margin/2 - 18) / 2, 20, 20)
end

draw.SimpleText(DarkRP.formatMoney(ply:Salary() or 0), 'f4.zetnik', 20 + 50, startY + panelHeight + margin + panelHeight/2 - margin/2 + (panelHeight/2 - margin/2) / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

-- Панель статистики (самая нижняя - увеличенная)
local statsPanelHeight = panelHeight + 20 -- Увеличиваем высоту
local statsPanelY = startY + panelHeight + 70 + margin -- Опускаем ниже денежной панели
draw.RoundedBox(4, 20, statsPanelY, panelWidth, statsPanelHeight, colorStatsPanel)

local iconSize = 32
local colWidth = (panelWidth - 40) / 3

local playersCount = player.GetCount()
local adminsCount = getAdminsCount()
local policeCount = #player.GetPolice()

-- Игроки (левый столбец)
local playerX = 20 + colWidth * 0.5
if statIcons.players and not statIcons.players:IsError() then
	surface.SetMaterial(statIcons.players)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(playerX - 13 - iconSize * 0.5, statsPanelY - 3, 42, 42)
end
draw.SimpleText(tostring(playersCount), 'f4.normal', playerX, statsPanelY + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

-- Админы (центральный столбец)
local adminX = 20 + colWidth * 1.5
if statIcons.admin and not statIcons.admin:IsError() then
	surface.SetMaterial(statIcons.admin)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(adminX + 2 - iconSize * 0.5, statsPanelY + 8, iconSize, iconSize)
end
draw.SimpleText(tostring(adminsCount), 'f4.normal', adminX, statsPanelY + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

local policeX = 20 + colWidth * 2.5
if statIcons.police and not statIcons.police:IsError() then
	surface.SetMaterial(statIcons.police)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(policeX - iconSize * 0.5, statsPanelY + 8, iconSize, iconSize)
end
draw.SimpleText(tostring(policeCount), 'f4.normal', policeX, statsPanelY + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if IsValid(hvrPnl) and hvrPnl.barTxt then
			drawText(
				hvrPnl.barTxt, 'f4.medium', w / 2, h - 80,
				TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, cols.txt, cols.txtSh
			)
		end

		surface.SetAlphaMultiplier(1)
	end

	local p = f:Add 'DPanel'
	p:SetPos(0, ScrH() - 75)
	p:SetTall(70)
	function p:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0, 100 * panel.al))
	end
	f.openWindow = {}
	function p:Update()
		self:Clear()
		f.openWindow = {}

		local butsNum = 0
		for i, v in ipairs(options) do
			if not v.check or v.check() then
				local b = p:Add 'DButton'
				b:SetSize(75,70)
				b:SetPos(3 + (i-1) * 75, 0)
				b:SetText('')
				b.barTxt = v.name
				b.icon = v.icon
				b.Paint = paintBut
				b.window = f.windows[i]
				b.counter = panel.counters[v.id] or 0
				function b:DoClick(onlyOpen)
					local w = f.windows[i]
					if IsValid(w) then
						local st = not w:IsVisible()
						if st then
							showWindow(w)
						elseif not onlyOpen then
							hideWindow(w)
						end
						self.window = w
						return
					end

					w = f:Add 'DFrame'
					w:SetTitle(v.name)
					w.btnMaxim:SetVisible(false)
					w.btnMinim:SetVisible(false)
					v.build(w)
					w.showFunc = v.show
					w:SetPos(self:LocalToScreen(32, 32) - w:GetWide() / 2, 0)
					w:CenterVertical()
					w:SetDeleteOnClose(false)
					showWindow(w)
					function w.btnClose:DoClick() hideWindow(w) end

					f.windows[i] = w
					self.window = f.windows[i]
				end
				f.openWindow[v.id] = function() b:DoClick(true) end
				f.buttons[v.id] = b
				butsNum = butsNum + 1

				if IsValid(f.windows[i]) then
					local w = f.windows[i]
					if w.wasVisible then
						showWindow(w)
					end
				end
			else
				if IsValid(f.windows[i]) then
					f.windows[i]:Remove()
					f.windows[i] = nil
				end
			end
		end

		self:SetWide(butsNum * 75 + 6)
		self:CenterHorizontal()
	end

	function panel:Update()
		p:Update()
	end

	function panel:Think()
		if self:IsVisible() and gui.IsGameUIVisible() then
			self:Hide()
		end
	end

	function panel:SetCounter(id, amount)
		panel.counters[id] = amount

		local but = f.buttons[id]
		if IsValid(but) then
			but.counter = amount
		end
	end

	local lastCursorPos = {ScrW() / 2, ScrH() / 2}
	function panel:Show()
		if self.isClosing then return end

		self.openTime = CurTime()
		self:SetVisible(true)
		self:SetMouseInputEnabled(true)
		self:SetKeyboardInputEnabled(true)
		self:Update()

		gui.SetMousePos(lastCursorPos[1], lastCursorPos[2])
	end

	function panel:Hide()
		if self.isClosing then return end

		for _, w in pairs(f.windows) do
			w.wasVisible = w:IsVisible()
			if w.wasVisible then hideWindow(w) end
		end

		gui.HideGameUI()
		lastCursorPos[1], lastCursorPos[2] = gui.MousePos()

		self:SetMouseInputEnabled(false)
		self:SetKeyboardInputEnabled(false)
		self.isClosing = CurTime() + 0.3
		timer.Simple(0.5, function()
			if not IsValid(self) then return end
			self.isClosing = nil
			self:SetVisible(false)
		end)
	end

	function panel:Toggle()
		if self:IsVisible() then
			self:Hide()
		else
			self:Show()
		end
	end

	function panel:OpenWindow(id)
		if self.openWindow[id] then
			if not self:IsVisible() then
				self:Show()
			end
			timer.Simple(0.5, function()
				self.openWindow[id]()
			end)
		end
	end

	hook.Add('ShowSpare2', 'f4', function()
		if IsValid(panel) then
			panel:Toggle()
		else
			octolib.notify.show('warning', L.f4_failure)
		end
	end)

	function panel:OnKeyCodeReleased(key)
		if input.LookupKeyBinding(key) == 'gm_showspare2' then
			panel:Hide()
		end
	end

	function octogui.f4.addButton(data)
		insertAndSort(data)
		panel:Update()
	end

	hook.Run('octogui.f4-tabs')
end

concommand.Add('octogui_reloadf4', octogui.f4.reload)
hook.Add('PlayerFinishedLoading', 'octogui.f4', octogui.f4.reload)
timer.Simple(0, octogui.f4.reload)

octolib.testHelper.addCategory('f4', {
	name = 'F4',
	icon = octolib.icons.silk16('application_view_tile'),
})

octolib.testHelper.addMethod('f4.reload', {
	name = 'Перезагрузить F4',
	parent = 'f4',
}, octogui.f4.reload)