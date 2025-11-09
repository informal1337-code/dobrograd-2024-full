--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_galil.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base						= "weapon_octo_base_rifle"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Galil"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "galil.fire" )
SWEP.Primary.DistantSound 		= Sound( "galil.fire-distant" )
SWEP.Primary.Damage				= 20
SWEP.Primary.RPM				= 750
SWEP.Primary.ClipSize			= 25
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 0
SWEP.Primary.KickDown			= 1.27
SWEP.Primary.KickHorizontal		= 0.8

SWEP.WorldModel					= "models/weapons/w_rif_galil.mdl"
SWEP.MuzzlePos = Vector(25, -1, 8.2)
SWEP.MuzzleAng = Angle(-10, 0, 0)
SWEP.AimPos = Vector(-4, -0.75, 5.6)
SWEP.AimAng = Angle(-10, 0, 0)

SWEP.Icon = octolib.icons.color('weapon_galil')
