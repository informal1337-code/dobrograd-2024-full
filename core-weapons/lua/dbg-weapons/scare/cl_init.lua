-- "addons\\core-weapons\\lua\\dbg-weapons\\scare\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add('HUDPaint', 'dbg-scare', function()
	local scare = LocalPlayer():GetAccumulatableValue('dbgWeapons.scare')
	if scare > 0 then
		draw.RoundedBox(0, -1, -1, ScrW() + 2, ScrH() + 2, Color(0,0,0, 180 * scare))
	end
end)