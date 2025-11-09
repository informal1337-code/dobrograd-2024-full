dbgTutorial = dbgTutorial or {}

--resource.AddWorkshop("") -- надо найти материалы говна

if not file.Exists("dbg_tutorial", "DATA") then
    file.CreateDir("dbg_tutorial")-- мне лень дб юзать сорян
end

octolib.server('tutorial/sv_tours')
octolib.server('tutorial/sv_quest')