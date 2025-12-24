-- Anti-cheat: Monitor for external Lua code execution
-- This detects when Lua code is compiled from external sources (potential injection)

if CLIENT then
	pcall(jit.attach, function(f)
		local source = jit.util.funcinfo(f).source
		if string.sub(source, 2) ~= 'external' then return end
		
		-- Log locally for debugging
		octolib.logger.debug('External code execution detected: ' .. source)
		
		-- Notify server of suspicious activity
		net.Start('octolib_anticheat_external')
		net.SendToServer()
	end, 'bc')
end
