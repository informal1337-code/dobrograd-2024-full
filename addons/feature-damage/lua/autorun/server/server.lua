AddCSLuaFile()

local DAMAGE_CONFIG = {
    ENABLED = true,
    
    DAMAGE_SCALE = {
        [HITGROUP_HEAD] = 2.0,
        [HITGROUP_CHEST] = 1.25,
        [HITGROUP_STOMACH] = 0.75,
        [HITGROUP_LEFTARM] = 0.5,
        [HITGROUP_RIGHTARM] = 0.5,
        [HITGROUP_LEFTLEG] = 0.5,
        [HITGROUP_RIGHTLEG] = 0.5,
        HITGROUP_HAND = 0.25,
        HITGROUP_NUTS = 2.0
    },
    
    DROP_CHANCE = {
        ARM = 50,
        HAND = 75
    },
    
    LEG_BREAK = {
        ENABLED = true,
        DURATION = 10,
        WALK_MULTIPLIER = 0.5
    },
    
    BLEEDING = {
        HEALTH_THRESHOLD = 10,
        MOVE_PENALTY = {
            walkmul = 0.5,
            norun = true,
            nojump = true,
            nostand = true
        },
        BLEED_INTERVAL = 18,
        BLEED_DAMAGE = 1
    }
}

local HITGROUP_NAMES = {
    [HITGROUP_HEAD] = "голову",
    [HITGROUP_CHEST] = "область груди",
    [HITGROUP_STOMACH] = "область живота",
    [HITGROUP_LEFTARM] = "левую руку",
    [HITGROUP_RIGHTARM] = "правую руку",
    [HITGROUP_LEFTLEG] = "левую ногу",
    [HITGROUP_RIGHTLEG] = "правую ногу",
    HITGROUP_HAND = "руку",
    HITGROUP_NUTS = "пах"
}

local ALLOWED_HOLSTER_WEAPONS = {
    weapon_flashlight = true,
    gmod_camera = true
}

local bleedingPlayers = {}
local drowningPlayers = {}

local function IsPlayerImmune(ply)
    return not IsValid(ply) or not ply:IsPlayer() or ply:IsGhost() or ply:Team() == TEAM_ADMIN
end

local function PlayPainSound(ply)
    if not IsValid(ply) then return end
    
    local genderSound = ply:IsMale() and "vo/npc/male01/moan0" or "vo/npc/female01/moan0"
    ply:EmitSound(genderSound .. math.random(1, 5) .. ".wav")
end

local function BreakLeg(ply, duration)
    if not DAMAGE_CONFIG.LEG_BREAK.ENABLED then return end
    if ply.legBroken then return end
    
    ply.legBroken = true
    ply:MoveModifier("broken_leg", {
        walkmul = DAMAGE_CONFIG.LEG_BREAK.WALK_MULTIPLIER,
        norun = true,
        nojump = true
    })
    
    timer.Create("breakLeg_" .. ply:SteamID(), duration or DAMAGE_CONFIG.LEG_BREAK.DURATION, 1, function()
        if IsValid(ply) then
            ply:MoveModifier("broken_leg", nil)
            ply.legBroken = nil
        end
    end)
end

local function DamageHands(ply, chance)
    if IsPlayerImmune(ply) then return false end
    if math.random(100) > chance then return end
    
    local weapon = ply:GetActiveWeapon()
    if not IsValid(weapon) then return end
    
    local GM = GAMEMODE or GM
    
    if not GM.Config.DisallowDrop[weapon:GetClass()] then
        if not ply:jobHasWeapon(weapon:GetClass()) then
            if not weapon.NoHandDamageDrop then
                local droppedWeapon = ply:dropDRPWeapon(weapon)
                if IsValid(droppedWeapon) and weapon.IsLethal then
                    droppedWeapon.isEvidence = true
                end
            end
        else
            ply:SelectWeapon("dbg_hands")
        end
    end
    
    ply.noPickups = true
    timer.Create("resetNoPickups_" .. ply:SteamID(), 30, 1, function()
        if IsValid(ply) then ply.noPickups = nil end
    end)
end

local function HandleDrowning()
    octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
        if not IsValid(ply) or IsPlayerImmune(ply) then return end
        
        if ply:WaterLevel() == 3 then
            local drownScore = ply.drowningScore or 0
            if drownScore >= 10 then
                local dmginfo = DamageInfo()
                dmginfo:SetDamage(10)
                dmginfo:SetDamageType(DMG_DROWN)
                dmginfo:SetAttacker(game.GetWorld())
                dmginfo:SetInflictor(game.GetWorld())
                ply:TakeDamageInfo(dmginfo)
            else
                ply.drowningScore = drownScore + 1
            end
        else
            ply.drowningScore = nil
        end
    end)
end

