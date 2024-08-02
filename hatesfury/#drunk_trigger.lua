-- Drunken Event

function event_spawn(e)
    local xloc = e.self:GetX();
    local yloc = e.self:GetY();
    eq.set_proximity(xloc - 10, xloc + 10, yloc - 10, yloc + 10);
end

function event_enter(e)
    eq.spawn2(228113,0,0,0,0,0,0); -- #drunk_counter
--    eq.depop_with_timer();
end