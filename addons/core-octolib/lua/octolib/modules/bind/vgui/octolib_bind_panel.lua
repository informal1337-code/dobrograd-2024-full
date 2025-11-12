local PANEL = {}

function PANEL:Init()
    self:Clear()
    
    octolib.label(self, 'Чтобы убрать назначение клавиши, нажми правую кнопку мыши')

    for i = 1, #octolib.bind.cache do
        local row = self:Add 'octolib_bind_row'
        row:SetBind(i)
    end

    octolib.button(self, 'Создать', function()
        octolib.bind.set(nil, KEY_SPACE, 'chat', 'Привет!')
    end)
end

function PANEL:Think()
    if self.lastUpdate == octolib.bind.lastUpdatedTime then return end
    self.lastUpdate = octolib.bind.lastUpdatedTime
    self:RebuildList()
end

function PANEL:RebuildList()
    self:Clear()

    octolib.label(self, 'Чтобы убрать назначение клавиши, нажми правую кнопку мыши')

    for i = 1, #octolib.bind.cache do
        local row = self:Add 'octolib_bind_row'
        row:SetBind(i)
    end

    octolib.button(self, 'Создать', function()
        octolib.bind.set(nil, KEY_SPACE, 'chat', 'Привет!')
    end)
end

vgui.Register('octolib_bind_panel', PANEL, 'DScrollPanel')