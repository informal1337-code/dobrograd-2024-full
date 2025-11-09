-- "addons\\feature-police\\lua\\police\\sh_fines.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgPolice.fines = dbgPolice.fines or {}

dbgPolice.fines.maxFines = 10

dbgPolice.fines.maxCost = 15000

dbgPolice.fines.revokeDate = octolib.time.toSeconds(2, 'days')

function dbgPolice.fines.get(ply)
	return ply:GetNetVar('dbg-police.activeFines', {})
end

function dbgPolice.fines.has(ply)
	return table.Count(dbgPolice.fines.get(ply)) ~= 0
end

function dbgPolice.fines.nameBySteamID(steamid)
	return util.SteamIDTo64(steamid)
end
function dbgPolice.fines.findPlayerByName(name)
	name = name:lower()
	local found = {}
	
	for _, ply in ipairs(player.GetAll()) do
		if ply:Name():lower():find(name, 1, true) then
			table.insert(found, ply)
		end
	end
	
	return found
end
octolib.testHelper.addCategory('fines', {
	name = 'Штрафы',
	icon = octolib.icons.silk16('page_edit'),
})
