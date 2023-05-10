--Fabled Magus Rokyl (1120001078)

--we have spawned! lets roar!
function event_spawn(e)
	phase = 1;
	e.self:Emote(" Appears in a puff of smoke!");
	e.self:Shout("I'm sorry my Lord! I could have swore something was looking at me...");
	SpawnCrystal(e);
	
end

--when someone is trying to send us a message... ignore for now
function event_signal(e)
	
end

--we are rooted, dun care :p
function event_waypoint_arrive(e)

end

-- when combat starts/ends.  Joins = starts, else = ends
function event_combat(e)
	
	if (e.joined) then
		e.self:Emote(" Glances around...");
		e.self:Shout("You puny things, feel the power of my magic!");
		--lets get some pressure on the tank, and anyone who is stupid enough
		--be in front of the mob :)
		eq.set_timer("Heal", math.random(1000,3000));
		eq.set_timer("CastRain", math.random(3000,4000));
		eq.set_timer("CastSingleNuke", math.random(3000,4000));
		eq.set_timer("CastBIGNuke", 20000);
		eq.set_timer("CheckCloseHateDistance",  math.random(5000,6000));
		
	else
		--check to see if we purposefully wiped the hate list, if so ignore this
		eq.stop_timer("Heal");
		eq.stop_timer("CastRain");
		eq.stop_timer("CastSingleNuke");
		eq.stop_timer("CastBIGNuke");
	end
end
function SpawnCrystal(e)

	local xloc = e.self:GetX();
	local yloc = e.self:GetY();
	local zloc = e.self:GetZ();
	local heading = e.self:GetHeading();
	-- sanity depop
	eq.depop_all(1120001079);
	-- spawn randomly around Magus.
	eq.spawn2(1120001079,0,0,xloc +10,yloc + 10,zloc,heading);

end

function SummonPlayer(e)

	local rand_hate = e.self:GetHateClosest();
	local xloc = e.self:GetX();
	local yloc = e.self:GetY();
	local zloc = e.self:GetZ();
	if (rand_hate.valid and rand_hate:IsClient() and not e.self:IsMezzed() and not rand_hate:IsPet()) then
		local rand_hate_v = rand_hate:CastToClient()
		if (rand_hate_v.valid) then
			if(e.self:CalculateDistance(rand_hate:GetX(), rand_hate:GetY(), rand_hate:GetZ()) >30) then
				e.self:CastSpell(9079, rand_hate:GetID());
				eq.zone_emote(MT.Emote, "Rokyl rips apart the fabric of space and time to get to his target. Chaos leaks into the room. (Everyone takes 5,000 damage!!!!)");
				e.self:CameraEffect(500,5);
				e.self:DamageAreaClients(5000,300);
				return true;
			end
		end
		
	end
	return false;

end
function event_timer(e)
	
	
	if(e.timer == "Heal") then
		eq.stop_timer(e.timer);
		if(e.self:IsCasting()) then
			eq.set_timer("Heal", 500);
			return;
		end
		e.self:Shout("'My Lord, let me heal you!");
		HealNagafen(e)
		eq.set_timer("Heal",15000);
	elseif(e.timer=="CheckCloseHateDistance") then
		if(e.self:IsCasting()) then
			eq.set_timer("CheckCloseHateDistance", 500);
			return;
		end
		SummonPlayer(e);
		eq.set_timer("CheckCloseHateDistance", 1000);
	
	elseif (e.timer=="CastBIGNuke") then
		eq.stop_timer(e.timer);
	
		if(e.self:IsCasting()) then
			eq.set_timer("CastBIGNuke", 500);
			return;
		end
		e.self:Shout("I call upon the flames to strike you down!");
		local rand_hate = e.self:GetHateClosest();
		e.self:CastSpell(19563, rand_hate:GetID());
		eq.set_timer("CastBIGNuke", 20000);
		
	elseif (e.timer == "CastRain") then
		eq.stop_timer(e.timer);
		
		if(e.self:IsCasting()) then
			eq.set_timer("CastRain", 500);
			return;
		end
		
		e.self:CastSpell(39861, e.self:GetHateClosest():GetID());
		eq.set_timer("CastSingleNuke", 1000);
		
		
	elseif (e.timer=="CastSingleNuke") then
		eq.stop_timer(e.timer);
	
		if(e.self:IsCasting()) then
			eq.set_timer("CastSingleNuke", 500);
			return;
		end
		--e.self:Shout("'There is no hiding from my magic!");
		e.self:CastSpell(26588, e.self:GetHateRandom():GetID());
		eq.set_timer("CastRain", 1000);
	
	end
end

function HealNagafen(e)

	--1120001072 = lord nagafen
	e.self:CastSpell(39862,eq.get_entity_list():GetNPCByNPCTypeID(1120001072):GetID());
end

function event_hp(e)
	
end

function event_death_complete(e)

	e.self:Shout("My Lord... I have failed you...");
	
end
