include "shared.lua"

function ENT:Draw()
	self:DrawModel()
end

local storageModels = {
    {
        name = "Металлический ящик",
        model = "models/props_junk/wood_crate001a.mdl",
    },
    {
        name = "Металлический шкаф", 
        model = "models/props_wasteland/controlroom_storagecloset001a.mdl",
    },
    {
        name = "Сейф",
        model = "models/props_lab/huladoll.mdl",
    },
    {
        name = "Деревянный сундук",
        model = "models/props/de_inferno/crate_fruit_break_gib2.mdl",
    }
}

local function openStorageMenu()
    if IsValid(LocalPlayer().storageMenu) then
        LocalPlayer().storageMenu:Remove()
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(500, 300)
    frame:SetTitle("Выберите тип хранилища")
    frame:Center()
    frame:MakePopup()

    LocalPlayer().storageMenu = frame

    local panel = vgui.Create("DPanel", frame)
    panel:Dock(FILL)
    panel:DockMargin(5, 5, 5, 5)
    panel.Paint = function() end

    for i, modelData in ipairs(storageModels) do
        local button = vgui.Create("DButton", panel)
        button:SetSize(100, 100)
        button:SetPos(((i-1) % 4) * 110 + 10, math.floor((i-1) / 4) * 110 + 10)
        button:SetText("")

        button.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, self:IsHovered() and Color(50, 100, 150, 100) or Color(40, 40, 40, 200))
            draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 10))

            local modelIcon = vgui.Create("DModelPanel", self)
            modelIcon:SetSize(80, 80)
            modelIcon:SetPos(10, 10)
            modelIcon:SetModel(modelData.model)

            local campos = modelIcon.Entity:GetPos()
            modelIcon:SetLookAt(campos)
            modelIcon:SetCamPos(campos + Vector(30, 30, 30))
        end

        button.DoClick = function()
            frame:Close()
            net.Start("octoinv.SpawnStorage")
            net.WriteUInt(i, 8)
            net.SendToServer()
        end
    end

    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:Dock(BOTTOM)
    closeBtn:SetTall(30)
    closeBtn:SetText("Отмена")
    closeBtn:DockMargin(0, 5, 0, 0)

    closeBtn.DoClick = function()
        frame:Close()
    end
end

net.Receive("octoinv.OpenStorageMenu", openStorageMenu)