local function editor(e)
    local target = e.self:GetTarget();
    local item_cursor = e.self:GetItemIDAt(Slot.Cursor);

    if item_cursor ~= -1 then -- Has item on cursor
        local item_name = eq.get_item_name(item_cursor);

        local address = "https://live.wayfarershaven.com/dev/index.php?editor=items&id="..item_cursor.."&action=2"
        local message = "Click to edit "..item_name

        e.self:Popup("Item Editor", eq.popup_link(address, message))
    elseif not target.null then
        local target_NPCID = target:GetNPCTypeID();
        local target_name = target:GetName();

        --Replace 255.255.255.255
        local address = "https://live.wayfarershaven.com/dev/index.php?editor=npc&npcid="..target_NPCID.."&action=1"
        local message = "Click to edit "..target_name

        e.self:Popup("NPC Editor", eq.popup_link(address, message))
    else
        e.self:Message(MT.Red, "No Item or NPC Selected");
    end
end

return editor;