--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-characters/lua/dbg-characters/cl_characters.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

dbgChars.presets = dbgChars.presets or {}

octolib.vars.init('dbgChars.name', '')
octolib.vars.init('dbgChars.model', '')
octolib.vars.init('dbgChars.skin', 0)
octolib.vars.init('dbgChars.job', 'citizen')
octolib.vars.init('dbgChars.desc', '')

function dbgChars.savePreset(preset, id)
	id = id or (#dbgChars.presets + 1)
	dbgChars.presets[id] = preset
	dbgChars.sendPresetsToServer()

	hook.Run('dbg-characters.presetsUpdated', dbgChars.presets)
end

function dbgChars.removePreset(id)
	table.remove(dbgChars.presets, id)
	dbgChars.sendPresetsToServer()

	hook.Run('dbg-characters.presetsUpdated', dbgChars.presets)
end

function dbgChars.fetchPresetsFromServer()
	netstream.Request('dbg-characters.getPresets')
		:Then(function(saved)
			dbgChars.presets = saved or {}
			hook.Run('dbg-characters.presetsUpdated', dbgChars.presets)
		end)
end

function dbgChars.sendPresetsToServer()
	netstream.Start('dbg-characters.savePresets', dbgChars.presets)
end

function dbgChars.fixConVars()
	local model = octolib.vars.get('dbgChars.model')
	local face = octolib.vars.get('dbgChars.face')
	local skin = octolib.vars.get('dbgChars.skin')

	if not model or not skin or not dbgChars.canUseModel(LocalPlayer(), model, face, skin) then
		local randomModel, randomFace, randomSkin = dbgChars.getRandomModel()
		model = randomModel
		face = randomFace
		skin = randomSkin
		octolib.vars.set('dbgChars.model', model)
		octolib.vars.set('dbgChars.face', face)
		octolib.vars.set('dbgChars.skin', skin)
	end

	local name = octolib.vars.get('dbgChars.name')
	if not name or string.Trim(name) == '' then
		name = dbgChars.getRandomName(octolib.models.isMale(model))
		octolib.vars.set('dbgChars.name', name)
	end

	local sanitizedName = dbgChars.sanitizeName(name)
	if sanitizedName ~= name then
		octolib.vars.set('dbgChars.name', sanitizedName)
	end

	local desc = octolib.vars.get('dbgChars.desc')
	local sanitizedDesc = dbgChars.sanitizeDescription(desc)
	if sanitizedDesc ~= desc then
		octolib.vars.set('dbgChars.desc', sanitizedDesc)
	end
end

netstream.Hook('dbg-characters.firstSpawn', function()
	hook.Run('dbg-characters.firstSpawn')
end)
netstream.Hook('dbg-char.respawnPos', function(pos)
	if not IsValid(LocalPlayer()) then return end
	
	LocalPlayer():AddMarker({
		id = 'change-char',
		txt = 'Место для смены персонажа',
		pos = pos,
		col = Color(255,92,38),
		icon = 'octoteam/icons-16/user.png',
	})
end)

netstream.Hook('dbg-char.updateState', function(state)
	hook.Run('dbg-characters.updateState', state)
end)