-- "addons\\feature-phone\\lua\\phone\\modules\\sms\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function sms()
	local text, tgtName = '', ''

	local f = vgui.Create('DFrame')
	f:SetSize(400, 135)
	f:SetTitle(L.send_sms)
	f:Center()
	f:MakePopup()
	f:SetBackgroundBlur(true)

	local b = f:Add('DButton')
	b:Dock(BOTTOM)
	b:SetTall(30)
	b:SetText(L.send)
	b:SetEnabled(false)

	function b:DoClick()
		netstream.Start('chat', ('/sms "%s" %s'):format(tgtName, text))
		f:Remove()
	end

	local function check()
		b:SetEnabled(tgtName ~= '' and string.Trim(text) ~= '')
	end

	local c = f:Add 'DComboBox'
	c:Dock(TOP)
	c:SetTall(30)
	c:DockMargin(0, 0, 0, 5)
	c:SetValue(L.recipient)

	local localPly = LocalPlayer()
	local choices = octolib.table.mapSequential(player.GetAll(), function(ply)
		if ply == localPly then return end
		return ply:Name('phone')
	end)
	table.sort(choices)
	for _, name in ipairs(choices) do
		c:AddChoice(name, name)
	end

	function c:OnSelect(i, val, data)
		tgtName = data
		check()
	end

	local e = f:Add 'DTextEntry'
	e:Dock(TOP)
	e:SetTall(20)
	e:DockMargin(5, 5, 5, 10)
	e:SetUpdateOnType(true)
	e:SetPlaceholderText(L.text_msg)

	e.PaintOffset = 5

	function e:OnValueChange(val)
		text = val
		check()
	end
end

local usingPhone = false
local cmds = {'/sms '}
hook.Add('ChatTextChanged', 'dbg-phone', function(txt)
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if ply:GetVelocity():LengthSqr() > 0 then return end

	local showPhone
	for _, cmd in ipairs(cmds) do
		if txt:StartWith(cmd) then
			showPhone = true
			break
		else
			showPhone = false
		end
	end

	if showPhone then
		if txt:sub(6) then netstream.Start('dbg-phone.typingSMS') end
		if not usingPhone then
			netstream.Start('dbg-phone.updateTypeStatus', true)
			usingPhone = true
		end
	elseif usingPhone then
		netstream.Start('dbg-phone.updateTypeStatus', false)
		usingPhone = false
	end
end)

dbgPhone.registerAction('sms', {
	title = L.send_sms,
	priority = 2,
	icon = octolib.icons.silk16('oms_new_text_message'),
	callback = sms,
})