function event_death_complete(e)
	local instance_id = eq.get_zone_instance_id() or 0;
	local airplane_sirran_status = tonumber(eq.get_data("airplane-sirran-" .. instance_id)) or 0;

	if not (eq.get_entity_list():IsMobSpawnedByNpcTypeID(71009) or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71020) or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71022)) then
		eq.set_data("airplane-sirran-" .. instance_id, "5", tostring(eq.seconds("24h")));
		eq.unique_spawn(71058,0,0,955,-570,466,390); -- NPC: Sirran_the_Lunatic
	end

	eq.signal(71013, 1); -- The_Spiroc_Guardian
end

function event_killed_merit(e)
    if not e.other then
        eq.debug("Error: `e.other` is nil.")
        return
    end
    
    local count = tonumber(e.other:GetEntityVariable("bird_farmer")) or 0
    count = count + 1

    if count > 100 then
        e.other:SetBucket("flag-semaphore", "204")
        e.other:DeleteEntityVariable("bird_farmer")
        e.other:Signal(100) -- Uncomment if Signal is available
    else
        e.other:SetEntityVariable("bird_farmer", tostring(count or "0"))
    end
end