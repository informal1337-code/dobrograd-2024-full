CreateClientConVar('cl_govorilka_voice', 'zahar', true, true)
local useProxy = false
local link = {
	[false] = 'http://tts.voicetech.yandex.net/tts?speaker=%s&text=%s',
	[true] = 'https://octothorp.team/api/tts/y/%s/%s',
}

CFG.octoservicesURL = "https://octothorp.team/api"

local function init()
	link[true] = CFG.octoservicesURL .. '/tts/y/%s/%s'

	local encode = link[false]:format('zahar', octolib.string.urlEncode('-'))
	sound.PlayURL(encode, 'noplay 3d', function(station)
		if IsValid(station) then
			local ply = LocalPlayer()
			if IsValid(ply) then
				station:SetPos(ply:GetPos())
				station:SetVolume(2)
				station:Play()
				useProxy = false
			else
				station:Stop()
			end
		else
			useProxy = true
		end
	end)
end

if octoservices then
	init()
else
	hook.Add('octoservices.init', 'govorilka', init)
end

local meta = FindMetaTable 'Entity'
function meta:DoVoice(text, voice)
	if not IsValid(self) or not self:IsPlayer() then 
		return 
	end

	local encode = (link[useProxy]):format(voice or self:GetVoice(), octolib.string.urlEncode(text))
	local flag = 'noplay 3D'
	sound.PlayURL(encode, flag, function(station, errID, err)
		if not IsValid(self) or not self:IsPlayer() then 
			if IsValid(station) then 
				station:Stop() 
			end
			return 
		end

		if IsValid(station) then
			if IsValid(self) then
				station:SetPos(self:GetPos())
				station:SetVolume(2)
				station:Play()
			else
				station:Stop()
				return
			end

			local timerName = 'govorilka_' .. self:EntIndex()
			timer.Create(timerName, 0.2, 0, function()
				if not IsValid(self) or not self:IsPlayer() or not IsValid(station) then
					if IsValid(station) then 
						station:Stop() 
					end
					timer.Remove(timerName)
					return
				end
				
				station:SetPos(self:GetPos())
			end)
			
			timer.Create(timerName .. '_remove', 30, 1, function()
				if timer.Exists(timerName) then
					timer.Remove(timerName)
				end
				if IsValid(station) then
					station:Stop()
				end
			end)
		end
	end)
end

netstream.Hook('govorilka.play', function(ent, text, voice)
	if IsValid(ent) and ent:IsPlayer() then
		ent:DoVoice(text, voice)
	end
end)