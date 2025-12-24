-- "addons\\core-characters\\lua\\dbg-characters\\ghosts\\cl_near-death.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local clrGray = Color(220,220,220)

local giveUpPnl = dbgChars.ghosts.giveUpPnl
local function drawDeathIn(x, y)
	local margin = 5
	local ply = LocalPlayer()

	giveUpPnl:SetPos(x - 150, y - giveUpPnl:GetTall())

	local textTall = 0
	if not ply:GetLocalVar('reviveTime') then
		local timeData = string.FormattedTime(ply:GetRagdollTimeLeft())
		_, textTall = draw.SimpleText(
			string.format('%02i:%02i', timeData.m, timeData.s),
			'dbg-chars.timer',
			x,
			y - giveUpPnl:GetTall() - margin,
			clrGray,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_BOTTOM
		)
	end

	draw.SimpleText(
		'Ты серьезно ранен, но тебе все еще могут помочь встать',
		'dbg-chars.progress',
		x,
		y - giveUpPnl:GetTall() - margin - textTall,
		color_white,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_BOTTOM
	)

	return textTall + giveUpPnl:GetTall() + margin * 2
end

local function clearDeathIn()
	octolib.bottomMessages.remove('death-in')
	if IsValid(giveUpPnl) then
		giveUpPnl:SetEnabled(false)
		giveUpPnl:AlphaTo(0, 0.5, 0, function()
			giveUpPnl:Remove()
		end)
	end
end

local function showDeathIn(toggle)
	if toggle == true then
		if not IsValid(giveUpPnl) then
			giveUpPnl = vgui.Create('dbg_chars_revivePanel')
			giveUpPnl:ShowButton()

			dbgChars.ghosts.giveUpPnl = giveUpPnl
		end

		octolib.bottomMessages.add('death-in', {
			paint = drawDeathIn,
		})
	else
		clearDeathIn()
	end
end

netstream.Hook('dbgChars.deathFinish', function()
	clearDeathIn()
end)

hook.Add('octolib.netVarUpdate', 'dbg-characters.ghosts.nearDeath', function(index, key, value)
	if index == LocalPlayer():EntIndex() then
		if key == 'nearDeath' then
			showDeathIn(value)
		elseif key == 'reviveTime' then
			if value then
				giveUpPnl:ShowProgress()
			else
				giveUpPnl:ShowButton()
			end
		end
	end
end)

hook.Add('PostDrawHUD', 'dbg-characters.ghosts.nearDeath', function()
	local ply = LocalPlayer()
	if not ply:GetNetVar('nearDeath') then
		return
	end

	local ct = CurTime()

	local alpha = 220
	local transitionDuration = 3
	local ragdollEndsAt = ply:GetRagdollEndsAt()
	local startTransition = ragdollEndsAt - ply:GetRagdollDuration() + transitionDuration
	local endTransition = ragdollEndsAt - transitionDuration

	if ct <= startTransition then
		alpha = Lerp(1 - (startTransition - ct) / transitionDuration, 0, 220)
	elseif ct >= endTransition then
		alpha = Lerp((ct - endTransition) / transitionDuration, 220, 255)
	end

	draw.RoundedBox(0, -5, -5, ScrW() + 10, ScrH() + 10, Color(0, 0, 0, alpha))
end)
