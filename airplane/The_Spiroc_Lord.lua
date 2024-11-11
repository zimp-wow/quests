function event_combat(e)
	if(eq.get_entity_list():IsMobSpawnedByNpcTypeID(71013)) then
		eq.set_timer("reset", 300000);
		eq.signal(71007, 255); --a_spiroc_banisher
		eq.signal(71008, 255); --a_spiroc_arbiter
		eq.signal(71009, 255); --a_spiroc_vanquisher
		eq.signal(71010, 255); --a_spiroc_revolter
		eq.signal(71011, 255); --a_spiroc_expulser
		eq.signal(71013, 255); --The_Spiroc_Guardian
		eq.signal(71014, 255); --a_spiroc_walker
		eq.signal(71015, 255); --a_spiroc_caller
	end
end

function event_timer(e)
	if(e.timer == "reset") then
		eq.signal(71007, 254); --a_spiroc_banisher
		eq.signal(71008, 254); --a_spiroc_arbiter
		eq.signal(71009, 254); --a_spiroc_vanquisher
		eq.signal(71010, 254); --a_spiroc_revolter
		eq.signal(71011, 254); --a_spiroc_expulser
		eq.signal(71013, 254); --The_Spiroc_Guardian
		eq.signal(71014, 254); --a_spiroc_walker
		eq.signal(71015, 254); --a_spiroc_caller
	end
end
function event_death_complete(e)
		local instance_id = eq.get_zone_instance_id() or 0;
		eq.set_data("airplane-sirran-" .. instance_id, "5", tostring(eq.seconds("24h")));
		eq.spawn2(71058,0,0,955,-570,466,390); -- NPC: Sirran_the_Lunatic
	--[[if(eq.get_entity_list():IsMobSpawnedByNpcTypeID(71013) or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71009)) then
		eq.update_spawn_timer(2630,1000); --update to respawn in 1 sec if vanquisher or guardian are still up
	end]]--
end
