-- "addons\\core-octogui\\lua\\octogui\\settings-tabs\\gameplay.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
CreateClientConVar('cl_dbg_voiceicon', '1', true)
CreateClientConVar('cl_dbg_alcohol_effect', '1', true, true)
CreateClientConVar('cl_dbg_hunger_sound', '1', true, true)

hook.Add('octolib.settings.createTabs', 'gameplay', function(add, buildFuncs)
	add({
		order = 5,
		name = 'Геймплей',
		icon = 'bricks',
		build = function(p)
			local cp = buildFuncs.childPanel(p)
			cp:DockPadding(10, 0, 10, 10)

			buildFuncs.fancyCheckbox(cp, L.dbg_help_login, 'Автоматически открывать F1-справку при входе на сервер'):SetConVar('dbg_help_login')
			buildFuncs.fancyCheckbox(cp, L.voicemods, 'Возможность шептать или кричать в голосовой чат при удерживании Alt или Shift вместе с кнопкой разговора'):SetConVar('dbg_voicemods')
			buildFuncs.fancyCheckbox(cp, 'Иконка голосового чата над головой', 'Пригодится для записи видео, но можно запутаться, кто говорит'):SetConVar('cl_dbg_voiceicon')
			buildFuncs.fancyCheckbox(cp, 'Эффект опьянения в чате', 'Если ты под воздействием алкоголя, твои сообщения в ролевом чате будут измеЕеенееЕЕны вооООт таааак'):SetConVar('cl_dbg_alcohol_effect')
			buildFuncs.fancyCheckbox(cp, 'Эффект рыбьего глаза на глазках', 'Чем ближе человек за дверью к глазку, тем шире ты его видишь в дверном глазке. Прямо как в реальной жизни! Но может мешать'):SetConVar('cl_dbg_fisheyeonpeepholes')
			buildFuncs.fancyCheckbox(cp, 'Отображать ники говорящих в рацию', 'Когда кто-то начнет говорить в рацию на твоей волне, слева снизу ты увидишь его ролевое имя, как в обычном Sandbox'):SetConVar('cl_dbg_talkienotifies')
			buildFuncs.fancyCheckbox(cp, 'Звук голода', 'Проигрывать при низком уровне сытости звук урчания живота'):SetConVar('cl_dbg_hunger_sound')
		end,
	})
end)