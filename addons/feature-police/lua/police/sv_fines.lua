util.AddNetworkString 'dbg-police.fines.menu'
util.AddNetworkString 'dbg-police.fines.menuUpdateList'
util.AddNetworkString 'dbg-police.applyFine'
util.AddNetworkString 'dbg-police.fines.payFine'
util.AddNetworkString 'dbg-police.fines.revokeFine'
util.AddNetworkString 'dbg-police.adminApplyFines'

netstream.Hook('dbg-police.applyFine', function(ply, target, reason, amount)
	if not IsValid(ply) or not IsValid(target) or not ply:isCP() then return end
	if not reason or #reason < 5 then
		return ply:Notify('warning', 'Причина штрафа должна содержать не менее 5 символов')
	end
	
	amount = tonumber(amount) or 0
	if amount <= 0 or amount > dbgPolice.fines.maxCost then
		return ply:Notify('warning', 'Некорректная сумма штрафа')
	end
	
	local fines = dbgPolice.fines.get(target)
	if table.Count(fines) >= dbgPolice.fines.maxFines then
		return ply:Notify('warning', 'У игрока слишком много неоплаченных штрафов')
	end
	
	local uuid = octolib.string.uuid()
	fines[uuid] = {
		reason = reason,
		price = amount,
		issueDate = os.time(),
		giverName = ply:Name(),
		giverSteamID = ply:SteamID(),
	}
	
	target:SetNetVar('dbg-police.activeFines', fines)
	
	target:Notify(('Вам выписан штраф на %s за "%s"'):format(DarkRP.formatMoney(amount), reason))
	ply:Notify(('Вы выписали штраф на %s игроку %s'):format(DarkRP.formatMoney(amount), target:Name()))
	
	netstream.Start(target, 'dbg-police.fines.menuUpdateList', fines)
end)

netstream.Hook('dbg-police.fines.payFine', function(ply, uuid)
	if not IsValid(ply) then return end
	
	local fines = dbgPolice.fines.get(ply)
	local fine = fines[uuid]
	if not fine then return end
	
	if ply:getMoney() < fine.price then
		return ply:Notify('warning', 'Недостаточно денег для оплаты штрафа')
	end
	
	ply:addMoney(-fine.price)
	fines[uuid] = nil
	
	ply:SetNetVar('dbg-police.activeFines', fines)
	ply:Notify(('Вы оплатили штраф на %s'):format(DarkRP.formatMoney(fine.price)))
	
	netstream.Start(ply, 'dbg-police.fines.menuUpdateList', fines)
end)

netstream.Hook('dbg-police.fines.revokeFine', function(ply, uuid, target, reason)
	if not IsValid(ply) or not IsValid(target) or not ply:isCP() then return end
	if not reason or #reason < 5 then
		return ply:Notify('warning', 'Причина отзыва должна содержать не менее 5 символов')
	end
	
	local fines = dbgPolice.fines.get(target)
	local fine = fines[uuid]
	if not fine then return end
	
	if fine.giverSteamID ~= ply:SteamID() then
		local timePassed = os.time() - fine.issueDate
		if timePassed < dbgPolice.fines.revokeDate then
			return ply:Notify('warning', 'Вы можете отзывать только свои штрафы или штрафы старше 2 дней')
		end
	end
	
	fines[uuid] = nil
	target:SetNetVar('dbg-police.activeFines', fines)
	
	target:Notify(('Ваш штраф на %s был отозван. Причина: %s'):format(DarkRP.formatMoney(fine.price), reason))
	ply:Notify(('Вы отозвали штраф на %s у игрока %s'):format(DarkRP.formatMoney(fine.price), target:Name()))
	
	netstream.Start(target, 'dbg-police.fines.menuUpdateList', fines)
end)

netstream.Hook('dbg-police.adminApplyFines', function(ply, target, finesTable)
	if not IsValid(ply) or not ply:IsAdmin() then return end
	if not IsValid(target) then return end
	
	local validatedFines = {}
	for uuid, fineData in pairs(finesTable) do
		if fineData.reason and fineData.price and fineData.issueDate and fineData.giverSteamID then
			validatedFines[uuid] = fineData
		end
	end
	
	target:SetNetVar('dbg-police.activeFines', validatedFines)
	ply:Notify('Штрафы для ' .. target:Name() .. ' обновлены')
	
	netstream.Start(target, 'dbg-police.fines.menuUpdateList', validatedFines)
end)

timer.Create('dbg-police.fines.cleanup', 3600, 0, function()
	for _, ply in ipairs(player.GetAll()) do
		local fines = dbgPolice.fines.get(ply)
		local changed = false
		
		for uuid, fine in pairs(fines) do
			if os.time() - fine.issueDate > octolib.time.toSeconds(30, 'days') then
				fines[uuid] = nil
				changed = true
			end
		end
		
		if changed then
			ply:SetNetVar('dbg-police.activeFines', fines)
			ply:Notify('Некоторые ваши старые штрафы были автоматически сняты')
		end
	end
end)

hook.Add('PlayerCanChangeTeam', 'dbg-police.fines', function(ply, job)
	if job.police and dbgPolice.fines.has(ply) then
		ply:Notify('warning', 'Вы не можете устроиться в полицию с неоплаченными штрафами')
		return false
	end
end)
hook.Add('PlayerDeath', 'dbg-police.fines', function(ply)
	if dbgPolice.fines.has(ply) and math.random() < 0.5 then
		local fines = dbgPolice.fines.get(ply)
		local uuids = {}
		for uuid in pairs(fines) do
			table.insert(uuids, uuid)
		end
		
		if #uuids > 0 then
			local removedUuid = table.Random(uuids)
			local removedFine = fines[removedUuid]
			fines[removedUuid] = nil
			
			ply:SetNetVar('dbg-police.activeFines', fines)
			ply:Notify(('В связи с вашей смертью штраф на %s был списан'):format(DarkRP.formatMoney(removedFine.price)))
		end
	end
end)
