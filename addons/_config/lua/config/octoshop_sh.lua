--
-- SALARY
--

octoshop.salaryAFKTime = 45 -- seconds
octoshop.salaryPeriod = 60 -- minutes

--
-- MISC FUNCTIONS
--

octoshop.openTopup = function(but, pnl)

	F4:Hide()
	gui.ActivateGameUI()
	octoesc.OpenURL('')

end

local owners = {
	['STEAM_0:0:162799155'] = true, -- informal
}

octoshop.checkOwner = function(ply)

	return owners[ply:SteamID()]

end
