include 'shared.lua'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

ENT.DPU = 10
ENT.DrawShared = true
ENT.DrawPos = Vector(2.65, -35, 22.5)
ENT.DrawAng = Angle(0, 90, 90)

surface.CreateFont('city-board.title', {
    font = 'Calibri',
    extended = true,
    size = 48,
    weight = 350,
})

-- Хранилище новостей
ENT.NewsStorage = ENT.NewsStorage or {}

local colors = CFG.skinColors

-- Регистрация команды для админов
if SERVER then
    util.AddNetworkString("CityBoard_PostNews")
    
    concommand.Add("cityboard_post_news", function(ply, _, args)
        if not ply:IsAdmin() then return end
        
        local title = table.remove(args, 1)
        local content = table.concat(args, " ")
        
        if #title < 5 or #content < 10 then
            ply:ChatPrint("Использование: cityboard_post_news [заголовок] [содержание]")
            return
        end
        
        table.insert(ENT.NewsStorage, {
            title = title,
            content = content,
            date = os.date("%d.%m.%Y %H:%M"),
            author = ply:Nick()
        })
        
        -- Синхронизация с клиентами
        net.Start("CityBoard_PostNews")
        net.WriteTable(ENT.NewsStorage)
        net.Broadcast()
    end)
end

function ENT:InitPanel(pnl)
    pnl:SetSize(700, 450)
    
    function pnl:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, colors.bg)
    end

    -- Контейнер для контента
    local contentPanel = vgui.Create("DPanel", pnl)
    contentPanel:Dock(FILL)
    contentPanel:DockMargin(10, 10, 10, 10)
    contentPanel:SetPaintBackground(false)
    
    -- Заголовок
    local title = octolib.label(contentPanel, "Восточное побережье сегодня")
    title:SetFont('city-board.title')
    title:SetContentAlignment(5)
    title:SetTall(50)
    
    -- Панель новостей
    local newsPanel = vgui.Create("DScrollPanel", contentPanel)
    newsPanel:Dock(FILL)
    newsPanel:DockMargin(0, 10, 0, 0)
    
    -- Функция отображения списка новостей
    local function showNewsList()
        newsPanel:Clear()
        
        if #self.NewsStorage == 0 then
            local empty = octolib.label(newsPanel, "Новостей пока нет")
            empty:SetContentAlignment(5)
            empty:SetTall(50)
            return
        end
        
        for i, news in ipairs(self.NewsStorage) do
            local newsBtn = vgui.Create("DButton", newsPanel)
            newsBtn:SetText("")
            newsBtn:SetTall(80)
            newsBtn:Dock(TOP)
            newsBtn:DockMargin(0, 0, 0, 5)
            
            -- Кастомная прорисовка кнопки новости
            function newsBtn:Paint(w, h)
                draw.RoundedBox(4, 0, 0, w, h, colors.panel)
                
                draw.SimpleText(news.title, "DermaDefaultBold", 10, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(news.date .. " | " .. news.author, "DermaDefault", 10, 40, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
            
            -- Открытие полной новости
            newsBtn.DoClick = function()
                showFullNews(news)
            end
        end
    end
    
    -- Функция отображения полной новости
    local function showFullNews(news)
        newsPanel:Clear()
        
        local backButton = octolib.button(newsPanel, "← Назад", function()
            showNewsList()
        end)
        backButton:Dock(TOP)
        backButton:SetTall(30)
        backButton:DockMargin(0, 0, 0, 10)
        
        local title = octolib.label(newsPanel, news.title)
        title:SetFont("DermaLarge")
        title:SetContentAlignment(5)
        title:SetTall(40)
        
        local content = octolib.label(newsPanel, news.content)
        content:SetMultiline(true)
        content:SetWrap(true)
        content:SetAutoStretchVertical(true)
        content:Dock(FILL)
    end
    
    -- Кнопка добавления новости для админов
    if LocalPlayer():IsAdmin() then
        local postBtn = octolib.button(contentPanel, "Добавить новость", function()
            Derma_StringRequest(
                "Добавление новости",
                "Введите заголовок:",
                "",
                function(title)
                    Derma_StringRequest(
                        "Содержание новости",
                        "Введите содержание:",
                        "",
                        function(content)
                            RunConsoleCommand("cityboard_post_news", title, content)
                        end
                    )
                end
            )
        end)
        postBtn:Dock(BOTTOM)
        postBtn:SetTall(30)
        postBtn:DockMargin(0, 10, 0, 0)
    end
    
    -- Инициализация списка новостей
    showNewsList()
    
    -- Обработчик обновления новостей с сервера
    net.Receive("CityBoard_PostNews", function()
        self.NewsStorage = net.ReadTable()
        showNewsList()
    end)
end