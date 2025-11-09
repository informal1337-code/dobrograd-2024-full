-- "addons\\core-octolib\\lua\\octolib\\modules\\notify\\realtime\\cl_nets.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
netstream.Hook('octolib.notify', function(type, ...)
	octolib.notify.show(type, ...)
end)
