--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_tmp.lua
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
SWEP.PrintName						= "TMP"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "tmp.fire" )
SWEP.Primary.DistantSound 		= Sound( "tmp.fire-distant" )
SWEP.Primary.Damage				= 19
SWEP.Primary.RPM				= 980
SWEP.Primary.ClipSize			= 20
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0.05
SWEP.Primary.KickDown		   = 0.4
SWEP.Primary.KickHorizontal	 = 1.3

SWEP.WorldModel					= "models/weapons/w_smg_tmp.mdl"
SWEP.MuzzlePos = Vector(20, -0.5, 7)
SWEP.MuzzleAng = Angle(-9, 1, 0)
SWEP.AimPos = Vector(-8, -1.04, 3.8)
SWEP.AimAng = Angle(-9, 1, 0)

SWEP.Icon = octolib.icons.color('weapon_tmp')
