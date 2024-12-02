-- Taskmaster Luga Event

local taskmaster_sp2 = {
	32397,32408,30022,32570,32512,30021,30019,30020,30008,35437,30029,35840,35872,30026,35812,30027,35953,30028,30025,30060,30024
}

local spirit_sp2    = {
    29975,29976,29977,29978
}

local tzobodinroom_sp2  = {
    46865,29967,46868,29968,46869
}

function event_death_complete(e)
    if has_value(spirit_sp2, e.self:CastToNPC():GetSp2()) then --spawn groups inside the water spirit room
        eq.signal(226097,1); -- signal An_ancient_spirit (226097) to add to wave counter
    elseif has_value(taskmaster_sp2, e.self:CastToNPC():GetSp2()) then--spawn group inside the overlord room
        eq.signal(226204,1); -- #overlord_trigger (226204) to add to wave counter
    elseif has_value(tzobodinroom_sp2, e.self:CastToNPC():GetSp2()) then --spawn groups inside Ritualist Tzobodin room
        eq.signal(226218,1); -- signal A_hate (226218) to add to wave counter
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
