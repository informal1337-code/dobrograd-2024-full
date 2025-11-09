local options = {{
	id = 'shop',
	name = L.shop,
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
},{
	id = 'craft',
	name = L.directory,
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
}}

hook.Add('octogui.f4-tabs', 'f4', function()
	for i, opt in ipairs(options) do
		opt.order = i + 10
		octogui.f4.addButton(opt)
	end
end)