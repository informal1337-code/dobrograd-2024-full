--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-characters/lua/cmenu/properties/char.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

properties.Add('demote', {
	MenuLabel = L.c_language_demote,
	Order = 3,
	MenuIcon = octolib.icons.silk16('user_delete'),
	Filter = function(self, ent, ply)
		return IsValid(ent) and ent:IsPlayer()
		and not ent:IsGhost() and not ply:IsGhost()
	end,
	Action = function(self, ent)
		Derma_StringRequest(L.c_language_demote, L.c_language_demote_description, nil, function(a)
			octochat.say('/demote', ent:UserID(), a)
		end)
	end
})
