local autoReconnectTime = 70

local bgMat = Material('octoteam/vgui/reconnect.png')
local panel

surface.CreateFont('dbg.reconnect.button', {
	font = 'Nunito Sans Black',
	size = 26,
	weight = 900,
	antialias = true,
	extended = true,
})

surface.CreateFont('dbg.reconnect.timer', {
	font = 'Nunito Sans Black',
	size = 64,
	weight = 900,
	antialias = true,
	extended = true,
})

surface.CreateFont('dbg.reconnect.hint', {
	font = 'Nunito Sans SemiBold',
	size = 26,
	weight = 600,
	antialias = true,
	extended = true,
})

local function show(time)
	if IsValid(panel) then
		panel.progress:SetProgress(time / autoReconnectTime)
		panel.progressLabel:SetText(math.ceil(autoReconnectTime - time))

		if time >= autoReconnectTime then
			panel:Remove()
			RunConsoleCommand('retry')
		end

		return
	end

	local iw, ih = bgMat:Width(), bgMat:Height()
	local scale = ScrH() / ih
	local bgColor = ColorAlpha(color_black, 200)

	panel = vgui.Create('DPanel')
	panel:SetSize(ScrW(), ScrH())
	panel:MakePopup()
	function panel:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, bgColor)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(bgMat)
		surface.DrawTexturedRect(0, 0, iw * scale, ih * scale)
	end

	local container = panel:Add('DPanel')
	container:DockPadding(0, 0, 0, 0)
	container:SetSize(800, 500)
	container:Center()
	function container:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, CFG.skinColors.bg_d)
	end

	local title = container:Add 'DLabel'
	title:Dock(TOP)
	title:SetTall(130)
	title:SetContentAlignment(5)
	title:SetFont('dbg.reconnect.timer')
	title:SetText('СОЕДИНЕНИЕ РАЗОРВАНО')

	local function addHint(text)
		local hint = container:Add 'DLabel'
		hint:Dock(TOP)
		hint:SetTall(30)
		hint:SetContentAlignment(5)
		hint:SetFont('dbg.reconnect.hint')
		hint:SetText(text)
		return hint
	end

	addHint('Возможно, сервер выключился или у тебя пропал интернет')
	addHint('В любом случае надо немного подождать, вдруг оживет')
	addHint('ПЕРЕПОДКЛЮЧИМ ТЕБЯ ЧЕРЕЗ'):DockMargin(0, 30, 0, 0)

	local progress = container:Add 'CircularProgress'
	progress:Dock(TOP)
	progress:DockMargin(0, 10, 0, 0)
	progress:SetTall(128)
	progress:SetBackgroundColor(Color(0,0,0, 120))
	progress:SetProgress(time / autoReconnectTime)
	panel.progress = progress

	local progressLabel = progress:Add 'DLabel'
	progressLabel:Dock(FILL)
	progressLabel:SetContentAlignment(5)
	progressLabel:SetFont 'dbg.reconnect.timer'
	progressLabel:SetText ''
	panel.progressLabel = progressLabel

	local cancelButton = container:Add('DButton')
	cancelButton:SetSize(200, 32)
	cancelButton:SetY(container:GetTall() - cancelButton:GetTall() - 30)
	cancelButton:CenterHorizontal()
	cancelButton:SetFont('dbg.reconnect.button')
	cancelButton:SetText('ОТКЛЮЧИТЬСЯ')
	cancelButton.Paint = octolib.func.zero
	function cancelButton:DoClick()
		RunConsoleCommand('disconnect')
	end

	local music = {
		volume = 0,
		channel = nil,
	}
	sound.PlayFile('sound/ambient/music/country_rock_am_radio_loop.wav', '', function(channel)
		if not IsValid(channel) then
			return
		end

		music.channel = channel
		channel:EnableLooping(true)

		octolib.tween.create(3, music, { volume = 0.5 }, nil, nil, function()
			if IsValid(music.channel) then
				music.channel:SetVolume(music.volume)
			end
		end)
	end)

	function panel:OnRemove()
		if IsValid(music.channel) then
			octolib.tween.create(1, music, { volume = 0 }, nil, function()
				if IsValid(music.channel) then
					music.channel:Stop()
				end
			end, function()
				if IsValid(music.channel) then
					music.channel:SetVolume(music.volume)
				end
			end)
		end
	end
end

local function hide()
	if not IsValid(panel) then return end
	panel:Remove()
end

local function setWatcherEnabled(isEnabled)
	if not isEnabled then
		hook.Remove('Think', 'dbg.reconnect')
		return
	end

	hook.Add('Think', 'dbg.reconnect', function()
		local shouldShow, time = GetTimeoutInfo()
		if shouldShow then
			show(time)
		else
			hide()
		end
	end)
end
setWatcherEnabled(true)

concommand.Add('dev_reconnect_screen', function()
	if not IsValid(panel) then
		local startTime = RealTime()
		hook.Add('Think', 'dbg.reconnect.test', function()
			local time = math.max(RealTime() - startTime, 0)
			show(time)
		end)

		setWatcherEnabled(false)
	else
		hook.Remove('Think', 'dbg.reconnect.test')
		hide()

		setWatcherEnabled(true)
	end
end)
