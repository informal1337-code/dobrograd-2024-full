-- "addons\\core-weapons\\lua\\dbg-weapons\\suppression\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local mat, val = Material('overlays/vignette01'), 0
hook.Add('HUDPaint', 'dbgWeapons.suppression', function()


	mat:SetFloat('$alpha', val)

	render.SetMaterial(mat)
	render.DrawScreenQuad()

	surface.SetDrawColor(0, 0, 0, 150 * val)
	surface.DrawRect(0, 0, ScrW(), ScrH())
end)