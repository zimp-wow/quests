-- Shadow Knight Pre Epic

-- Bucket Name: Epic-Ranger-CharacterID

-- Field 1 = Epic 1.5 Prequest Status - Completed = 2
-- Field 2 = Epic 1.5 Status - Completed = 12
-- Field 3 = Epic 2.0 Status - Completed = 10
-- Field 4 = Epic 2.5 Status - Completed = 1

-- Epic 1.5 Prequest Details - Subfield 1 (INT)
---- SubField - 1 - Initial Dialog Completed
---- SubField - 2 - Turn in items - Pre Epic Complete

-- Epic 1.5 Details - Subfield 2 (INT) - Must have Prequest or Swiftwind AND Earthcaller
---- SubField - 1 - Initial Dialog Done
---- SubField - 2 - Speak with Maelin
---- SubField - 3 - Turn in Egg to Maelin
---- SubField - 4 - Give Book to Sienn
---- SubField - 5 - Give Sheath to Sienn
---- SubField - 6 - Give Parchment to Sienn
---- SubField - 7 - Give Wailings to Sienn
---- SubField - 8 - Give Innorukks Voice to Gilina
---- SubField - 9 - Give 4 heads to Gilina
---- SubField - 10 - Give 3 Bloods and Sheathed Voice to Gilina
---- SubField - 11 - Loot Holy Symbol (Chest)
---- SubField - 12 - Give Symbol to Bilina - Get Epic 1.5, AA, Title - Completed

-- Epic 2.0 Details - Subfield 3 (INT)
---- SubField - 1 - Initial Dialog Completed
---- SubField - 2 - Give head to Gilina
---- SubField - 3 - Complete Gilina
---- SubField - 4 - Give 3 Lhran's items to Gilina
---- SubField - 5 - Give Filigono Anchor and 2.0 Orb
---- SubField - 6 - Loot Essence of the Shadowknight (Chest)
---- SubField - 7 - Give Essence and Innoruuk's Voice to Fillgno - 2.0, AA, Title - Completed

function event_say(e)
	if e.other:HasClass(Class.SHADOWKNIGHT) then -- Shadow Knight Only

		local data_bucket = ("Epic-ShadowKnight-"..e.other:CharacterID());

		local epic_pre_onefive	= nil;	-- Epic 1.5 Pre Quest Status
		local epic_onefive		= nil;	-- Epic 1.5 Status
		local epic_two			= nil;	-- Epic 2.0 Status
		local epic_twofive		= nil;	-- Epic 2.5 Status
		local s					= nil;	-- Status Array

		if eq.get_data(data_bucket) ~= "" then -- Has Started
			local temp = eq.get_data(data_bucket);
			s = eq.split(temp, ',');
	
			epic_pre_onefive	= tonumber(s[1]);
			epic_onefive		= tonumber(s[2]);		
			epic_two			= tonumber(s[3]);
			epic_twofive		= tonumber(s[4]);
		else -- Set variables to 0 and update databuckets
			epic_pre_onefive = 0;
			epic_onefive = 0;
			epic_two = 0;
			epic_twofive = 0;
			update_shadowknight_epic_databucket(e,epic_pre_onefive,epic_onefive,epic_two,epic_twofive); -- Create empty bucket
		end

		if epic_pre_onefive == 0 and not e.other:HasItem(14383) then
			if e.message:findi("hail") then
				e.other:Message(MT.NPCQuestSay, "Ritald says 'Greetings, dark one. Do you feel it? I am sure you do. Innoruuk's voice is so distant now. His voice is merely a whisper. This disturbs me greatly. How will the evil ones do their master's bidding without his dark guidance? I fear the end is almost near for true champions of darkness such as yourself. We cannot let that happen! I believe I know of a way to slow down the diminishing of our master's voice. There is a sword of great evil. It is however not of this world. I believe I can summon it to this plane of existence, but I will need several items first. Will you [take on this task]? Your future and the future of all our dark brethren depends on obtaining this sword!'");
			elseif e.message:findi("task") then
				e.other:Message(MT.NPCQuestSay, "Ritald says 'Excellent. There is no time to waste. The first item I need is an ancient flamberge of hatred. I believe a trollish pirate named, Captain Varns, here in Dulak's Harbor is in possession of one. Destroy him and return this item to me. The second item is an essence of hate. You should be able to find such an essence in the Plane of Hate. The last item I need is a stormborn phylactery. You should be able to find one in the Plane of Storms. When you have all these items, hand them to me so that I may begin the summoning of the sword.'");
				update_shadowknight_epic_databucket(e,1,epic_onefive,epic_two,epic_twofive);
			end
		elseif epic_pre_onefive == 2 and e.message:findi("done") then
			e.other:Message(MT.NPCQuestSay, "Ritald says 'This sword known as Innoruuk's Voice emanates great evil. It should help to generate enough evil to sustain the mysterious powers that make one a shadowknight. It is not at full power yet however. I am now trusting you to take this sword and help to recover its full power. You will be its new champion. Take it to Sienn Kastane in the Plane of Knowledge. I believe she should be able to help you with returning the sword to its full power.'");
		end
	end
end

function event_trade(e)
	local item_lib = require("items");
	if e.other:HasClass(Class.SHADOWKNIGHT) then -- Ranger Only
		local data_bucket = ("Epic-ShadowKnight-"..e.other:CharacterID());


		if eq.get_data(data_bucket) ~= "" then -- Has Started
			local temp = eq.get_data(data_bucket);
			s = eq.split(temp, ',');

			local epic_pre_onefive	= tonumber(s[1]);
			local epic_onefive		= tonumber(s[2]);		
			local epic_two			= tonumber(s[3]);
			local epic_twofive		= tonumber(s[4]);

			if epic_pre_onefive == 1 and item_lib.check_turn_in(e.self, e.trade, {item1 = 55902, item2 = 21870, item3 = 21782}) then -- Items: Ancient Flamberge of Hatred, Essence of Hate, and Stormborn Phylactery
				e.other:Message(MT.NPCQuestSay, "Ritald says 'You have done well. The flamberge you have brought to me will act as a vessel for the summoning of the sword. The essence of hate will help generate hatred needed to fuel the summoning, and the phylactery should hopefully help contain that hate to be used in the summoning.' Ritald holds the flamberge above his head with both hands and begins to chant. Dark storm clouds gather overhead as a flash of lightning momentarily blinds you. When you regain your sight, Ritald holds the summoned sword of Innoruuk's Voice. 'I [have done it]!'");
				e.other:SummonItem(22944); -- Item: Innoruuk's Voice [non-functional]
				update_shadowknight_epic_databucket(e,2,epic_onefive,epic_two,epic_twofive);
			end
		end
	end
	item_lib.return_items(e.self, e.other, e.trade);
end

function update_shadowknight_epic_databucket(e,pre_one_five,one_five,two,two_five)
	eq.set_data("Epic-ShadowKnight-"..e.other:CharacterID(), pre_one_five..","..one_five..","..two..","..two_five);
	e.other:Message(MT.Yellow, "Your quest has been advanced"); -- Made up to let people know the flags have been updated.
end
