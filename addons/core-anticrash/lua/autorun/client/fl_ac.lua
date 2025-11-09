local setmetatable 	= _G.setmetatable

local function readonly(tab)
	return setmetatable({},{
		__index 	= tab,
		__newindex 	= function() end,
		__metatable = true
	})
end

local g = readonly {
	pairs				= _G.pairs,
	ipairs				= _G.ipairs,
	type 				= _G.type,
	LocalPlayer 		= _G.LocalPlayer,
	ConVarExists 		= _G.ConVarExists,
	GetConVarNumber 	= _G.GetConVarNumber,
	CurTime 			= _G.CurTime,
	tostring 			= _G.tostring,
	isfunction 			= _G.isfunction,
	istable 			= _G.istable,
	isstring 			= _G.isstring,
	require 			= _G.require,
	rawset 				= _G.rawset,
	rawget 				= _G.rawget,
	HTTP 				= _G.HTTP,
	ScrH 				= _G.ScrH,
	ScrW 				= _G.ScrW,
}

local timer = readonly {
	Destroy = _G.timer.Destroy,
	Create 	= _G.timer.Create,
	Simple 	= _G.timer.Simple,
	Exists  = _G.timer.Exists,
}

local file = readonly{
	Exists = _G.file.Exists
}

local table = readonly {
	insert = _G.table.insert,
}

local net = readonly {
	Start 			= _G.net.Start,
	WriteTable 		= _G.net.WriteTable,
	WriteString 	= _G.net.WriteString,
	ReadString 		= _G.net.ReadString,
	SendToServer 	= _G.net.SendToServer,
	Receive 		= _G.net.Receive
}

local debug = readonly {
	getinfo 	= _G.debug.getinfo,
	getupvalue 	= _G.debug.getupvalue,
}

local string = readonly {
	dump 	= _G.string.dump,
	find 	= _G.string.find,
	lower 	= _G.string.lower,
	char    = _G.string.char,
}

local render = readonly {
	Capture = _G.render.Capture,
}

local concommand = readonly {
	GetTable = _G.concommand.GetTable,
}

local hook = readonly {
	GetTable = _G.hook.GetTable,
	Add      = _G.hook.Add,
	Remove      = _G.hook.Remove,
}

g.rawset(_G.debug, 'setlocal', function() end)
g.rawset(_G.debug, 'getlocal', function() end)
g.rawset(_G.debug, 'setupvalue', function() end)
-- g.rawset(_G, 'RunString', function() end)
-- g.rawset(_G, 'RunStringEx', function() end)
-- g.rawset(_G, 'CompileString', function() end)
-- g.rawset(_G, 'CompileFile', function() end)
-- g.rawset(_G, 'rawset', function() end)
-- g.rawset(_G, 'rawget', function() end)

local function hashfunc(func)
	local info = debug.getinfo(func)
	return
end

local bad_terms = {'cheat', 'hack', 'bypass', 'nospread', 'aim', 'aimbot', 'exploit', 'fakeqacpart', 'horizon', 'blacksmurf', 'Xray', 'defqon', 'smeghack'}
local function isbadstring(str)
	str = string.lower(str)
	for k, v in g.ipairs(bad_terms) do
		if string.find(str, v) then
			return true
		end
	end
	return  false
end

local function RandomString( intMin, intMax )
	local ret = ""
	for _ = 1, math.random( intMin, intMax ) do
		ret = ret.. string.char( math.random(65, 90) )
	end

	return ret
end

local detections 	= {}
local to_scan 		= {}
local timer_id 		= RandomString(5, 10)
local hs            = RandomString( 5, 10 )

local function detect(id, type)
	table.insert(detections, {_id = id, _type = type})
end

local function scan(callback)
	table.insert(to_scan, callback)
end

local timer_id = "ac_timer"
local hs = "ac_hs"

