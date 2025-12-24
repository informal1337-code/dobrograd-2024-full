timer.Simple(1,function()

	net.Receive('ArmDupe', function(len,ply)
		if CFG.webhooks.cheats then
			octolib.webhook.anticheat(CFG.webhooks.cheats,
				'ArmDupe Attempt Detected',
				'Player attempted to use ArmDupe exploit',
				ply
			)
		end

		ply:Kick('exploits')
	end)

end)
