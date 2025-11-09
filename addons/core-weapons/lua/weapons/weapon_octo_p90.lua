--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_p90.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base						= "weapon_octo_base_smg"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "P90"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "p90.fire" )
SWEP.Primary.DistantSound 		= Sound( "p90.fire-distant" )
SWEP.Primary.Damage				= 18
SWEP.Primary.RPM				= 970
SWEP.Primary.ClipSize			= 50
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0.3
SWEP.Primary.KickDown		   = 0.45
SWEP.Primary.KickHorizontal	 = 0.49


SWEP.WorldModel					= "models/weapons/w_smg_p90.mdl"
SWEP.MuzzlePos = Vector(12, -0.35, 6)
SWEP.MuzzleAng = Angle(-3, 2.2, 0)
SWEP.AimPos = Vector(-7, -1.03, 10.15)
SWEP.AimAng = Angle(-3, 2.2, 0)

SWEP.ActiveHoldType			 = "smg"

SWEP.Icon = octolib.icons.color('weapon_p90')
