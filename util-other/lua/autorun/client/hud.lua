-- "addons\\util-other\\lua\\autorun\\client\\hud.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ply, W, H

local colors = {}
colors.black = Color(0, 0, 0, 255)
colors.blue = Color(0, 0, 255, 255)
colors.brightred = Color(200, 30, 30, 255)
colors.darkred = Color(0, 0, 70, 100)
colors.darkblack = Color(0, 0, 0, 200)
colors.gray1 = Color(0, 0, 0, 155)
colors.gray2 = Color(51, 58, 51,100)
colors.red = Color(255, 0, 0, 255)
colors.white = Color(255, 255, 255, 255)
colors.white1 = Color(255, 255, 255, 200)


-- VOICE TALK ICON
local vcTexture = Material('octoteam/icons-glyph/microphone.png')
local vcRangeColors = {
	[150000]  = { Color(1   * 255,  0.7 * 255,  0.4 * 255,  150), 64},
	[500000]  = { Color(1   * 255,  0.4 * 255,  0.4 * 255,  150), 76},
	[2250000] = { Color(0.5 * 255,  0.5 * 255,  1   * 255,  150), 80},
	[10000]   = { Color(0.5 * 255,  0.5 * 255,  1   * 255,  150), 48},
}
local function voiceChat(x, y)
	if not LocalPlayer().DRPIsTalking then
		return 20
	end
	local data = vcRangeColors[LocalPlayer():GetNetVar('TalkRange', 0)] or vcRangeColors[150000]
	surface.SetMaterial(vcTexture)
	surface.SetDrawColor(data[1])
	surface.DrawTexturedRectRotated(x, y - 40, data[2], data[2], 0)
	return 20
end

hook.Add('PlayerStartVoice', 'voice-chat-icon', function(pl)
	if pl == LocalPlayer() then
		octolib.bottomMessages.add('voice', {
			paint = voiceChat
		})
	end
end)
hook.Add('PlayerEndVoice', 'voice-chat-icon', function(pl)
	if pl == LocalPlayer() then
		octolib.bottomMessages.remove('voice')
	end
end)


-- LOCKDOWN
surface.CreateFont('dbg.lockdown.normal', {
	font = 'Calibri',
	extended = true,
	size = 30,
	weight = 350,
})
surface.CreateFont('dbg.lockdown.normal-sh', {
	font = 'Calibri',
	extended = true,
	size = 30,
	weight = 350,
	blursize = 3,
})

local function lockdown_hud(x, y)

	local t = {
		text = L.lockdown_started,
		font = 'dbg.lockdown.normal-sh',
		pos = {x, y},
		color = color_black,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_BOTTOM,
	}
	local clr = 220 + 35 * math.sin(CurTime() * 3)
	draw.Text(t)
	t.color = Color(clr,clr,clr)
	t.font = 'dbg.lockdown.normal'
	draw.Text(t)

	return 30
end

-- ARRESTED
local arrestedUntil
local function arrested(x, y)
	if not arrestedUntil then
		octolib.bottomMessages.remove('arrested')
		return 30
	end

	local ct = CurTime()

	if ct >= arrestedUntil or not ply:GetNetVar('Arrested') then
		arrestedUntil = nil
		octolib.bottomMessages.remove('arrested')
		return 30
	end

	local t = {
		text = L.youre_arrested:format(octolib.time.formatIn(arrestedUntil - ct, true)),
		font = 'dbg.lockdown.normal-sh',
		pos = {x, y},
		color = color_black,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_BOTTOM,
	}

	draw.Text(t)
	t.color = color_white
	t.font = 'dbg.lockdown.normal'
	draw.Text(t)

	return 30
end

net.Receive('gotArrested', function()
	arrestedUntil = CurTime() + net.ReadFloat()
	octolib.bottomMessages.add('arrested', {
		paint = arrested
	})
end)

local darkRP_HUD = {
	lockdown = function(enabled)
		if enabled then
			octolib.bottomMessages.add('lockdown', {
				paint = lockdown_hud,
			})
		else
			octolib.bottomMessages.remove('lockdown')
		end
	end,
}

hook.Add('octolib.netVarUpdate', 'octolib.bottom-messages.darkrp', function(_, key, value)
	if darkRP_HUD[key] then
		darkRP_HUD[key](value)
	end
end)

-- ADMINTELL
surface.CreateFont('admintell.title', {
	font = 'Calibri',
	extended = true,
	size = 72,
	weight = 350,
})

surface.CreateFont('admintell.text', {
	font = 'Calibri',
	extended = true,
	size = 28,
	weight = 350,
})

local adminTellStart, adminTellTime, adminTellTxt, adminTellW, adminTellH, adminTellColor
octolib.notify.registerType('admin', function(time, title, msg, color)
	time, title, msg = time or 0, title or '', msg or ''
	if not (time > 0 and (title ~= '' or msg ~= '')) then
		adminTellTime = nil
		return
	end
	adminTellStart = CurTime()
	adminTellTime = time

	adminTellTxt = markup.Parse(('<font=admintell.title>%s</font>\n<font=admintell.text>%s</font>'):format(title or '', msg or ''), 750)
	adminTellW, adminTellH = adminTellTxt:Size()
	adminTellColor = color or colors.darkblack
	ply:EmitSound('weapons/fx/tink/shotgun_shell' .. math.random(1,3) .. '.wav', 75, 200)

end)
local function adminTell()
	if not adminTellTime then return end
	local ct = CurTime()
	if ct - adminTellStart > adminTellTime then
		adminTellTime = nil
		return
	end

	draw.RoundedBox(4, (W - adminTellW) / 2 - 15, 10, adminTellW + 30, adminTellH + 15, adminTellColor)
	adminTellTxt:Draw(W / 2, 15, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	local pr = (ct - adminTellStart) / adminTellTime
	draw.RoundedBoxEx(4, (W - adminTellW) / 2 - 15, adminTellH + 20, pr * (adminTellW + 30), 5, color_white, false, false, true)
end

local function run()
if not GAMEMODE then return end

GAMEMODE.DrawDeathNotice = octolib.func.zero

function GAMEMODE:HUDPaint()
	ply = ply and IsValid(ply) and ply or LocalPlayer()
	W, H = ScrW(), ScrH()

	adminTell()
end
end
hook.Add('darkrp.loadModules', 'dbg-hud', run)
run()
