-- "addons\\core-weapons\\lua\\dbg-weapons\\attachments\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgWeapons.attachments = dbgWeapons.attachments or {
	registered = {},
}

function dbgWeapons.attachments.canAttach(ply, wep, attID)
	local job = ply:getJobTable()
	local wepClass = wep:GetClass()
	local att = dbgWeapons.attachments.registered[attID]

	if not wep.IsOctoWeapon or not att or not att.weapons[wepClass] then return false end
	if att.jobs and att.jobs[job.command] then return true end
	return octolib.table.some(att.orgs or {}, function(org, orgID) return (org == true and orgID == ply:GetActiveOrg()) or (istable(org) and org[ply:GetActiveRank(orgID)]) end)
end