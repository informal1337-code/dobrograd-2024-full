--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/_config/lua/config/octomap/markers.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

function octomap.sidebarMarkerClick(self, map)

	if not map.GetMarkerLine then return end

	local line = map:GetMarkerLine(self)
	if not IsValid(line) then return end

	line:GetListView():OnClickLine(line, true)
	line:OnSelect()

end

hook.Add('Think', 'octomap.addMarkers', function()

	hook.Remove('Think', 'octomap.addMarkers')

	for i, v in ipairs(octomap.config.markers or {}) do
		if istable(v.pos) then
			for i2, pos in ipairs(v.pos) do
				local m = octomap.createMarker('dbg' .. i .. '_' .. i2)
					:SetIcon(v.icon)
					:SetPos(pos)
					:SetClickable(true)
					:AddToSidebar(v.name, 'dbg' .. i)

				m.sort = v.sort
				m.LeftClick = octomap.sidebarMarkerClick
			end
		else
			local m = octomap.createMarker('dbg' .. i)
				:SetIcon(v.icon)
				:SetPos(v.pos)
				:SetClickable(true)
				:AddToSidebar(v.name)

			m.sort = v.sort
			m.LeftClick = octomap.sidebarMarkerClick
		end
	end

	local ply = octomap.createMarker('__me')
		:SetIcon('octoteam/icons-16/bullet_red.png')
		:AddToSidebar('Ты')

	ply.sort = -1000

	local lp = LocalPlayer()
	function ply:Paint(x, y, map)

		local scale = map.scale
		self:SetPos(lp:GetPos())

		local p = {
			{ x = 0, y = 0 },
			{ x = 100 * scale, y = -50 * scale },
			{ x = 100 * scale, y = 50 * scale },
		}

		octolib.poly.rotate(p, -lp:GetAngles().y)
		octolib.poly.translate(p, x, y)

		draw.NoTexture()
		surface.SetDrawColor(0,0,0, 50)
		surface.DrawPoly(p)

		octomap.metaMarker.Paint(self, x, y, scale)

	end

end)
