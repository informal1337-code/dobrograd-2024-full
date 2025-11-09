-- "addons\\feature-tutorial\\lua\\tutorial\\sh_tours.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
dbgTutorial.tours = dbgTutorial.tours or {}

if CLIENT then
	dbgTutorial.tours.list = dbgTutorial.tours.list or {}

	function dbgTutorial.tours.register(tourId, struct)
		dbgTutorial.tours.list[tourId] = struct
	end
end

octolib.include.client('tours/')