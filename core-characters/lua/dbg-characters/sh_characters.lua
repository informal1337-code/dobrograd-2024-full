--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-characters/lua/dbg-characters/sh_characters.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

function dbgChars.getRandomModel()
	local models = table.GetKeys(dbgChars.config.playerModels)
	local model = models[math.random(#models)]

	local faces = dbgChars.config.playerModels[model].faces
	local face = faces[math.random(#faces)]

	local skins = dbgChars.config.playerModels[model].skins
	local skin = skins[math.random(#skins)]

	return model, face, skin
end

function dbgChars.getRandomName(isMale)
	if isMale == nil then isMale = math.random(2) == 1 end

	local namePool = isMale and dbgChars.config.names.male or dbgChars.config.names.female
	local name = namePool[math.random(#namePool)]
	local surname = dbgChars.config.names.surnames[math.random(#dbgChars.config.names.surnames)]

	return ('%s %s'):format(name, surname)
end

-- returns canUse, needsPremium
function dbgChars.canUseModel(ply, model, face, skin)
	local modelData = dbgChars.config.playerModels[model or '']
	if not modelData then return false, false end

	if face and modelData.faces and not table.HasValue(modelData.faces, face) then
		if modelData.premiumFaces and not table.HasValue(modelData.premiumFaces, face) then
			return false, false
		end

		if not dbgChars.hasPremium(ply) then
			return false, true
		end
	end

	if skin and modelData.skins and not table.HasValue(modelData.skins, skin) then
		return false, false
	end

	return true, false
end

function dbgChars.sanitizeName(name)
	return string.Trim(octolib.string.camel(octolib.string.stripNonCyrillic(utf8.sub(name, 1, 35))))
end

function dbgChars.sanitizeDescription(desc)
	return string.Trim(octolib.string.stripNonWord(utf8.sub(desc, 1, 350), ',:%.0-9-;%(%)%/%"%\'a-zA-Z'))
end

function dbgChars.hasPremium(ply)
	return ply:GetNetVar('os_dobro')
end

function dbgChars.getMaxPresetCount(ply)
	if dbgChars.hasPremium(ply) then
		return 10
	end

	return 3
end
