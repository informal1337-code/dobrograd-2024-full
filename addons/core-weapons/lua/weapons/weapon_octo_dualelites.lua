--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_dualelites.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base						= "weapon_octo_base_pistol"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Dual Elites"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "elite.fire" )
SWEP.Primary.DistantSound 		= Sound( "elite.fire-distant" )
SWEP.Primary.Damage				= 25
SWEP.Primary.RPM				= 800
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 0.9
SWEP.Primary.KickDown			= 0.3
SWEP.Primary.KickHorizontal		= 1.4
SWEP.Primary.Spread 			= 0.06

SWEP.WorldModel					= "models/weapons/w_pist_elite.mdl"

SWEP.ActiveHoldType			 = "duel"
SWEP.ReloadTime 				= 2.5

SWEP.AimPos = Vector(-10.5, -2.85, 4.5)
SWEP.AimAng = Angle(0, 11, 0)

SWEP.Icons = octolib.icons.color('weapon_dual_elite')
