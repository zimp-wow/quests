function event_spawn(e)
	instance_id = eq.get_zone_instance_id() or 0;
end
function event_hate_list(e)
	eq.set_timer("reset", 300000);
	if(eq.get_entity_list():IsMobSpawnedByNpcTypeID(71009)) then
		eq.SignalMobsByNPCID(71007, 255); --a_spiroc_banisher
		eq.SignalMobsByNPCID(71008, 255); --a_spiroc_arbiter
		eq.SignalMobsByNPCID(71009, 255); --a_spiroc_vanquisher
		eq.SignalMobsByNPCID(71010, 255); --a_spiroc_revolter
		eq.SignalMobsByNPCID(71011, 255); --a_spiroc_expulser
		eq.SignalMobsByNPCID(71013, 255); --The_Spiroc_Guardian
		eq.SignalMobsByNPCID(71014, 255); --a_spiroc_walker
		eq.SignalMobsByNPCID(71015, 255); --a_spiroc_caller
	end
end

function event_timer(e)
	if(e.timer == "Shout") then
		eq.SignalMobsByNPCID(71007, 254); --a_spiroc_banisher
		eq.SignalMobsByNPCID(71008, 254); --a_spiroc_arbiter
		eq.SignalMobsByNPCID(71009, 254); --a_spiroc_vanquisher
		eq.SignalMobsByNPCID(71010, 254); --a_spiroc_revolter
		eq.SignalMobsByNPCID(71011, 254); --a_spiroc_expulser
		eq.SignalMobsByNPCID(71013, 254); --The_Spiroc_Guardian
		eq.SignalMobsByNPCID(71014, 254); --a_spiroc_walker
		eq.SignalMobsByNPCID(71015, 254); --a_spiroc_caller
	end
end
function event_death_complete(e)
		eq.set_data("airplane-sirran-".. instance_id, "5");
		eq.spawn2(71058,0,0,955,-570,466,390); -- NPC: Sirran_the_Lunatic
	--[[if(eq.get_entity_list():IsMobSpawnedByNpcTypeID(71013) or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71009)) then
		eq.update_spawn_timer(2630,1000); --update to respawn in 1 sec if vanquisher or guardian are still up
	end]]--
end
