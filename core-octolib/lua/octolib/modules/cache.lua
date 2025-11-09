octolib.cache = octolib.cache or {}
octolib.cache.CacheClass = octolib.cache.CacheClass or {}

local Cache = octolib.cache.CacheClass
Cache.__index = Cache

local function wrap(cache, val, ttl)
	local now = CurTime()
	local lifetime = 0

	if ttl ~= nil then
		lifetime = now + ttl
	elseif ttl == nil and cache.stdTTL ~= 0 then
		lifetime = now + cache.stdTTL
	end

	return {
		t = lifetime,
		v = val,
	}
end

local function unwrap(val)
	return val.v
end

local function check(cache, key, data)
	local valid = true

	if data.t ~= 0 and data.t < CurTime() then
		if cache.deleteOnExpire then
			valid = false
			cache:Del(key)
		end
		cache:OnExpired(key, unwrap(data))
	end

	return valid
end

function octolib.cache.create(data)
	data = data or {}

	local cache = setmetatable({
		uid = octolib.string.uuid(),
		data = {},
		stdTTL = data.stdTTL or 0,
		checkperiod = data.checkperiod or 600,
		deleteOnExpire = data.deleteOnExpire or true,
	}, Cache)

	timer.Create('cache-' .. cache.uid .. '.checkData', cache.checkperiod, 0, function()
		for key, value in pairs(cache.data) do
			check(cache, key, value)
		end
	end)

	return cache
end

function Cache:Set(key, val, ttl)
	if ttl == nil then ttl = self.stdTTL end

	self.data[key] = wrap(self, val, ttl)
	self:OnSet(key, val)

	return true
end

function Cache:Get(key)
	return self:Has(key) and unwrap(self.data[key]) or nil
end

function Cache:Take(key)
	local val = self:Get(key)
	if val then self:Del(key) end
	return val
end

function Cache:Del(keys)
	local delCount = 0

	local function delIfExist(key)
		local val = self.data[key]
		if val then
			delCount = delCount + 1
			self.data[key] = nil
			self:OnDel(key, unwrap(val))
		end
	end

	if istable(keys) then
		for _, key in ipairs(keys) do
			delIfExist(key)
		end
	else
		delIfExist(keys)
	end

	return delCount
end

function Cache:Has(key)
	return self.data[key] and check(self, key, self.data[key])
end

function Cache:Close()
	timer.Remove('cache-' .. cache.uid .. '.checkData')
end

function Cache:OnSet(key, val)
	-- to be overridden
end

function Cache:OnDel(key, val)
	-- to be overridden
end

function Cache:OnExpired(key, val)
	-- to be overridden
end
