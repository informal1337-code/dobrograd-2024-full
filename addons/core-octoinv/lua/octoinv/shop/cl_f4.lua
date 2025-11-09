hook.Add('octogui.f4-tabs', 'octoinv.shop', function()
	octogui.f4.addButton({
		id = 'shop',
		name = L.shop,
		order = 11,
		icon = Material('octoteam/icons/shop.png'),
		build = function(f)
			octoinv.pnlShop:SetVisible(true)
			octoinv.pnlShop:SetPos(0, 19)
			octoinv.pnlShop.btnClose:SetVisible(false)
			f:DockPadding(0, 0, 0, 0)
			f:Add(octoinv.pnlShop)
			f:SizeToChildren(true, true)
			function f:OnRemove()
				octoinv.createShop()
			end
		end,
		show = function(f, st)
			if st then octoinv.updateShop() end
			octoinv.pnlShop:SetVisible(st)
		end,
	})
end)