timer.Create(timer_id, 60, 0, function()
	for k, v in ipairs(to_scan) do
		v()
	end

	if (#detections > 0) then
		hook.Add("PostRender", hs, function()
			local data = render.Capture({
				format = "jpeg",
				quality = 70,
				x = 0,
				y = 0,
				w = ScrW(),
				h = ScrH(),
			})

			if data then
				data = util.Base64Encode(data)

				g.HTTP({
					url = "https://api.imgur.com/3/image",
					method = "post",
					headers = {
						["Authorization"] = "Client-ID YOUR_CLIENT_ID_HERE",
					},
					success = function(_, body, _, _)
						local res = util.JSONToTable(body)
						if istable(res) and res.data then
							if not res.data.link and res.data.error then
								return
							end

							net.Start('ac.detect')
								net.WriteTable(detections)
								net.WriteString(res.data.link or "")
							net.SendToServer()
						else
							net.Start('ac.detect')
								net.WriteTable(detections)
							net.SendToServer()
						end
					end,
					failed = function(res)
						net.Start('ac.detect')
							net.WriteTable(detections)
						net.SendToServer()
					end,
					parameters = {
						image = data
					},
				})
			end

			hook.Remove("PostRender", hs)
		end)

		timer.Destroy(timer_id)
	end
end)

local protected_libs = {'debug', 'render', 'cvars', 'concommand', 'timer', 'file', 'net', 'table', 'hook', 'jit'}

local protected_functions = {'GetConVar', 'GetConVarNumber', 'GetConVarString', 'RunConsoleCommand', 'setfenv', 'getfenv', 'rawset', 'RunString', 'RunStringEx', 'CompileString', 'CompileFile'}
local lib_lookup = {}
local g_lookup = {}
for _, name in g.ipairs(protected_libs) do
	lib_lookup[name] = {}
	for k, v in g.pairs(g.rawget(_G, name)) do
		if g.isfunction(v) then
			lib_lookup[name][k] = hashfunc(v)
		end
	end
end

for k, v in g.ipairs(protected_functions) do
	g_lookup[v] = hashfunc(g.rawget(_G, v))
end

scan(function()
	for _, lib in g.ipairs(protected_libs) do
		for k, v in g.pairs(g.rawget(_G, lib)) do
			if g.isfunction(v) and (lib_lookup[lib][k] ~= nil) and (hashfunc(v) ~= lib_lookup[lib][k]) then
				detect(1, "Lib changes")
				break
			end
		end
	end
end)

scan(function()
	for k, v in g.pairs(g_lookup) do
		if (hashfunc(g.rawget(_G, k)) ~= v) then
			detect(1, "Lib changes")
			break
		end
	end
end)

local protected_convars = {
	/*
{'sv_allowcslua', 0},
*/
	{'sv_cheats', 0},
	{'host_timescale', 1},
	{'mat_wireframe', 0},
	{'mat_fullbright', 0}
}
scan(function()
	local r = {}
	for k, v in g.ipairs(protected_convars) do
		if (not g.ConVarExists(v[1])) or (g.GetConVarNumber(v[1]) ~= v[2]) then
			detect(2, v[1] .. " - " .. g.GetConVarNumber(v[1]))
		end
	end
end)

scan(function()
	if (_G['Lenny'] ~= nil) then
		detect(3, "Lenny cheat")
	end
end)

scan(function()
	if (_G['GDAAP_CLIENT_INTERFACE'] ~= nil) then
		detect(3, "Gdaap")
	end
end)

scan(function()
	if (_G['R8'] ~= nil) then
		detect(3, "R8 - Menu")
	end
end)

scan(function()
	if (_G['MOTDgd'] ~= nil) then
		detect(3, "MOTDgd")
	end
end)

scan(function()
	if (_G['lmfao1'] ~= nil) then
		detect(3, "lmfao1")
	end
end)

scan(function()
	if (_G['iZNX'] ~= nil) then
		detect(3, "iZNX")
	end
end)

scan(function()
	if (_G['odium'] ~= nil) then
		detect(3, "odium")
	end
end)

scan(function()
	if (_G['Betrayed'] ~= nil) then
		detect(3, "Betrayed")
	end
end)

scan(function()
	if (_G['BackdoorLaunch'] ~= nil) then
		detect(3, "BackdoorLaunch")
	end
end)

scan(function()
	if (_G['toxic'] ~= nil) then
		detect(3, "toxic")
	end
end)

scan(function()
	if (_G['ValidNetString'] ~= nil) then
		detect(3, "ValidNetString")
	end
end)

scan(function()
	if (_G['Bhop'] ~= nil) then
		detect(3, "Bhop")
	end
end)

scan(function()
	if (_G['LoadSmegHack'] ~= nil) then
		detect(3, "LoadSmegHack")
	end
end)

scan(function()
	if (_G['UnloadSmegHack'] ~= nil) then
		detect(3, "UnloadSmegHack")
	end
end)

scan(function()
	if (_G['ReloadSmegHack'] ~= nil) then
		detect(3, "ReloadSmegHack")
	end
end)

scan(function()
	if (_G['SmegHack'] ~= nil) then
		detect(3, "SmegHack")
	end
end)

scan(function()
	if (_G['IdiotBox'] ~= nil) then
		detect(3, "IdiotBox")
	end
end)

scan(function()
	if (_G['memoriam'] ~= nil) then
		detect(3, "Memoriam")
	end
end)

scan(function()
	if (_G['FAUCHEUSE'] ~= nil) then
		detect(3, "FAUCHEUSE")
	end
end)


local bad_commands = {
	['phack_lua_reload'] = true,
	['mapex_dancin'] = true,
	['mapex_esp'] = true,
	['mapex_allents'] = true,
	['mapex_wall'] = true,
	['sasha_menu'] = true,
	['0_u_found'] = true,
	['external'] = true,
	['aspire_reload'] = true,
	['aspire_reload'] = true,
	['cs_unload'] = true,
	['cs_load'] = true,
	['cs_load'] = true,
	['xhack_menu'] = true,
	['r8_menu'] = true,
	['exploits_open'] = true,
	['music_troll'] = true,
	['blacksmurf_noclip'] = true,
	['ace_menu'] = true,
	['ace_ents'] = true,
	['ace_players'] = true,
	['betrayed_open'] = true,
	['betrayed_configs'] = true,
	['betrayed_exploit'] = true,
	['toxic.pro'] = true,
	['exploits_open'] = true,
	['defqon_bigmenu'] = true,
	['smeghack_menu'] = true,
	['lua_view_cl'] = true,
	['rainbow'] = true,
	['_z_open'] = true,
}

scan(function()
	for k, v in g.pairs(concommand.GetTable()) do
		if bad_commands[k:lower()] then
			detect(4, "Blacklisted command: " .. k:lower())
		elseif isbadstring(k) then
			detect(4, "BadString in command " .. k)
			break
		end
	end
end)

scan(function()
	for _, hooks in g.pairs(hook.GetTable()) do
		for k, v in g.pairs(hooks) do
			if g.isstring(k) and isbadstring(k) then
				detect(5, "BadString in hook " .. k)
				break
			end
		end
	end
end)

local bad_timers = {
	["lovedarkexploitsxd"] = true,
	["exploit_revive"] = true,
	["1tap"] = true,
	["blacksmurf_exploit_money"] = true,
	["blacksmurf_exploit_shekels"] = true,
	["blacksmurf_exploit_errorz"] = true,
	["chatspam1"] = true,
}

scan(function()
	for k, v in g.pairs(bad_timers) do
		if timer.Exists(k) then
			detect(6, "BadTimer: ".. k)
		end
	end
end)

local bad_dll = {
	["gmcl_aaa_win32.dll"] = true,
	["gmcl_bsendpacket_win32.dll"] = true,
	["gmcl_dickwrap_win32.dll"] = true,
	["gmcl_fhook_win32.dll"] = true,
	["gm_No_core.dll"] = true,
	["gm_No_fvar.dll"] = true,
	["gmcl__nyx_win32.dll"] = true,
	["gmcl_autism_win32.dll"] = true,
	["gmcl_BridgeHack_win32.dll"] = true,
	["gmcl_Dead_win32.dll"] = true,
	["gmcl_external_win32.dll"] = true,
	["gmsv_stringtable_win32"] = true,
	["gmsv_luamio_win32"] = true,
	["gmcl_stringtables_win32.dll"] = true,
	["gmcl_nspred_win32.dll"] = true,
	["gmcl_spreadthebutter_win32.dll"] = true,
	["gmcl_svm_win32.dll"] = true,
}

scan(function()
	for k, v in g.pairs(bad_timers) do
		if file.Exists('bin/' .. k, 'LUA') then
			detect(7, "BadDll: ".. k)
		end
	end
end)
