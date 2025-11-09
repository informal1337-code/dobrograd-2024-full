dbgChars.config = dbgChars.config or {}

dbgChars.config.names = {
	male = {
		'Джеймс','Джон','Майкл','Винсент','Стив','Уилл','Вильям','Джонни','Майки','Джимми',
		'Дуглас','Уейн','Винни','Алекс','Альберт','Дональд','Грег','Ларри','Ллойд','Лео',
		'Остин','Ричи','Сэм','Уолтер','Чарльз','Шон','Питер', 'Бенджамин','Роберт','Дэйви',
		'Мартин','Даниэль','Ирвин','Рэнди','Эдвард','Эдди','Джастин','Фредерик', 'Кристофер',
	},
	female = {
		'Оливия','Эмма','София','Ева','Изабелла','Мия','Шарлотта','Эмили','Харпер','Эбигейл',
		'Эйвери','Элла','Маргарет','Лили','Хлоя','Софи','Эвелин','Анна','Эдисон','Грейс',
		'Зоуи','Одри','Арья', 'Ария', 'Амели','Элли','Натали','Скарлет','Виктория', 'Кэролайн',
		'Элен','Оливия','Аманда','Кэти','Кэтрин','Джулия','Скарлетт',
	},
	surnames = {
		'Смит','Джонсон','Уильямс','Браун','Кларк','Родригес','Тейлор','Томпсон','Уайт',
		'Мартинес','Ли','Хилл','Скотт','Грин','Митчелл','Паркер','Коллинс','Моррис','Купер',
		'Говард','Эрнандес','Райт','Вашингтон','Симмонс','Фостер','Хейз', 'Лопес',
		'Скот', 'Грин', 'Бейкер', 'Нельсон', 'Картер', 'Перес', 'Тёрнер', 'Кэмпбелл',
	},
}

