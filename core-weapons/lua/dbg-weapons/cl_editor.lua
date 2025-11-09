-- "addons\\core-weapons\\lua\\dbg-weapons\\cl_editor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local c = Color(255, 125, 125)
local n = Color(125, 255, 125)
local function e(t, e)
    return e.SightPos ~= nil
end

local function o(t, e)
    local e = e.csEnt
    return IsValid(e) and e:GetBodygroup(e:FindBodygroupByName('scope')) == 1
end

local t = {
    {
        desc = 'Звук выстрела',
        key = 'Primary.Sound',
        type = 'strShort',
    },
    {
        desc = 'Звук выстрела в дали',
        key = 'Primary.DistantSound',
        type = 'strShort',
    },
    {
        desc = 'Урон',
        key = 'Primary.Damage',
        type = 'numScratch',
        min = 0,
        max = 1e3,
    },
    {
        desc = 'Скорострельность',
        key = 'Primary.RPM',
        type = 'numScratch',
        min = 0,
        max = 2e3,
        dec = 0,
    },
    {
        desc = 'Разброс',
        key = 'Primary.Spread',
        type = 'numScratch',
        min = 0,
        max = 25,
    },
    {
        desc = 'Реальная отдача вверх',
        key = 'Primary.KickUp',
        type = 'numScratch',
        min = 0,
        max = 60,
    },
    {
        desc = 'Реальная отдача вниз',
        key = 'Primary.KickDown',
        type = 'numScratch',
        min = 0,
        max = 60,
    },
    {
        desc = 'Реальная отдача вбок',
        key = 'Primary.KickHorizontal',
        type = 'numScratch',
        min = 0,
        max = 25,
    },
    {
        desc = 'Визуальная отдача X',
        key = 'VisualRecoilHorizontal',
        type = 'numScratch',
        min = 0,
        max = 25,
    },
    {
        desc = 'Визуальная отдача Y',
        key = 'VisualRecoilVertical',
        type = 'numScratch',
        min = 0,
        max = 60,
    },
    {
        desc = 'Скорость возврата виз. отдачи',
        key = 'VisualRecoilRecoverRate',
        type = 'numScratch',
        min = 0,
        max = 100,
    },
    {
        desc = 'Дистанция полета пули',
        key = 'Primary.Distance',
        type = 'numScratch',
        min = 0,
        max = 3e3,
    },
    {
        desc = 'Вместимость магазина',
        key = 'Primary.ClipSize',
        type = 'numScratch',
        min = 0,
        max = 2e3,
        dec = 0,
    },
    {
        desc = 'Позиция вылета пули',
        key = 'MuzzlePos',
        neighbor = 'MuzzleAng',
        type = 'vector',
        prepare = function(t, e)
            if e then return e end
            local c = t.MuzzlePosAngPerHoldType
            e = (c[t.ActiveHoldType] or c._default)[1]
            t.MuzzlePos = e
            return e
        end,
        visualize = function(e, t, t)
            local t, o = e:AlvWULRKzsZItVPGVsyffWssAoESvCpvolR()
            local e = t:ToScreen()
            local t = (t + o * 50):ToScreen()
            surface.SetDrawColor(c)
            surface.DrawLine(e.x, e.y, t.x, t.y)
            draw.SimpleTextOutlined('•', nil, e.x, e.y, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
        end,
    },
    {
        desc = 'Угол вылета пули',
        key = 'MuzzleAng',
        neighbor = 'MuzzlePos',
        type = 'vector',
        prepare = function(t, e)
            if e then return e end
            local c = t.MuzzlePosAngPerHoldType
            e = (c[t.ActiveHoldType] or c._default)[2]
            t.MuzzleAng = e
            return e
        end,
    },
    {
        desc = 'Позиция камеры в прицеле',
        key = 'AlnXXjzqcLCZCgdoHAEAPUJHdnCkXKQYvDwTnvK',
        realKey = 'AimPos',
        type = 'vector',
    },
    {
        desc = 'Угол камеры в прицеле',
        key = 'WMtwbPbFORUixACUsihxBlVwBhphewUBIOykdZqsrK',
        realKey = 'AimAng',
        type = 'vector',
    },
    {
        desc = 'Материал в прицеле',
        key = 'ScopeReticleMaterial',
        type = 'strShort',
        canShow = o,
    },
    {
        desc = 'Размер материала в прицеле',
        key = 'ScopeReticleSize',
        type = 'numScratch',
        min = .01,
        max = 5,
        canShow = o,
    },
    {
        desc = 'Режим стрельбы по умолчанию',
        key = 'DefaultFireMode',
        type = 'numScratch',
        min = 1,
        max = 10,
        dec = 0,
    },
    {
        desc = 'Доступные режимы стрельбы',
        key = 'FireModes',
        type = 'checkGroup',
        isArray = true,
        opts = {{'Автоматический', 'auto'}, {'Очередь', 'burst'}, {'Одиночный', 'single'},},
    },
    {
        desc = 'Скорострельность очередью',
        key = 'BurstRPM',
        type = 'numScratch',
        min = 0,
        max = 2e3,
        dec = 0,
    },
    {
        desc = 'Кол-во патрон в очереди',
        key = 'BurstAmount',
        type = 'numScratch',
        min = 0,
        max = 2e3,
        dec = 0,
    },
    {
        desc = 'Задержка между очередями',
        key = 'BurstDelay',
        type = 'numScratch',
        min = 0,
        max = 25,
    },
    {
        desc = 'Звук перезарядки',
        key = 'ReloadSound',
        type = 'strShort',
    },
    {
        desc = 'Время перезарядки',
        key = 'ReloadTime',
        type = 'numScratch',
    },
    {
        desc = 'Звук после перезарядки',
        key = 'ReloadEndSound',
        type = 'strShort',
    },
    {
        desc = 'Звук после выстрела',
        key = 'ShootEndSound',
        type = 'strShort',
    },
    {
        desc = 'Задержка звука после выстрела',
        key = 'ShootEndSoundDelay',
        type = 'numScratch',
    },
    {
        desc = 'Звук пустого выстрела',
        key = 'NoAmmoSound',
        type = 'strShort',
    },
    {
        desc = 'Позиция прицела',
        key = 'SightPos',
        type = 'vector',
        canShow = e,
    },
    {
        desc = 'Угол прицела',
        key = 'SightAng',
        type = 'vector',
        canShow = e,
    },
    {
        desc = 'Радиус прицела',
        key = 'SightSize',
        type = 'numScratch',
        canShow = e,
    },
    {
        desc = 'FOV прицела',
        key = 'SightFOV',
        type = 'numScratch',
        canShow = e,
    },
    {
        desc = 'Начальная дальность прорисовки прицела',
        key = 'SightZNear',
        type = 'numScratch',
        canShow = e,
    },
    {
        desc = 'Уровни приближения прицела',
        key = 'SightZoomLevels',
        type = 'table',
        canShow = e,
    },
    {
        desc = 'Позиция фонарика (если есть)',
        key = 'FlashlightPos',
        type = 'vector',
        visualize = function(t, e, c)
            local t = t:GetOwner()
            local c = t:LookupAttachment('anim_attachment_RH')
            local t = t:GetAttachment(c)
            if not t then return end
            e = LocalToWorld(e, angle_zero, t.Pos, t.Ang)
            local e = e:ToScreen()
            draw.SimpleTextOutlined('•', nil, e.x, e.y, n, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
        end,
    },
    {
        desc = 'Угол фонарика (если есть)',
        key = 'FlashlightAng',
        type = 'vector',
    },
    {
        desc = 'Размер ореола фонарика (если есть)',
        key = 'FlashlightHalo',
        type = 'numScratch',
        min = .05,
        max = 5,
    },
}

octolib.testHelper.addCategory('weapons', {
    name = 'Оружие',
    icon = octolib.icons.silk16('gun'),
})

octolib.testHelper.addMethod('weapons.openEditor', {
    name = 'Открыть редактор',
    parent = 'weapons',
}, function()
    local e = LocalPlayer():GetActiveWeapon()
    if not IsValid(e) or not e.IsOctoWeapon then
        Derma_Message('Сначала нужно взять оружие!', 'Ой...', 'Хорошо')
        return
    end

    local e = dbgEntityEditor.buildMenu(e, t)
    e:CenterVertical()
    e:AlignRight(20)
    e:SetTitle('Редактор оружия')
end)