-- Overseer Wrank Event

--Trade Block
function event_trade(e)
    local item_lib = require("items");
    if(item_lib.check_turn_in(e.self, e.trade, {item1 = 2485, item2 = 2485, item3 = 2485, item4 = 2485})) then --
        e.self:Emote("thanks you and scurries off into the shadows");
        eq.signal(226200,4,0); -- #wrank_trigger
        e.other:QuestReward(e.self,0,0,0,0,0,400000); -- 100k Exp For Each Key
    elseif(item_lib.check_turn_in(e.self, e.trade, {item1 = 2485, item2 = 2485, item3 = 2485})) then --
        e.self:Emote("thanks you and scurries off into the shadows");
        eq.signal(226200,3,0); -- #wrank_trigger
        e.other:QuestReward(e.self,0,0,0,0,0,300000); -- 100k Exp For Each Key
    elseif(item_lib.check_turn_in(e.self, e.trade, {item1 = 2485, item2 = 2485})) then --
        e.self:Emote("thanks you and scurries off into the shadows");
        eq.signal(226200,2,0); -- #wrank_trigger
        e.other:QuestReward(e.self,0,0,0,0,0,200000); -- 100k Exp For Each Key
    elseif(item_lib.check_turn_in(e.self, e.trade, {item1 = 2485})) then --
        e.self:Emote("thanks you and scurries off into the shadows");
        eq.signal(226200,1,0); -- #wrank_trigger
        e.other:QuestReward(e.self,0,0,0,0,0,100000); -- 100k Exp For Each Key
    end
    item_lib.return_items(e.self, e.other, e.trade)
end