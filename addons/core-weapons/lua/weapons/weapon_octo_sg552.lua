--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_sg552.lua
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
SWEP.PrintName						= "SG552"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "sg552.fire" )
SWEP.Primary.DistantSound 		= Sound( "sg552.fire-distant" )
SWEP.Primary.Damage				= 28
SWEP.Primary.RPM				= 690
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 0.55
SWEP.Primary.KickHorizontal	 = 0.9
SWEP.Primary.Spread				= 0

SWEP.WorldModel					= "models/weapons/w_rif_sg552.mdl"
SWEP.AimPos = Vector(-4, -0.89, 5.6)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(-0.8, -0.89, 6.2)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.4
SWEP.SightFOV = 18

SWEP.Icon = octolib.icons.color('weapon_sg552')