local function HandleFallDamage(ply, speed)
    if IsPlayerImmune(ply) then return 0 end
    
    local damage = speed / 7.5
    if damage > ply:Health() / 2 and damage < ply:Health() then
        BreakLeg(ply, 10)
    end
    
    ply.lastDMGT = DMG_FALL
    return damage
end

local function DetermineHitGroup(ply, damagePos)
    local boneDistances = {}
    
    local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
    if headBone then
        local headPos = ply:GetBonePosition(headBone) + Vector(0, 0, 3)
        boneDistances[HITGROUP_HEAD] = damagePos:DistToSqr(headPos)
    end
    
    local leftHandBone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
    local rightHandBone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
    
    if leftHandBone then
        local leftHandPos = ply:GetBonePosition(leftHandBone)
        boneDistances.HITGROUP_HAND = math.min(boneDistances.HITGROUP_HAND or math.huge, damagePos:DistToSqr(leftHandPos))
    end
    
    if rightHandBone then
        local rightHandPos = ply:GetBonePosition(rightHandBone)
        boneDistances.HITGROUP_HAND = math.min(boneDistances.HITGROUP_HAND or math.huge, damagePos:DistToSqr(rightHandPos))
    end
    
    local leftCalfBone = ply:LookupBone("ValveBiped.Bip01_L_Calf")
    local rightCalfBone = ply:LookupBone("ValveBiped.Bip01_R_Calf")
    
    if leftCalfBone then
        local leftCalfPos = ply:GetBonePosition(leftCalfBone)
        boneDistances[HITGROUP_LEFTLEG] = damagePos:DistToSqr(leftCalfPos)
    end
    
    if rightCalfBone then
        local rightCalfPos = ply:GetBonePosition(rightCalfBone)
        boneDistances[HITGROUP_RIGHTLEG] = damagePos:DistToSqr(rightCalfPos)
    end
    
    local pelvisBone = ply:LookupBone("ValveBiped.Bip01_Pelvis")
    if pelvisBone then
        local pelvisPos = ply:GetBonePosition(pelvisBone)
        boneDistances.HITGROUP_NUTS = damagePos:DistToSqr(pelvisPos)
    end
    
    local closestHitGroup = HITGROUP_GENERIC
    local minDistance = math.huge
    
    for hitgroup, distance in pairs(boneDistances) do
        local threshold = (hitgroup == HITGROUP_HEAD and 80) or
                         (hitgroup == HITGROUP_HAND and 100) or
                         (hitgroup == HITGROUP_LEFTLEG and 350) or
                         (hitgroup == HITGROUP_RIGHTLEG and 350) or
                         (hitgroup == HITGROUP_NUTS and 49) or math.huge
        
        if distance < minDistance and distance <= threshold then
            minDistance = distance
            closestHitGroup = hitgroup
        end
    end
    
    return closestHitGroup
end

local function NotifyDamage(ply, hitgroup)
    local hitgroupName = HITGROUP_NAMES[hitgroup]
    if hitgroupName then
        ply:Notify("hint", "Тебе попали в " .. hitgroupName)
    end
end

local function HandlePlayerDamage(ply, hitgroup, dmginfo)
    if not DAMAGE_CONFIG.ENABLED or IsPlayerImmune(ply) then return dmginfo end
    
    local damagePos = dmginfo:GetDamagePosition()
    local calculatedHitgroup = DetermineHitGroup(ply, damagePos)
    
    local damageScale = DAMAGE_CONFIG.DAMAGE_SCALE[calculatedHitgroup] or 1.0
    dmginfo:ScaleDamage(damageScale)
    
    if calculatedHitgroup == HITGROUP_LEFTARM or calculatedHitgroup == HITGROUP_RIGHTARM then
        DamageHands(ply, DAMAGE_CONFIG.DROP_CHANCE.ARM)
    elseif calculatedHitgroup == HITGROUP_LEFTLEG or calculatedHitgroup == HITGROUP_RIGHTLEG then
        BreakLeg(ply, 5)
    elseif calculatedHitgroup == HITGROUP_NUTS then
        BreakLeg(ply, 5)
    elseif calculatedHitgroup == HITGROUP_HAND then
        DamageHands(ply, DAMAGE_CONFIG.DROP_CHANCE.HAND)
    end
    
    NotifyDamage(ply, calculatedHitgroup)
    return dmginfo
end

local function HandleBleeding()
    for i = #bleedingPlayers, 1, -1 do
        local steamID = bleedingPlayers[i]
        local ply = player.GetBySteamID(steamID)
        
        if not IsValid(ply) then
            table.remove(bleedingPlayers, i)
            timer.Remove("bleeding_" .. steamID)
        elseif ply:Health() > DAMAGE_CONFIG.BLEEDING.HEALTH_THRESHOLD or not ply:Alive() or ply:IsGhost() then
            ply:MoveModifier("bleeding", nil)
            ply.bleeding = nil
            table.remove(bleedingPlayers, i)
            timer.Remove("bleeding_" .. steamID)
        end
    end
end

