octolib.esc = octolib.esc or {}
octolib.esc.handlers = octolib.esc.handlers or {}
octolib.esc.handlersOrder = octolib.esc.handlersOrder or {}

local handlersPaused = false
function octolib.esc.pauseHandlers()
	handlersPaused = true

	local function clearPause()
		if not gui.IsGameUIVisible() then
			handlersPaused = false
			hook.Remove('Think', 'octolib.esc.clearPause')
		end
	end

	timer.Create('octolib.esc.addClearPauseHook', 0.1, 1, function()
		hook.Add('Think', 'octolib.esc.clearPause', clearPause)
	end)
end

function octolib.esc.setHandler(id, func)
	id = id or octolib.string.uuid()

	table.RemoveByValue(octolib.esc.handlersOrder, id)
	table.insert(octolib.esc.handlersOrder, id)
	octolib.esc.handlers[id] = func
end

hook.Add('OnPauseMenuShow', 'octolib.esc.handler', function()
	if handlersPaused then return end

	if #octolib.esc.handlersOrder > 0 then
		for i = #octolib.esc.handlersOrder, 1, -1 do
			local id = octolib.esc.handlersOrder[i]
			local handler = octolib.esc.handlers[id]

			table.remove(octolib.esc.handlersOrder, i)
			octolib.esc.handlers[id] = nil

			if handler() then
				return false
			end
		end
	end
end)
