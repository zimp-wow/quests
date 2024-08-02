-- Drunken Event

local drunk = 0;

function event_spawn(e)
    drunk = 0; -- Ensure Counter is Reset
end

function event_signal(e)
    local drunken_mob = eq.get_entity_list():GetMobByNpcTypeID(228111);

    if(e.signal == 1) then
        drunk = drunk + 1;
    end

    if(drunk == 26 and not drunken_mob.valid) then -- Spawn Drunken Mob
        eq.unique_spawn(228111,0,0,431,1006,-607.4, 0); -- the_Drunken_Buccaneer
        drunk = 0; -- Reset Counter
--        eq.depop();
    elseif(drunk == 26 and drunken_mob.valid) then -- Mobs already up
        drunk = 0; -- Reset Counter
    end
end