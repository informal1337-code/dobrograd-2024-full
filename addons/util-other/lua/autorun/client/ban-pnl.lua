-- "addons\\util-other\\lua\\autorun\\client\\ban_pnl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local banConsentFrame

local performLayout = function(self)
	timer.Simple(0.2, function()
		if IsValid(self) then
			self:SizeToChildren(false, true)
		end
	end)
end
local sizeToY = function(self)
	self:SizeToContentsY()
end

local function panel(parent, name, desc)

	local pan = parent:Add 'DPanel'
	pan:Dock(TOP)
	pan:DockMargin(0,0,0,5)
	pan:DockPadding(5,5,5,5)
	pan.PerformLayout = performLayout

	if name then
		local l = pan:Add 'DLabel'
		l:Dock(TOP)
		l:DockMargin(5,0,5,5)
		l:SetTall(25)
		l:SetFont('octolib.normal')
		l:SetText(name)
		pan.name = l
	end

	if desc then
		local l = pan:Add 'DLabel'
		l:Dock(TOP)
		l:DockMargin(5,0,5,0)
		l:SetText(desc)
		l:SetWrap(true)
		l.PerformLayout = sizeToY
		pan.desc = l
	end

	return pan
end

netstream.Hook('dbg-ban.consent', function(data)
	if IsValid(banConsentFrame) then banConsentFrame:Close() end

	local height = 550
	local fr = vgui.Create 'DFrame'
	fr:SetSize(500, 550)
	fr:SetSizable(true)
	function fr:OnSizeChanged(w, h)
		if w ~= 500 then fr:SetWide(500) end
		if h > height then fr:SetTall(height) end
	end
	fr:Center()
	fr:SetTitle('Блокировка игрока ' .. data.target)
	fr:SetAlpha(0)
	fr:MakePopup()
	banConsentFrame = fr

	local scr = fr:Add('DScrollPanel')
	scr:Dock(FILL)

	panel(scr, nil, 'Ты собираешься выдать ПЕРМАНЕНТНУЮ блокировку игроку. Пожалуйста, проверь всю информацию о нем, чтобы убедиться в отсутствии последствий')
	local nick = panel(scr, 'Ник игрока', '')
	steamworks.RequestPlayerInfo(util.SteamIDTo64(data.target), function(name)
		nick.desc:SetText(name)
	end)
	panel(scr, 'SteamID', data.target)

	local profile = panel(scr, 'Профиль в Steam', 'https://steamcommunity.com/profiles/' .. util.SteamIDTo64(data.target))
	profile.desc:SetMouseInputEnabled(true)
	profile.desc:SetCursor('hand')
	profile.desc:SetColor(Color(0,130,255))
	profile.desc.DoClick = function(self)
		octogui.esc.OpenURL(self:GetText())
	end

	panel(scr, 'БЛОКИРОВКА БЕССРОЧНАЯ!', 'Особенно внимательно просмотри связанные аккаунты')

	local banReason, banBtn = panel(scr, 'Причина выдачи блокировки', 'Пожалуйста, укажи причину выдачи ПЕРМАНЕНТНОЙ блокировки аккаунта. Убедись, что в этом имеется необходимость, поскольку это крайняя мера наказания')
	data.banReason = data.banReason ~= '' and data.banReason or nil
	local e = banReason:Add 'DTextEntry'
	e:Dock(TOP)
	e:DockMargin(5,5,5,0)
	e:SetUpdateOnType(true)
	e:SetValue(data.reason ~= 'Причина не указана' and data.reason or '')
	e.OnValueChange = function(self)
		local val = string.Trim(self:GetText())
		data.banReason = val ~= '' and val or nil
	end

	local familyPan = panel(scr, 'Связанные аккаунты', not data.family[1] and 'Нет связанных аккаунтов' or 'ПКМ или двойной ЛКМ по строке откроет профиль игрока в Steam')
	local lst = familyPan:Add('DListView')
	lst:Dock(TOP)
	lst:DockMargin(5,5,5,0)
	lst:AddColumn('Ник в стиме')
	lst:AddColumn('SteamID')
	lst:SetMultiSelect(false)
	for _, v in ipairs(data.family) do
		if v ~= data.target then
			local line = lst:AddLine('', v)
			steamworks.RequestPlayerInfo(util.SteamIDTo64(v), function(name)
				if IsValid(line) then line:SetColumnText(1, name) end
			end)
		end
	end
	function lst:OnRowRightClick(_, line)
		octolib.menu({{'Открыть профиль', 'icon16/user_go.png', function()
			octogui.esc.OpenURL('https://steamcommunity.com/profiles/' .. util.SteamIDTo64(line:GetColumnText(2)))
		end}}):Open()
	end
	function lst:OnDoubleClick(_, line)
		octogui.esc.OpenURL('https://steamcommunity.com/profiles/' .. util.SteamIDTo64(line:GetColumnText(2)))
	end
	lst:SetTall(lst:GetHeaderHeight() + lst:GetDataHeight() * #lst:GetLines())

	panel(scr, nil, 'Нажми на кнопку ниже, чтобы выдать бан навсегда. Чтобы отменить выдачу блокировки, закрой это окно')

	local sec = 10
	banBtn = octolib.button(scr, 'Выдать блокировку (' .. sec .. ')', function()
		if data.banReason == nil then return end
		netstream.Start('dbg-ban.consent', data.target, data.banReason)
		fr:Close()
	end)
	banBtn:SetFont('f4.normal')
	banBtn:SetTall(45)
	banBtn:SetEnabled(false)
	timer.Create('serverguard.ban.confirm-think', 1, 0, function()
		if not banBtn:IsValid() then return timer.Remove('serverguard.ban.confirm-think') end
		if data.reason ~= 'Причина не указана' then
			if sec == 0 then
				banBtn:SetText('Выдать блокировку')
				banBtn:SetEnabled(true)
			else
				banBtn:SetText('Выдать блокировку (' .. sec .. ')')
				sec = sec - 1
			end
		else
			banBtn:SetText('Укажи причину выдачи блокировки')
			banBtn:SetEnabled(false)
		end
	end)
	fr:InvalidateChildren(true)
	timer.Simple(1, function()
		local h = octolib.table.reduce(scr:GetCanvas():GetChildren(), function(ch, child)
			return ch + child:GetTall() + select(2, child:GetDockMargin()) + select(4, child:GetDockMargin())
		end, 0)
		if fr:IsValid() then fr:AlphaTo(255, 0.5) end
		height = h + select(2, fr:GetDockPadding()) + select(4, fr:GetDockPadding())
	end)
end)