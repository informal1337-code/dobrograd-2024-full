-- "addons\\core-octolib\\lua\\octolib\\modules\\notify\\realtime\\cl_realtime.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
octolib.notify.types = octolib.notify.types or {
	_generic = octolib.func.zero,
}

function octolib.notify.register(type, handler)
	if type == '_generic' and not handler then
		handler = octolib.func.zero
	end
	octolib.notify.types[type] = handler
end

function octolib.notify.show(type, ...)
	local data = {...}
	if not data[1] then
		data = {type}
		type = '_generic'
	end
	type = type or '_generic'

	if octolib.notify.types[type] then octolib.notify.types[type](unpack(data))
	else octolib.notify.types._generic(unpack(data)) end
end
