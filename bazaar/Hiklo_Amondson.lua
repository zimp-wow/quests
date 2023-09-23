-- items: 21800, 21820, 21801, 21821, 21802, 21822, 21803, 21823
function event_say(e)
	if(e.message:findi("Hail")) then
		e.self:Say("Greetings " .. e.other:GetName() .. ". Were you hoping I would have a quest for you?... BEGONE!");
		$client->MovePC($client->GetBindZoneID, $client->GetBindX, $client->GetBindY, $client->GetBindZ, $client->GetBindHeading);
	end
end

--function event_trade(e)
	--local item_lib = require("items");
	--if(item_lib.check_turn_in(e.trade, {item1 = 21800})) then
		--e.other:SummonItem(21820); -- Item: Bag of Platinum Pieces

	--elseif(item_lib.check_turn_in(e.trade, {item1 = 21801})) then
		--e.other:SummonItem(21821); -- Item: Heavy Bag of Platinum

	--elseif(item_lib.check_turn_in(e.trade, {item1 = 21802})) then
		--e.other:SummonItem(21822); -- Item: Big Bag of Platinum

	--elseif(item_lib.check_turn_in(e.trade, {item1 = 21803})) then
		--e.other:SummonItem(21823); -- Item: Huge Bag of Platinum
	--end
	--item_lib.return_items(e.self, e.other, e.trade)
--end

-------------------------------------------------------------------------------------------------
-- Converted to .lua using MATLAB converter written by Stryd
-- Find/replace data for .pl --> .lua conversions provided by Speedz, Stryd, Sorvani and Robregen
-------------------------------------------------------------------------------------------------
