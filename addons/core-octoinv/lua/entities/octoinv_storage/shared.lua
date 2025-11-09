ENT.Type = 'anim'
ENT.Base = 'base_entity'

ENT.Category		= L.dobrograd
ENT.PrintName		= L.container_storage
ENT.Author			= 'chelog'
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

hook.Add('octoinv.calcItemVolume', 'octoinv.storage', function(class, data, contID)
	if not octoinv.getItemData('persistent', class, data) then return end
	if contID ~= 'storage' then return end

	return 0
end)