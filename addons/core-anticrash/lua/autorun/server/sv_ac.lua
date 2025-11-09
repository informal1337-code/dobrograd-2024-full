util.AddNetworkString("_Detect")
util.AddNetworkString('Sandbox_ArmDupe')
util.AddNetworkString('Ulib_Message')
util.AddNetworkString('DarkRP_AdminWeapons')
util.AddNetworkString('ac.detect')


net.Receive("DarkRP_AdminWeapons", function(len, ply)
	ply:Kick("Exploits: 1")
end)

net.Receive("StackGhost", function(len, ply)
	ply:Kick("Exploits: 2")
end)

net.Receive("Sandbox_ArmDupe", function(len, ply)	
		ply:Kick("Exploits: 3")																																																																						
end)

net.Receive("Ulib_Message", function(len, ply)
	ply:Kick("Exploits: 4")	
end)

net.Receive("_Detect", function(len,ply)
	local a = net.ReadString()
	if a == "external" then
		ply:Kick("Exploits: 5")	
	elseif a == '' then
		ply:Kick("Exploits: 6")	
	end
end)

local nextlog = 0

local a = 0

timer.Create("sd.CheckMoney_Kick..", 2, 0, function()
	if a == 2 then
		a = 0
	end
end)

function net.Incoming( len, client )

	local i = net.ReadHeader()
	local strName = util.NetworkIDToString( i )

	if(strName == "editvariable") then return end

	if strName == 'gangs.update_top_list' then return end

	if strName == '_Detect' then return end

	if ( !strName ) then return end

	local func = net.Receivers[ strName:lower() ]
	if ( !func ) then return end

	len = len - 16

	if IsValid(client) then
		client.netcache = (client.netcache or 0) + 1
		timer.Simple(5, function()
			if IsValid(client) then
				client.netcache = (client.netcache or 0) - 1
			end
		end)
		if client.netcache > 60 then
			if CurTime() > nextlog then
				local Timestamp = os.time()
				local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )

				if not file.Exists("lognetfucker.txt","DATA") then
					file.Write("lognetfucker.txt",client:Name().." ("..client:SteamID()..") - "..TimeString.."  NET: "..strName.."\n")
				else
					file.Append("lognetfucker.txt",client:Name().." ("..client:SteamID()..") - "..TimeString.."  NET: "..strName.."\n")
				end
				nextlog = CurTime() + 15
			end
            if strName == 'NetStreamDS' then
                if a != 2 then
                    RunConsoleCommand('sg', 'a', 'A players attempt to crash the server: ' .. client:Nick() .. '(' .. client:SteamID() .. ')' )
                    a = 2
                end
                RunConsoleCommand('sg', 'ban', client:SteamID(), 24 * 60, 'Server crash attempt')
            end
            client:Kick('You have been kicked for spamming NET messages')
		end
	end

	func( len, client )
end

local net_ReadHeader=net.ReadHeader -- cuz localz goes faster
local util_NetworkIDToString=util.NetworkIDToString
local gamers=player.GetHumans
local isnumber=isnumber
local print=print

for k,v in pairs(gamers()) do
    v.kicked=false
end

function net.Incoming( len, client )
    local i = net_ReadHeader()
    local strName = util_NetworkIDToString( i )
   
    if ( !strName ) then return end
    if !isnumber(client.net_per_sec) then
        client.net_per_sec=1
    else
        client.net_per_sec=client.net_per_sec+1
    end

    if client.net_per_sec>500 then -- 333 -- 1999 300
        if client.kicked then return end
         client.kicked=true
		 if a != 2 then
			RunConsoleCommand('sg', 'a', 'Possible server crash attempt by a player: ' .. client:Nick() .. '(' .. client:SteamID() .. ')' )
			a = 2
		end
         client:Kick('Possible server crash attempt')
    end 
 
    local func = net.Receivers[ strName:lower() ]
    if ( !func ) then return end
    len = len - 16
     
    if not pcall(func,len,client) then
         client.net_per_sec=client.net_per_sec+10
    end

    file.Append( "net_logger.txt", util.DateStamp( ) .. "\t[" .. client:SteamID( ) .. "] \t" .. client:Nick( ) .. "\t\"" .. strName:lower( ) .. "\"\n" )
end


timer.Create("net_per_sec",1,0,function()
    for i=1,#gamers() do
        gamers()[i].net_per_sec=0
    end
end) 

hook.Add('PlayerSpawnedProp', 'AntiGay_PS', function(pl, mdl, ent)

	for k, v in pairs(ents.FindInSphere(ent:LocalToWorld(ent:OBBCenter()), ent:BoundingRadius())) do
        if v:IsPlayer() and not v:InVehicle() and not tobool(v:GetObserverMode()) or v:IsVehicle() then
            if ent:NearestPoint(v:NearestPoint(ent:GetPos())):Distance(v:NearestPoint(ent:GetPos())) <= 20 then
              	ent.lalka = true
            end
        end
    end

    if ent.lalka then
    	ent:Remove()			
           pl:SendLua("GAMEMODE:AddNotify(\"В вашем пропе мог застрять игрок, мы предотвратили это.\", NOTIFY_GENERIC, 5)")
    end
end)