dbgChars.config.playerModels = {
	--
	-- FEMALE
	--
	['models/humans/octo/female_01.mdl'] = {
		name = 'Женщина 1',
		skins = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21,22,23,24,25,26,27,28,29},
		faceIndex = 4,
		faces = {
			'models/humans/modern/female/female_01/facemap_01_01',
			'models/humans/modern/female/female_01/facemap_01_02',
			'models/bloo_ltcom_zel/citizens/facemaps/joey_facemap',
			'models/bloo_ltcom_zel/citizens/facemaps/joey_facemap6',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/joey_facemap3',
			'models/bloo_ltcom_zel/citizens/facemaps/joey_facemap4',
			'models/bloo_ltcom_zel/citizens/facemaps/joey_facemap5',
		},
	},
	['models/humans/octo/female_02.mdl'] = {
		name = 'Женщина 2',
		skins = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
		faceIndex = 2,
		faces = {
			'models/humans/modern/female/female_02/facemap_02_01',
			'models/humans/modern/female/female_02/facemap_02_02',
			'models/bloo_ltcom_zel/citizens/facemaps/kanisha_cylmap5',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/kanisha_cylmap3',
			'models/bloo_ltcom_zel/citizens/facemaps/kanisha_cylmap4',
		},
	},
	['models/humans/octo/female_03.mdl'] = {
		name = 'Женщина 3',
		skins = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
		faceIndex = 0,
		faces = {
			'models/humans/modern/female/female_03/facemap_03_01',
			'models/humans/modern/female/female_03/facemap_03_02',
			'models/bloo_ltcom_zel/citizens/facemaps/kim_facemap',
			'models/bloo_ltcom_zel/citizens/facemaps/kim_facemap5',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/kim_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/kim_facemap4',
		},
	},
	['models/humans/octo/female_04.mdl'] = {
		name = 'Женщина 4',
		skins = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
		faceIndex = 0,
		faces = {
			'models/humans/modern/female/female_04/facemap_04_01',
			'models/humans/modern/female/female_04/facemap_04_02',
			'models/bloo_ltcom_zel/citizens/facemaps/chau_facemap4',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/chau_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/chau_facemap3',
		},
	},
	['models/humans/octo/female_06.mdl'] = {
		name = 'Женщина 6',
		skins = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
		faceIndex = 3,
		faces = {
			'models/humans/modern/female/female_06/facemap_06_01',
			'models/humans/modern/female/female_06/facemap_06_02',
			'models/bloo_ltcom_zel/citizens/facemaps/naomi_facemap4',
			'models/bloo_ltcom_zel/citizens/facemaps/naomi_facemap5',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/naomi_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/naomi_facemap3',
		},
	},
	['models/humans/octo/female_07.mdl'] = {
		name = 'Женщина 7',
		skins = {0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30},
		faceIndex = 4,
		faces = {
			'models/humans/modern/female/female_07/facemap_07_01',
			'models/humans/modern/female/female_07/facemap_07_02',
			'models/bloo_ltcom_zel/citizens/facemaps/lakeetra_facemap5',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/lakeetra_facemap2',
		},
	},

	--
	-- MALE
	--
	['models/humans/octo/male_01_01.mdl'] = {
		name = 'Мужчина 1',
		skins = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
		faceIndex = 1,
		faces = {
			'models/humans/modern/male/male_01/facemap_01',
			'models/humans/modern/male/male_01/facemap_02',
			'models/humans/modern/male/male_01/facemap_03',
			'models/bloo_ltcom_zel/citizens/facemaps/van_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/van_facemap4',
			'models/bloo_ltcom_zel/citizens/facemaps/van_facemap5',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/van_facemap3',
			'models/bloo_ltcom_zel/citizens/facemaps/van_facemap8',
		},
	},
	['models/humans/octo/male_02_01.mdl'] = {
		name = 'Мужчина 2',
		skins = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
		faceIndex = 0,
		faces = {
			'models/humans/modern/male/male_02/facemap_01',
			'models/humans/modern/male/male_02/facemap_02',
			'models/humans/modern/male/male_02/facemap_03',
			'models/bloo_ltcom_zel/citizens/facemaps/ted_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/ted_facemap3',
			'models/bloo_ltcom_zel/citizens/facemaps/ted_facemap5',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/ted_facemap4',
			'models/bloo_ltcom_zel/citizens/facemaps/ted_facemap9',
			'models/bloo_ltcom_zel/citizens/facemaps/ted_facemap10',
		},
	},
	['models/humans/octo/male_03_01.mdl'] = {
		name = 'Мужчина 3',
		skins = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
		faceIndex = 3,
		faces = {
			'models/humans/modern/male/male_03/facemap_01',
			'models/humans/modern/male/male_03/facemap_02',
			'models/humans/modern/male/male_03/facemap_03',
			'models/humans/modern/male/male_03/facemap_04',
			'models/humans/modern/male/male_03/facemap_07',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/joe_facemap4',
			'models/bloo_ltcom_zel/citizens/facemaps/joe_facemap8',
			'models/bloo_ltcom_zel/citizens/facemaps/joe_facemap9',
			'models/bloo_ltcom_zel/citizens/facemaps/joe_facemap10',
		},
	},
	['models/humans/octo/male_04_01.mdl'] = {
		name = 'Мужчина 4',
		skins = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
		faceIndex = 2,
		faces = {
			'models/humans/modern/male/male_04/facemap_01',
			'models/humans/modern/male/male_04/facemap_02',
			'models/humans/modern/male/male_04/facemap_03',
			'models/humans/modern/male/male_04/facemap_04',
			'models/bloo_ltcom_zel/citizens/facemaps/eric_facemap',
			'models/bloo_ltcom_zel/citizens/facemaps/eric_facemap5',
			'models/bloo_ltcom_zel/citizens/facemaps/eric_facemap8',
			'models/bloo_ltcom_zel/citizens/facemaps/eric_facemap10',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/eric_facemap3',
			'models/bloo_ltcom_zel/citizens/facemaps/eric_facemap6',
			'models/bloo_ltcom_zel/citizens/facemaps/eric_facemap7',
			'models/bloo_ltcom_zel/citizens/facemaps/eric_facemap11',
			'models/bloo_ltcom_zel/citizens/facemaps/cheaple_face',
		},
	},
	['models/humans/octo/male_05_01.mdl'] = {
		name = 'Мужчина 5',
		skins = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
		faceIndex = 0,
		faces = {
			'models/humans/modern/male/male_05/facemap_01',
			'models/humans/modern/male/male_05/facemap_02',
			'models/humans/modern/male/male_05/facemap_03',
			'models/humans/modern/male/male_05/facemap_04',
			'models/humans/modern/male/male_05/facemap_05',
			'models/bloo_ltcom_zel/citizens/facemaps/art_facemap3',
			'models/bloo_ltcom_zel/citizens/facemaps/art_facemap5',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/art_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/art_facemap8',
			'models/bloo_ltcom_zel/citizens/facemaps/art_facemap9',
		},
	},
	['models/humans/octo/male_06_01.mdl'] = {
		name = 'Мужчина 6',
		skins = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
		faceIndex = 3,
		faces = {
			'models/humans/modern/male/male_06/facemap_01',
			'models/humans/modern/male/male_06/facemap_02',
			'models/humans/modern/male/male_06/facemap_03',
			'models/humans/modern/male/male_06/facemap_04',
			'models/humans/modern/male/male_06/facemap_05',
			'models/bloo_ltcom_zel/citizens/facemaps/sandro_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/sandro_facemap8',
			'models/bloo_ltcom_zel/citizens/facemaps/sandro_facemap9',
			'models/humans/modern/octo/patrickchief_face',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/sandro_facemap3',
			'models/bloo_ltcom_zel/citizens/facemaps/sandro_facemap5',
			'models/bloo_ltcom_zel/citizens/facemaps/sandro_facemap6',
			'models/bloo_ltcom_zel/citizens/facemaps/sandro_facemap10',
		},
	},
	['models/humans/octo/male_07_01.mdl'] = {
		name = 'Мужчина 7',
		skins = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
		faceIndex = 3,
		faces = {
			'models/humans/modern/male/male_07/facemap_01',
			'models/humans/modern/male/male_07/facemap_02',
			'models/humans/modern/male/male_07/facemap_03',
			'models/humans/modern/male/male_07/facemap_04',
			'models/humans/modern/male/male_07/facemap_05',
			'models/humans/modern/male/male_07/facemap_06',
			'models/bloo_ltcom_zel/citizens/facemaps/mike_facemap',
			'models/bloo_ltcom_zel/citizens/facemaps/mike_facemap3',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/mike_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/mike_facemap5',
			'models/bloo_ltcom_zel/citizens/facemaps/mike_facemap6',
		},
	},
	['models/humans/octo/male_08_01.mdl'] = {
		name = 'Мужчина 8',
		skins = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
		faceIndex = 4,
		faces = {
			'models/humans/modern/male/male_08/facemap_01',
			'models/humans/modern/male/male_08/facemap_02',
			'models/humans/modern/male/male_08/facemap_03',
			'models/humans/modern/male/male_08/facemap_04',
			'models/bloo_ltcom_zel/citizens/facemaps/vance_facemap',
			'models/bloo_ltcom_zel/citizens/facemaps/vance_facemap5',
			'models/bloo_ltcom_zel/citizens/facemaps/vance_facemap8',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/vance_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/vance_facemap3',
			'models/bloo_ltcom_zel/citizens/facemaps/vance_facemap6',
			'models/bloo_ltcom_zel/citizens/facemaps/vance_facemap7',
		},
	},
	['models/humans/octo/male_09_01.mdl'] = {
		name = 'Мужчина 9',
		skins = {0,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23},
		faceIndex = 4,
		faces = {
			'models/humans/modern/male/male_09/facemap_01',
			'models/humans/modern/male/male_09/facemap_02',
			'models/humans/modern/male/male_09/facemap_03',
			'models/humans/modern/male/male_09/facemap_04',
			'models/bloo_ltcom_zel/citizens/facemaps/erdim_facemap3',
			'models/bloo_ltcom_zel/citizens/facemaps/erdim_facemap6',
			'models/bloo_ltcom_zel/citizens/facemaps/erdim_facemap7',
		},
		premiumFaces = {
			'models/bloo_ltcom_zel/citizens/facemaps/erdim_facemap2',
			'models/bloo_ltcom_zel/citizens/facemaps/erdim_facemap5',
			'models/bloo_ltcom_zel/citizens/facemaps/erdim_facemap8',
			'models/bloo_ltcom_zel/citizens/facemaps/erdim_facemap11',
			'models/humans/male/group01/jensface',
		},
	},
}

dbgChars.config.selector = {
	rp_evocity_dbg_251024 = {
		pos = Vector(-7478.599609, -7916.663086, 512.031250),
		ang = Angle(2.136044, 90, 0),
	},
	rp_eastcoast_dbg_240821 = {
		pos = Vector(-1303, 2148, 192),
		ang = Angle(0, 75, 0),
	},
	default = {
		pos = Vector(),
		ang = Angle(),
	},
}
