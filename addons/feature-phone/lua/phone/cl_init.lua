-- "addons\\feature-phone\\lua\\phone\\cl_init.lua"

local actions = dbgPhone.actions
if not actions then
	actions = {}
	dbgPhone.actions = actions
end

local actionsKeys = dbgPhone.actionsKeys
if not actionsKeys then
	actionsKeys = {}
	dbgPhone.actionsKeys = actionsKeys
end

local function sortActions(a, b)
	return a.priority < b.priority
end

function dbgPhone.registerAction(key, struct)
	local oldAction = actionsKeys[key]
	if oldAction then
		table.remove(actions, oldAction.id)
	end

	local priority = struct.priority
	if not priority then
		priority = math.huge
	end

	struct.key = key

	local totalActions = #actions + 1
	actions[totalActions] = struct
	table.sort(actions, sortActions)

	for i = 1, totalActions do
		local action = actions[i]
		action.id = i

		actionsKeys[action.key] = action
	end
end

local function addOption(menu, struct)
	local option
	local tourAnchor = struct.key and 'dbgPhone.menu.' .. struct.key or nil

	local submenu = struct.submenu
	if submenu then
		if isfunction(submenu) then
			submenu = submenu()
		end

		local optmenu, opt = menu:AddSubMenu(struct.title, struct.callback)
		opt:SetIcon(struct.icon)

		for _, substruct in ipairs(submenu) do
			addOption(optmenu, substruct)
		end

		option = opt
	else
		option = menu:AddOption(struct.title, function()
			struct.callback()

			if tourAnchor then
				octolib.tour.trigger(tourAnchor)
			end
		end)

		option:SetIcon(struct.icon)
	end

	if IsValid(option) and tourAnchor then
		option:SetTourAnchor(tourAnchor)
	end
end

netstream.Hook('dbg-phone.open', function(center)
	local menu = DermaMenu()

	for _, struct in ipairs(actions) do
		addOption(menu, struct)
	end

	menu:Open()

	if center then menu:Center() end
end)