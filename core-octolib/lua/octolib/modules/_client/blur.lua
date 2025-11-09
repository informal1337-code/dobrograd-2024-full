local matBlur = Material('pp/blurscreen')

octolib.blur = octolib.blur or {}

function octolib.blur.draw(alpha, amount, passes, force)
	alpha = alpha or 1
	amount = amount or 2
	passes = passes or 3

	if alpha <= 0 then return end

	local colMod = {
		['$pp_colour_addr'] = 0,
		['$pp_colour_addg'] = 0,
		['$pp_colour_addb'] = 0,
		['$pp_colour_mulr'] = 0,
		['$pp_colour_mulg'] = 0,
		['$pp_colour_mulb'] = 0,
		['$pp_colour_brightness'] = -alpha * 0.3,
		['$pp_colour_contrast'] = 1 + 0.4 * alpha,
		['$pp_colour_colour'] = 1 - alpha,
	}
	local colors = CFG.skinColors

	if force or GetConVar('octolib_blur'):GetBool() then
		DrawColorModify(colMod)

		surface.SetDrawColor(255, 255, 255, alpha * 255)
		surface.SetMaterial(matBlur)

		for i = 1, passes do
			matBlur:SetFloat('$blur', alpha * i * amount)
			matBlur:Recompute()

			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(-1, -1, ScrW() + 2, ScrH() + 2)
		end
	else
		colMod['$pp_colour_brightness'] = -0.4 * alpha
		colMod['$pp_colour_contrast'] = 1 + 0.2 * alpha
		DrawColorModify(colMod)
	end

	local col = colors.bg
	draw.NoTexture()
	surface.SetDrawColor(col.r, col.g, col.b, alpha * 100)
	surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
end

function octolib.blur.panel(panel, amount, passes)
	if not IsValid(panel) then return end
	if not GetConVar('octolib_blur'):GetBool() then return end

	amount = amount or 2
	passes = passes or 3

	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(matBlur)

	for i = 1, passes do
		matBlur:SetFloat('$blur', (i / passes) * amount)
		matBlur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end
end
