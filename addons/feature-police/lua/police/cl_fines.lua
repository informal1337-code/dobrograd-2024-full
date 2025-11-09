local fr
surface.CreateFont('fines.normal', {
	font = 'Derma Default',
	extended = true,
	size = 13,
	weight = 350,
})
surface.CreateFont('fines.normal-sm', {
	font = 'Calibri',
	extended = false,
	size = 25,
	weight = 350,
})
surface.CreateFont('fines.normal-smaller', {
	font = 'Calibri',
	extended = false,
	size = 16,
	weight = 350,
})

local fineText = 'Штраф №%s: %s'
net.Receive("dbg-police.fines.openMenu", function()
	local ply = net.ReadEntity()
	local fines = net.ReadTable()
	
	if IsValid(ply) and ply == LocalPlayer() then
		dbgPolice.fines.openFines(ply, fines)
	end
end)
function dbgPolice.fines.openFines(pl, data, adminPreferences)
    if IsValid(fr) then fr:Remove() return end

    local function isAdminPreferences()
        return LocalPlayer():IsAdmin() and adminPreferences
    end

    local currentData = {}

    fr = vgui.Create('DFrame')
    fr:SetSize(600, 550)
    fr:SetTitle('Штрафы')
    fr:Center()
    fr:MakePopup()
    fr.data = data

    local fineList = vgui.Create('DListView', fr)
    fineList:Dock(LEFT)
    fineList:SetSize(230, 300)
    fineList:DockMargin(0,0,2,0)
    fineList:SetMultiSelect( false )
    fineList:AddColumn('Список активных штрафов')
    fr.fineList = fineList

    local dataPanel = vgui.Create('DPanel', fr)
    dataPanel:Dock(FILL)
    dataPanel:DockPadding(8,0,8,8)
    dataPanel:SetPaintBackground(false)

    local l = vgui.Create('DLabel', dataPanel)
    l:Dock(TOP)
    l:DockMargin(5,0,5,0)
    l:SetTall(30)
    l:SetText('Причина штрафа')
    l:SetFont('f4.normal')

    local textReason = vgui.Create('DTextEntry', dataPanel)
    textReason:Dock(TOP)
    textReason:DockMargin(5,0,5,0)
    textReason:SetTall(30)
    textReason:SetDrawLanguageID(false)
    textReason:SetUpdateOnType(true)
    textReason.PerformLayout = nil

    local l = vgui.Create('DLabel', dataPanel)
    l:Dock(TOP)
    l:DockMargin(5,0,5,0)
    l:SetTall(30)
    l:SetText('Кем выдан')
    l:SetFont('f4.normal')

    local textGiver = vgui.Create('DPanel', dataPanel)
    textGiver:Dock(TOP)
    textGiver:DockMargin(5,0,5,15)
    textGiver:SetTall(30)
    function textGiver:Paint(w, h)
        draw.RoundedBox(3,0,0,w,h,color_white)
        if currentData.giverSteamID then
            draw.SimpleText(('%s (%s)'):format(currentData.giverName or '', currentData.giverSteamID or ''), 'fines.normal', 5, h/2, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    local copyGiver = textGiver:Add('DImageButton')
	copyGiver:Dock(RIGHT)
	copyGiver:SetWide(32)
	copyGiver:SetStretchToFit(true)
    copyGiver:DockMargin(5,0,5,0)
	copyGiver:SetIcon('octoteam/icons/pages_text.png')
	copyGiver:AddHint('Копировать')
    function copyGiver:DoClick()
        SetClipboardText(currentData.giverSteamID or '')
    end

    local l = vgui.Create('DLabel', dataPanel)
    l:Dock(TOP)
    l:DockMargin(5,0,5,0)
    l:SetText('Дата выдачи')
    l:SetFont('f4.normal')
    local issueTime = vgui.Create('DLabel', dataPanel)
    issueTime:Dock(TOP)
    issueTime:DockMargin(5,0,10,0)
    issueTime:SetTall(30)
    issueTime:SetText('')
    issueTime:SetFont('fines.normal-sm')

    local i = 0
    for uuid, fineData in pairs(data) do
        i = i + 1
        local bt = fineList:AddLine(fineText:format(i, DarkRP.formatMoney(fineData.price)))
        bt.data = fineData
        bt.uuid = uuid
    end

    local priceEntry, fineAmountLabel
    local sendReqBtn = vgui.Create('DButton', dataPanel)

    local function focusOnCreation(focus)
        textReason:SetEnabled(focus)

        if IsValid(fineAmountLabel) then fineAmountLabel:Remove() end
        if IsValid(priceEntry) then priceEntry:Remove() end

        if focus and not isAdminPreferences() then
            textReason:KillFocus()

            sendReqBtn:SetText('Выдать')
            sendReqBtn.DoClick = function(self)
                netstream.Start('dbg-police.applyFine', pl, textReason:GetValue(), tonumber(currentData.amount))
            end

            fineAmountLabel = vgui.Create('DLabel', dataPanel)
            fineAmountLabel:Dock(TOP)
            fineAmountLabel:DockMargin(5,0,5,0)
            fineAmountLabel:SetTall(30)
            fineAmountLabel:SetText('Сумма штрафа')
            fineAmountLabel:SetFont('f4.normal')

            priceEntry = vgui.Create('DTextEntry', dataPanel)
            priceEntry:SetNumeric( true )
            priceEntry:Dock(TOP)
            priceEntry:DockMargin(5,0,5,0)
            priceEntry:SetTall(30)
            priceEntry:SetDrawLanguageID(false)
            priceEntry:SetUpdateOnType(true)
            function priceEntry:OnValueChange(value)
                currentData.amount = value
            end

        else

            if pl == LocalPlayer() then
                sendReqBtn:SetText('Оплатить')
                sendReqBtn.DoClick = function(self)
                    netstream.Start('dbg-police.fines.payFine', currentData.uuid)
                end
            else
                sendReqBtn:SetText('Отозвать')
                sendReqBtn.DoClick = function(self)
                    octolib.request.open({
                        {
                            type = 'strShort',
                            name = 'Отозвать штраф',
                            ph = 'Причина отзыва штрафа',
                            len = 100,
                            required = true,
                        },
                    }, function(data)
                        if not istable(data) then return end
                        netstream.Start('dbg-police.fines.revokeFine', currentData.uuid, pl, data[1])
                    end)
                end
            end
        end
    end

    function fineList:OnRowSelected(_, pnl)
        currentData = pnl.data
        if pl ~= LocalPlayer() and not isAdminPreferences() then
            focusOnCreation(false)
        end

        local TimeString = os.date( '%d/%m/%Y %H:%M', currentData.issueDate )
        issueTime:SetText(TimeString)
        textReason:SetText(currentData.reason)
    end

    sendReqBtn:SetTall(30)
    sendReqBtn:SetWidth(150)
    sendReqBtn:SetPos(195, 486)

    focusOnCreation(false)

    if pl ~= LocalPlayer() and LocalPlayer():isCP() then
        fr:SetTitle('Штрафы ' .. pl:Name())
        if not isAdminPreferences() then
            local createNewFineBtn = octolib.button(fineList, 'Создать', function()
                focusOnCreation(true)
                if currentData.giverSteamID ~= LocalPlayer():SteamID() then
                    currentData = {
                        giverName = LocalPlayer():Name(),
                        giverSteamID = LocalPlayer():SteamID(),
                    }
                end
                local TimeString = os.date( '%d/%m/%Y %H:%M', currentData.issueDate )
                issueTime:SetText(TimeString)
            end)

            createNewFineBtn:Dock(BOTTOM)
        end
    end

    if isAdminPreferences() then
        sendReqBtn:SetText('Удалить')
        sendReqBtn.DoClick = function(self)
            local id, _ = fineList:GetSelectedLine()
            if not id then
                octolib.notify.show('warning', 'Выберите штраф')
                return
            end

            fineList:RemoveLine(id)
        end

        local saveFinesBtn = vgui.Create('DButton', dataPanel)
        saveFinesBtn:SetText('Сохранить')
        saveFinesBtn:SetTall(30)
        saveFinesBtn:SetWidth(150)
        saveFinesBtn:SetPos(25, 486)

        function saveFinesBtn:DoClick()
            local prettyFinesTable = {}
            for _, v in pairs(fineList.Lines) do
                prettyFinesTable[v.uuid] = v.data
            end

            netstream.Start('dbg-police.adminApplyFines', pl, prettyFinesTable)
        end
    end
end

netstream.Hook('dbg-police.fines.menu', dbgPolice.fines.openFines)
netstream.Hook('dbg-police.fines.menuUpdateList', function(data)
    if IsValid(fr) then
        for lineID, _ in pairs(fr.fineList.Lines) do
            fr.fineList:RemoveLine(lineID)
        end

        local i = 0
        for uuid, fineData in pairs(data) do
            i = i + 1
            local bt = fr.fineList:AddLine(fineText:format(i, DarkRP.formatMoney(fineData.price)))
            bt.data = fineData
            bt.uuid = uuid
        end
    end
end)