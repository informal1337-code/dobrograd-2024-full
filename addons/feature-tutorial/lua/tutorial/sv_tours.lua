dbgTutorial.tours = dbgTutorial.tours or {}

function dbgTutorial.tours.start(ply, tourId)
    if not IsValid(ply) or not tourId then return end

    net.Start('dbgTutorial.tours.start')
    net.WriteString(tourId)
    net.Send(ply)
end

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

net.Receive('dbgTutorial.tours.finish', function(len, ply)
    local state = net.ReadBool()
    -- handle client finishing tour
end)

net.Receive('dbgTutorial.tours.next', function(len, ply)
    -- handle client requesting next step
end)
