octolib.string = octolib.string or {}

local utfPattern = '[%z\x01-\x7F\xC2-\xF4][\x80-\xBF]*'
local letterPattern = '[%z%s\x41-\x5A\x61-\x7A\x7F-\x7F\xC2-\xF4][\x80-\xBF]*'

function octolib.string.camel(str)
	local res = ''
	for w in string.gmatch(str, '[^%s]+') do
		local f = true
		for c in string.gmatch(w, utfPattern) do
			if f then
				res = res .. utf8.upper(c)
				f = false
			else
				res = res .. utf8.lower(c)
			end
		end
		res = res .. ' '
	end

	return res:Trim()
end

function octolib.string.stripNonWord(str, ignore)
	local res = ''
	for c in string.gmatch(str, '[%z%s' .. (ignore or '') .. '\x7F-\x7F\xC2-\xF4][\x80-\xBF]*') do
		res = res .. c
	end

	return res
end

function octolib.string.stripNonCyrillic(str, ignore)
	return utf8.gsub(str, '[^%z%s' .. (ignore or '') .. '\xD0\x90-\xD1\x8F\xD1\x91\xD0\x81]', '')
end

function octolib.string.urlEncode(url)
	if not isstring(url) then url = tostring(url) end

	return url:gsub('[^%w _~%.%-]', function(str)
		local formated = ('%X'):format(string.byte(str))
		return '%' .. ((formated:len() == 1) and '0' or '') .. formated
	end):gsub(' ', '+')
end

function octolib.string.signed(number)
	number = tonumber(number) or 0

	return number > 0
		and '+' .. number
		or tostring(number)
end

function octolib.string.separateDigits(number, separator)
	separator = separator or ','

	local out = tostring(number)
	while true do
		out, k = string.gsub(out, '^(-?%d+)(%d%d%d)', '%1' .. separator .. '%2')
		if k == 0 then break end
	end

	return out
end

function octolib.string.formatCount(num, single, plural, plural2)
	num = math.abs(num)
	if plural2 then
		if num > 4 and num < 21 then
			return plural2
		else
			local lastDigit = num % 10
			if lastDigit == 1 then
				return single
			elseif lastDigit > 1 and lastDigit < 5 then
				return plural
			else
				return plural2
			end
		end
	else
		return num == 1 and single or plural
	end
end

function octolib.string.formatCountExt(num, rules)
	for i, rule in ipairs(rules) do
		local nextRule = rules[i+1]
		if not nextRule or num < nextRule[1] then
			local _num = math.floor(num / rule[1])
			return ('%s %s'):format(_num, octolib.string.formatCount(_num, unpack(rule, 2)))
		end
	end
end

function octolib.string.enumeration(strings, lastSeparator, separator)
	local count = #strings
	if count == 0 then return '' end
	if count == 1 then return strings[1] end

	local lastString = table.remove(strings, count)
	return table.concat(strings, separator or ', ') .. (lastSeparator or ' и ') .. lastString
end

function octolib.string.isSteamID(str)
	if not isstring(str) then return false end
	return str:find('^STEAM_[0-5]:[01]:%d+$') ~= nil
end

function octolib.string.isSteamID64(str)
	if not isstring(str) then return false end
	return str:find('^7656119%d%d%d%d%d%d%d%d%d%d$') ~= nil
end

function octolib.string.compressSteamID(str)
	if not octolib.string.isSteamID(str) then return str end
	str = str:Replace(':', '')
	str = str:sub(8)
	return str:sub(1, 1) .. pon.encode({tonumber(str:sub(2))}):sub(3, -3)
end

function octolib.string.decompressSteamID(str)
	if not isstring(str) or str:len() < 2 then return str end
	if octolib.string.isSteamID(str) then return str end
	local ok, num = pcall(function() return pon.decode('{Y' .. str:sub(2) .. ';}')[1] end)
	if not (ok and num) then return str end
	return ('STEAM_0:%s:%d'):format(str:sub(1, 1), num)
end

local urlPattern = 'https?://[^%s/%$%.%?#].[^%s]*'
function octolib.string.isUrl(str)
	return isstring(str) and str:gsub(urlPattern, '', 1) == ''
end

