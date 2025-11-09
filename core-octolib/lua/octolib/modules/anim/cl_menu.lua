--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-octolib/lua/octolib/modules/anim/cl_menu.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

function octolib.createAnimSelectMenu()

	local menu = DermaMenu()

	for catID, cat in SortedPairsByMemberValue(octolib.animations, 'order') do
		local catOpt = menu:AddSubMenu(cat.name)

		for i, anim in pairs(cat.anims) do
			local opt = catOpt:AddOption(anim[1], function() netstream.Start('player-anim', catID, i) end)
			if cat.canUse then
				local canUse = cat.canUse(LocalPlayer())
				if not canUse then opt:SetAlpha(75) end
			end
		end
	end

	local rows = octolib.vars.get('faceposes') or {}
	local catOpt = menu:AddSubMenu('Эмоции')

	local canUseEmotions = hook.Run('octolib.canUseEmotions')
	local neutralityOpt = catOpt:AddOption('Нейтральность', function() netstream.Start('player-flex', {}) end)
	if canUseEmotions == false then neutralityOpt:SetAlpha(75) end

	for _, row in pairs(rows) do
		local opt = catOpt:AddOption(row.name, function() netstream.Start('player-flex', row.flexes) end)
		if canUseEmotions == false then opt:SetAlpha(75) end
	end

	if #rows > 0 then catOpt:AddSpacer() end

	catOpt:AddOption('Редактор эмоций...', function()
		octolib.dataEditor.open('faceposes')
	end):SetIcon(octolib.icons.silk16('pencil'))

	return menu

end

octolib.bind.init(nil, KEY_F2, 'octolib.animations.menu')
octolib.bind.registerHandler('octolib.animations.menu', {
	name = 'Меню анимаций',
	run = function(data)
		if hook.Run('octolib.canOpenAnimationsMenu') == false then return end

		gui.EnableScreenClicker(true)

		local menu = octolib.createAnimSelectMenu()
		menu:Open()
		menu:Center()

		gui.EnableScreenClicker(false)
	end,
})
