-- Taskmaster Luga Event

local taskmaster_sp2 = {
	1032397,1032408,1030022,1032570,1032512,1030021,1030019,1030020,1030008,1035437,1030029,1035840,1035872,1030026,1035812,1030027,1035953,1030028,1030025,1030060,1030024
}

function event_death_complete(e)    
    if has_value(taskmaster_sp2, e.self:CastToNPC():GetSp2()) then --spawn group inside the overlord room
        eq.signal(226204,1); -- #overlord_trigger (226204) to add to wave counter
    end

    if(e.self:CastToNPC():GetSp2() == 46865 or e.self:CastToNPC():GetSp2() == 29967 or e.self:CastToNPC():GetSp2() == 46868 or e.self:CastToNPC():GetSp2() == 29968 or e.self:CastToNPC():GetSp2() == 46869) then --spawn groups inside Ritualist Tzobodin room
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