function octolib.string.splitByUrl(str)
	if not isstring(str) then return {} end

	local nonUrls = string.Explode(urlPattern, str, true)
	local urls = {}
	for v in string.gmatch(str, urlPattern) do
		urls[#urls + 1] = v
	end

	local united = {}
	local nextUrl, nextPhrase = 1, 1
	if string.StartWith(str, nonUrls[1]) then
		united[1] = nonUrls[1]
		nextPhrase = 2
	end

	for i = nextPhrase, #nonUrls do
		if urls[nextUrl] then
			united[#united + 1] = {urls[nextUrl]}
			nextUrl = nextUrl + 1
		end
		united[#united + 1] = nonUrls[i]
	end
	for i = nextUrl, #urls do
		united[#united + 1] = {urls[i]}
	end

	return united
end

function octolib.string.uuid()
	local bytes = {}
	for i = 1, 16 do bytes[i] = math.random(0, 0xFF) end
	bytes[7] = bit.bor(0x40, bit.band(bytes[7], 0x0F))
	bytes[9] = bit.bor(0x80, bit.band(bytes[7], 0x3F))

	return string.format('%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x', unpack(bytes))
end

local defaultAlphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
function octolib.string.random(size, alphabet)
	size = isnumber(size) and math.max(1, size) or 6
	alphabet = isstring(alphabet) and alphabet or defaultAlphabet
	local isUtf8 = false
	for i = 1, string.len(alphabet) do
		if string.byte(alphabet, i) > 128 then
			isUtf8 = true
			break
		end
	end

	local result, alphabetLength = {}
	if isUtf8 then
		alphabetLength = utf8.len(alphabet)
		for i = 1, size do
			local pos = math.random(alphabetLength)
			result[i] = utf8.sub(alphabet, pos, pos)
		end
	else
		alphabetLength = #alphabet
		for i = 1, size do
			result[i] = alphabet[math.random(alphabetLength)]
		end
	end

	return table.concat(result)
end

function octolib.string.truncate(str, length, ending)
	if not isstring(str) then str = tostring(str) end
	if not isnumber(length) then return str end
	if not isstring(ending) then ending = '...' end

	local strLen = utf8.len(str)
	if strLen <= length then return str end

	local visibleText = utf8.sub(str, 1, length - utf8.len(ending))
	return string.Trim(visibleText) .. ending
end

function octolib.string.wrapWord(text, widthLeft, widthMax)
	local widthCursor = widthMax - widthLeft

	local lines = {}
	local curLine = {}

	local function finishLine()
		table.insert(lines, table.concat(curLine, ''))
		curLine = {}
	end

	for char in string.gmatch(text, utfPattern) do
		widthCursor = widthCursor + surface.GetTextSize(char)

		if widthCursor > widthMax then
			finishLine()
			curLine[#curLine + 1] = char
			widthCursor = surface.GetTextSize(char)
			continue
		end

		curLine[#curLine + 1] = char
	end

	if #curLine > 0 then
		finishLine()
	end

	return lines, widthCursor
end

function octolib.string.wrap(text, font, widthMax)
	local widthCursor = 0

	surface.SetFont(font)

	local widthSpace = surface.GetTextSize(' ')
	local lines = {}
	local curLine = {}

	local function finishLine()
		table.insert(lines, table.concat(curLine, ''))
		curLine = {}
	end

	for word in string.gmatch(text, '(%s?[%S]+)') do
		local char = utf8.sub(word, 1, 1)
		if char == '\n' or char == '\t' then
			widthCursor = 0
			finishLine()
		end

		local widthWord = surface.GetTextSize(word)
		widthCursor = widthCursor + widthWord

		if widthWord > widthMax then
			-- word is too long, split it
			local wordLines, newWidthCursor = octolib.string.wrapWord(word, widthMax - (widthCursor - widthWord), widthMax)
			widthCursor = newWidthCursor

			-- add remaining part on current line
			curLine[#curLine + 1] = wordLines[1]
			if #wordLines == 1 then continue end

			-- add middle lines, they should be full width
			if #wordLines > 2 then
				for i = 2, #wordLines - 1 do
					finishLine()
					curLine[#curLine + 1] = wordLines[i]
				end
			end

			-- add last line part
			finishLine()
			curLine[#curLine + 1] = wordLines[#wordLines]

			continue
		elseif widthCursor < widthMax then
			curLine[#curLine + 1] = word
			continue
		end

		if char == ' ' then
			finishLine()
			curLine[#curLine + 1] = utf8.sub(word, 2)
			widthCursor = widthWord - widthSpace
			continue
		end

		finishLine()
		curLine[#curLine + 1] = word
		widthCursor = widthWord
	end

	if #curLine > 0 then
		finishLine()
	end

	return lines
end

local STRING = getmetatable ''
function STRING:__mod(tbl)
	return self:gsub('{(.-)}', tbl)
end
