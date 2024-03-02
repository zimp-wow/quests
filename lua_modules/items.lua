local items = {}

function items.check_turn_in(trade, trade_check)
	--create trade_return table == trade
	--shallow copy
	local trade_return = {};
	for key, value in pairs(trade) do
		trade_return[key] = value;
	end
	
	for i = 1, 4 do
		local key = "item" .. i;
		if trade_check[key] ~= nil and trade_check[key] ~= 0 then
			local found = false;
			for j = 1, 4 do
				local inst = trade_return["item" .. j];
				if inst.valid then
					local item_id = inst:GetID()
					local item_name = eq.get_item_name(item_id)
					local base_item_id = nil -- Variable to store the ID of the base item if adjustments are needed
					
					-- Check for 'Rose Colored ' prefix and adjust item ID if necessary
					if string.sub(item_name, 1, 13) == "Rose Colored " then
						local stripped_name = string.sub(item_name, 14)
						if eq.get_item_name(item_id - 70000) == stripped_name then
							base_item_id = item_id - 70000
						elseif eq.get_item_name(item_id - 700000) == stripped_name then
							base_item_id = item_id - 700000
						end
					-- Check for 'Apocryphal ' prefix and adjust item ID if necessary
					elseif string.sub(item_name, 1, 11) == "Apocryphal " then
						local stripped_name = string.sub(item_name, 12)
						if eq.get_item_name(item_id - 80000) == stripped_name then
							base_item_id = item_id - 80000
						elseif eq.get_item_name(item_id - 800000) == stripped_name then
							base_item_id = item_id - 800000
						end
					end
					
					-- Check if the original or adjusted item ID matches what's required in trade_check
					if trade_check[key] == item_id or trade_check[key] == base_item_id then
						trade_return["item" .. j] = ItemInst(); -- Invalidate the found item
						found = true
						break
					end
				end
			end
			
			if not found then
				return false
			end
		end
	end
	
	--convert our money into copper then check that we have enough then convert change back
	local trade_check_money = 0;
	local return_money = 0;
	
	if(trade_check["platinum"] ~= nil and trade_check["platinum"] ~= 0) then
		trade_check_money = trade_check_money + (trade_check["platinum"] * 1000);
	end
	
	if(trade_check["gold"] ~= nil and trade_check["gold"] ~= 0) then
		trade_check_money = trade_check_money + (trade_check["gold"] * 100);
	end
	
	if(trade_check["silver"] ~= nil and trade_check["silver"] ~= 0) then
		trade_check_money = trade_check_money + (trade_check["silver"] * 10);
	end
	
	if(trade_check["copper"] ~= nil and trade_check["copper"] ~= 0) then
		trade_check_money = trade_check_money + trade_check["copper"];
	end
	
	return_money = return_money + trade_return["platinum"] * 1000 + trade_return["gold"] * 100;
	return_money = return_money + trade_return["silver"] * 10 + trade_return["copper"];
	
	if(return_money < trade_check_money) then
		return false;
	else
		return_money = return_money - trade_check_money;
	end
	
	--replace trade with trade_return
	trade.item1 = trade_return.item1;
	trade.item2 = trade_return.item2;
	trade.item3 = trade_return.item3;
	trade.item4 = trade_return.item4;
	
	trade.platinum = math.floor(return_money / 1000);
	return_money = return_money - (trade.platinum * 1000);
	
	trade.gold = math.floor(return_money / 100);
	return_money = return_money - (trade.gold * 100);
	
	trade.silver = math.floor(return_money / 10);
	return_money = return_money - (trade.silver * 10);
	
	trade.copper = return_money;
	return true;
end

function items.return_items(npc, client, trade, text)
	text = text or true;
	local returned = false;
	for i = 1, 4 do
		local inst = trade["item" .. i];
		if(inst.valid) then
			if(eq.is_disc_tome(inst:GetID()) and npc:GetClass() > 19 and npc:GetClass() < 36) then
				if(client:GetClass() == npc:GetClass() - 19) then
					client:TrainDisc(inst:GetID());
				else
					npc:Say(string.format("You are not a member of my guild. I will not train you!"));
					client:PushItemOnCursor(inst);
					returned = true;
				end
			else
				client:PushItemOnCursor(inst);
				if(text == true) then
					npc:Say(string.format("I have no need for this %s, you can have it back.", client:GetCleanName()));
				end
				returned = true;
			end
		end
	end
	
	local money = false;
	if(trade.platinum ~= 0) then
		returned = true;
		money = true;
	end
	
	if(trade.gold ~= 0) then
		returned = true;
		money = true;
	end
	
	if(trade.silver ~= 0) then
		returned = true;
		money = true;
	end
	
	if(trade.copper ~= 0) then
		returned = true;
		money = true;
	end
	
	if(money == true) then
		client:AddMoneyToPP(trade.copper, trade.silver, trade.gold, trade.platinum, true);
	end
	
	return returned;
end
	
return items;
