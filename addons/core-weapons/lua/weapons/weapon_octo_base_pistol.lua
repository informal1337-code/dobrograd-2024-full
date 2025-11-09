--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_base_pistol.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if SERVER then

	AddCSLuaFile()

end

SWEP.Base						= "weapon_octo_base"
SWEP.WeaponCategory				= "pistol"

SWEP.Primary.Ammo				= "pistol"
SWEP.Primary.Automatic			= false

SWEP.PassiveHoldType 			= "normal"
SWEP.ActiveHoldType 			= "revolver"
SWEP.HasFlashlight 				= true
SWEP.IsLightweight				= true

SWEP.ReloadTime 				= 2.5
SWEP.Icon = 'octoteam/icons/gun_pistol.png'
