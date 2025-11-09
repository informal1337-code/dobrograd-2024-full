-- "addons\\core-weapons\\lua\\dbg-weapons\\firemodes\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgWeapons.fireModes = dbgWeapons.fireModes or {}

function dbgWeapons.registerFireMode(id, modeStruct)
	dbgWeapons.fireModes[id] = modeStruct
end

sound.Add({
	name = 'octoweapons.modeSwitch',
	channel = CHAN_STATIC,
	level = 155,
	sound = 'weapons-new/shared/mode_switch.ogg'
})

octolib.include.shared('modes/')
