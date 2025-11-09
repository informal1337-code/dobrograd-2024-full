--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_m249.lua
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
SWEP.PrintName						= "M249"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "m249.fire" )
SWEP.Primary.DistantSound 		= Sound( "m249.fire-distant" )
SWEP.Primary.Damage				= 32
SWEP.Primary.RPM				= 650
SWEP.Primary.ClipSize			= 60
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 1
SWEP.Primary.KickHorizontal	 = 1.04
SWEP.Primary.Spread			 = 0.04

SWEP.WorldModel					= "models/weapons/w_mach_m249para.mdl"
SWEP.AimPos = Vector(-6, -0.82, 6.4)
SWEP.AimAng = Angle(-9, 0, 0)

SWEP.MuzzlePos = Vector(25, -1, 10)
SWEP.MuzzleAng = Angle(-10, 0, 0)

SWEP.Icon = octolib.icons.color('weapon_m249')
