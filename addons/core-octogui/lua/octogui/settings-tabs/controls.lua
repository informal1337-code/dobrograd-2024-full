-- "addons\\core-octogui\\lua\\octogui\\settings-tabs\\controls.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- defkey, cvar, userinfo, name
local k_list = {
	{L.character},
	{KEY_G, 'cl_dbg_key_look', false, L.look},
	{KEY_LALT, 'cl_dbg_key_freeview', false, L.freeview},
	{MOUSE_MIDDLE, 'cl_dbg_key_sights', false, 'Смотреть в прицел'},
	{KEY_C, 'cl_dbg_key_bend', false, 'Целиться из-за угла'},
	{KEY_V, 'radio_bind_key', false, L.speak_in_radio},
	{KEY_K, 'dbg_emotions_key', false, 'Меню эмоций'},
	{KEY_B, 'cl_dbg_key_firemode', false, 'Переключить режим огня'},

	{L.car},
	{KEY_W, 'cl_simfphys_keyforward', true, L.key_w},
	{KEY_S, 'cl_simfphys_keyreverse', true, L.key_s},
	{KEY_A, 'cl_simfphys_keyleft', true, L.key_a},
	{KEY_D, 'cl_simfphys_keyright', true, L.key_d},
	{KEY_I, 'cl_simfphys_keyengine', true, L.key_i},
	{KEY_LALT, 'cl_simfphys_keyclutch', true, L.key_lalt},
	{KEY_LSHIFT, 'cl_simfphys_keywot', true, L.key_lshift},
	{MOUSE_LEFT, 'cl_simfphys_keygearup', true, L.key_mouse_left},
	{MOUSE_RIGHT, 'cl_simfphys_keygeardown', true, L.key_mouse_right},
	{KEY_SPACE, 'cl_simfphys_keyhandbrake', true, L.key_space},
	{KEY_R, 'cl_simfphys_keyhandbrake_toggle', true, L.key_r},

	{KEY_COMMA, 'cl_simfphys_key_turnmenu', true, L.key_comma},
	{KEY_UP, 'cl_simfphys_key_signals', true, 'Выключить поворотники'},
	{KEY_DOWN, 'cl_simfphys_key_hazards', true, 'Аварийка'},
	{KEY_LEFT, 'cl_simfphys_key_leftsignal', true, 'Левый поворотник'},
	{KEY_RIGHT, 'cl_simfphys_key_rightsignal', true, 'Правый поворотник'},

	{MOUSE_MIDDLE, 'cl_simfphys_keymousesteer', true, L.key_mouse_middle},
	{KEY_F, 'cl_simfphys_lights', true, L.key_f},
	{KEY_H, 'cl_simfphys_keyhorn', true, L.key_h},
	{KEY_M, 'cl_simfphys_emssiren', true, L.key_m},
	{KEY_N, 'cl_simfphys_emslights', true, L.key_n},
	{KEY_J, 'cl_simfphys_key_lock', true, L.key_j},
	{KEY_LCONTROL, 'cl_simfphys_key_mirror', false, L.key_lcontrol},
	{KEY_B, 'cl_simfphys_key_belt', true, L.key_b},
	{KEY_V, 'cl_simfphys_special', true, 'Лебедка тягача'},
}
for _, v in ipairs(k_list) do
	if isnumber(v[1]) then
		CreateClientConVar(v[2], v[1], true, v[3])
	end
end

hook.Add('PlayerButtonDown', 'dbg-emotions.bind', function(_, key)
	if key ~= GetConVar('dbg_emotions_key'):GetInt() then return end

	local opts = {{'Нейтральность', nil, function() netstream.Start('player-flex', {}) end}}
	for _, row in ipairs(octolib.vars.get('faceposes') or {}) do
		table.insert(opts, {row.name, nil, function()
			netstream.Start('player-flex', row.flexes)
		end})
	end
	octogui.circularMenu(opts)
end)

hook.Add('octolib.settings.createTabs', 'controls', function(add, buildFuncs)
	add({
		order = 1,
		name = 'Управление',
		icon = 'keyboard',
		build = function(p)
			local l = octolib.label(p, 'В этом меню ты можешь назначить горячие клавиши. Чтобы убрать назначение, кликни правой кнопкой мыши')
			l:SetTall(35)
			l:SetContentAlignment(5)
			l:SetWrap(true)

			for _, v in ipairs(k_list) do
				if isstring(v[1]) then
					local l = p:Add 'DLabel'
					l:Dock(TOP)
					l:DockMargin(0,5,0,5)
					l:SetTall(30)
					l:SetText(v[1])
					l:SetContentAlignment(5)
					l:SetFont('f4.normal')
				else
					local b = buildFuncs.binder(p, v)
					b:Dock(TOP)
					b:SetTall(25)
					b:DockMargin(0, 0, 0, 5)
				end
			end
		end,
	})
end)
