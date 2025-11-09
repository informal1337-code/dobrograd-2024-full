hook.Add('octogui.f4-tabs', 'octoinv.craft', function()
	octogui.f4.addButton({
		id = 'craft',
		name = L.directory,
		order = 12,
		icon = Material('octoteam/icons/blueprint.png'),
		build = function(f)
			if not IsValid(octoinv.helpPnl) then octoinv.initHelp() end

			octoinv.helpPnl:SetVisible(true)
			octoinv.helpPnl:SetPos(3, 22)
			f:DockPadding(3, 22, 3, 3)
			f:Add(octoinv.helpPnl)
			f:SizeToChildren(true, true)
			function f:OnRemove()
				octoinv.helpPnl:SetParent(vgui.GetWorldPanel())
				octoinv.helpPnl:SetVisible(false)
			end
		end,
	})
end)
