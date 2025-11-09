-- "addons\\feature-tutorial\\lua\\tutorial\\cl_slideshow.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.slideshow = dbgTutorial.slideshow or {}

local ScaleH = function(num)
	local scrW, scrH = ScrW(), ScrH()
	if scrW / scrH >= 1.4 then
		return num * (scrH / 1080)
	else
		return num * (scrW / 1920)
	end
end

surface.CreateFont('tutorial.title', {
	font = 'Nunito Sans ExtraBold',
	extended = true,
	size = ScaleH(100),
	weight = 400,
})

surface.CreateFont('tutorial.nav-button', {
	font = 'Nunito Sans Black',
	extended = true,
	size = ScaleH(24),
	weight = 900,
})

surface.CreateFont('tutorial.button', {
	font = 'Nunito Sans Black',
	extended = true,
	size = ScaleH(26),
	weight = 900,
})

local function openUrl(url)
	return function()
		gui.OpenURL(url)
	end
end

local colors = CFG.skinColors
local pages = {
	{
		title = 'ДОБРО ПОЖАЛОВАТЬ!',
		panel = {
			mat = Material('tutorial_dbg/0.png'),
			offsetX = 400,
		},
		background = Material('tutorial_dbg/0_bg.png'),
	},
	{
		title = 'РАЗНООБРАЗИЕ ЗАНЯТИЙ',
		panel = {
			mat = Material('tutorial_dbg/1.png'),
			offsetX = -400,
		},
		background = Material('tutorial_dbg/1_bg.png'),
	},
	{
		title = 'РЕАЛИСТИЧНОЕ ОРУЖИЕ',
		panel = {
			mat = Material('tutorial_dbg/2.png'),
			offsetX = 400,
		},
		background = Material('tutorial_dbg/2_bg.png'),
	},
	{
		title = 'ПОЛНЫЙ КОНТРОЛЬ АВТО',
		panel = {
			mat = Material('tutorial_dbg/3.png'),
			offsetX = -400,
		},
		background = Material('tutorial_dbg/3_bg.png'),
	},
	{
		title = 'КРАФТ И ЭКОНОМИКА',
		panel = {
			mat = Material('tutorial_dbg/4.png'),
			offsetX = 400,
		},
		background = Material('tutorial_dbg/4_bg.png'),
	},
	{
		title = 'УДОБНАЯ КАРТА',
		panel = {
			mat = Material('tutorial_dbg/5.png'),
			offsetX = -400,
		},
		background = Material('tutorial_dbg/5_bg.png'),
	},
	{
		title = 'НАШ СЕТТИНГ',
		panel = {
			mat = Material('tutorial_dbg/6.png'),
			offsetX = 400,
			button = {
				text = 'ПРОЧИТАТЬ ИСТОРИЮ ГОРОДА',
				offsetY = 460,
				height = 46,
				onClick = openUrl('https://wiki.octothorp.team/ru/dobrograd'),
			},
		},
		background = Material('tutorial_dbg/6_bg.png'),
	},
	{
		title = 'НАШИ ПРАВИЛА',
		panel = {
			mat = Material('tutorial_dbg/7.png'),
			offsetX = -400,
			button = {
				text = 'ОТКРЫТЬ ПРАВИЛА',
				offsetY = 460,
				height = 46,
				onClick = openUrl('https://wiki.octothorp.team/ru/dobrograd/rules'),
			},
		},
		background = Material('tutorial_dbg/7_bg.png'),
	},
	{
		title = 'НАЧАЛО ИГРЫ',
		panel = {
			mat = Material('tutorial_dbg/8.png'),
			offsetX = 400,
			button = {
				text = 'НАЧАТЬ ИГРУ',
				offsetY = 360,
				height = 46,
				onClick = function()
					dbgTutorial.slideshow.close()

					netstream.Request('dbgTest.spawnPlayer')
						:Then(function()
							dbgTest.welcomeScreen(false)
							dbgTest.disableFlyover()
						end)
				end,
			},
		},
		background = Material('tutorial_dbg/8_bg.png'),
	},
}

local disabledColor = Color(37, 30, 33, 255)
local disabledColor_d = Color(disabledColor.r * 0.75, disabledColor.g * 0.75, disabledColor.b * 0.75, 255)

