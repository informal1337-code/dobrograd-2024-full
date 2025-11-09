--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-octolib/lua/octolib/vgui/dactionnotice.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local PANEL = {}

function PANEL:Init()
	self:Dock(TOP)
	self:DockPadding(5, 5, 5, 5)
	self:SetTall(40)

	local icon = self:Add 'DImageButton'
	icon:Dock(LEFT)
	icon:DockMargin(5, 0, 5, 0)
	icon:SetMouseInputEnabled(false)
	icon:SetStretchToFit(false)
	self.icon = icon

	local buttonPanel = self:Add 'DPanel'
	buttonPanel:Dock(RIGHT)
	buttonPanel:SetPaintBackground(false)
	buttonPanel:SetVisible(false)
	self.buttonPanel = buttonPanel

	local button = octolib.button(buttonPanel, '', octolib.func.zero)
	button:Dock(NODOCK)
	self.button = button

	local label = octolib.label(self, '')
	label:Dock(FILL)
	label:DockMargin(5, 0, 0, 0)
	label:SetWrap(true)
	label:SetVisible(false)
	self.label = label
end

function PANEL:PerformLayout(w, h)
	self.button:CenterVertical()
	self.button:SizeToContentsX(12)
	self.buttonPanel:SetWide(self.button:GetWide())
end

function PANEL:SetIcon(icon)
	if not icon then
		self.icon:SetVisible(false)
		return
	end

	self.icon:SetVisible(true)
	self.icon:SetImage(icon:find('/') and icon or octolib.icons.silk16(icon))
end

function PANEL:SetButton(txt, click)
	self.buttonPanel:SetVisible(true)
	self.button:SetText(txt)
	self.button.DoClick = click
end

function PANEL:SetText(text)
	self.label:SetVisible(true)
	self.label:SetText(text)
end

vgui.Register('DActionNotice', PANEL, 'DPanel')
