--[[
	Namespace: octolib

	Group: bottomMessages
]]

octolib.bottomMessages = octolib.bottomMessages or {}
octolib.bottomMessages.cache = {}
local cache = octolib.bottomMessages.cache
local startPos = ScrH() - 20

hook.Add('OnScreenSizeChanged', 'octolib.bottomMessages', function(w, h)
	startPos = h - 20
end)

surface.CreateFont('octolib.bottomMessage.normal', {
	font = 'Calibri',
	extended = true,
	size = 40,
	weight = 350,
})

--[[
	Function: add
		Add a message to the bottom messages list

	Arguments:
		<string> id - Identifier, used to remove the block later
		<table> Параметры
			<string> text - Text to draw
			<string?> font - Font to use
			<float?> time - Time to automatically remove the message
			<function?> paint - Override the paint function, provides ability to set height

	_paint_ arguments::
		<int> x - x coordinate of position
		<int> y - y coordinate of position

	_paint_ returns::
		<int> height - Height of painted block
]]
function octolib.bottomMessages.add(id, data)
	if not isstring(id) or not istable(data) then
		error('id should be string and data should be a table')
	end

	octolib.bottomMessages.remove(id)
	data.id = id
	data.font = data.font or 'octolib.bottomMessage.normal'
	cache[#cache + 1] = data

	if data.time then
		timer.Simple(data.time, function()
			octolib.bottomMessages.remove(id)
		end)
	end
end


--[[
	Function: findByID
		Find an existing message index by its id

	Arguments:
		<string> id - Identifier that was set in <add>

	Returns:
		<int> - Numeric index from internal table
]]
function octolib.bottomMessages.findByID(_id)
	for i, v in ipairs(cache) do
		if v.id == _id then return i end
	end
end


--[[
	Function: remove
		Remove an existing message by its id

	Arguments:
		<string> id - Identifier that was set in <add>
]]
function octolib.bottomMessages.remove(id)
	local foundID = octolib.bottomMessages.findByID(id)

	if foundID then
		table.remove(cache, foundID)
	end
end

hook.Add('HUDPaint', 'octolib.bottomMessages', function(w, h)
	local y = startPos

	for id, data in ipairs(cache) do
		if not data.paint then
			draw.Text({
				text = data.text,
				font = data.font,
				pos = {ScrW() / 2, y},
				color = color_white,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_BOTTOM,
			})

			surface.SetFont(data.font)
			y = y - select(2, surface.GetTextSize(data.text))
		elseif isfunction(data.paint) then
			y = y - data.paint(ScrW() / 2, y) or 50
		end
	end
end)
