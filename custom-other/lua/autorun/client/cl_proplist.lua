local PANEL = {}

function PANEL:Init()
    self.PanelList = vgui.Create("DPanelList", self)
    self.PanelList:SetPadding(4)
    self.PanelList:SetSpacing(2)
    self.PanelList:EnableVerticalScrollbar(true)
    self:BuildList()
end

function PANEL:BuildList()
    self.PanelList:Clear()
    local propCategories = list.Get("PropCategories") or {}

    for _, category in SortedPairsByMemberValue(propCategories, "Name") do
        local CategoryName = category.Name
        local models = category.Models or {}

        local Category = vgui.Create("DCollapsibleCategory", self)
        self.PanelList:AddItem(Category)
        Category:SetExpanded(false)
        Category:SetLabel(CategoryName)
        Category:SetCookieName("EntitySpawn."..CategoryName)

        local Content = vgui.Create("DPanelList", Category)
        Category:SetContents(Content)
        Content:EnableHorizontal(true)
        Content:SetDrawBackground(false)
        Content:SetSpacing(2)
        Content:SetPadding(2)
        Content:SetAutoSize(true)

        for _, model in pairs(models) do
            local Icon = vgui.Create("SpawnIcon", Content)
            Icon:SetModel(model)

            Icon.DoClick = function()
                RunConsoleCommand("gm_spawn", model)
            end

            local label = vgui.Create("DLabel", Icon)
            label:SetFont("DebugFixedSmall")
            label:SetTextColor(color_black)
            label:SetText(model:match("[^/]+$"):gsub("%.mdl", ""))
            label:SetContentAlignment(5)
            label:Dock(BOTTOM)
            label:DockMargin(0, 0, 0, 2)
            Content:AddItem(Icon)
        end
    end

    self.PanelList:InvalidateLayout()
end

function PANEL:PerformLayout()
    self.PanelList:StretchToParent(0, 0, 0, 0)
end

local CreationSheet = vgui.RegisterTable(PANEL, "Panel")

local function CreateContentPanel()
    return vgui.CreateFromTable(CreationSheet)
end