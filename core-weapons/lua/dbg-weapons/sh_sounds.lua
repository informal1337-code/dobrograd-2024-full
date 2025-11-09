-- "addons\\core-weapons\\lua\\dbg-weapons\\sh_sounds.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function s(t, o, n, e)
    local a = a and .5 or 1
    sound.Add({
        name = t,
        channel = CHAN_USER_BASE + 10,
        volume = 1,
        sound = o,
        pitch = {95, 105},
        level = 75 * a,
    })

    if n then
        sound.Add({
            name = t .. '-distant',
            channel = CHAN_USER_BASE + 11,
            volume = e and .05 or 1,
            sound = n,
            pitch = {95, 105},
            level = (e and 85 or 95) * a,
        })
    end
end

s('beretta.fire', 'weapons-new/pistols/beretta_92/beretta_92_shot.wav', 'weapons-new/pistols/beretta_92/beretta_92_shot_distant.wav')
s('taurus_judge.fire', 'weapons-new/pistols/taurus_judge/taurus_judge_shot.wav', 'weapons-new/pistols/taurus_judge/taurus_judge_shot_distant.wav')
s('cobra.fire', 'weapons-new/pistols/colt_cobra/colt_cobra_shot.wav', 'weapons-new/pistols/colt_cobra/colt_cobra_shot_distant.wav')
s('python.fire', 'weapons-new/pistols/colt_python/colt_python_shot.wav', 'weapons-new/pistols/colt_python/colt_python_shot_distant.wav')
s('cz75.fire', 'weapons-new/pistols/cz-75/cz-75_shot.wav', 'weapons-new/pistols/cz-75/cz-75_shot_distant.wav')
s('deagle.fire', 'weapons-new/pistols/desert_eagle/desert_eagle_shot.wav', 'weapons-new/pistols/desert_eagle/desert_eagle_shot_distant.wav')
s('fiveseven.fire', 'weapons-new/pistols/five-seven/five-seven_shot.wav', 'weapons-new/pistols/five-seven/five-seven_shot_distant.wav')
s('glock-17.fire', 'weapons-new/pistols/glock-17/glock_17_shot.wav', 'weapons-new/pistols/glock-17/glock_17_shot_distant.wav')
s('hi-point_c-9.fire', 'weapons-new/pistols/hi-point_c-9/hi-point_c-9_shot.wav', 'weapons-new/pistols/hi-point_c-9/hi-point_c-9_shot_distant.wav')
s('hk_usp.fire', 'weapons-new/pistols/hk_usp/hk_usp_shot.wav', 'weapons-new/pistols/hk_usp/hk_usp_shot_distant.wav')
s('p226.fire', 'weapons-new/pistols/p226/p226_shot.wav', 'weapons-new/pistols/p226/p226_shot_distant.wav')
s('waltherp38.fire', 'weapons-new/pistols/waltherp38/waltherp38_shot.wav', 'weapons-new/pistols/waltherp38/waltherp38_shot_distant.wav')
s('pm.fire', 'weapons-new/pistols/makarov/makarov_shot.wav', 'weapons-new/pistols/makarov/makarov_shot_distant.wav')
s('1911.fire', 'weapons-new/pistols/M1911/1911_shot.wav', 'weapons-new/pistols/M1911/1911_shot_distant.wav')
s('spectre_m4.fire', 'weapons-new/smg/spectre_m4/spectre_m4_shot.wav', 'weapons-new/smg/spectre_m4/spectre_m4_shot_distant.wav')
s('pp19_bizon.fire', 'weapons-new/smg/pp19_bizon/pp19_bizon_shot.wav', 'weapons-new/smg/pp19_bizon/pp19_bizon_shot_distant.wav')
s('mac10.fire', 'weapons-new/smg/mac10/mac10_shot.wav', 'weapons-new/smg/mac10/mac10_shot_distant.wav')
s('tec9.fire', 'weapons-new/smg/tec9/tec9_shot.wav', 'weapons-new/smg/tec9/tec9_shot_distant.wav')
s('ar15_pistol.fire', 'weapons-new/smg/ar15_pistol/ar15_pistol_shot.wav', 'weapons-new/smg/ar15_pistol/ar15_pistol_shot_distant.wav')
s('smg919.fire', 'weapons-new/smg/smg919/smg919_shot.wav', 'weapons-new/smg/smg919/smg919_shot_distant.wav')
s('mp7.fire', 'weapons-new/smg/mp7/mp7_shot.wav', 'weapons-new/smg/mp7/mp7_shot_distant.wav')
s('mp5.fire', 'weapons-new/smg/mp5/mp5_shot.wav', 'weapons-new/smg/mp5/mp5_shot_distant.wav')
s('p90.fire', 'weapons-new/smg/p90/p90_shot.wav', 'weapons-new/smg/p90/p90_shot_distant.wav')
s('tmp.fire', 'weapons-new/smg/tmp/tmp_shot.wav', 'weapons-new/smg/tmp/tmp_shot_distant.wav', true)
s('ump45.fire', 'weapons-new/smg/ump45/ump45_shot.wav', 'weapons-new/smg/ump45/ump45_shot_distant.wav')
s('tar21.fire', 'weapons-new/assault_rifles/tar_21/tar_21_shot.wav', 'weapons-new/assault_rifles/tar_21/tar_21_shot_distant.wav')
s('ak74.fire', 'weapons-new/assault_rifles/ak_74/ak_74_shot.wav', 'weapons-new/assault_rifles/ak_74/ak_74_shot_distant.wav')
s('ak105.fire', 'weapons-new/assault_rifles/ak_105/ak_105_shot.wav', 'weapons-new/assault_rifles/ak_105/ak_105_shot_distant.wav')
s('ak74u.fire', 'weapons-new/assault_rifles/ak_74u/ak_74u_shot.wav', 'weapons-new/assault_rifles/ak_74u/ak_74u_shot_distant.wav')
s('aug.fire', 'weapons-new/assault_rifles/steyr_aug/steyr_aug_shot.wav', 'weapons-new/assault_rifles/steyr_aug/steyr_aug_shot_distant.wav')
s('g36.fire', 'weapons-new/assault_rifles/hk_g36/hk_g36_shot.wav', 'weapons-new/assault_rifles/hk_g36/hk_g36_shot_distant.wav')
s('galil.fire', 'weapons-new/assault_rifles/galil/galil_shot.wav', 'weapons-new/assault_rifles/galil/galil_shot_distant.wav')
s('m4a1.fire', 'weapons-new/assault_rifles/m4a1/m4a1_shot.wav', 'weapons-new/assault_rifles/m4a1/m4a1_shot_distant.wav')
s('sg552.fire', 'weapons-new/assault_rifles/sg552_acog/sg552_acog_shot.wav', 'weapons-new/assault_rifles/sg552_acog/sg552_acog_shot_distant.wav')
s('hk416.fire', 'weapons-new/assault_rifles/hk416/hk416_shot.wav', 'weapons-new/assault_rifles/hk416/hk416_shot_distant.wav')
s('ar15.fire', 'weapons-new/assault_rifles/ar_15/ar_15_shot.wav', 'weapons-new/assault_rifles/ar_15/ar_15_shot_distant.wav')
s('famas.fire', 'weapons-new/assault_rifles/famas/famas_shot.wav', 'weapons-new/assault_rifles/famas/famas_shot_distant.wav')
s('db.fire', 'weapons-new/shotguns/double_barrel/double_barrel_shot.wav', 'weapons-new/shotguns/double_barrel/double_barrel_shot_distant.wav')
s('dbs.fire', 'weapons-new/shotguns/double_barrel_so/double_barrel_so_shot.wav', 'weapons-new/shotguns/double_barrel_so/double_barrel_so_shot_distant.wav')
s('m3.fire', 'weapons-new/shotguns/m3/m3_super_90_shot.wav', 'weapons-new/shotguns/m3/m3_super_90_shot_distant.wav')
s('rem870.fire', 'weapons-new/shotguns/remington870/remington_870_shot.wav', 'weapons-new/shotguns/remington870/remington_870_shot_distant.wav')
s('xm1014.fire', 'weapons-new/shotguns/xm1014/xm_1014_shot.wav', 'weapons-new/shotguns/xm1014/xm_1014_shot_distant.wav')
s('browning.fire', 'weapons-new/shotguns/browning_a5/browning_a5_shot.wav', 'weapons-new/shotguns/browning_a5/browning_a5_shot_distant.wav')
s('awm.fire', 'weapons-new/sniper_rifles/awm/awm_shot.wav', 'weapons-new/sniper_rifles/awm/awm_shot_distant.wav')
s('remsr.fire', 'weapons-new/sniper_rifles/remington_msr/remington_msr_shot.wav', 'weapons-new/sniper_rifles/remington_msr/remington_msr_shot_distant.wav')
s('scout.fire', 'weapons-new/sniper_rifles/scout/scout_shot.wav', 'weapons-new/sniper_rifles/scout/scout_shot_distant.wav')
s('sg550.fire', 'weapons-new/sniper_rifles/sg550/sg550_shot.wav', 'weapons-new/sniper_rifles/sg550/sg550_shot_distant.wav')
s('rem700.fire', 'weapons-new/sniper_rifles/remington_700/remington_700_shot.wav', 'weapons-new/sniper_rifles/remington_700/remington_700_shot_distant.wav')
s('svd.fire', 'weapons-new/sniper_rifles/svd/svd_shot.wav', 'weapons-new/sniper_rifles/svd/svd_shot_distant.wav')
s('m249.fire', 'dbg/weapons/m249/m249-1.wav', 'dbg/weapons/m249/m249-1-distant.wav')
s('beanbag.fire', 'weapons/beanbag/beanbagfire.wav', 'weapons/beanbag/beanbagfire.wav', true)
s('1911.fire_s', 'weapons-new/pistols/M1911/1911_shot_s.wav', 'weapons-new/pistols/M1911/1911_shot_s_distant.wav', true)
s('pm.fire_s', 'weapons-new/pistols/makarov/makarov_shot_s.wav', 'weapons-new/pistols/makarov/makarov_shot_s_distant.wav')
s('hk_usp.fire_s', 'weapons-new/pistols/hk_usp/hk_usp_shot_s.wav', 'weapons-new/pistols/hk_usp/hk_usp_shot_s_distant.wav')
s('mp7.fire_s', 'weapons-new/smg/mp7/mp7_shot_s.wav', 'weapons-new/smg/mp7/mp7_shot_s_distant.wav')
s('mp5.fire_s', 'weapons-new/smg/mp5/mp5_shot_s.wav', 'weapons-new/smg/mp5/mp5_shot_s_distant.wav')
s('p90.fire_s', 'weapons-new/smg/p90/p90_shot_s.wav', 'weapons-new/smg/p90/p90_shot_s_distant.wav')
s('tmp.fire_s', 'weapons-new/smg/tmp/tmp_shot_s.wav', 'weapons-new/smg/tmp/tmp_shot_s_distant.wav', true)
s('ump45.fire_s', 'weapons-new/smg/ump45/ump45_shot_s.wav', 'weapons-new/smg/ump45/ump45_shot_s_distant.wav')
s('ak74.fire_s', 'weapons-new/assault_rifles/ak_74/ak_74_shot_s.wav', 'weapons-new/assault_rifles/ak_74/ak_74_shot_s_distant.wav')
s('ak105.fire_s', 'weapons-new/assault_rifles/ak_105/ak_105_shot_s.wav', 'weapons-new/assault_rifles/ak_105/ak_105_shot_s_distant.wav')
s('hk416.fire_s', 'weapons-new/assault_rifles/hk416/hk416_shot_s.wav', 'weapons-new/assault_rifles/hk416/hk416_shot_s_distant.wav')
s('ar15.fire_s', 'weapons-new/assault_rifles/ar_15/ar_15_shot_s.wav', 'weapons-new/assault_rifles/ar_15/ar_15_shot_s_distant.wav')
s('rem700.fire_s', 'weapons-new/sniper_rifles/remington_700/remington_700_shot_s.wav', 'weapons-new/sniper_rifles/remington_700/remington_700_shot_s_distant.wav')