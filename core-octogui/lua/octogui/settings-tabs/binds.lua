hook.Add('octolib.settings.createTabs', 'binds', function(add, buildFuncs)
	add({
		order = 3,
		name = 'Бинды',
		icon = 'key',
		build = function()
			local cont = vgui.Create('octolib_bind_panel')
			local t = buildFuncs.title(cont, 'Бинды')
			t:SetParent()
			function cont:RebuildList()
				t:SetParent()
				self:Clear()
				self:Add(t)

				for i = 1, #octolib.bind.cache do
					local row = self:Add 'octolib_bind_row'
					row:SetBind(i)
				end

				octolib.button(self, 'Создать', function()
					octolib.bind.set(nil, KEY_SPACE, 'chat', 'Привет!')
				end)

			end

			return cont
		end,
	})
end)
