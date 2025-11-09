-- "addons\\core-weapons\\lua\\dbg-weapons\\attachments\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgWeapons.attachments = dbgWeapons.attachments or {
	registered = {},
}

netstream.Hook('dbg-weapons.attachments.sync', function(data)
	dbgWeapons.attachments.registered = data
end)