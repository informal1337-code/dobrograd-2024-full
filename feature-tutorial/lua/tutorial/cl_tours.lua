-- "addons\\feature-tutorial\\lua\\tutorial\\cl_tours.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours = dbgTutorial.tours or {}

function dbgTutorial.tours.start(tourId)
	octolib.tour.start(dbgTutorial.tours.list[tourId])
end

function dbgTutorial.tours.finish(state)
	if state == false then
		octolib.tour.stop()
	else
		octolib.tour.finish()
	end
end

function dbgTutorial.tours.next()
	octolib.tour.nextStep()
end

netstream.Hook('dbgTutorial.tours.start', dbgTutorial.tours.start)

netstream.Hook('dbgTutorial.tours.finish', function(state)
	dbgTutorial.tours.finish(state)
end)

netstream.Hook('dbgTutorial.tours.next', dbgTutorial.tours.next)