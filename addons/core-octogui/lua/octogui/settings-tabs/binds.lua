hook.Add('octolib.settings.createTabs', 'binds', function(add, buildFuncs)
	add({
		order = 3,
		name = 'Бинды',
		icon = 'key',
		build = function(parent)
			local cont = vgui.Create('octolib_bind_panel')

			local t = buildFuncs.title(parent, 'Бинды')
			t:SetParent(cont)
			
			function cont:RebuildList()
				self:Clear()
				self:Add(t)

				octolib.label(self, 'Чтобы убрать назначение клавиши, нажми правую кнопку мыши')

				for i = 1, #octolib.bind.cache do
					local row = self:Add 'octolib_bind_row'
					row:SetBind(i)
				end

				octolib.button(self, 'Создать', function()
					octolib.bind.set(nil, KEY_SPACE, 'chat', 'Привет!')
				end)
			end

			cont:RebuildList()
			return cont
		end,
	})
end)