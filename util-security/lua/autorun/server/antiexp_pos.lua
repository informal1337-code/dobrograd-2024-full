local entMeta = FindMetaTable('Entity')
local phyMeta = FindMetaTable('PhysObj')

entMeta.SetRealPos = entMeta.SetRealPos or entMeta.SetPos
phyMeta.SetRealPos = phyMeta.SetRealPos or phyMeta.SetPos

local abs = math.abs

local function setPos(obj, pos)
    -- Ensure 'pos' is a valid Vector
    if not pos or type(pos) ~= "Vector" then
        ErrorNoHalt("Invalid position passed to SetPos! Defaulting to Vector(0, 0, 0).\n")
        pos = Vector(0, 0, 0)
    end

    -- Check for extreme coordinates and clamp them
    if abs(pos.x) > 50000 or abs(pos.y) > 50000 or abs(pos.z) > 50000 then
        ErrorNoHalt("Position exceeds allowed limits! Clamping to Vector(0, 0, 0).\n")
        pos = Vector(0, 0, 0)
    end

    -- Call the original SetPos method
    obj:SetRealPos(pos)
end

-- Override SetPos for Entity and PhysObj
entMeta.SetPos = setPos
phyMeta.SetPos = setPos