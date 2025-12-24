-- "addons\\core-characters\\lua\\dbg-characters\\accumulatables\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgChars.accumulatables = dbgChars.accumulatables or {
	idTemplate = 'accumulatables.%s'
}

local plyMeta = FindMetaTable('Player')

function plyMeta:GetAccumulatableValue(id, defaultValue)
	return self:GetNetVar(dbgChars.accumulatables.idTemplate:format(id), 0) or defaultValue or 0
end