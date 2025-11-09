--octolib.ptime.registerType('police')

function dbgPolice.checkCitizenForm(ply)
	local plyModel = ply:GetModel()

	if string.StartsWith(plyModel, 'models/dizcordum/citizens/playermodels') then
		return true
	end

	if not string.StartsWith(plyModel, 'models/octo_detective') then
		return false
	end

	return true
end