-- "addons\\core-octolib\\lua\\octolib\\modules\\render\\client.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
octolib.renderModel = octolib.renderModel or {}

local emptyPng = render.Capture({x = 0, y = 0, w = 1, h = 1, format = 'png'})

local waitingDests = {}
local waitingImages = {}
local renderedImages = {}
local knownDestinations = setmetatable({}, {__mode = 'k'})

file.CreateDir('octolib/render')
hook.Add('ShutDown', 'octolib.renderModel.clenup', function()
	local files = file.Find('octolib/render/*', 'DATA')
	for _, name in ipairs(files) do
		file.Delete('octolib/render/' .. name)
	end
end)

local queue = {}
hook.Add('Think', 'octolib.renderModel.queue', function()
	if not queue[1] then return end

	local destination, settings, fileName, filePath, matPath = unpack(table.remove(queue, 1))

	local scale = destination.scale or 3
	local imgW, imgH = destination.width * scale, destination.height * scale
	local model = destination.model or 'models/error.mdl'
	local color = destination.color or color_white
	local skin = destination.skin or 0
	local bg = destination.bg or {}
	local subMats = destination.subMats or {}
	local texture = GetRenderTarget(('octolib_render_%d_%d'):format(imgW, imgH), imgW, imgH)

	local csent = ClientsideModel(model, RENDERGROUP_BOTH)
	csent:SetPos(vector_origin)
	csent:SetAngles(angle_zero)
	csent:SetSkin(skin or 0)
	for id, val in pairs(bg) do
		csent:SetBodygroup(id, val)
	end
	for idOrPattern, val in pairs(subMats) do
		if isnumber(idOrPattern) then
			csent:SetSubMaterial(idOrPattern, val)
		else
			for i, original in ipairs(csent:GetMaterials()) do
				if string.match(original, idOrPattern) then
					csent:SetSubMaterial(i - 1, val)
				end
			end
		end
	end

	if isfunction(settings) then
		settings = settings(csent)
	end
	local camPos = settings.camPos or vector_zero
	local camAng = settings.camAng or angle_zero
	local camFov = settings.camFov or 45
	local baseLightColor = settings.baseLightColor or Vector(0.75, 0.75, 0.75)
	local lights = settings.lights or {}

	render.PushRenderTarget(texture)
	render.Clear(0,0,0,0, true, true)
	cam.Start3D(camPos, camAng, camFov, 0, 0, imgW, imgH)
		render.OverrideAlphaWriteEnable(true, true)
		render.SuppressEngineLighting(true)
		render.PushFilterMin(TEXFILTER.ANISOTROPIC)
		render.SetLocalModelLights(lights)
			render.SetWriteDepthToDestAlpha(false)
			render.SetColorModulation(color:ToVector():Unpack())
			render.ResetModelLighting(baseLightColor:Unpack())
			csent:DrawModel()
			local imageData = render.Capture({
				format = 'png',
				x = 0, y = 0,
				w = imgW, h = imgH,
				farz = camPos:Length() * 2,
			})
		render.SetLocalModelLights()
		render.PopFilterMin()
		render.SuppressEngineLighting(false)
		render.OverrideAlphaWriteEnable(false)
	cam.End3D()
	render.PopRenderTarget()

	csent:Remove()

	file.Write(filePath, imageData)
	RunConsoleCommand('mat_reloadmaterial', matPath:StripExtension())

	local image = Material(matPath, 'smooth noclamp mips')
	for _, _destination in ipairs(waitingDests[fileName]) do
		_destination.image = image
		knownDestinations[_destination] = true
	end

	waitingDests[fileName] = nil
	renderedImages[fileName] = image

	hook.Run('octolib.renderModel.rendered', fileName, image)
end)

function octolib.renderModel.getFileName(destination, renderSettings)
	if destination.fileName then
		return destination.fileName
	end

	if isfunction(renderSettings) then
		renderSettings = renderSettings()
	end

	local destinationKey = table.Copy(destination)
	destinationKey.image = nil

	return util.CRC(pon.encode({destinationKey, renderSettings}))
end

function octolib.renderModel.queueRender(destination, settings)
	local image = destination.image
	if image then
		return fileName, true
	end

	local fileName = octolib.renderModel.getFileName(destination, settings)
	local filePath = 'octolib/render/' .. fileName .. '.png'
	local matPath = '../data/' .. filePath

	image = renderedImages[fileName]
	if image then
		destination.image = image
		knownDestinations[destination] = true
		return fileName, true
	end

	if not waitingImages[fileName] then
		file.Write(filePath, emptyPng)
		RunConsoleCommand('mat_reloadmaterial', matPath:StripExtension())
		image = Material(matPath, 'smooth noclamp')
		waitingImages[fileName] = image
	end

	local waiting = waitingDests[fileName]
	if not waiting then
		waitingDests[fileName] = {destination}
		waiting = waitingDests[fileName]
		queue[#queue + 1] = {destination, settings, fileName, filePath, matPath}
	else
		waiting[#waitingDests + 1] = destination
	end

	return fileName, false
end

function octolib.renderModel.clear(destination, renderSettings)
	if not destination then
		for knownDestination in pairs(knownDestinations) do
			knownDestination.image = nil
		end

		renderedImages = {}
		return
	end

	local fileName = octolib.renderModel.getFileName(destination, renderSettings)
	renderedImages[fileName] = nil
	destination.image = nil
end
