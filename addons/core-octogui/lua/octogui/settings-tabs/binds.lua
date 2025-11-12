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

            local function refreshBinds()
                cont:Clear()
                buildFuncs.title(cont, 'Бинды')
                octolib.label(cont, 'Чтобы убрать назначение клавиши, нажми правую кнопку мыши')

                octolib.bind.cache = octolib.bind.cache or {}

                if #octolib.bind.cache > 0 then
                    for i = 1, #octolib.bind.cache do
                        local row = cont:Add 'octolib_bind_row'
                        if IsValid(row) then
                            row:SetBind(i)
                        end
                    end
                else
                    octolib.label(cont, 'Нет созданных биндов')
                end

                octolib.button(cont, 'Создать', function()
                    if octolib.bind and octolib.bind.set then
                        octolib.bind.set(nil, KEY_SPACE, 'chat', 'Привет!')
                        timer.Simple(0.5, function()
                            if IsValid(cont) then
                                refreshBinds()
                            end
                        end)
                    else
                        print("ERROR: octolib.bind.set is not available")
                    end
                end)
            end

            timer.Simple(0, function()
                if IsValid(cont) then
                    refreshBinds()
                end
            end)

            return cont
        end,
    })
end)