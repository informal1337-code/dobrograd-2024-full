-- "addons\\core-characters\\lua\\dbg-characters\\ragdoll\\cl_ragdoll.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
netstream.Hook('dbgChars.ragdoll.enabled', function(ragdoll)
	octolib.whenNotNull(ragdoll, function()
		hook.Run('dbgChars.ragdoll.enabled', ragdoll[1])
	end)
end)

netstream.Hook('dbgChars.ragdoll.disabled', function()
	hook.Run('dbgChars.ragdoll.disabled')
end)
