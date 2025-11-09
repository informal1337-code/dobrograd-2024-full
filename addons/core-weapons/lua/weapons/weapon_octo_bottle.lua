--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_bottle.lua
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
SWEP.PrintName			= 'Бутылка'

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'sharp'
SWEP.HitDistance		= 35
SWEP.HitInclination	= 0.2
SWEP.HitPushback		= 100
SWEP.HitRate			= 0.50
SWEP.Damage				= {2, 8}
SWEP.ScareMultiplier	= 0.2

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('GlassBottle.Break')
SWEP.HitSoundBody		= Sound('GlassBottle.Break')

SWEP.Icon				= 'octoteam/icons/bottle_empty.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_bottle.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_bottle.mdl')
SWEP.ActiveHoldType	= 'melee'

function SWEP:OnBulletShot()
	if SERVER then
		self:Remove()
		self.Owner:Give('weapon_octo_bottle_broken')
		self.Owner:SelectWeapon('weapon_octo_bottle_broken')
	end
end
