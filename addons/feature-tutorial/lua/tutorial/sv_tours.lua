dbgTutorial.tours = dbgTutorial.tours or {}

function dbgTutorial.tours.finish(ply, state)
    if not IsValid(ply) then return end
    
    net.Start('dbgTutorial.tours.finish')
    net.WriteBool(state or true)
    net.Send(ply)
end

function dbgTutorial.tours.next(ply)
    if not IsValid(ply) then return end
    
    net.Start('dbgTutorial.tours.next')
    net.Send(ply)
end

net.Receive('dbgTutorial.tours.start', function(len, ply)
end) --у я з в и м а я х у е т а

net.Receive('dbgTutorial.tours.finish', function(len, ply)
    local state = net.ReadBool()
end)

net.Receive('dbgTutorial.tours.next', function(len, ply)
end)