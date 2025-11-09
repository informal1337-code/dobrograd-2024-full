--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-weapons/lua/weapons/weapon_octo_beanbag.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

SWEP.Base						= "weapon_octo_base_air"
SWEP.Category					= L.dobrograd
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.PrintName						= "Bean Bag"

if SERVER then
	AddCSLuaFile()
end

SWEP.Primary.Sound 				= Sound( "beanbag.fire" )
SWEP.Primary.Automatic		= false
SWEP.Primary.Damage				= 1
SWEP.Primary.RPM				= 70
SWEP.Primary.ClipSize			= 4
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp			 = 5.28
SWEP.Primary.KickDown		   = 0.3
SWEP.Primary.KickHorizontal	 = 0.03
SWEP.Primary.Spread			 = 0
SWEP.Primary.Distance			= 850

SWEP.WorldModel					= "models/weapons/w_shot_m3super90_beanbag.mdl"
SWEP.AimPos = Vector(-5, -0.94, 4.6)
SWEP.AimAng = Angle(-9, 0, 0)

SWEP.Primary.NumShots			= 1
SWEP.Icon = "octoteam/icons/gun_shotgun.png"

SWEP.CanScare						= true
SWEP.IsLethal						= true
SWEP.WaveOnShot						= false

if SERVER then
	function SWEP:BulletHitCallback(trace, bullet)
		local ent = trace.Entity
		if not IsValid(ent) or not ent:IsPlayer() then return end
		ent.beanbagEffect = (ent.beanbagEffect or 0) + 1

		if ent.beanbagEffect == 1 then
			ent:MoveModifier('stunstick', {
				walkmul = 0.1,
				norun = true,
				nojump = true,
			})
			timer.Create('stunstick' .. ent:EntIndex(), 5, 1, function()
				if not IsValid(ent) then return end
				ent:MoveModifier('stunstick', nil)
			end)
		elseif ent.beanbagEffect == 2 then
			dbgDamage.damageHands(ent, 100, self:GetOwner())
		else
			dbgDamage.startDying(ent)
		end
		
	end


	timer.Create('dbg-weps.resetEffects', 60, 0, function()
		for _, v in ipairs(player.GetAll()) do
			if v.beanbagEffect then
				v.beanbagEffect = v.beanbagEffect - 1
				if v.beanbagEffect <= 0 then
					v.beanbagEffect = nil
				end
			end
		end
	end)

end
