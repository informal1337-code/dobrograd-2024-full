--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-octolib/lua/octolib/modules/test-helper/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

octolib.testHelper = octolib.testHelper or {}
octolib.testHelper.uiData = octolib.testHelper.uiData or {}
octolib.testHelper.handlers = octolib.testHelper.handlers or {}
octolib.testHelper.categories = octolib.testHelper.categories or {
	_other = {name = 'No category'},
}

octolib.include.client('vgui')

function octolib.testHelper.addMethod(id, uiData, handler)
	uiData.category = uiData.category or '_other'
	uiData.icon = uiData.icon
		or SERVER and octolib.icons.silk16('bullet_blue')
		or CLIENT and octolib.icons.silk16('bullet_yellow')

	octolib.testHelper.uiData[id] = uiData
	octolib.testHelper.handlers[id] = handler

	if SERVER then
		if octolib.testHelper.sync then
			octolib.testHelper.sync()
		end
	else
		hook.Run('octolib.testHelper.sync')
	end
end

function octolib.testHelper.removeMethod(id)
	octolib.testHelper.uiData[id] = nil
	octolib.testHelper.handlers[id] = nil
end

function octolib.testHelper.addCategory(id, data)
	octolib.testHelper.categories[id] = {
		name = data.name or id,
		icon = data.icon,
		parent = data.parent,
	}

	if SERVER then
		if octolib.testHelper.sync then
			octolib.testHelper.sync()
		end
	else
		hook.Run('octolib.testHelper.sync')
	end
end

function octolib.testHelper.removeCategory(id)
	octolib.testHelper.categories[id] = nil
end

octolib.testHelper.addCategory('octolib', {
	name = 'octolib',
	icon = octolib.icons.silk16('plugin'),
})
