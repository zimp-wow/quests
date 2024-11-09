function event_signal(e)
	entity_list = eq.get_entity_list();

	if(e.signal == 255) then
		local mobtypeID =  entity_list:GetMobByNpcTypeID(71012);
		local follow_mob = mobtypeID:GetID();
		eq.follow(follow_mob);
	elseif(e.signal == 254) then
		eq.stop_follow();
		eq.Repop();
	end
end


function event_death_complete(e)
	
	--[[if(eq.get_entity_list():IsMobSpawnedByNpcTypeID(71009)
		or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71008)
		or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71007)
		or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71015)
		or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71011)
		or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71010)
		or eq.get_entity_list():IsMobSpawnedByNpcTypeID(71014)) then
		eq.update_spawn_timer(2631,1000); --update to respawn in 1 sec if any spiroc except for lord are still up
	end]]--
end

-------------------------------------------------------------------------------------------------
-- Converted to .lua using MATLAB converter written by Stryd
-- Find/replace data for .pl --> .lua conversions provided by Speedz, Stryd, Sorvani and Robregen
-------------------------------------------------------------------------------------------------
