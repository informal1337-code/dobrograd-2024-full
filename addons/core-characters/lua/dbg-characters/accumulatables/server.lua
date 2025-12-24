local plyMeta = FindMetaTable('Player')

function plyMeta:SetAccumulatableValue(id, value)
	self:SetNetVar(dbgChars.accumulatables.idTemplate:format(id), value)
end

function plyMeta:AddAccumulatableValue(id, amount)
	local current = self:GetAccumulatableValue(id, 0)
	self:SetAccumulatableValue(id, current + amount)
end

function plyMeta:ResetAccumulatableValue(id)
	self:SetNetVar(dbgChars.accumulatables.idTemplate:format(id), nil)
end
