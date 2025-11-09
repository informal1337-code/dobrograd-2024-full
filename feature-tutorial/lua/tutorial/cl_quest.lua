-- "addons\\feature-tutorial\\lua\\tutorial\\cl_quest.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.quest = dbgTutorial.quest or {}

function dbgTutorial.quest.next()
	netstream.Start(octoquests.tempHookId(LocalPlayer(), 'dbgTutorial.quest.next'))
end

function dbgTutorial.quest.start()
	netstream.Start('dbgTutorial.quest.start')
end

function dbgTutorial.quest.skip()
	netstream.Start('dbgTutorial.quest.skip')
end