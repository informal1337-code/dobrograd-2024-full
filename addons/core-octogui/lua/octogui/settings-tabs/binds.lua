hook.Add('octolib.settings.createTabs', 'binds', function(add, buildFuncs)
    add({
        order = 3,
        name = 'Бинды',
        icon = 'key',
        build = function(parent)
            local cont = vgui.Create('DScrollPanel', parent)
            cont:SetPaintBackground(false)
            cont:Dock(FILL)
            
            buildFuncs.title(cont, 'Бинды')
            
            octolib.label(cont, 'Чтобы убрать назначение клавиши, нажми правую кнопку мыши')

            for i = 1, #octolib.bind.cache do
                local row = cont:Add 'octolib_bind_row'
                row:SetBind(i)
            end

            octolib.button(cont, 'Создать', function()
                octolib.bind.set(nil, KEY_SPACE, 'chat', 'Привет!')
            end)
            
            return cont
        end,
    })
end)