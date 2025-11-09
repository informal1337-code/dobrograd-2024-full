--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_pan.lua
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
SWEP.PrintName			= L.pan

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo		= 'blunt'
SWEP.HitDistance		= 40
SWEP.HitInclination	= 0.2
SWEP.HitPushback		= 300
SWEP.HitRate			= 1
SWEP.Damage				= {12, 18}
SWEP.ScareMultiplier	= 0.5

SWEP.SwingSound		= Sound('WeaponFrag.Roll')
SWEP.HitSoundWorld	= Sound('Metal_Box.ImpactHard')
SWEP.HitSoundBody		= Sound('Flesh.ImpactHard')

SWEP.Icon				= 'octoteam/icons/pan.png'
SWEP.ViewModel			= Model('models/weapons/HL2meleepack/v_pan.mdl')
SWEP.WorldModel		= Model('models/weapons/HL2meleepack/w_pan.mdl')
SWEP.ActiveHoldType	= 'melee'
