--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_deagle.lua
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
SWEP.PrintName						= "Desert Eagle"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "deagle.fire" )
SWEP.Primary.DistantSound 		= Sound( "deagle.fire-distant" )
SWEP.Primary.Damage				= 35
SWEP.Primary.RPM				= 300
SWEP.Primary.ClipSize			= 7
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 3.24
SWEP.Primary.KickDown			= 0.72
SWEP.Primary.KickHorizontal		= 0.01

SWEP.WorldModel					= "models/weapons/w_pist_deagle.mdl"
SWEP.AimPos = Vector(-10.5, -1.28, 4.5)
SWEP.AimAng = Angle(-2, 5, 0)

SWEP.Icon = octolib.icons.color('weapon_deagle')
