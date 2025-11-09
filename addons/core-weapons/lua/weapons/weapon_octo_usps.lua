--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_usps.lua
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
SWEP.PrintName						= "USP-S"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Sound 				= Sound( "usps.fire" )
SWEP.Primary.DistantSound 		= Sound( "usps.fire-distant" )
SWEP.Primary.Damage				= 21
SWEP.Primary.RPM				= 825
SWEP.Primary.ClipSize			= 12
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 1.7
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03

SWEP.WorldModel					= "models/weapons/w_pist_usp_silencer.mdl"
SWEP.AimPos = Vector(-10.5, -1.13, 4.05)
SWEP.AimAng = Angle(-2, 5, 0)

SWEP.NoMuzzleflash = true

SWEP.Icon = octolib.icons.color('weapon_usp_s')
