--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_bottle_broken.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base				= 'weapon_octo_base_cold'
SWEP.Category			= L.dobrograd .. ' - Холодное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable	= false
SWEP.PrintName			= 'Разбитая бутылка'

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'sharp'
SWEP.HitDistance		= 32
SWEP.HitInclination	= 0.2
SWEP.HitPushback		= 0
SWEP.HitRate			= 0.40
SWEP.Damage				= {5, 15}
SWEP.ScareMultiplier	= 0.4

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('GlassBottle.ImpactHard')
SWEP.HitSoundBody		= Sound('Flesh_Bloody.ImpactHard')

SWEP.Icon				= 'octoteam/icons/bottle_broken.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_brokenbottle.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_brokenbottle.mdl')
SWEP.ActiveHoldType	= 'knife'
SWEP.TrajectoryType = 'point'

function SWEP:GetDamage(tr)
	local ent = tr.Entity
	if not (IsValid(ent) and ent:IsPlayer()) then return end
	local limit = math.max(self.Owner:HasBuff('Meth') and 100 or (ent:Health() - 20), 0)
	return math.min(limit, math.random(unpack(self.Damage))) -- do not kill him
end
