if CLIENT then
    if serverguard then
        local category = {}

        category.name = "Anti-Crash"
        category.material = "icon16/shield.png"
        category.permissions = {"View AntiCrash", "Manage AntiCrash"}

        function category:Create(base)
            base.panel = base:Add("tiger.panel")
            base.panel:SetTitle("Anti-Crash")
            base.panel:Dock(FILL)

            local header = base.panel:Add("DPanel")
            header:Dock(TOP)
            header:SetTall(80)
            header:DockMargin(5, 5, 5, 5)
            header:SetBackgroundColor(Color(50, 50, 50))

            local title = header:Add("DLabel")
            title:Dock(TOP)
            title:SetText("sosi")
            title:SetFont("Trebuchet24")
            title:SetTextColor(Color(255, 255, 255))
            title:DockMargin(10, 10, 10, 5)

            local status = header:Add("DLabel")
            status:Dock(TOP)
            status:SetText("sosut:" .. #player.GetHumans() .. " players")
            status:SetFont("Default")
            status:SetTextColor(Color(0, 255, 0))
            status:DockMargin(10, 0, 10, 10)

            local controls = base.panel:Add("DPanel")
            controls:Dock(TOP)
            controls:SetTall(50)
            controls:DockMargin(5, 0, 5, 5)

            local refreshBtn = controls:Add("DButton")
            refreshBtn:Dock(LEFT)
            refreshBtn:SetWide(120)
            refreshBtn:SetText("Refresh Stats")
            refreshBtn:SetIcon("icon16/arrow_refresh.png")
            refreshBtn:DockMargin(5, 5, 5, 5)

            local clearBtn = controls:Add("DButton")
            clearBtn:Dock(LEFT)
            clearBtn:SetWide(120)
            clearBtn:SetText("Clear Logs")
            clearBtn:SetIcon("icon16/bin_closed.png")
            clearBtn:DockMargin(0, 5, 5, 5)

            local exportBtn = controls:Add("DButton")
            exportBtn:Dock(LEFT)
            exportBtn:SetWide(120)
            exportBtn:SetText("Export Logs")
            exportBtn:SetIcon("icon16/page_white_put.png")
            exportBtn:DockMargin(0, 5, 5, 5)

            local mainArea = base.panel:Add("DPanel")
            mainArea:Dock(FILL)
            mainArea:DockMargin(5, 0, 5, 5)

            local statsPanel = mainArea:Add("DPanel")
            statsPanel:Dock(LEFT)
            statsPanel:SetWide(300)
            statsPanel:DockMargin(0, 0, 5, 0)

            local statsTitle = statsPanel:Add("DLabel")
            statsTitle:Dock(TOP)
            statsTitle:SetText("📊 System Statistics")
            statsTitle:SetFont("Trebuchet18")
            statsTitle:DockMargin(5, 5, 5, 5)

            local statsList = statsPanel:Add("DListView")
            statsList:Dock(FILL)
            statsList:DockMargin(5, 0, 5, 5)
            statsList:AddColumn("Metric", 150)
            statsList:AddColumn("Value", 100)

            local logsPanel = mainArea:Add("DPanel")
            logsPanel:Dock(FILL)

            local logsTitle = logsPanel:Add("DLabel")
            logsTitle:Dock(TOP)
            logsTitle:SetText("Activity Logs")
            logsTitle:SetFont("Trebuchet18")
            logsTitle:DockMargin(5, 5, 5, 5)

            local logsList = logsPanel:Add("DListView")
            logsList:Dock(FILL)
            logsList:DockMargin(5, 0, 5, 5)
            logsList:AddColumn("Time", 120)
            logsList:AddColumn("Player", 150)
            logsList:AddColumn("Activity", 200)
            logsList:AddColumn("Severity", 80)

            function refreshBtn:DoClick()
                net.Start("ac_admin_get_stats")
                net.SendToServer()

                net.Receive("ac_admin_get_stats", function()
                    local stats = net.ReadTable()

                    statsList:Clear()
                    for k, v in pairs(stats) do
                        statsList:AddLine(k, tostring(v))
                    end
                end)
            end

            function clearBtn:DoClick()
                Derma_Query("Are you sure you want to clear all Anti-Crash logs?", "Confirm Clear",
                    "Yes", function()
                        net.Start("ac_admin_clear_logs")
                        net.SendToServer()
                        refreshBtn:DoClick()
                    end,
                    "No", function() end)
            end

            function exportBtn:DoClick()
                net.Start("ac_admin_get_logs")
                net.SendToServer()

                net.Receive("ac_admin_get_logs", function()
                    local logs = net.ReadTable()
                    local exportData = "Anti-Crash System Logs Export\n"
                    exportData = exportData .. "Generated: " .. os.date() .. "\n\n"

                    for _, log in ipairs(logs) do
                        exportData = exportData .. string.format("[%s] %s: %s (Severity: %s)\n",
                            log.time, log.player, log.activity, log.severity)
                    end

                    file.Write("anticrash_export_" .. os.date("%Y%m%d_%H%M%S") .. ".txt", exportData)
                    notification.AddLegacy("Logs exported to garrysmod/data/", NOTIFY_GENERIC, 5)
                end)
            end

            refreshBtn:DoClick()
        end

        serverguard.menu.AddSubCategory("Intelligence", category)
    end
end
