--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-octolib/lua/octolib/modules/bind/client.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

octolib.bind.handlers = octolib.bind.handlers or {}
octolib.bind.cache = octolib.bind.cache or {}

if CFG.serverGroupIDvars ~= CFG.serverGroupID and octolib.vars.get('binds_' .. CFG.serverGroupID) then
	octolib.vars.set('binds_' .. CFG.serverGroupIDvars, octolib.vars.get('binds_' .. CFG.serverGroupID))
	octolib.vars.set('binds_' .. CFG.serverGroupID, nil)
end

local mapDown, mapUp = {}, {}
function addToMap(event, bind)
	local tbl = event == 'down' and mapDown or mapUp
	if not tbl[bind.button] then
		tbl[bind.button] = {}
	end

	table.insert(tbl[bind.button], function()
		octolib.bind.handlers[bind.action].run(bind.data, event, bind)
	end)
end

local function rebuildMaps()
	table.Empty(mapDown)
	table.Empty(mapUp)

	for _, bind in ipairs(octolib.bind.cache) do
		if not octolib.bind.handlers[bind.action] then continue end

		if bind.on == 'downUp' or bind.on == 'down' then
			addToMap('down', bind)
		end
		if bind.on == 'downUp' or bind.on == 'up' then
			addToMap('up', bind)
		end
	end

	octolib.bind.lastUpdatedTime = CurTime()
end

local rebuildMapsDebounced = octolib.func.debounce(rebuildMaps, 0)

function octolib.bind.registerHandler(id, data)
	octolib.bind.handlers[id] = data
	rebuildMapsDebounced()
end

function octolib.bind.set(id, button, action, data, on)
	if button then
		octolib.bind.cache[id or (#octolib.bind.cache + 1)] = {
			button = button,
			action = action,
			data = data,
			on = on or 'down',
		}
	elseif id then
		table.remove(octolib.bind.cache, id)
	else
		return
	end

	octolib.vars.set('binds_' .. (CFG.serverGroupIDvars or CFG.serverGroupID), octolib.bind.cache)
	rebuildMapsDebounced()
end

function octolib.bind.init(id, button, action, data, on)
	local bind = octolib.array.find(octolib.bind.cache, function(v) return v.action == action end)
	if bind ~= nil then return end
	octolib.bind.set(id, button, action, data, on)
end

function octolib.bind.clientConvar(name, defaultKeyCode, helpText)
	local returnData = {
		name = name,
		defaultKeyCode = defaultKeyCode,
		conVar = CreateClientConVar(name, defaultKeyCode, true, false, helpText)
	}

	local function updateKeyCode()
		returnData.keyCode = returnData.conVar:GetInt()
	end
	updateKeyCode()
	cvars.AddChangeCallback(name, updateKeyCode, 'octolib.bind.clientConvar')

	return returnData
end

hook.Add('PlayerButtonDown', 'octolib-bind', function(_, but)
	if not IsFirstTimePredicted() or vgui.CursorVisible() then return end

	local funcs = mapDown[but]
	if funcs then
		for _, func in ipairs(funcs) do func() end
	end
end)

hook.Add('PlayerButtonUp', 'octolib-bind', function(_, but)
	if not IsFirstTimePredicted() or vgui.CursorVisible() then return end

	local funcs = mapUp[but]
	if funcs then
		for _, func in ipairs(funcs) do func() end
	end
end)

octolib.bind.cache = octolib.vars.get('binds_' .. (CFG.serverGroupIDvars or CFG.serverGroupID)) or {}
rebuildMapsDebounced()
