-- "addons\\core-octolib\\lua\\octolib\\modules\\notify\\persistent\\cl_nets.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local notify = octolib.notify

notify.persistent.cache = notify.persistent.cache or {}

netstream.Hook('octolib-notify.persistent.add', function(notif)
	notify.persistent.cache[#notify.persistent.cache + 1] = notif
	hook.Run('octolib.notify.persistent.cacheUpdate', notify.persistent.cache)
end)

netstream.Hook('octolib-notify.persistent.remove', function(id)
	local found, index = octolib.array.find(notify.persistent.cache, function(notif)
		return notif.id == id
	end)
	if not found then
		return
	end

	table.remove(notify.persistent.cache, index)
	hook.Run('octolib.notify.persistent.cacheUpdate', notify.persistent.cache)
end)

netstream.Hook('octolib-notify.persistent.sync', function(notifs)
	notify.persistent.cache = notifs
	hook.Run('octolib.notify.persistent.cacheUpdate', notify.persistent.cache)
end)
