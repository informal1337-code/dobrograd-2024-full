--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_awp.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base						= "weapon_octo_base_sniper"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "AWP"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "awp.fire" )
SWEP.Primary.DistantSound 		= Sound( "awp.fire-distant" )
SWEP.Primary.Damage				= 50
SWEP.Primary.RPM				= 50
SWEP.Primary.ClipSize			= 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 6.7
SWEP.Primary.KickDown			= 1.2
SWEP.Primary.KickHorizontal		= 0.02
SWEP.Primary.Spread				= 0
SWEP.ZoomAmount = 50

SWEP.WorldModel					= "models/weapons/w_snip_awp.mdl"
SWEP.AimPos = Vector(-3, -0.8, 6.5)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(-0.52, -0.78, 6.88)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.6
SWEP.SightFOV = 10
SWEP.SightZNear = 12

SWEP.Icon = octolib.icons.color('weapon_awp')
