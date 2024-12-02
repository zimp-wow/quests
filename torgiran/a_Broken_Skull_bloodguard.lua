-- Taskmaster Luga Event

local taskmaster_sp2 = {
	32397,32408,30022,32570,32512,30021,30019,30020,30008,35437,30029,35840,35872,30026,35812,30027,35953,30028,30025,30060,30024
}

local treasureroom_sp2 = {
	29974,30002,30004,30004,46864,47819
}

function event_death_complete(e)
	if has_value(treasureroom_sp2, e.self:CastToNPC():GetSp2()) then -- spawn groups inside the treasurer room
		eq.signal(226211,1); -- signal The_room to add to wave counter
	elseif has_value(taskmaster_sp2, e.self:CastToNPC():GetSp2()) then -- spawn group inside the overlord room
		eq.signal(226204,1); -- #overlord_trigger (226204) to add to wave counter
	end
end

function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end
