--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-octogui/lua/octogui/settings.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

octogui.settings = octogui.settings or {}

local function binder(parent, data)

	local cv = GetConVar(data[2])

	local p = parent:Add 'DPanel'
	p:SetSize(400, 40)

	local b = p:Add 'DBinder'
	b:Dock(RIGHT)
	b:SetWide(80)
	b:SetValue(cv:GetInt() or data[1])
	function b:SetSelectedNumber(num)
		self.m_iSelectedNumber = num
		self:ConVarChanged(num)
		self:UpdateText()
		self:OnChange(num)
		cv:SetInt(num)
	end

	local l = p:Add 'DLabel'
	l:Dock(FILL)
	l:DockMargin(8, 0, 0, 0)
	l:SetContentAlignment(4)
	l:SetText(data[4])

	function p:Reset()
		b:SetValue(data[1])
	end

	return p

end

local function paintIconInCenter(self, w, h)
	local mat = self:GetMaterial()
	local matW, matH = mat:Width(), mat:Height()
	surface.SetMaterial(mat)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect((w-matW) / 2, (h-matH) / 2, matW, matH)
end

-- FANCY CHECKBOX WITH DESCRIPTION
local function cbLayout(self)
	local x = self.m_iIndent or 0
	self.Button:SetSize(15, 15)
	self.Button:SetPos(x, math.floor((self:GetTall() - self.Button:GetTall()) / 2))
	self.Label:SizeToContents()
	self.Label:SetPos(x + self.Button:GetWide() + 9, math.floor((self:GetTall() - self.Label:GetTall()) / 2) - 1)
end
local function sizeToContents(self)
	self:SizeToChildren(false, true)
end
local function fancifyCheckbox(p, cb, desc)
	local cont = p:Add 'DPanel'
	cont:Dock(TOP)
	cont:SetPaintBackground(false)
	cont:DockMargin(0, 8, 0, 8)
	cont.PerformLayout = sizeToContents

	cb:SetParent(cont)
	cb.PerformLayout = cbLayout
	cb:InvalidateLayout(true)
	if not desc then return cb end

	local lbl = octolib.label(cont, desc)
	lbl:DockMargin(28, -5, 0, 7)
	lbl:SetMultiline(true)
	lbl:SetWrap(true)
	lbl:SetAutoStretchVertical(true)
	lbl:SetAlpha(100)

	return cb
end
local function fancyCheckbox(p, title, desc)
	return fancifyCheckbox(p, octolib.checkBox(p, title), desc)
end
local function fancyVarCheckbox(p, var, title, desc)
	return fancifyCheckbox(p, octolib.vars.checkBox(p, var, title), desc)
end

-- FANCY NUMSLIDER WITH DESCRIPTION
local function slider_pl(self)
	self.Label:SetWide(15)
end
local function fancyNumSlider(p, title, desc, min, max, prc)
	local cont = p:Add 'DPanel'
	cont:Dock(TOP)
	cont:SetPaintBackground(false)
	cont:DockMargin(0, 8, 0, 8)
	cont.PerformLayout = sizeToContents

	local t = octolib.label(cont, title)
	t:SetAutoStretchVertical(true)
	if desc then
		local d = octolib.label(cont, desc)
		d:SetMultiline(true)
		d:SetWrap(true)
		d:SetAlpha(100)
		d:DockMargin(5, 3, 0, 5)
		d:SetAutoStretchVertical(true)
	end

	local sl = octolib.slider(cont, '↔', min, max, prc)
	sl:DockMargin(0, -7, 0, 0)
	sl.PerformLayout = slider_pl

	return sl
end

function octogui.settings.createPanel()
	local container = vgui.Create 'DPanel'
	container:SetPaintBackground(false)

	local function performLayout(self)
		self:SizeToChildren(false, true)
	end
local function title(p, txt)
    if not IsValid(p) then return end
    
    local l = vgui.Create('DLabel')
    l:SetParent(p)
    l:Dock(TOP)
    l:DockMargin(0,5,0,15)
    l:SetTall(32)
    l:SetText(txt)
    l:SetContentAlignment(5)
    l:SetFont('f4.medium')
    return l
end
	local function childPanel(p)
		local cp = p:Add 'DPanel'
		cp:Dock(TOP)
		cp:DockMargin(0, 0, 0, 5)
		cp:DockPadding(5, 5, 5, 10)
		cp.PerformLayout = performLayout
		return cp
	end

	local menuList = container:Add 'DListView'
	menuList:Dock(LEFT)
	menuList:SetWide(150)
	menuList:AddColumn('Icon'):SetFixedWidth(48)
	menuList:AddColumn('Name')
	menuList:SetHideHeaders(true)
	menuList:SetDataHeight(42)
	menuList:DockMargin(2, 7, 0, 3)
	menuList:SetMultiSelect(false)

	local scrollPanel
	function menuList:OnRowSelected(_, row)
		if IsValid(scrollPanel) then
			scrollPanel:Remove()
		end
		scrollPanel = container:Add 'DScrollPanel'
		scrollPanel:Dock(FILL)
		scrollPanel:DockMargin(5, 3, 5, 0)
		scrollPanel.pnlCanvas:DockPadding(20, 5, 25, 20)
		title(scrollPanel, row:GetColumnText(2))

		local tab = row.build(scrollPanel)
		if IsValid(tab) then
			scrollPanel:Remove()
			tab:SetParent(container)
			tab:Dock(FILL)
			container:DockMargin(15, 5, 5, 5)
			scrollPanel = tab
		end
	end

	local function addCategory(name, icon, build)
		local iconPnl = vgui.Create 'DImage'
		iconPnl:SetImage(octolib.icons.silk32(icon))
		iconPnl.Paint = paintIconInCenter

		local row = menuList:AddLine(iconPnl, name)
		row.build = build
	end

	local tabs = {}
	hook.Run('octolib.settings.createTabs', function(tab)
		tabs[#tabs + 1] = tab
	end, {
		title = title,
		childPanel = childPanel,
		binder = binder,
		fancyCheckbox = fancyCheckbox,
		fancyVarCheckbox = fancyVarCheckbox,
		fancyNumSlider = fancyNumSlider,
	})

	for _, tab in SortedPairsByMemberValue(tabs, 'order') do
		addCategory(tab.name, tab.icon, tab.build)
	end

	menuList:SelectFirstItem()
	return container
end

hook.Add('octogui.f4-tabs', 'settings', function()
	octogui.f4.addButton({
		id = 'settings',
		name = L.settings,
		order = 14,
		icon = Material('octoteam/icons/cog.png'),
		build = function(f)
			f:SetSize(650, 500)
			f:DockPadding(0, 21, 0, 0)

			local settingsPanel = octogui.settings.createPanel()
			settingsPanel:SetParent(f)
			settingsPanel:Dock(FILL)
		end,
	})
end)
