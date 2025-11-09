-- "addons\\core-octolib\\lua\\octolib\\modules\\table.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
octolib.table = octolib.table or {}

function octolib.table.toKeyVal(tbl)
	local out = {}
	for k, v in pairs(tbl) do
		out[#out + 1] = {k, v}
	end

	return out
end

function octolib.table.getValues(tbl)
	return octolib.table.mapSequential(tbl, function(v) return v end)
end

function octolib.table.count(tbl, func)
	local count = 0
	for k, v in pairs(tbl) do
		if func(v, k) then count = count + 1 end
	end

	return count
end

function octolib.table.map(tbl, func)
	local out = {}
	for k, v in pairs(tbl) do
		out[k] = func(v, k, tbl)
	end

	return out
end

function octolib.table.mapSequential(tbl, func)
	local out = {}
	local index = 1
	for k, v in pairs(tbl) do
		local value = func(v, k, tbl)
		if value == nil then continue end

		out[index] = value
		index = index + 1
	end

	return out
end

function octolib.table.strip(tbl, defaults, depth)
	depth = depth or 1

	if depth == 0 then
		return tbl
	end

	for k, default in pairs(defaults) do
		if tbl[k] == default then
			tbl[k] = nil
		elseif istable(tbl[k]) then
			if istable(default) and table.Count(octolib.table.diff(tbl[k], default)) == 0 then
				octolib.table.strip(tbl[k], default, depth - 1)
			else
				tbl[k] = nil
			end
		end
	end

	return tbl
end

function octolib.table.reduce(tbl, func, initVal)
	local a = initVal or tbl[table.GetKeys(tbl)[1]]
	for k, v in pairs(tbl) do
		a = func(a, v, k, tbl)
	end

	return a
end

function octolib.table.some(tbl, func)
	for k, v in pairs(tbl) do
		if func(v, k) then return true end
	end

	return false
end

function octolib.table.every(tbl, func)
	for k, v in pairs(tbl) do
		if not func(v, k) then return false end
	end

	return true
end

function octolib.table.find(tbl, func)
	for k, v in pairs(tbl) do
		if func(v, k) then return v, k end
	end
end

function octolib.table.filter(tbl, func)
	local found = {}
	for k, v in pairs(tbl) do
		if func(v, k) then found[k] = v end
	end

	return found
end

function octolib.table.filterMultiple(tbl, funcs, limit)
	local out = {}
	local foundAmount = 0
	for k, v in pairs(tbl) do
		if octolib.array.every(funcs, function(func)
			return func(v, k)
		end) then
			out[k] = v
			foundAmount = foundAmount + 1
			if limit and foundAmount >= limit then break end
		end
	end

	return out
end

local queryTypes = {
	-- general
	_equals = function(v, arg)
		return v == arg
	end,
	_not = function(v, arg)
		return v ~= arg
	end,
	_exists = function(v, arg)
		return (arg and v ~= nil) or (not arg and v == nil)
	end,
	_custom = function(v, arg)
		return arg(v)
	end,

	-- numbers
	_gt = function(v, arg)
		return isnumber(v) and v > arg
	end,
	_gte = function(v, arg)
		return isnumber(v) and v >= arg
	end,
	_lt = function(v, arg)
		return isnumber(v) and v < arg
	end,
	_lte = function(v, arg)
		return isnumber(v) and v <= arg
	end,
	_between = function(v, arg)
		return isnumber(v) and (v > arg[1] and v < arg[2])
	end,
	_notBetween = function(v, arg)
		return isnumber(v) and (v < arg[1] or v > arg[2])
	end,
	_betweenInc = function(v, arg)
		return isnumber(v) and (v >= arg[1] and v <= arg[2])
	end,
	_notBetweenInc = function(v, arg)
		return isnumber(v) and (v <= arg[1] or v >= arg[2])
	end,

	-- strings
	_find = function(v, arg)
		return isstring(v) and v:find(arg, 1, true)
	end,
	_regex = function(v, arg)
		return isstring(v) and v:find(arg)
	end,
	_starts = function(v, arg)
		return isstring(v) and v:StartWith(arg)
	end,
	_ends = function(v, arg)
		return isstring(v) and v:EndsWith(arg)
	end,
}

local function checkFieldValue(item, k, v, getter)
	local fieldValue
	if getter then
		fieldValue = getter(item, k)
	else
		fieldValue = item[k]
	end

	if istable(v) then
		for field, value in pairs(v) do
			local func = queryTypes[field]
			if not func then
				return checkFieldValue(fieldValue, field, value, getter)
			end

			if not func(fieldValue, value) then
				return false
			end
		end
	else
		local func = queryTypes[k] or queryTypes._equals
		if not func(fieldValue, v) then
			return false
		end
	end

	return true
end

local function checkLogicalOperators(item, query, getter)
	if istable(query._AND) then
		if table.IsSequential(query._AND) then
			return octolib.array.every(query._AND, function(condition)
				return checkLogicalOperators(item, condition, getter)
			end)
		else
			return octolib.table.every(query._AND, function(condition, key)
				return checkLogicalOperators(item, {[key] = condition}, getter)
			end)
		end

		return true
	elseif istable(query._OR) then
		if table.IsSequential(query._OR) then
			return octolib.array.some(query._OR, function(condition)
				return checkLogicalOperators(item, condition, getter)
			end)
		else
			return octolib.table.some(query._OR, function(condition, key)
				return checkLogicalOperators(item, {[key] = condition}, getter)
			end)
		end
	elseif istable(query._NOT) then
		if table.IsSequential(query._NOT) then
			return octolib.array.every(query._NOT, function(condition)
				return not checkLogicalOperators(item, condition, getter)
			end)
		else
			return octolib.table.every(query._NOT, function(condition, key)
				return not checkLogicalOperators(item, {[key] = condition}, getter)
			end)
		end
	else
		for k, v in pairs(query) do
			if not checkFieldValue(item, k, v, getter) then
				return false
			end
		end

		return true
	end
end

function octolib.table.precacheFilterFunctions(query, getter)
	local funcs = {}

	for k, v in pairs(query) do
		if k == '_AND' or k == '_OR' or k == '_NOT' then
			funcs[#funcs + 1] = function(item)
				return checkLogicalOperators(item, query, getter)
			end
		else
			funcs[#funcs + 1] = function(item)
				return checkLogicalOperators(item, {[k] = v}, getter)
			end
		end
	end

	return funcs
end

function octolib.table.filterQuery(tbl, query, getter, limit)
	return octolib.table.filterMultiple(tbl, octolib.table.precacheFilterFunctions(query, getter), limit)
end

function octolib.table.diff(t1, t2, changes)
	changes = changes or {}

	for k, v in pairs(t1) do
		if istable(v) then
			if t2[k] ~= nil then
				local innerChanges = {}
				octolib.table.diff(v, t2[k], innerChanges)
				if not table.IsEmpty(innerChanges) then
					changes[k] = innerChanges
				end
			else
				changes[k] = '--deleted--'
			end
		else
			if t2[k] ~= nil then
				if v ~= t2[k] then
					changes[k] = t2[k]
				end
			else
				changes[k] = '--deleted--'
			end
		end
	end

	for k, v in pairs(t2) do
		if t1[k] == nil then
			if istable(v) then
				changes[k] = table.Copy(v)
			else
				changes[k] = v
			end
		end
	end

	return changes
end

function octolib.table.get(t, path)
	local value = t
	for segment in string.gmatch(path, '[%w_]+') do
		if istable(value) then
			local index = tonumber(segment) or segment
			value = value[index]
		else
			return nil
		end
	end
	return value
end

function octolib.table.set(t, path, value)
	local segments = {}
	for segment in string.gmatch(path, '[%w_]+') do
		segments[#segments + 1] = tonumber(segment) or segment
	end

	local lastSegment = table.remove(segments)
	local lastTable = t
	for _, segment in ipairs(segments) do
		if not lastTable[segment] then
			lastTable[segment] = {}
		end

		lastTable = lastTable[segment]
	end

	lastTable[lastSegment] = value
end

function octolib.table.pick(t, keys)
	local out = {}
	for _, key in ipairs(keys) do
		out[key] = t[key]
	end

	return out
end
