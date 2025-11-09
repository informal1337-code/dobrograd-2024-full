--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_air_p228.lua
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
SWEP.PrintName						= "Страйкбольный P228"

if SERVER then

	AddCSLuaFile()

end

SWEP.Primary.RPM				= 400
SWEP.Primary.ClipSize			= 15
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 0.47
SWEP.Primary.KickDown		   = 0.15
SWEP.Primary.KickHorizontal	 = 0.01

SWEP.Primary.Automatic			= false

SWEP.PassiveHoldType 			= "normal"
SWEP.ActiveHoldType 			= "revolver"
SWEP.ReloadTime 				= 1.1

SWEP.WorldModel					= "models/weapons/w_pist_p228.mdl"
SWEP.AimPos = Vector(-10.5, -1.16, 4.15)
SWEP.AimAng = Angle(-2, 5, 0)
SWEP.Icon = octolib.icons.color('weapon_p228')
