if CLIENT then
	netstream.Hook('sendLua', function(lua)
		pcall(RunString, lua)
	end)
end

if SERVER then
	local pmeta = FindMetaTable 'Player'

	function pmeta:SendLua(lua)
		netstream.Start(self, 'sendLua', lua)
	end

	function BroadcastLua(lua)
		netstream.Start(nil, 'sendLua', lua)
	end
end
