--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_air_aug.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base						= "weapon_octo_base_zoom"
SWEP.Category					= L.dobrograd .. ' - Страйкбольное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Страйкбольный AUG"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo				= "air"
SWEP.Primary.Damage			= 0
SWEP.Primary.RPM				= 720
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0
SWEP.Primary.KickDown		   = 0.52
SWEP.Primary.KickHorizontal	 = 0.25
SWEP.Primary.Spread				= 0

SWEP.CanScare					= false
SWEP.IsLethal					= false
SWEP.ReloadTime 				= 2.2
SWEP.WorldModel					= "models/weapons/w_rif_aug.mdl"
SWEP.AimPos = Vector(-5, -0.68, 5.5)
SWEP.AimAng = Angle(-8, 0, 0)
SWEP.SightPos = Vector(-3.2, -0.67, 5.87)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1
SWEP.SightFOV = 18

SWEP.Icon = octolib.icons.color('weapon_aug')