-- "addons\\core-octolib\\lua\\octolib\\modules\\bind\\vgui\\octolib_bind_row.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

function PANEL:Init()

	self:Dock(TOP)
	self:SetTall(31)
	self:DockMargin(0, 0, 0, 5)

	local top = self:Add 'DPanel'
	top:Dock(TOP)
	top:DockMargin(3, 3, 3, 3)
	top:SetTall(25)
	top:SetPaintBackground(false)

	local cb = octolib.comboBox(top, nil, {
		{'При нажатии', 'down', true},
		{'При отжатии', 'up'},
		{'Удерживание', 'downUp'},
	})
	cb:Dock(LEFT)
	cb:DockMargin(0, 0, 3, 0)
	cb:SetWide(100)
	function cb:OnSelect() end
	self.on = cb

	local b = top:Add 'DBinder'
	b:Dock(LEFT)
	b:DockMargin(0, 0, 3, 0)
	b:SetWide(50)
	function b:SetSelectedNumber(but)
		self.m_iSelectedNumber = but
		self:UpdateText()
	end
	self.binder = b

	local del = top:Add 'DImageButton'
	del:Dock(RIGHT)
	del:SetWide(16)
	del:DockMargin(3, 4, 0, 5)
	del:SetImage('icon16/cross.png')
	del:SetTooltip('Удалить')
	self.del = del

	local opts = {}
	for id, data in pairs(octolib.bind.handlers) do
		opts[#opts + 1] = { data.name, id }
	end
	local cb = octolib.comboBox(top, nil, opts)
	cb:Dock(FILL)
	cb:DockMargin(0, 0, 0, 0)
	function cb:OnSelect() end
	self.action = cb

	local custom = self:Add 'DPanel'
	custom:Dock(TOP)
	custom:DockMargin(3, 0, 3, 3)
	custom:SetPaintBackground(false)
	custom:SetTall(0)
	self.custom = custom

end

function PANEL:SetBind(bindID)

	local bind = octolib.bind.cache[bindID]
	local handler = octolib.bind.handlers[bind.action]

	function self.del:DoClick()
		octolib.bind.set(bindID, nil)
	end

	local _, selectedId = octolib.array.find(self.on.Data, function(value)
		return value == bind.on
	end)
	self.on:ChooseOptionID(selectedId or 1)
	function self.on:OnSelect(_, _, val)
		local bind = octolib.bind.cache[bindID]
		octolib.bind.set(bindID, bind.button, bind.action, bind.data, val)
	end

	self.binder:SetValue(bind.button)
	function self.binder:SetSelectedNumber(but)
		self.m_iSelectedNumber = but
		self:UpdateText()

		local bind = octolib.bind.cache[bindID]
		octolib.bind.set(bindID, but, bind.action, bind.data, bind.on)
	end

	self.action:SetValue(handler and handler.name or 'Неизвестное действие')
	function self.action:OnSelect(_, _, val)
		local bind = octolib.bind.cache[bindID]
		octolib.bind.set(bindID, bind.button, val, nil, bind.on)
	end

	if handler and handler.buildBinder then
		handler.buildBinder(self.custom, bindID, bind)
		local h = self.custom:GetTall()
		if h > 0 then h = h + 3 end
		self:SetTall(31 + h)
	end

end

vgui.Register('octolib_bind_row', PANEL, 'DPanel')
