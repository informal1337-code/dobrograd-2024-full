--[[
Server Name: [#] Новый Доброград – Зима ❄️
Server IP:   46.174.50.64:27015
File Path:   addons/core-octolib/lua/octolib/modules/test-helper/vgui/octolib_test_helper.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local PANEL = {}

function PANEL:Init()
	self:SetPaintBackground(false)

	self.tree = self:Add 'DTree'
	self.tree:Dock(FILL)
	function self.tree:OnNodeSelected(node)
		self:GetParent():OnNodeSelected(node)
	end

	self.search = self:Add 'DTextEntry'
	self.search:Dock(TOP)
	self.search:DockMargin(5,5,5,10)
	self.search:SetUpdateOnType(true)
	self.search.PaintOffset = 5
	self.search:SetPlaceholderText(L.search_hint)
	function self.search:OnValueChange(val)
		self:GetParent():FilterItems(val)
	end

	self.button = self:Add 'DButton'
	self.button:Dock(BOTTOM)
	self.button:DockMargin(0,5,0,0)
	self.button:SetTall(30)
	self.button:SetVisible(false)
	function self.button:DoClick()
		self:GetParent():ExecuteMethod()
	end

	self:Reload()
end

function PANEL:Reload()
	self.tree:Clear()
	self.nodes = {}

	local nodeLayout = {}
	local categoryNodes = {}
	local waitingForParent = {}

	for id, category in pairs(octolib.testHelper.categories) do
		local nodeData = {
			name = category.name,
			icon = category.icon or octolib.icons.silk16('folder'),
			parent = category.parent,
			panelProps = {category = category},
			children = {},
		}
		categoryNodes[id] = nodeData

		if nodeData.parent then
			if categoryNodes[nodeData.parent] then
				table.insert(categoryNodes[nodeData.parent].children, nodeData)
			else
				waitingForParent[nodeData.parent] = waitingForParent[nodeData.parent] or {}
				table.insert(waitingForParent[nodeData.parent], nodeData)
			end
		else
			table.insert(nodeLayout, nodeData)
		end

		if waitingForParent[id] then
			for _, child in pairs(waitingForParent[id]) do
				table.insert(nodeData.children, child)
			end

			waitingForParent[id] = nil
		end
	end

	for id, uiData in pairs(octolib.testHelper.uiData) do
		local nodeData = {
			name = uiData.name,
			icon = uiData.icon or octolib.icons.silk16('bullet_black'),
			parent = uiData.parent or '_other',
			panelProps = {
				uiData = uiData,
				handler = octolib.testHelper.handlers[id],
			},
		}

		local children = (categoryNodes[nodeData.parent] or categoryNodes._other).children
		table.insert(children, nodeData)
	end

	local function addNode(nodeData, parent)
		local node = parent:AddNode(nodeData.name)
		node:SetIcon(nodeData.icon)
		node:SetExpanded(false)
		node:SetForceShowExpander(nodeData.panelProps.category ~= nil)
		self.nodes[#self.nodes + 1] = node

		if nodeData.panelProps then
			for k, v in pairs(nodeData.panelProps) do
				node[k] = v
			end
		end

		local children = nodeData.children or {}
		table.sort(children, function(a, b) return a.name < b.name end)
		for _, child in pairs(children) do
			addNode(child, node)
		end
	end

	table.sort(nodeLayout, function(a, b) return a.name < b.name end)
	for _, nodeData in pairs(nodeLayout) do
		if nodeData.name == octolib.testHelper.categories._other.name and #nodeData.children < 1 then
			continue
		end

		addNode(nodeData, self.tree)
	end
end

function PANEL:OnNodeSelected(node)
	if node.category then
		node:SetExpanded(not node:GetExpanded())
	end

	local hasHandler = node.handler ~= nil
	self.button:SetVisible(hasHandler)
	if hasHandler then
		self.button:SetText(node.uiData.args and 'Выбор параметров' or L.run)
	end
end

local function recursiveShow(node)
	node:SetVisible(true)
	if node.SetExpanded then
		node:SetExpanded(true, true)
	end

	local parent = node:GetParent()
	if parent.ClassName == 'DTree' then
		return
	end

	recursiveShow(parent)
end

function PANEL:FilterItems(val)
	if val == '' then
		-- show all
		for _, node in ipairs(self.nodes) do
			node:SetVisible(true)
			if node.SetExpanded then
				node:SetExpanded(false, true)
			end
		end
	else
		-- hide all
		for _, node in ipairs(self.nodes) do
			node:SetVisible(false)
		end

		-- show matched
		for itemID, node in ipairs(self.nodes) do
			if utf8.lower(node:GetText()):find(utf8.lower(val), 1, true) then
				recursiveShow(node)
			end
		end
	end

	self.tree:InvalidateLayout()
end

function PANEL:ExecuteMethod()
	local node = self.tree:GetSelectedItem()
	if not node or not node.handler then
		return
	end

	if node.uiData.args then
		octolib.request.open(node.uiData.args, function(data)
			if not data then return end
			node.handler(unpack(data))
		end)
	else
		node.handler()
	end
end

vgui.Register('octolib.testHelper', PANEL, 'DPanel')
