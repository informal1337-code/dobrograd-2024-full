-- "addons\\core-characters\\lua\\dbg-characters\\ragdoll\\stun\\client.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local clrGray = Color(220, 220, 220)

local function drawKnocked(x, y)
	local ply = LocalPlayer()

	local textTall = 0
	if not ply:GetLocalVar('reviveTime') then
		local timeData = string.FormattedTime(ply:GetRagdollTimeLeft())
		_, textTall = draw.SimpleText(
			string.format('%02i:%02i', timeData.m, timeData.s),
			'dbg-chars.timer',
			x,
			y,
			clrGray,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_BOTTOM
		)
	end

	draw.SimpleText(
		'Ты без сознания, но скоро сможешь подняться',
		'dbg-chars.progress',
		x,
		y - textTall,
		color_white,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_BOTTOM
	)

	return textTall
end

local function showKnockedOut(toggle)
	if toggle == true then
		octolib.bottomMessages.add('knocked-out', {
			paint = drawKnocked,
		})
	else
		octolib.bottomMessages.remove('knocked-out')
	end
end

hook.Add('octolib.netVarUpdate', 'dbg-characters.stun', function(index, key, value)
	if index == LocalPlayer():EntIndex() and key == 'knockedOut' then
		showKnockedOut(value)
	end
end)

hook.Add('HUDPaint', 'dbg-characters.stun', function()
	if LocalPlayer():GetNetVar('knockedOut') then
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), color_black)
	end
end, -8)