local function navigationButtonPaint(self, w, h)
	local alpha = 255
	local off = h > 20 and 2 or 1
	if self.Depressed then
		draw.RoundedBoxEx(32, 0, off, w, h-off, colors.g, unpack(self.cornerInfo))
		draw.RoundedBoxEx(32, 0, off, w, h-off, colors.hvr, unpack(self.cornerInfo))
	else
		local disabled = self:GetDisabled()
		draw.RoundedBoxEx(32, 0, 0, w, h, not disabled and colors.g_d or disabledColor_d, unpack(self.cornerInfo))
		draw.RoundedBoxEx(32, 0, 0, w, h-off, not disabled and colors.g or disabledColor, unpack(self.cornerInfo))
		if disabled then
			alpha = 100
		elseif self.Hovered then
			draw.RoundedBoxEx(32, 0, 0, w, h, colors.hvr, unpack(self.cornerInfo))
		end
	end
	draw.SimpleText(self.text, 'tutorial.nav-button', w / 2, h / 2, ColorAlpha(color_white, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function centerLayout(self, w)
	local children = self:GetChildren()
	local panelsWide = 0
	for _, v in ipairs(children) do panelsWide = panelsWide + v:GetWide() end

	local spacing = ScaleH(150)
	local x = (w - panelsWide - spacing * (#children - 1)) / 2
	if self.offsetX then
		x = x + ScaleH(self.offsetX)
	end

	for _, v in ipairs(children) do
		v:SetX(x)
		v:CenterVertical()
		x = x + v:GetWide() + spacing
	end
end

function dbgTutorial.slideshow.open()
	dbgTest.welcomeScreen(false)

	if IsValid(DBG_TUTORIAL) then
		DBG_TUTORIAL:Hide()
	end

	if IsValid(dbgTutorial.slideshow.frame) then
		dbgTutorial.slideshow.frame:Remove()
	end

	local frame = vgui.Create 'DFrame'
	dbgTutorial.slideshow.frame = frame
	frame:SetSize(ScrW(), ScrH())
	frame:SetTitle('')
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:MakePopup()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.5, 0)

	frame.pages = {}
	frame.selectedPage = 0

	function frame:Paint(w, h)
		octolib.blur.draw()

		if #self.pages == 0 or self.selectedPage == 0 then return end

		local pageInfo = self.pages[self.selectedPage]
		if pageInfo.background then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(pageInfo.background)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		draw.SimpleText(pageInfo.title, 'tutorial.title', w / 2, 60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local pageSelector = frame:Add 'DPanel'
	pageSelector:SetTall(74)
	pageSelector:SetPaintBackground(false)
	pageSelector:SetZPos(10)
	function pageSelector:PerformLayout(w, h)
		self:SetPos(ScrW() / 2 - w / 2, ScrH() - h - 60)
	end

	local pageList = pageSelector:Add 'DPanel'
	pageList:SetTall(16)
	pageList:AlignBottom()

	local startVector = Vector(16, 0, 0)
	pageList.anim = {}
	pageList.anim.startPos = startVector
	pageList.anim.pos = startVector
	pageList.anim.endPos = startVector

	function pageList:UpdateSelectionAnimation()
		local systime = SysTime()
		local anim = self.anim
		anim.startTime = systime
		anim.endTime = systime + 0.35
		anim.startPos = anim.endPos
		anim.endPos = Vector(16 + (frame.selectedPage - 1) * 32, 0, 0)
	end

	function pageList:Paint(w, h)
		local anim = pageList.anim
		local x = 16
		for i = 1, #frame.pages do
			if math.abs(anim.pos.x - x) > 1 then
				draw.RoundedBox(8, x, 0, 16, 16, ColorAlpha(color_black, 150))
			end
			x = x + 32
		end

		local pos = startVector
		if anim.startPos ~= anim.endPos then
			local fraction = math.TimeFraction(anim.startTime, anim.endTime, SysTime())
			fraction = math.Clamp(fraction, 0, 1)

			pos = LerpVector(octolib.tween.easing.outBack(fraction, 0, 1, 1), anim.startPos, anim.endPos)
		end

		anim.pos = pos
		draw.RoundedBox(8, pos.x, 0, 16, 16, colors.g)
	end

	local pageButtons = pageSelector:Add 'DPanel'
	pageButtons:Dock(TOP)
	pageButtons:DockPadding(10, 0, 10, 0)
	pageButtons:SetTall(40)
	pageButtons:SetPaintBackground(false)

	function pageButtons:PerformLayout(w, h)
		local children = self:GetChildren()
		local panelsWide = 0
		for _, v in ipairs(children) do panelsWide = panelsWide + v:GetWide() end

		local spacing = 20
		local x = (w - panelsWide - spacing * (#children - 1)) / 2
		for _, v in ipairs(children) do
			v:SetX(x)
			x = x + v:GetWide() + spacing
		end
	end

	local function createNavigationButton(text, corners, onClick)
		local btn = pageButtons:Add 'DButton'
		btn:SetSize(124, 40)
		btn:SetText('')

		btn.text = text
		btn.cornerInfo = corners
		btn.Paint = navigationButtonPaint
		btn.DoClick = onClick

		return btn
	end

	local backBtn, nextBtn

	local function switchToPage(index)
		local pageCount = #frame.pages
		if index <= 0 or index > pageCount then return end
		if index == 1 then
			backBtn:SetDisabled(true)
		elseif index == pageCount then
			nextBtn:SetDisabled(true)
		end

		local currentPageIndex = frame.selectedPage
		local currentPageDir, pageDir
		if currentPageIndex < index then
			currentPageDir = -ScrW()
			pageDir = ScrW()
		elseif currentPageIndex > index then
			currentPageDir = ScrW()
			pageDir = -ScrW()
		end

		if index > 1 and index < pageCount then
			backBtn:SetDisabled(false)
			nextBtn:SetDisabled(false)
		end

		local currentPage = frame.pages[currentPageIndex]
		local page = frame.pages[index]
		if currentPage then
			currentPage.pnl:Stop()
			currentPage.pnl:SetVisible(true)
			currentPage.pnl:MoveTo(currentPageDir, 0, 0.2, 0, -1, function()
				currentPage.pnl:SetVisible(false)
			end)
		end

		if page then
			page.pnl:SetPos(pageDir, 0)
			page.pnl:SetVisible(true)
			page.pnl:SetAlpha(0)
			page.pnl:MoveTo(0, 0, 0.2)
			page.pnl:AlphaTo(255, 0.2, 0)
		end

		frame.selectedPage = index
	end

	backBtn = createNavigationButton('НАЗАД', {true, false, true, false}, function()
		switchToPage(frame.selectedPage - 1)
		pageList:UpdateSelectionAnimation()

		surface.PlaySound('dbg/button_click.ogg')
	end)
	nextBtn = createNavigationButton('ДАЛЕЕ', {false, true, false, true}, function()
		switchToPage(frame.selectedPage + 1)
		pageList:UpdateSelectionAnimation()

		surface.PlaySound('dbg/button_click.ogg')
	end)

	for k, v in ipairs(pages) do
		local panelInfo = v.panel

		local panel = frame:Add 'DPanel'
		panel:SetSize(ScrW(), ScrH())
		panel:SetPaintBackground(false)
		panel:SetZPos(-1)
		if frame.selectedPage ~= k then
			panel:SetVisible(false)
		end

		panel.offsetX = panelInfo.offsetX
		panel.PerformLayout = centerLayout

		local function addImage(parent, info)
			local p = parent:Add 'DPanel'
			p:SetPaintBackground(false)

			local mat = info.mat
			local scale = info.scale or 1

			local image = p:Add 'DImage'
			image:SetMaterial(mat)
			image:SetSize(ScaleH(mat:Width()) * scale, ScaleH(mat:Height()) * scale)

			if info.button then
				local buttonInfo = info.button
				local button = p:Add 'DButton'
				button:SetFont('tutorial.button')
				button:SetText(buttonInfo.text)
				button:SizeToContentsX(40)

				if buttonInfo.height then
					button:SetTall(ScaleH(buttonInfo.height))
				else
					button:SizeToContentsY(18)
				end

				function button:Paint(w, h)
					local off = h > 20 and 2 or 1
					if self.Depressed then
						draw.RoundedBox(16, 0, off, w, h-off, colors.g)
						draw.RoundedBox(16, 0, off, w, h-off, colors.hvr)
					else
						draw.RoundedBox(16, 0, 0, w, h, colors.g_d)
						draw.RoundedBox(16, 0, 0, w, h-off, colors.g)
						if self.Hovered then
							draw.RoundedBox(16, 0, 0, w, h, colors.hvr)
						end
					end
				end

				button.DoClick = buttonInfo.onClick
				button.offsetX = buttonInfo.offsetX
				button.offsetY = buttonInfo.offsetY

				image.btn = button
			end

			function p:PerformLayout()
				local button = image.btn
				if not button then return end
				if button.offsetX then
					button:SetX(ScaleH(button.offsetX))
				else
					button:CenterHorizontal()
				end

				if button.offsetY then
					button:SetY(ScaleH(button.offsetY))
				else
					button:CenterVertical()
				end
			end

			p:SizeToChildren(true, true)

			if info.tooltip then
				p:AddOctoHint(info.tooltip)
			end

			return image
		end

		if istable(panelInfo[1]) then
			for _, p in ipairs(panelInfo) do
				addImage(panel, p)
			end
		else
			addImage(panel, panelInfo)
		end

		table.insert(frame.pages, {
			title = v.title,
			pnl = panel,
			background = v.background,
		})
	end

	pageList:SetWide(#frame.pages * 16 + (#frame.pages + 1) * 16)

	pageSelector:InvalidateLayout(true)
	pageSelector:SizeToChildren(true, false)

	switchToPage(1)

	-- local music = {
	-- 	volume = 0.2,
	-- 	channel = nil,
	-- }

	-- sound.PlayFile('sound/kramersk/kramersk.ogg', '', function(channel)
	-- 	if not IsValid(channel) then
	-- 		return
	-- 	end

	-- 	music.channel = channel
	-- 	channel:SetVolume(music.volume)
	-- 	channel:EnableLooping(true)
	-- end)

	-- function frame:OnRemove()
	-- 	if IsValid(music.channel) then
	-- 		octolib.tween.create(2, music, {volume = 0}, nil, function()
	-- 			if IsValid(music.channel) then
	-- 				music.channel:Stop()
	-- 			end
	-- 		end, function()
	-- 			if IsValid(music.channel) then
	-- 				music.channel:SetVolume(music.volume)
	-- 			end
	-- 		end)
	-- 	end
	-- end
end

function dbgTutorial.slideshow.close()
	if not IsValid(dbgTutorial.slideshow.frame) then
		return
	end

	dbgTutorial.slideshow.frame:Remove()

	hook.Run('dbgTutorial.slideshow.finished')
end

netstream.Hook('dbgTutorial.slideshow.open', dbgTutorial.slideshow.open)