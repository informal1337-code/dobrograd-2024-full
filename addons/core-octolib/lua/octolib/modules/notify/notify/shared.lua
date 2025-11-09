-- "addons\\core-octolib\\lua\\octolib\\modules\\notify\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
octolib.notify = octolib.notify or {}

if SERVER then
	octolib.notify.models = octolib.notify.models or {}
end

octolib.include.prefixed('realtime')
octolib.include.prefixed('persistent')
