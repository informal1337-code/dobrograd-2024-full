-- "addons\\util-other\\lua\\autorun\\client\\x86-64.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function showChromiumNotice()
	netstream.Start('chromium-analytics', {
		branch = BRANCH,
		resolution = {ScrW(), ScrH()},
	})

	if BRANCH == 'x86-64' then
		return
	end

	local frame = vgui.Create('DFrame')
	frame:SetSize(580, 800)
	frame:SetTitle('Пора обновиться')
	frame:Center()
	frame:MakePopup()
	frame:ShowCloseButton(false)

	local iconImage = frame:Add('octolib.urlImage')
	iconImage:SetSize(96, 96)
	iconImage:SetPos(10, 24 + (190 - 96) / 2)
	iconImage:SetImageURL('https://img.icons8.com/?size=96&id=eFyl8nHKJToi&format=png')

	local messageLabel = frame:Add('DLabel')
	messageLabel:SetFont('dbg.reconnect.hint')
	messageLabel:SetWrap(true)
	messageLabel:SetContentAlignment(4)
	messageLabel:SetSize(580 - 10 - 96 - 10 - 10, 190)
	messageLabel:SetPos(10 + 96 + 10, 24)
	messageLabel:SetText([[У тебя стоит устаревшая версия игры!
Новая ветка работает быстрее и поддерживает новые функции. В ближайшем будущем мы будем использовать только новую версию (x86-64).

Поставить ее очень просто:]])

	local hintImage = frame:Add('octolib.urlImage')
	hintImage:SetSize(580, 534)
	hintImage:AlignBottom(52)
	hintImage:SetImageURL('https://imgur.octo.gg/i/MMQ2tPV.png')

	local cancelButton = frame:Add('DButton')
	cancelButton:SetSize(300, 32)
	cancelButton:CenterHorizontal()
	cancelButton:AlignBottom(10)
	cancelButton:SetFont('dbg.reconnect.button')
	cancelButton.Paint = octolib.func.zero
	function cancelButton:DoClick()
		frame:Remove()
	end

	cancelButton:SetEnabled(false)
	local timeLeft = 15
	local function timerTick()
		if not IsValid(cancelButton) then
			return
		end

		if timeLeft <= 0 then
			cancelButton:SetText('В ДРУГОЙ РАЗ')
			cancelButton:SetEnabled(true)
			return
		end

		cancelButton:SetText(('МОЖНО ЗАКРЫТЬ ЧЕРЕЗ %s'):format(timeLeft))
		timeLeft = timeLeft - 1

		timer.Simple(1, timerTick)
	end
	timerTick()
end

-- hook.Add('PlayerFinishedLoading', 'chromium-analytics', showChromiumNotice)
