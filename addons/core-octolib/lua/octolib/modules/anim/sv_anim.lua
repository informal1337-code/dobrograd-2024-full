local ply = FindMetaTable('Player')

function ply:DoAnimation(animID)
    netstream.StartPVS(self:GetPos(), 'player-anim', self, animID) -- буду молодым
end

netstream.Hook('player-anim', function(ply, catID, animID)
    if not IsValid(ply) then return end
    
    local cat = octolib.animations[catID or -1]
    if not cat then return end

    local anim = cat.anims[animID or -1]
    if not anim then return end

    if cat.type == 'act' then
        ply:DoAnimation(anim[2])
    elseif cat.type == 'seq' then
        netstream.StartPVS(ply:GetPos(), 'player-custom-anim', ply, catID, animID)
        
        if cat.stand then
            octolib.resetSequenceOnMove[ply] = true
        else
            octolib.resetSequenceOnMove[ply] = nil
        end
        
        if anim.bones then
            octolib.manipulateBones(ply, anim.bones, 0.4)
        end
    end
end)

netstream.Hook('player-flex', function(ply, flexes)
    if IsValid(ply) then
        netstream.StartPVS(ply:GetPos(), 'player-flex', ply, flexes)
    end
end)