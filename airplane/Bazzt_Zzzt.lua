function event_spawn(e)
	instance_id = eq.get_zone_instance_id() or 0;
end
function event_death_complete(e)
	eq.set_data("airplane-sirran-" .. instance_id, "7", tostring(eq.seconds("24h")));
	eq.spawn2(71058,0,0,-960,-1037,1093,128); -- NPC: Sirran_the_Lunatic
end
