-- "addons\\feature-phone\\lua\\phone\\modules\\calls\\cl_notifications.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local phoneNotifies = CreateClientConVar('cl_dbg_phone_notifies', '1')
octolib.notify.register('phone', function(text, isImportant)
	if not isImportant and not phoneNotifies:GetBool() then return end

	octolib.notify.types.rp(text)
end)