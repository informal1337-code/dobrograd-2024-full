-- "addons\\feature-tutorial\\lua\\tutorial\\tours\\cl_stage_closelook.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours.register('stage_closelook', {
	steps = {
		{
			align = TOP,
			title = 'Присматривание',
			opacity = 0,
			content = 'Чтобы понять, с кем ты разговариваешь, на какой предмет смотришь или увидеть какие-то другие детали, нужно воспользоваться функцией "Присмотреться". Присмотрись к окружающим вокруг. Если рядом нет ничего интересного, выбрось деньги из инвентаря и присмотрись к ним',
			contentOpacity = 1,
			keybinds = {
				{
					cvar = 'cl_dbg_key_look',
					text = 'присмотреться',
				},
			},
			onEnter = function()
				hook.Add('dbgView.closeLook.done', 'dbgTutorial.stage_closelook', function(_)
					octolib.tour.nextStep()
				end)
			end,
			onExit = function()
				hook.Remove('dbgView.closeLook.done', 'dbgTutorial.stage_closelook')
			end,
		},
		{
			align = TOP,
			title = 'Присматривание',
			opacity = 0,
			content = 'Иногда для получения информации о чем-то нужно чуть больше времени. Попробуй присмотреться к любому выброшенному предмету, чтобы определить, что это лежит',
			contentOpacity = 1,
			keybinds = {
				{
					cvar = 'cl_dbg_key_look',
					text = 'присмотреться',
				},
			},
			onEnter = function()
				hook.Add('dbgView.closeLook.done', 'dbgTutorial.stage_closelook', function(data)
					if data.time > 0.25 then
						octolib.tour.nextStep()
					end
				end)
			end,
			onExit = function()
				hook.Remove('dbgView.closeLook.done', 'dbgTutorial.stage_closelook')
			end,
		},
	},
	onFinish = function()
		timer.Simple(2, function()
			dbgTutorial.quest.next()
		end)
	end,
})