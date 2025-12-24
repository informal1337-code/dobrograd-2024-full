-- "addons\\core-characters\\lua\\dbg-characters\\ghosts\\cl_ghost-timer.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local clrGray = Color(220,220,220)

local function drawDeathText(x, y)
	local ply = LocalPlayer()
	if not ply:IsGhost() or not ply:Alive() then
		return 0
	end

	local timeData = string.FormattedTime(math.max(ply:GetLocalVar('_SpawnTime', 0) - CurTime(), 0))
	local timeLeft = timeData.h >= 1
		and string.format('%02i:%02i:%02i', timeData.h, timeData.m, timeData.s)
		or string.format('%02i:%02i', timeData.m, timeData.s)
	draw.SimpleText(
		timeLeft,
		'dbg-chars.timer',
		x,
		y,
		clrGray,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_BOTTOM
	)
	return 64
end

local function showTimer(show)
	if show then
		octolib.bottomMessages.add('ghost-timer', {
			paint = drawDeathText,
			time = LocalPlayer():GetLocalVar('_SpawnTime', 0) - CurTime(),
		})
	else
		octolib.bottomMessages.remove('ghost-timer')
	end
end

hook.Add('octolib.netVarUpdate', 'dbg-characters.ghosts', function(index, key, value)
	if index == LocalPlayer():EntIndex() and key == 'Ghost' then
		timer.Simple(0.5, function()
			showTimer(value)
		end)
	end
end)
