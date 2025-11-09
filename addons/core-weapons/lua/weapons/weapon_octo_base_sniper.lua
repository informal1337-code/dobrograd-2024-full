--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_base_sniper.lua
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

game.AddAmmoType({
	name = "sniper",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	force = 2000,
})

SWEP.Base						= "weapon_octo_base"
SWEP.WeaponCategory				= "sniper"

SWEP.Primary.Ammo				= "sniper"
SWEP.Primary.Automatic			= true

SWEP.PassiveHoldType 			= "passive"
SWEP.ActiveHoldType 			= "ar2"
SWEP.HasFlashlight 			= true
SWEP.HasZoom			= true

SWEP.ReloadTime 				= 3
SWEP.Icon = 'octoteam/icons/gun_sniper.png'

-- local mat = Material("overlays/scope_lens")
-- hook.Add( "HUDPaint", "octoweapons", function()
-- 	local wep = LocalPlayer():GetActiveWeapon()
-- 	if IsValid(wep) and wep.WeaponCategory == "sniper" then
-- 		local curfov = math.Round( LocalPlayer():GetFOV() )
-- 		local perc = (defaultfov - curfov) / 60
-- 		if perc ~= 0 then
-- 			surface.SetDrawColor( 255,255,255, perc*180 )
-- 			surface.SetMaterial( mat )
-- 			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
-- 		end
-- 	end
-- end)

-- hook.Add( "PreDrawHUD", "octoweapons", function()
-- 	local wep = LocalPlayer():GetActiveWeapon()
-- 	if IsValid(wep) and wep.WeaponCategory == "sniper" then
-- 		local curfov = math.Round( LocalPlayer():GetFOV() )
-- 		local perc = (defaultfov - curfov) / 60
-- 		if perc ~= 0 then
-- 			DrawToyTown( 4 * perc, ScrH() / 2 )
-- 		end
-- 	end
-- end)
