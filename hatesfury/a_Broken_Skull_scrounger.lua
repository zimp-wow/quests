-- Drunken Event and Navigator Event

function event_death_complete(e)
    eq.signal(228107,1,0); -- #Navigator_counter
    eq.signal(228113,1,0); -- #drunk_counter
end