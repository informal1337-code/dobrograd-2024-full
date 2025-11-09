--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_air_scout.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base						= "weapon_octo_base_sniper"
SWEP.Category					= L.dobrograd .. ' - Страйкбольное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Страйкбольный Scout"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.Ammo				= "air"
SWEP.Primary.Damage				= 0
SWEP.Primary.RPM				= 60
SWEP.Primary.ClipSize			= 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp				= 3.35
SWEP.Primary.KickDown			= 0.6
SWEP.Primary.KickHorizontal		= 0.01
SWEP.Primary.Spread				= 0
SWEP.ReloadTime						= 2.2
SWEP.CanScare						= false
SWEP.IsLethal						= false -- shouldn't take karma whet shots fired

SWEP.WorldModel					= "models/weapons/w_snip_scout.mdl"
SWEP.AimPos = Vector(-0.5, -0.98, 5.8)
SWEP.AimAng = Angle(-9, 0, 0)
SWEP.SightPos = Vector(1.6, -0.99, 6.17)
SWEP.SightAng = Angle(0, -90, 100)
SWEP.SightSize = 1.3
SWEP.SightFOV = 10
SWEP.SightZNear = 12

SWEP.Icon = octolib.icons.color('weapon_scout')