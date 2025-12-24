-- Anti-cheat: Client-side cheat detection
-- Monitors for unauthorized cheat CVars being enabled

if CLIENT then
	timer.Create('octolib_anticheat_cslua_check', 60, 0, function()
		-- Check if cheats are enabled
		if GetConVar('sv_cheats'):GetBool() or GetConVar('sv_allowcslua'):GetBool() then
			-- Notify server of cheat detection
			netstream.Start('octolib_anticheat_cslua')
		end
	end)
end
