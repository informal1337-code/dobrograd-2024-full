hook.Add('octogui.f4-tabs', 'octoshop', function()
	octogui.f4.addButton({
		id = 'donate',
		name = L.donate,
		order = 13,
		icon = Material('octoteam/icons/coin_stacks.png'),
		build = function(f)
			octoshop.pnl:SetVisible(true)
			octoshop.pnl:SetPos(0, 19)
			octoshop.pnl.cl:SetVisible(false)
			f:DockPadding(0, 0, 0, 0)
			f:Add(octoshop.pnl)
			f:SizeToChildren(true, true)
			function f:OnRemove()
				octoshop.pnl:SetParent(vgui.GetWorldPanel())
				octoshop.pnl.cl:SetVisible(true)
			end
		end,
		show = function(f, st)
			if st then
				net.Start('octoshop.rInventory')
				net.SendToServer()
			end
		end,
	})

	if octoshop.priceMultiplier and octoshop.priceMultiplier < 1 then
		local discountPercent = math.Round((1 - octoshop.priceMultiplier) * 100)
		local text = '-' .. discountPercent .. '%'
		octogui.f4.setCounter('donate', text)
	end
end)