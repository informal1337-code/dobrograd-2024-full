octogui.themes.presets = {
	{
		name = 'Стандартная',
		primary = Color(102,170,170),
		secondary = Color(85,68,85),
	}, {
		name = 'Хэллоуин',
		primary = Color(222, 132, 38),
		secondary = Color(52, 49, 52),
		check = function(ply)
			return ply:GetNetVar('halloweenTheme'), 'Приобретается во время хэллоуина'
		end,
	}, {
		name = 'Темная',
		primary = Color(75,75,75),
		secondary = Color(30, 30, 30),
	}, {
		name = 'Ночная',
		primary = Color(51,58,97),
		secondary = Color(28,32,57),
	}, {
		name = 'Зеленая',
		primary = Color(49, 117, 53),
		secondary = Color(9, 48, 25),
	}, {
		name = 'Голубая',
		primary = Color(37,168,224),
		secondary = Color(46,63,73),
	}, {
		name = 'Красная',
		primary = Color(187, 36, 64),
		secondary = Color(40, 50, 93),
	}, {
		name = 'Неоновая',
		primary = Color(78, 69, 204),
		secondary = Color(51, 49, 77),
	}, {
		name = 'Лиловая',
		primary = Color(128,103,183),
		secondary = Color(50,49,51),
	}, {
		name = 'Вишневая',
		primary = Color(191,38,60),
		secondary = Color(50,49,51),
	}, {
		name = 'Светло-фиолетовая',
		primary = Color(120,111,166),
		secondary = Color(49,58,82),
	}, {
		name = 'Джентльменская',
		primary = Color(231,128,104),
		secondary = Color(49,58,82),
	}, {
		name = 'Винтажная',
		primary = Color(243, 181, 98),
		secondary = Color(92, 75, 81),
	}, {
		name = 'Лакшери',
		primary = Color(234, 160, 18),
		secondary = Color(62, 67, 78),
	}
}