local function StartBleeding(ply)
    if ply.bleeding then return end
    
    local activeWeapon = ply:GetActiveWeapon()
    if IsValid(activeWeapon) and ply:HasWeapon(activeWeapon:GetClass()) and 
       not ALLOWED_HOLSTER_WEAPONS[activeWeapon:GetClass()] and 
       hook.Call("canDropWeapon", GAMEMODE or GM, ply, activeWeapon) then
        ply:dropDRPWeapon(activeWeapon)
    end
    
    ply:Notify("warning", "Ты при смерти. Если тебе не окажут помощь, ты погибнешь")
    ply.bleeding = true
    bleedingPlayers[#bleedingPlayers + 1] = ply:SteamID()
    
    ply:MoveModifier("bleeding", DAMAGE_CONFIG.BLEEDING.MOVE_PENALTY)
    
    timer.Create("bleeding_" .. ply:SteamID(), DAMAGE_CONFIG.BLEEDING.BLEED_INTERVAL, 0, function()
        if not IsValid(ply) then return end
        
        PlayPainSound(ply)
        
        if ply:Health() <= 1 then
            local bleedDmg = DamageInfo()
            bleedDmg:SetDamage(DAMAGE_CONFIG.BLEEDING.BLEED_DAMAGE)
            ply.attackedBy = ply.lastAttacker
            if ply.lastDMGT then
                bleedDmg:SetDamageType(ply.lastDMGT)
            end
            ply.weaponUsed = ply.lastWeapon
            ply:TakeDamageInfo(bleedDmg)
        else
            ply:SetHealth(ply:Health() - DAMAGE_CONFIG.BLEEDING.BLEED_DAMAGE)
        end
    end)
end

local function CheckForBleeding(ply, dmgInfo)
    if IsPlayerImmune(ply) or ply.bleeding then return end
    
    local remainingHealth = ply:Health() - dmgInfo:GetDamage()
    if remainingHealth > 0 and remainingHealth <= DAMAGE_CONFIG.BLEEDING.HEALTH_THRESHOLD then
        StartBleeding(ply)
    end
end

local function CantAction(ply)
    if ply.bleeding then return false, "Ты при смерти" end
end

hook.Add("Initialize", "dbg.enhanced_damage", function()
    timer.Create("damage.drown", 1, 0, HandleDrowning)
    
    timer.Create("dbg.damage.bleeding", 1, 0, HandleBleeding)
    
    hook.Add("ScalePlayerDamage", "dbg.enhanced_damage", HandlePlayerDamage)
    hook.Add("GetFallDamage", "dbg.enhanced_fall_damage", HandleFallDamage)
    hook.Add("EntityTakeDamage", "dbg.bleeding_check", CheckForBleeding)
    
    local restrictionHooks = {
        "octoinv.canPickup",
        "octoinv.canUse", 
        "PlayerSwitchWeapon",
        "CanPlayerEnterVehicle",
        "dbg-hands.canPunch",
        "dbg-hands.canCloseLockable",
        "dbg-hands.canOpenLockable",
        "dbg-hands.canDrag"
    }
    
    for _, hookName in ipairs(restrictionHooks) do
        hook.Add(hookName, "dbg.bleeding_restrictions", CantAction)
    end
    
    hook.Add("PlayerDisconnected", "dbg.bleeding_disconnect", function(ply)
        if ply.bleeding then
            local deathDmg = DamageInfo()
            deathDmg:SetDamage(ply:GetMaxHealth())
            ply.attackedBy = ply.lastAttacker
            if ply.lastDMGT then
                deathDmg:SetDamageType(ply.lastDMGT)
            end
            ply.weaponUsed = ply.lastWeapon
            ply:TakeDamageInfo(deathDmg)
            
            local steamID = ply:SteamID()
            timer.Remove("bleeding_" .. steamID)
            table.RemoveByValue(bleedingPlayers, steamID)
            
            if octodeath then
                octodeath.triggerDeath(ply)
            end
        end
    end)
end)

netstream.Hook("dbg-armor.unwear", function(ply)
    if not ply:Alive() then return end
    
    local armorData = ply.armorItem
    if not armorData then
        ply:Notify("warning", "У тебя нет надетого бронежилета")
        return
    end
    
    if armorData.armor ~= ply:Armor() then
        ply:Notify("warning", "Твой бронежилет поврежден")
        return
    end
    
    local inv = ply:GetInventory()
    local handContainer = inv and inv:GetContainer("_hand")
    if not handContainer then
        ply:Notify("warning", "Освободи руки, чтобы туда можно было положить бронежилет")
        return
    end
    
    if handContainer:AddItem("armor", armorData) >= 1 then
        ply:SetArmor(0)
        ply.armorItem = nil
        ply:SetLocalVar("armor", nil)
        ply:EmitSound("npc/combine_soldier/gear3.wav", 55)
    else
        ply:Notify("warning", "В руках недостаточно места")
    end
end)