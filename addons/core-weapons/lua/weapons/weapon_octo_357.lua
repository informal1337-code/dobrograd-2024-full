--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_357.lua
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
SWEP.PrintName						= "Colt .357"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound("revolver.fire")
SWEP.Primary.DistantSound 		= Sound("revolver.fire-distant")
SWEP.Primary.Damage				= 34
SWEP.Primary.RPM				= 300
SWEP.Primary.ClipSize			= 6
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 3.24
SWEP.Primary.KickDown			= 0.72
SWEP.Primary.KickHorizontal		= 0.02

SWEP.WorldModel					= "models/weapons/w_357.mdl"
SWEP.MuzzlePos = Vector(12, -0.8, 4.7)
SWEP.MuzzleAng = Angle(-4, -0.5, 4)
SWEP.AimPos = Vector(-10.5, -0.79, 4.6)
SWEP.AimAng = Angle(-4, -0.5, 4)
