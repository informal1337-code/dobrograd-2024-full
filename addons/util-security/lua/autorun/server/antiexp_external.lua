util.AddNetworkString('octolib_anticheat_external')
net.Receive('octolib_anticheat_external', function (len, ply)
	-- Log suspicious activity
	octolib.logger.warning('Suspicious external code execution detected', ply, {
		action = 'external_code_execution',
		source = 'jit_monitor'
	})

	-- Send to Discord webhook if configured
	if CFG.webhooks and CFG.webhooks.cheats then
		octolib.webhook.anticheat(CFG.webhooks.cheats,
			'External Code Execution Detected',
			'Player attempted to execute external Lua code',
			ply
		)
	end

	-- Kick the player
	ply:Kick('Anti-cheat: External code execution detected')
end)
