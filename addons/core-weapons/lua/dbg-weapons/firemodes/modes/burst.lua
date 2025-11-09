-- "addons\\core-weapons\\lua\\dbg-weapons\\firemodes\\modes\\burst.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgWeapons.registerFireMode('burst', {
	init = function(wep)
		wep.Primary.Automatic = false
	end,
	shoot = function(wep)
		local amount = wep.BurstAmount
		local delay = 1 / (wep.BurstRPM / 60)

		timer.Simple(0, function()
			if not wep:ShootBullet() then return end

			local timerID = 'octoweapons.burst.' .. wep:EntIndex()
			timer.Create(timerID, delay, amount - 1, function()
				if not IsValid(wep) then
					timer.Remove(timerID)
					return
				end

				if not wep:ShootBullet() then
					timer.Remove(timerID)
					return
				end
			end)
		end)

		return amount * delay + wep.BurstDelay
	end,
})