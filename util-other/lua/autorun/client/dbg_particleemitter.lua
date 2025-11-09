-- "addons\\util-other\\lua\\autorun\\client\\dbg_particleemitter.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local dbgParticleEmitters = {}

hook.Add('octolib.netVarUpdate', 'dbgParticleEmitters', function(index, key, value)
	if key ~= 'particleEmitter' then return end

	local ent = Entity(index)
	if not IsValid(ent) then return end

	local oldEmitter = dbgParticleEmitters[ent]
	if IsValid(oldEmitter) then
		oldEmitter:StopEmission(false)
		dbgParticleEmitters[ent] = nil
	end

	if not isstring(value) then return end

	local emitter = ent:CreateParticleEffect(value, PATTACH_ABSORIGIN_FOLLOW)
	if not IsValid(emitter) then return end

	emitter:StartEmission(true)

	dbgParticleEmitters[ent] = emitter
end)