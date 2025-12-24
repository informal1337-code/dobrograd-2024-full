-- Simple logging utility with webhook support
-- Provides easy logging with optional Discord webhook integration

octolib.logger = octolib.logger or {}

-- Configuration
local LOG_LEVELS = {
	ERROR = 1,
	WARNING = 2,
	INFO = 3,
	DEBUG = 4,
}

local LOG_COLORS = {
	ERROR = Color(255, 0, 0),
	WARNING = Color(255, 165, 0),
	INFO = Color(0, 255, 0),
	DEBUG = Color(128, 128, 128),
}

-- Current log level (can be changed at runtime)
octolib.logger.level = LOG_LEVELS.INFO

-- Webhook URL for logging (set via config)
octolib.logger.webhookURL = nil

-- Log to console
function octolib.logger.log(level, message, ply, extraData)
	local levelNum = LOG_LEVELS[level:upper()]
	if not levelNum or levelNum > octolib.logger.level then return end

	local timestamp = os.date('%Y-%m-%d %H:%M:%S')
	local prefix = string.format('[%s] [%s]', timestamp, level:upper())

	local logMessage = prefix
	if ply and IsValid(ply) then
		logMessage = logMessage .. string.format(' [%s (%s)]', ply:GetName(), ply:SteamID())
	end
	logMessage = logMessage .. ': ' .. message

	-- Print to server console
	MsgC(LOG_COLORS[level:upper()] or Color(255, 255, 255), logMessage .. '\n')

	-- Send to webhook if configured and level is important enough
	if octolib.logger.webhookURL and levelNum <= LOG_LEVELS.WARNING then
		octolib.webhook.log(octolib.logger.webhookURL, level, message, ply, extraData)
	end
end

-- Convenience functions
function octolib.logger.error(message, ply, extraData)
	octolib.logger.log('ERROR', message, ply, extraData)
end

function octolib.logger.warning(message, ply, extraData)
	octolib.logger.log('WARNING', message, ply, extraData)
end

function octolib.logger.info(message, ply, extraData)
	octolib.logger.log('INFO', message, ply, extraData)
end

function octolib.logger.debug(message, ply, extraData)
	octolib.logger.log('DEBUG', message, ply, extraData)
end

-- Set webhook URL
function octolib.logger.setWebhook(url)
	octolib.logger.webhookURL = url
end

-- Set log level
function octolib.logger.setLevel(level)
	if type(level) == 'string' then
		level = LOG_LEVELS[level:upper()]
	end
	if level and level >= LOG_LEVELS.ERROR and level <= LOG_LEVELS.DEBUG then
		octolib.logger.level = level
	end
end

-- Legacy compatibility - alias to octolib.log
if not octolib.log then
	octolib.log = octolib.logger.info
end

-- Initialize
if SERVER then
	octolib.logger.info('Logger utility loaded')
end
