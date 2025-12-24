if CLIENT then

local screencap = screencap or {}
screencap.history = screencap.history or {}
screencap.isCapturing = false
screencap.currentCapture = nil

netstream.Hook('sg.octolib-grab', function(ply, result)
	local act = screencap.pending[ply]
	if not act then return end
	act(result)
	screencap.pending[ply] = nil
end)

netstream.Hook('sg.screencap.take', function()
	if screencap.isCapturing then return false end

	screencap.isCapturing = true
	screencap.currentCapture = {
		startTime = SysTime(),
		player = LocalPlayer()
	}

	local notify = vgui.Create("DNotify")
	notify:SetPos(ScrW() - 300, ScrH() - 100)
	notify:SetSize(280, 80)

	local bg = vgui.Create("DPanel", notify)
	bg:Dock(FILL)
	bg:SetBackgroundColor(Color(40, 40, 40, 230))

	local lbl = vgui.Create("DLabel", bg)
	lbl:Dock(FILL)
	lbl:SetText("📸")
	lbl:SetFont("Trebuchet24")
	lbl:SetTextColor(Color(255, 255, 255))
	lbl:SetContentAlignment(5)
	notify:AddItem(bg)
	notify:SetLife(3)

	timer.Simple(0.2, function()
		local data = render.Capture({
			format = "png",
			x = 0,
			y = 0,
			w = ScrW(),
			h = ScrH(),
			quality = 100
		})

		local captureTime = SysTime() - screencap.currentCapture.startTime
		screencap.currentCapture = nil
		screencap.isCapturing = false

		octolib.logger.debug(string.format("Screenshot captured in %.2fs, size: %s",
			captureTime, string.NiceSize(#data)))

		return data
	end)
end)

function screencap.openGallery()
	local frame = vgui.Create("DFrame")
	frame:SetSize(1000, 700)
	frame:Center()
	frame:SetTitle("Screenshot Gallery - Admin Panel")
	frame:SetIcon("icon16/film.png")
	frame:MakePopup()
	frame:SetBackgroundBlur(true)

	local mainPanel = vgui.Create("DPanel", frame)
	mainPanel:Dock(FILL)
	mainPanel:DockMargin(5, 5, 5, 5)

	local controlPanel = vgui.Create("DPanel", mainPanel)
	controlPanel:Dock(TOP)
	controlPanel:SetTall(50)
	controlPanel:DockMargin(0, 0, 0, 5)

	local refreshBtn = vgui.Create("DButton", controlPanel)
	refreshBtn:Dock(LEFT)
	refreshBtn:SetWide(100)
	refreshBtn:SetText("Refresh")
	refreshBtn:SetIcon("icon16/arrow_refresh.png")
	refreshBtn:DockMargin(5, 5, 5, 5)

	local clearBtn = vgui.Create("DButton", controlPanel)
	clearBtn:Dock(LEFT)
	clearBtn:SetWide(100)
	clearBtn:SetText("Clear All")
	clearBtn:SetIcon("icon16/bin_closed.png")
	clearBtn:DockMargin(0, 5, 5, 5)

	local searchBox = vgui.Create("DTextEntry", controlPanel)
	searchBox:Dock(FILL)
	searchBox:DockMargin(5, 5, 5, 5)
	searchBox:SetPlaceholderText("Search by player name...")

	local scrollPanel = vgui.Create("DScrollPanel", mainPanel)
	scrollPanel:Dock(FILL)

	local list = vgui.Create("DIconLayout", scrollPanel)
	list:Dock(FILL)
	list:SetSpaceX(5)
	list:SetSpaceY(5)

	local screenshots = {}

	function refreshBtn:DoClick()
		list:Clear()
		screenshots = {}

		if not file.Exists("screencaps", "DATA") then
			file.CreateDir("screencaps")
			return
		end

		local files = file.Find("screencaps/*.png", "DATA")
		table.sort(files, function(a, b) return file.Time("screencaps/" .. a, "DATA") > file.Time("screencaps/" .. b, "DATA") end)

		for _, filename in ipairs(files) do
			local fullPath = "screencaps/" .. filename
			local fileTime = file.Time(fullPath, "DATA")

			local targetSteam, date, time, adminSteam = filename:match("screencap_([%w_]+)_([%d_]+)_([%d_]+)_([%w_]+)%.png")
			if targetSteam and adminSteam then
				targetSteam = targetSteam:gsub("_", ":")
				adminSteam = adminSteam:gsub("_", ":")

				local item = list:Add("DPanel")
				item:SetSize(200, 200)
				item:DockPadding(5, 5, 5, 5)

				local img = vgui.Create("DImage", item)
				img:Dock(FILL)
				img:SetMaterial(Material("../data/" .. fullPath, "smooth"))
				img:SetKeepAspect(true)

				local info = vgui.Create("DPanel", item)
				info:Dock(BOTTOM)
				info:SetTall(50)
				info:DockPadding(5, 5, 5, 5)

				local name = vgui.Create("DLabel", info)
				name:Dock(TOP)
				name:SetText(string.format("Target: %s", targetSteam))
				name:SetFont("DefaultSmall")

				local dateLabel = vgui.Create("DLabel", info)
				dateLabel:Dock(TOP)
				dateLabel:SetText(os.date("Taken: %Y-%m-%d %H:%M", fileTime))
				dateLabel:SetFont("DefaultSmall")

				local adminLabel = vgui.Create("DLabel", info)
				adminLabel:Dock(TOP)
				adminLabel:SetText(string.format("By: %s", adminSteam))
				adminLabel:SetFont("DefaultSmall")

				function img:DoClick()
					local viewFrame = vgui.Create("DFrame")
					viewFrame:SetSize(800, 600)
					viewFrame:Center()
					viewFrame:SetTitle("Screenshot Viewer")
					viewFrame:MakePopup()

					local viewImg = vgui.Create("DImage", viewFrame)
					viewImg:Dock(FILL)
					viewImg:SetMaterial(Material("../data/" .. fullPath, "smooth"))

					local saveBtn = vgui.Create("DButton", viewFrame)
					saveBtn:Dock(BOTTOM)
					saveBtn:SetText("Save to Desktop")
					saveBtn:DockMargin(5, 5, 5, 5)

					function saveBtn:DoClick()
						local data = file.Read(fullPath, "DATA")
						if data then
							file.Write("screenshots/" .. filename, data)
							notification.AddLegacy("Screenshot saved to garrysmod/data/screenshots/", NOTIFY_GENERIC, 3)
						end
					end
				end

				table.insert(screenshots, {
					item = item,
					filename = filename,
					target = targetSteam,
					admin = adminSteam
				})
			end
		end
	end

	function clearBtn:DoClick()
		Derma_Query("Are you sure you want to delete ALL screenshots?", "Confirm Deletion",
			"Yes", function()
				for _, filename in ipairs(file.Find("screencaps/*.png", "DATA")) do
					file.Delete("screencaps/" .. filename)
				end
				refreshBtn:DoClick()
				notification.AddLegacy("All screenshots deleted", NOTIFY_GENERIC, 3)
			end,
			"No", function() end)
	end

	function searchBox:OnChange()
		local search = self:GetValue():lower()
		for _, shot in ipairs(screenshots) do
			if search == "" or shot.target:lower():find(search) or shot.admin:lower():find(search) then
				shot.item:SetVisible(true)
			else
				shot.item:SetVisible(false)
			end
		end
		list:Layout()
	end

	refreshBtn:DoClick()
end

end

local plugin = plugin
local category = {}

category.name = "Advanced Screen Capture"
category.material = "serverguard/menuicons/icon_camera.png"
category.permissions = "Screencap"

function category:Create(base)
	base.panel = base:Add("tiger.panel")
	base.panel:SetTitle("Advanced Screen Capture")
	base.panel:Dock(FILL)

	local header = vgui.Create("DPanel", base.panel)
	header:Dock(TOP)
	header:SetTall(60)
	header:DockMargin(5, 5, 5, 5)

	local title = vgui.Create("DLabel", header)
	title:Dock(TOP)
	title:SetText("Advanced Screen Capture System")
	title:SetFont("Trebuchet24")
	title:SetTextColor(Color(255, 255, 255))
	title:DockMargin(10, 5, 5, 5)

	local desc = vgui.Create("DLabel", header)
	desc:Dock(TOP)
	desc:SetText("Capture, view, and manage player screenshots locally")
	desc:SetFont("Default")
	desc:SetTextColor(Color(200, 200, 200))
	desc:DockMargin(10, 0, 5, 5)

	local galleryBtn = vgui.Create("DButton", header)
	galleryBtn:Dock(RIGHT)
	galleryBtn:SetWide(120)
	galleryBtn:SetText("Open Gallery")
	galleryBtn:SetIcon("icon16/images.png")
	galleryBtn:DockMargin(5, 5, 10, 5)

	function galleryBtn:DoClick()
		screencap.openGallery()
	end

	base.panel.list = base.panel:Add("tiger.list")
	base.panel.list:Dock(FILL)
	base.panel.list:DockMargin(5, 0, 5, 5)

	base.panel.list:AddColumn("PLAYER", 250)
	base.panel.list:AddColumn("STEAMID", 180)
	base.panel.list:AddColumn("STATUS", 120)
	base.panel.list:AddColumn("ACTIONS", 120):SetDisabled(true)

	function base.panel.list:Think()
		local players = player.GetHumans()

		for i = 1, #players do
			local pPlayer = players[i]

			if not IsValid(pPlayer.screenPanel) then
				local panel = base.panel.list:AddItem(serverguard.player:GetName(pPlayer), pPlayer:SteamID())

				panel.player = pPlayer
				panel.unique = pPlayer:UniqueID()

				function panel:OnMousePressed(code) end

				function panel:Think()
					if not IsValid(self.player) then
						self:Remove()
						base.panel.list:GetCanvas():InvalidateLayout()

						timer.Simple(FrameTime() * 2, function()
							base.panel.list:OnSort()
						end)
					end
				end

				local nameLabel = panel:GetLabel(1)
				nameLabel:SetUpdate(function(self)
					if IsValid(pPlayer) then
						if self:GetText() ~= serverguard.player:GetName(pPlayer) then
							self:SetText(serverguard.player:GetName(pPlayer))
						end
					end
				end)

				local statusLabel = vgui.Create("DLabel")
				statusLabel:SetText("Ready")
				statusLabel:SetTextColor(Color(0, 255, 0))
				panel:SetColumnText(3, statusLabel)

				local actionsPanel = vgui.Create("DPanel")
				actionsPanel:SetSize(120, 30)

				local captureBtn = vgui.Create("DButton", actionsPanel)
				captureBtn:Dock(LEFT)
				captureBtn:SetWide(55)
				captureBtn:SetText("📸")
				captureBtn:SetTooltip("Capture Screen")
				captureBtn:DockMargin(1, 1, 1, 1)

				local viewBtn = vgui.Create("DButton", actionsPanel)
				viewBtn:Dock(RIGHT)
				viewBtn:SetWide(55)
				viewBtn:SetText("👁")
				viewBtn:SetTooltip("View Screenshot")
				viewBtn:DockMargin(1, 1, 1, 1)
				viewBtn:SetVisible(false)

				local immAdmin, immTarget = serverguard.player:GetImmunity(LocalPlayer()), serverguard.player:GetImmunity(pPlayer)
				captureBtn:SetVisible(immAdmin >= immTarget)

				function captureBtn:DoClick()
					statusLabel:SetText("Capturing...")
					statusLabel:SetTextColor(Color(255, 165, 0))

					captureBtn:SetVisible(false)
					viewBtn:SetVisible(false)

					local progress = 0
					timer.Create('screenCapProgress' .. tostring(panel.player), 0.1, 30, function()
						if not IsValid(statusLabel) then return end
						progress = progress + 1
						statusLabel:SetText(string.format("Capturing... %d%%", progress * 3.33))
					end)

					screencap.pending = screencap.pending or {}
					screencap.pending[panel.player] = function(result)
						if not IsValid(statusLabel) then return end

						timer.Remove('screenCapProgress' .. tostring(panel.player))

						if result and result.localFile then
							statusLabel:SetText("Captured ✓")
							statusLabel:SetTextColor(Color(0, 255, 0))
							viewBtn:SetVisible(true)
							viewBtn.localFile = result.localFile
						else
							statusLabel:SetText("Failed ✗")
							statusLabel:SetTextColor(Color(255, 0, 0))
							captureBtn:SetVisible(true)
						end
					end

					netstream.Start('sg.octolib-grab', panel.player)
				end

				function viewBtn:DoClick()
					if self.localFile then
						local frame = vgui.Create("DFrame")
						frame:SetSize(1000, 700)
						frame:Center()
						frame:SetTitle("Screenshot - " .. serverguard.player:GetName(panel.player))
						frame:SetIcon("icon16/film.png")
						frame:MakePopup()
						frame:SetBackgroundBlur(true)

						local img = vgui.Create("DImage", frame)
						img:Dock(FILL)
						img:DockMargin(10, 10, 10, 10)
						img:SetMaterial(Material("../" .. self.localFile, "smooth"))
						img:SetKeepAspect(true)

						local saveBtn = vgui.Create("DButton", frame)
						saveBtn:Dock(BOTTOM)
						saveBtn:SetText("💾 Save to Screenshots Folder")
						saveBtn:DockMargin(10, 5, 10, 10)

						function saveBtn:DoClick()
							local data = file.Read(self.localFile:gsub("data/", ""), "DATA")
							if data then
								file.CreateDir("screenshots")
								local filename = "screenshot_" .. os.date("%Y%m%d_%H%M%S") .. ".png"
								file.Write("screenshots/" .. filename, data)
								notification.AddLegacy("Screenshot saved as: " .. filename, NOTIFY_GENERIC, 5)
							end
						end
					end
				end

				panel:SetColumnText(4, actionsPanel)
				pPlayer.screenPanel = panel
			end
		end
	end
end

plugin:AddSubCategory("Intelligence", category)
