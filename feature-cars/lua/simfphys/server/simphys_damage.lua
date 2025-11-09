local DAMAGE_COOLDOWN = 0.5     -- Задержка между ударами (секунды)
local DAMAGE_MULTIPLIER = 0.15  -- Множитель от скорости
local MASS_MULTIPLIER = 0.02    -- Множитель от массы авто
local MIN_SPEED = 200           -- Минимальная скорость для урона
local SHAKE_POWER = 8           -- Сила тряски экрана

local lastDamage = {}

local function IsInVehicle(target, vehicle)
    -- Проверка водителя
    if vehicle:GetDriver() == target then return true end
    
    -- Проверка пассажиров через сиденья simfphys
    if vehicle.pSeat then
        for _, seat in pairs(vehicle.pSeat) do
            if IsValid(seat) and seat:GetDriver() == target then
                return true
            end
        end
    end
    
    return false
end

hook.Add("PhysicsCollide", "SimphysPlayerDamage", function(ent, data)
    if ent:GetClass() ~= "simfphys_vehicle" then return end
    
    local hit_entity = data.HitEntity
    if not IsValid(hit_entity) or not hit_entity:IsPlayer() or not hit_entity:Alive() then return end
    
    -- Игнорируем водителя и пассажиров
    if IsInVehicle(hit_entity, ent) then return end
    
    -- Фильтр мелких столкновений
    local speed = data.Speed
    if speed < MIN_SPEED then return end
    
    -- Защита от спама уроном
    local key = ent:EntIndex() .. "|" .. hit_entity:EntIndex()
    if lastDamage[key] and CurTime() - lastDamage[key] < DAMAGE_COOLDOWN then return end
    
    -- Расчёт урона
    local phys = ent:GetPhysicsObject()
    local damage = (speed * DAMAGE_MULTIPLIER) + (IsValid(phys) and phys:GetMass() * MASS_MULTIPLIER or 0)
    
    -- Применение урона
    hit_entity:TakeDamage(math.Round(damage), ent, ent)
    
    -- Эффекты
    hit_entity:EmitSound("physics/body/body_medium_impact_hard" .. math.random(6) .. ".wav")
    util.ScreenShake(hit_entity:GetPos(), SHAKE_POWER, SHAKE_POWER, 0.5, 500)
    
    -- Обновление таймера
    lastDamage[key] = CurTime()
end)

-- Чистка старых записей каждые 5 минут
timer.Create("DamageTableCleanup", 300, 0, function()
    local cutoff = CurTime() - 600 -- Удаляем записи старше 10 минут
    for k,v in pairs(lastDamage) do
        if v < cutoff then
            lastDamage[k] = nil
        end
    end
end)