serverguard.AddFolder('screencap');

local plugin = plugin;

plugin:IncludeFile('shared.lua', SERVERGUARD.STATE.SHARED);
plugin:IncludeFile('cl_panel.lua', SERVERGUARD.STATE.CLIENT);

netstream.Hook('sg.octolib-grab', function(ply, target)

	if not IsValid(target) or not target:IsPlayer() then
		netstream.Start(ply, 'sg.octolib-grab', target, false)
		return
	end

	local immAdmin, immTarget = serverguard.player:GetImmunity(ply), serverguard.player:GetImmunity(target)
	if immAdmin < immTarget or not serverguard.player:HasPermission(ply, 'Screencap') then
		octolib.logger.warning('Unauthorized screenshot attempt', ply, {
			target = target:SteamID(),
			admin_immunity = immAdmin,
			target_immunity = immTarget
		})
		netstream.Start(ply, 'sg.octolib-grab', target, false)
		return
	end

	-- Log screenshot attempt
	octolib.logger.info('Screenshot capture initiated', ply, {
		target = target:SteamID(),
		target_name = target:GetName()
	})

	local requestStart = SysTime()
	netstream.Request(target, 'sg.screencap.take', 15):Then(function(screenshotData)
		local captureTime = SysTime() - requestStart

		if screenshotData and #screenshotData > 0 then
			local filename = string.format('screencap_%s_%s_%s.png',
				target:SteamID():gsub(':', '_'),
				os.date('%Y%m%d_%H%M%S'),
				ply:SteamID():gsub(':', '_')
			)

			file.CreateDir('screencaps')

			local success = file.Write('screencaps/' .. filename, screenshotData)

			if success then
				local filePath = 'data/screencaps/' .. filename
				local fileSize = string.NiceSize(#screenshotData)

				octolib.logger.info('Screenshot captured successfully', ply, {
					target = target:SteamID(),
					filename = filename,
					size = fileSize,
					capture_time = string.format('%.2fs', captureTime)
				})

				netstream.Start(ply, 'sg.octolib-grab', target, {
					localFile = filePath,
					size = fileSize,
					timestamp = os.time()
				})
			else
				octolib.logger.error('Failed to save screenshot file', ply, {
					target = target:SteamID(),
					filename = filename
				})
				netstream.Start(ply, 'sg.octolib-grab', target, false)
			end
		else
			octolib.logger.warning('Screenshot capture returned empty data', ply, {
				target = target:SteamID(),
				capture_time = string.format('%.2fs', captureTime)
			})
			netstream.Start(ply, 'sg.octolib-grab', target, false)
		end
	end):Catch(function(err)
		local captureTime = SysTime() - requestStart
		octolib.logger.error('Screenshot capture failed', ply, {
			target = target:SteamID(),
			error = err or 'Unknown error',
			capture_time = string.format('%.2fs', captureTime)
		})
		netstream.Start(ply, 'sg.octolib-grab', target, false)
	end)

end)
