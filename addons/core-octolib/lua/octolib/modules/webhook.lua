octolib.webhook = octolib.webhook or {}
local RETRY_ATTEMPTS = 3
local RETRY_DELAY = 1 -- seconds

local webhookQueue = {}
local isProcessingQueue = false

function octolib.webhook.send(url, data, callback)
	if not url or url == '' or not data then return end

	data.timestamp = data.timestamp or os.date('!%Y-%m-%dT%H:%M:%SZ')

	if data.embeds and not istable(data.embeds) then
		data.embeds = {data.embeds}
	end

	local jsonData = util.TableToJSON(data, false)
	if not jsonData then
		if callback then callback(false, 'Failed to encode JSON') end
		return
	end

	http.Post(url, {
		['Content-Type'] = 'application/json',
		['Content-Length'] = #jsonData
	}, jsonData, function(code, body, headers)
		local success = code == 200 or code == 204
		if success then
			if callback then callback(true, body) end
		else
			octolib.log(string.format('Webhook failed: HTTP %d - %s', code, body or 'Unknown error'))
			if callback then callback(false, string.format('HTTP %d', code)) end
		end
	end, function(err)
		octolib.log('Webhook error: ' .. err)
		table.insert(webhookQueue, {
			url = url,
			data = data,
			attempts = 1,
			nextRetry = CurTime() + RETRY_DELAY
		})
		if callback then callback(false, err) end
	end)
end

function octolib.webhook.embed(url, embed, callback)
	octolib.webhook.send(url, {embeds = {embed}}, callback)
end

function octolib.webhook.message(url, content, username, callback)
	local data = {content = content}
	if username then data.username = username end
	octolib.webhook.send(url, data, callback)
end

local function processQueue()
	if isProcessingQueue or #webhookQueue == 0 then return end
	isProcessingQueue = true

	for i = #webhookQueue, 1, -1 do
		local item = webhookQueue[i]
		if CurTime() >= item.nextRetry then
			octolib.webhook.send(item.url, item.data, function(success, response)
				if success then
					table.remove(webhookQueue, i)
				else
					item.attempts = item.attempts + 1
					if item.attempts >= RETRY_ATTEMPTS then
						octolib.log("Webhook permanently failed after " .. RETRY_ATTEMPTS .. " attempts")
						table.remove(webhookQueue, i)
					else
						item.nextRetry = CurTime() + (RETRY_DELAY * item.attempts)
					end
				end
			end)
		end
	end

	isProcessingQueue = false

	if #webhookQueue > 0 then
		timer.Simple(RETRY_DELAY, processQueue)
	end
end

timer.Create("octolib.webhook.queue", 5, 0, processQueue)

function octolib.webhook.anticheat(url, title, description, ply, extraFields)
	local embed = {
		title = title,
		description = description,
		color = 16711680, -- Red
		fields = {{
			name = "Player",
			value = string.format("%s\n[%s](https://steamcommunity.com/profiles/%s)",
				ply:GetName(), ply:SteamID(), ply:SteamID64()),
		}, {
			name = "Time",
			value = os.date("%Y-%m-%d %H:%M:%S"),
		}},
		timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
	}

	if extraFields then
		for _, field in ipairs(extraFields) do
			table.insert(embed.fields, field)
		end
	end

	octolib.webhook.embed(url, embed)
end

function octolib.webhook.log(url, level, message, ply, extraData)
	local colors = {
		ERROR = 16711680,    -- Red
		WARNING = 16776960, -- Yellow
		INFO = 255,         -- Blue
		SUCCESS = 65280,    -- Green
	}

	local embed = {
		title = level:upper(),
		description = message,
		color = colors[level:upper()] or 16777215,
		timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
		fields = {},
	}

	if ply and IsValid(ply) then
		table.insert(embed.fields, {
			name = "Player",
			value = string.format("%s (%s)", ply:GetName(), ply:SteamID()),
		})
	end

	if extraData then
		for k, v in pairs(extraData) do
			table.insert(embed.fields, {
				name = k,
				value = tostring(v),
				inline = true,
			})
		end
	end

	octolib.webhook.embed(url, embed)
end
