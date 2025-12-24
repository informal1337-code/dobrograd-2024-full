local tintMaterials = octolib.array.toKeys {
	'shared/vehicle_generic_glasswindows75',
	'shared/vehicle_generic_glasswindows90',
	'models/rendertarget',
}

hook.Add('dbgCloseLook.canSee', 'cantSeeInCarWithTint', function(ent, ply)
	if not ent:IsPlayer() or not ent:InVehicle() then return end
	local seat = ent:GetVehicle()
	local plySeat = ply:GetVehicle()
	local veh = IsValid(seat) and seat:GetParent()

	if not IsValid(veh) or not simfphys.IsCar(veh) then return end
	if IsValid(plySeat) and plySeat:GetParent() == veh then return end

	if veh:GetNetVar('hasTint', 0) >= 75 then
		return false
	end
end)