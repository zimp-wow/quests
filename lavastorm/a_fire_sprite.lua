function event_say(e)
	if(e.message:findi("hail")) then
		e.self:Emote("ignores you.");
	elseif(e.message:findi("challenge eejag")) then
		e.self:Emote("lets loose a loud roar.");
		eq.depop_with_timer();
		eq.spawn2(27119,0,0,-100, -7, -11, 462); -- NPC: Eejag
	end
end
