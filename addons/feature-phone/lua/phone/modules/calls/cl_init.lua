-- "addons\\feature-phone\\lua\\phone\\modules\\calls\\cl_init.lua"

local callUI
netstream.Hook('dbgPhone.callingTo', function(name)
	if IsValid(callUI) then
		callUI:Remove()
	end

	callUI = vgui.Create('phone_frame_ongoingCall')

	callUI:Show()
	callUI:SetTarget(name)

	local ply = LocalPlayer()
	local callSound = dbgPhone.callSound

	local path = callSound.path
	ply:EmitSound(path)

	timer.Create('dbgPhone.waitingSound', callSound.duration, 0, function()
		ply:EmitSound(path)
	end)
end)

netstream.Hook('dbgPhone.incomingCall', function(name)
	if IsValid(callUI) then
		callUI:Remove()
	end

	callUI = vgui.Create('phone_frame_incomingCall')

	callUI:Show()
	callUI:SetText(name)
end)

netstream.Hook('dbgPhone.callStarted', function(name)
	if not IsValid(callUI) then
		callUI = vgui.Create('phone_frame_ongoingCall')
	end

	callUI:Show()
	callUI:SetTarget(name)
	callUI:SetCallStarted(true)

	timer.Remove('dbgPhone.waitingSound')
	LocalPlayer():StopSound(dbgPhone.callSound.path)
end)

netstream.Hook('dbgPhone.endCall', function(playSound)
	if IsValid(callUI) then
		callUI:Remove()
	end

	local ply = LocalPlayer()

	timer.Remove('dbgPhone.waitingSound')
	ply:StopSound(dbgPhone.callSound.path)

	if playSound then
		ply:EmitSound(dbgPhone.busySounds[playSound])
	end
end)

dbgPhone.registerAction('make_call', {
	title = L.make_call,
	priority = 2,
	icon = octolib.icons.silk16('phone_sound'),
	callback = function()
		local choices = octolib.table.mapSequential(player.GetAll(), function(ply, i)
			if ply == LocalPlayer() then return end
			return {ply:Name('phone'), ply:SteamID()}
		end)
		table.sort(choices, function(a, b)
			return a[1] < b[1]
		end)

		octolib.request.open({
			{
				required = true,
				type = 'comboBox',
				name = L.call_hint:Replace('...', ''),
				placeholder = 'Абонент...',
				opts = choices,
			},
		}, function(data)
			if not data then return end
			netstream.Start('chat', '/call ' .. data[1])
		end)
	end,
})