--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_m4a1.lua
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
SWEP.PrintName						= "M4A1"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "m4a1.fire" )
SWEP.Primary.DistantSound 		= Sound( "m4a1.fire-distant" )
SWEP.Primary.Damage				= 27
SWEP.Primary.RPM				= 750
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 0.66
SWEP.Primary.KickHorizontal	 = 0.64

SWEP.WorldModel					= "models/weapons/w_rif_m4a1.mdl"
SWEP.AimPos = Vector(-8, -0.97, 5.9)
SWEP.AimAng = Angle(-9, 0, 0)

SWEP.Icon = octolib.icons.color('weapon_m4a1')
