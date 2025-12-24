-- "addons\\core-characters\\lua\\dbg-characters\\ghosts\\sh_hooks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local classes = {
	prop_physics = true,
	prop_physics_multiplayer = true,
	prop_dynamic = true,
	prop_static = true,
	func_door = true,
	func_lookdoor = true,
	func_door_rotating = true,
	prop_door_rotating = true,
	prop_ragdoll = true,
	--func_movelinear = true,
	func_breakable = true,
	func_physbox = true,
	func_breakable_surf = true,
	extended_money_printer = true,
	standard_money_printer = true,
	printer_battery = true,
	spawned_shipment = true,
	itemstore_bag = true,
	itemstore_box_large = true,
	itemstore_box_small = true,
	itemstore_briefcase = true,
	itemstore_suitcase_large = true,
	itemstore_suitcase_small = true,
	m9k_css_thrown_knife = true,
	gmod_wire_wheel = true,
	gmod_sent_vehicle_fphysics_base = true,
	gmod_sent_vehicle_fphysics_wheel = true,
	ent_dbg_radio = true,
	ent_dbg_grenade_gas = true,
	ent_dbg_grenade_shock = true,
	ent_dbg_grenade_air = true,
	ent_dbg_grenade_frag = true,
	ent_dbg_grenade_smoke = true,
	ent_dbg_petard = true,
	dbg_jobs_package = true,
	letter = true,
	keypad = true,
	ent_dbg_vend = true,
	ent_dbg_policelocker = true,
	ent_dbg_trash = true,
	brax_atm = true,
	ent_dbg_camera = true,
	sent_soccerball = true,
	stormfox_digitalclock = true,
	stormfox_weekweather = true,
	ent_dbg_phone = true,
	ent_dbg_travel = true,
	dbg_police_analyser = true,
	ent_dbg_org_board = true,
	ent_dbg_growpot = true,
	ent_dbg_fireworks = true,
	ent_dbg_policefines = true,
	ent_dbg_xmas_box = true,
	ent_dbg_airammo = true,
	ent_dbg_workerbox = true,
}

local function handleCollide(ent1, ent2)
	-- disable collision between ghosts and players
	if ent1:IsPlayer() and ent2:IsPlayer() then
		if ent1:IsGhost() or ent2:IsGhost() then
			return false
		end
	elseif ent1:IsPlayer() and ent1:IsGhost() then
		return not (classes[ent2:GetClass()] or ent2:GetClass():StartWith('octoinv_'))
	elseif ent2:IsPlayer() and ent2:IsGhost() then
		return not (classes[ent1:GetClass()] or ent1:GetClass():StartWith('octoinv_'))
	end
end
hook.Add('ShouldCollide', 'GhostCollisions', handleCollide)

hook.Add('PlayerFootstep', 'GhostsMakeNoSound', function(ply)
	if ply:IsGhost() then
		return true
	end
end)

hook.Add('EntityEmitSound', 'ghosts', function(data)
	local ent = data.Entity
	if IsValid(ent) and ent:IsPlayer() and ent:IsGhost() then
		return false
	end
end)

hook.Add('Think', 'toolgun-nosound', function()
	hook.Remove('Think', 'toolgun-nosound')
	weapons.GetStored('gmod_tool').ShootSound = ''
end)

hook.Add('PlayerUse', 'dbgChars.ghosts.use', function(ply, ent)
	if ply:IsGhost() then
		return false
	end
end)

hook.Add('dbg-tools.lookable.canUse', 'dbgChars.ghosts.lookableCanUse', function(ply)
	if ply:IsGhost() then
		return false
	end
end)
