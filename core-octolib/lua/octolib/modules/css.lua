if CFG.disabledModules.css then return end

if SERVER then
	util.PrecacheModel('models/props/cs_assault/money.mdl')

	local texts = {
		{'Кажется, у тебя не установлен (или установлен неправильно) контент CSS!'},
		{'Платтсбург активно использует этот контент, поэтому с твоей стороны могут наблюдаться различные "Error\'ки", "Эмо-текстуры" и так далее'},
		{'Инструкция по установке CSS-контента: ', {'https://discord.gg/TsC2bDm75v'}},
		{'Устранение прочих проблем с контентом: ', {'https://discord.gg/TsC2bDm75v'}},
	}

	hook.Add('PlayerFinishedLoading', 'dbg.csscheck', function(ply)
		if ply.cssWarned then return end
		ply.cssWarned = true
		timer.Simple(5, function()
			if not IsValid(ply) then return end
			netstream.Request(ply, 'dbg.csscheck'):Then(function(res)
				if res then return end
				for _, text in ipairs(texts) do
					octochat.talkTo(ply, Color(225,0,0), unpack(text))
				end
			end)
		end)
	end)

else
	netstream.Listen('dbg.csscheck', function(reply)
		reply(util.IsValidModel('models/props/cs_assault/money.mdl'))
	end)
end
