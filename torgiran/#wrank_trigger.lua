-- Overseer Wrank Event

local key_counter = 0;
local captain_counter = 0;

function event_spawn(e)
    key_counter = 0; -- Ensure Counter is Reset
    captain_counter = 0; -- Ensure Counter is Reset
    eq.spawn2(226066,0,0,479,197,3,382); -- #Overseer_Wrank
end

function event_signal(e)
    if(e.signal == 1) then
        key_counter = key_counter + 1;
    elseif(e.signal == 2) then
        key_counter = key_counter + 2;
    elseif(e.signal == 3) then
        key_counter = key_counter + 3;
    elseif(e.signal == 4) then
        key_counter = key_counter + 4;
    elseif(e.signal == 11) then
        captain_counter = captain_counter + 1;
    end

    if(key_counter == 20) then -- 20 Keys Turned In, Start Event
        eq.spawn2(226109,0,0,109,62,2.7,430); -- #Captain_Nago
        eq.spawn2(226203,0,0,109,195,2.7,430); -- #Captain_Lung
        eq.spawn2(226202,0,0,220,195,2.7,430); -- #Captain_Lkai
        eq.spawn2(226201,0,0,220,62,2.7,430); -- #Captain_Flang
        eq.zone_emote(MT.White,"Overseer Wrank yells, 'Captains, stand at attention. There are invaders in the mines."); -- Emote the zone
		eq.set_timer("resetkey", 3 * 1000);
        
    end

    if(captain_counter == 4) then -- All four captains are dead
        eq.signal(226066,1,0); -- #Overseer_Wrank
        eq.spawn2(226095,0,0,479,197,3,382); -- Overseer_Wrank
        eq.zone_emote(MT.White,"The ground trembles as the magic protecting Overseer Wrank fails."); -- Emote the zone
        eq.set_timer("resetcaptain", 3 * 1000);
        --eq.depop_with_timer();
    end
end

function event_timer(e)
	if (e.timer == "resetkey") then
		eq.stop_timer("resetkey");
		key_counter = 0; -- reset counter
	elseif (e.timer == "resetcaptain") then
		eq.stop_timer("resetcaptain");
		captain_counter = 0; -- reset counter
		eq.depop_with_timer();
	end
end
