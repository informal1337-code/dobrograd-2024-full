--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-octolib/lua/octolib/modules/anim/cl_anim.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local ply = FindMetaTable 'Player'

function ply:DoAnimation(animID)
    if CLIENT then
        local state = { weight = 1 }
        local function update()
            if not IsValid(self) then return end
            self:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, state.weight)
        end

        octolib.tween.create(0.2, state, { weight = 0 }, 'inOutQuad', function()
            if not IsValid(self) then return end
            self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, animID, true)
            octolib.tween.create(0.2, state, { weight = 1 }, 'inOutQuad', nil, update)
        end, update)
    else
        -- заглушку добавил ебаааать!!!!
        print('DoAnimation called on server for anim:' .. tostring(animID))
    end
end

netstream.Hook('player-anim', function(ply, animID)
if IsValid(ply) then
ply:DoAnimation(animID)
end
end)

netstream.Hook('player-custom-anim', function(ply, catID, animID)

if not IsValid(ply) then return end

	if not catID then
		octolib.stopAnimations(ply)
		return
	end

	local cat = octolib.animations[catID or -1]
	if not cat then return end

	local anim = cat.anims[animID or -1]
	if not anim then return end

	if cat.type == 'act' then
		ply:DoAnimation(anim[2])
		return
	end

	if cat.type == 'seq' then
		local seqID = ply:LookupSequence(anim[2])
		octolib.overrideSequence[ply] = seqID

		if seqID == -1 then
			octolib.stopAnimations(ply)
			return
		end

		if cat.stand then
			octolib.resetSequenceOnMove[ply] = true
		else
			octolib.resetSequenceOnMove[ply] = nil
		end

		if anim.bones then
			octolib.manipulateBones(ply, anim.bones, 0.4)
		else
			octolib.manipulateBones(ply, nil, 0.4)
		end

		if anim.startTime then
			octolib.overrideSequenceTime[ply] = anim.startTime
		end

		return
	end

end)
