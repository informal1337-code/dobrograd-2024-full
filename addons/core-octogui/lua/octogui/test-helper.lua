local function run()
	if not octogui.f4 or not CFG.dev then return end

	octogui.f4.addButton({
		id = 'test-helper',
		name = 'Тестирование',
		order = 100,
		icon = octolib.icons.color('flask2', ''),
		build = function(f)
			f:SetSize(300, 600)

			local testHelper = f:Add('octolib.testHelper')
			testHelper:Dock(FILL)

			local hookName = 'f4.tab.' .. octolib.string.uuid()
			hook.Add('octolib.testHelper.sync', hookName, function()
				if not IsValid(testHelper) then
					hook.Remove('octolib.testHelper.sync', hookName)
					return
				end

				testHelper:Reload()
			end)
		end,
	})
end
hook.Add('octolib.configLoaded', 'octogui.f4.testHelper', run)
hook.Add('octogui.f4-tabs', 'octogui.f4.testHelper', run)
