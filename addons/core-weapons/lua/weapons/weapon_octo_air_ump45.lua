--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_air_ump45.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base						= "weapon_octo_base_air"
SWEP.Category					= L.dobrograd .. ' - Страйкбольное'
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Страйкбольный UMP45"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.RPM				= 600
SWEP.Primary.ClipSize			= 25
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0.1
SWEP.Primary.KickDown		   = 0.072
SWEP.Primary.KickHorizontal	 = 1

SWEP.WorldModel					= "models/weapons/w_smg_ump45.mdl"
SWEP.MuzzlePos = Vector(12, -0.9, 7)
SWEP.MuzzleAng = Angle(-9.5, 0, 0)
SWEP.AimPos = Vector(-7, -0.8, 5.4)
SWEP.AimAng = Angle(-9.5, 0, 0)

SWEP.ActiveHoldType			 = "smg"

SWEP.Icon = octolib.icons.color('weapon_ump45')
