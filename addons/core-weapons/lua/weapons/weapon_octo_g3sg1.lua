--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_g3sg1.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base						= "weapon_octo_base_zoom"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "G3SG1"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "g3sg1.fire" )
SWEP.Primary.DistantSound 		= Sound( "g3sg1.fire-distant" )
SWEP.Primary.Damage				= 35
SWEP.Primary.RPM				= 450
SWEP.Primary.ClipSize			= 20
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 2
SWEP.Primary.KickDown			= 0.3
SWEP.Primary.KickHorizontal		= 0.03
SWEP.Primary.Spread				= 0

SWEP.WorldModel					= "models/weapons/w_snip_g3sg1.mdl"
SWEP.AimPos = Vector(-6.2, -0.94, 6.7)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(-3.6, -0.94, 6.98)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.6
SWEP.SightFOV = 12

SWEP.Icon = octolib.icons.color('weapon_g3sg1')
