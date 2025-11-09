-- "addons\\feature-phone\\lua\\phone\\modules\\calls\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgPhone.ringtones = {
	{
		title = 'Стандартный',
		path = 'phone/phone_ringtone1.wav',
		duration = 3,
	},
	{
		title = 'Стандартный 2',
		path = 'phone/phone_ringtone6.wav',
		duration = 14,
	},
	{
		title = 'Стандартный 3',
		path = 'phone/phone_ringtone7.wav',
		duration = 10,
	},
	{
		isHidden = true,
		path = 'phone/phone_vibration.wav',
		duration = 3,
		volume = 25,
	},
	{
		title = 'Яблочный',
		path = 'phone/phone_ringtone2.wav',
		duration = 3.6,
	},
	{
		title = 'Колокольчик',
		path = 'phone/phone_ringtone3.wav',
		duration = 3,
	},
	{
		title = 'Китайский',
		path = 'phone/phone_ringtone4.wav',
		duration = 18.6,
	},
	{
		title = 'Моторольный',
		path = 'phone/phone_ringtone5.wav',
		duration = 12,
	},
	{
		title = 'Пианино',
		path = 'phone/phone_ringtone8.wav',
		duration = 14,
	},
	{
		title = 'Музыкальный',
		path = 'phone/phone_ringtone9.wav',
		duration = 20.5,
		volume = 50,
	},
	{
		title = 'Гитарный',
		path = 'phone/phone_ringtone10.wav',
		duration = 18,
		volume = 50,
	},
	{
		title = 'Энергичный',
		path = 'phone/phone_ringtone11.wav',
		duration = 26,
	},
}

dbgPhone.callSound = {
	path = 'phone/phone_waiting.wav',
	duration = 27.5,
}

dbgPhone.busySounds = {
	['busy'] = 'phone/phone_busy.wav',
	['deny'] = 'phone/phone_deny.wav',
}

dbgPhone.timeout = 60
dbgPhone.callPrice = 100