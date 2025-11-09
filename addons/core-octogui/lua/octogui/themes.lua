octogui.themes = octogui.themes or {}

local cvInverted = CreateClientConVar('cl_dbg_themeinverted', '0', true, false, '', 0, 1)

octolib.vars.init('octogui.themes.id', 1)

local function getActiveColors()
	if not LocalPlayer():GetNetVar('os_dobro') then
		return octogui.themes.presets[1]
	end

	if octolib.vars.get('octogui.themes.custom') then
		return {
			primary = octolib.vars.get('octogui.themes.custom.primary'),
			secondary = octolib.vars.get('octogui.themes.custom.secondary'),
		}
	end

	return octogui.themes.presets[octolib.vars.get('octogui.themes.id')]
end

function octogui.themes.update()
	local colors = getActiveColors()

	if cvInverted:GetBool() and LocalPlayer():GetNetVar('os_dobro') then
		colors = {
			secondary = colors.primary,
			primary = colors.secondary,
		}
	end

	octolib.changeSkinColor(colors.secondary, colors.primary)
end

hook.Add('octolib.netVarUpdate', 'dobro.theme', function(index, var, value)
	if index ~= LocalPlayer():EntIndex() or var ~= 'os_dobro' or not value then return end
	octogui.themes.update()
end)

hook.Add('PlayerFinishedLoading', 'dobro.theme', function()
	octogui.themes.update()
end)

local updateThemeForVars = octolib.array.toKeys({
	'octogui.themes.custom',
	'octogui.themes.custom.primary',
	'octogui.themes.custom.secondary',
})

hook.Add('octolib.setVar', 'dobro.theme', function(var, val)
	if not updateThemeForVars[var] then return end
	octogui.themes.update()
end)